-- ============================================================
-- Admin Dashboard — revenue & KPI aggregation (run in Supabase SQL editor)
-- Revenue source = orders.total where status='completed'.
-- ============================================================

-- 1. country column for the country filter (TEAM5-65)
alter table store add column if not exists country text;

-- 2. KPI summary (optional country filter). Returns one JSON object.
create or replace function dashboard_kpis(p_country text default null)
returns json
language sql security definer stable as $$
  select json_build_object(
    'total_revenue', coalesce((
        select sum(o.total)
        from orders o
        join store s on s.id = o.store_id
        where o.status = 'completed'
          and (p_country is null or s.country = p_country)
    ), 0),
    'active_stores', (
        select count(*) from store
        where status = 'active'
          and (p_country is null or country = p_country)
    ),
    'pending_transfers', (
        select count(*) from transfer_request where status = 'pending'
    ),
    'low_stock_alerts', (
        select count(*) from inventory_item where on_hand <= reorder_threshold
    )
  );
$$;

-- 3. Revenue grouped by month (for the chart). Optional country filter.
create or replace function revenue_by_month(p_country text default null)
returns table(month text, revenue numeric)
language sql security definer stable as $$
  select to_char(date_trunc('month', o.created_at), 'YYYY-MM') as month,
         sum(o.total) as revenue
  from orders o
  join store s on s.id = o.store_id
  where o.status = 'completed'
    and (p_country is null or s.country = p_country)
  group by 1
  order by 1;
$$;

-- 4. Revenue grouped by country (for a breakdown view)
create or replace function revenue_by_country()
returns table(country text, revenue numeric)
language sql security definer stable as $$
  select coalesce(s.country, 'Unknown') as country,
         sum(o.total) as revenue
  from orders o
  join store s on s.id = o.store_id
  where o.status = 'completed'
  group by 1
  order by 2 desc;
$$;

-- ------------------------------------------------------------
-- SAMPLE DATA so the dashboard shows numbers before checkout exists.
-- Replace the store_id with a real id from your store table.
-- ------------------------------------------------------------
-- update store set country = 'India'  where currency_code = 'INR';
-- update store set country = 'UAE'    where currency_code = 'AED';
-- insert into orders (store_id, order_type, status, total, created_at) values
--   ((select id from store limit 1), 'store', 'completed', 125000, now() - interval '40 days'),
--   ((select id from store limit 1), 'store', 'completed',  89000, now() - interval '12 days'),
--   ((select id from store limit 1), 'store', 'completed', 210000, now() - interval '3 days');


-- ============================================================
-- Top products by revenue, weekly or monthly window.
-- Requires order_line_item to be populated (see seed.sql backfill).
--   p_period: 'week' (last 7 days) or 'month' (last 30 days)
--   p_metric: 'revenue' or 'units'
-- ============================================================
create or replace function top_products(
    p_period  text default 'month',
    p_limit   int  default 10,
    p_country text default null
)
returns table(sku_id uuid, name text, category text, units int, revenue numeric)
language sql security definer stable as $$
  select s.id, s.name, s.category,
         sum(li.quantity)::int               as units,
         sum(li.quantity * li.applied_price) as revenue
  from order_line_item li
  join orders o  on o.id = li.order_id
  join sku    s  on s.id = li.sku_id
  join store  st on st.id = o.store_id
  where o.status = 'completed'
    and o.created_at >= (case when p_period = 'week'
                              then now() - interval '7 days'
                              else now() - interval '30 days' end)
    and (p_country is null or st.country = p_country)
  group by s.id, s.name, s.category
  order by revenue desc
  limit p_limit;
$$;
