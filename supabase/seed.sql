-- ============================================================
-- NexusRetail — SAMPLE DATA (run ONCE in Supabase SQL editor)
-- Populates stores, ~55 products, inventory, ~55 completed orders,
-- and a few pending transfers, so the Admin dashboard shows real numbers.
-- Safe to re-run the SKU/order blocks (they just add more rows).
-- ============================================================

-- 1. Stores (run once). Skip if you already created stores.
insert into store (name, address, locale, currency_code, timezone, country, status) values
 ('NexusRetail Mumbai', 'Mumbai, India',  'en_IN', 'INR', 'Asia/Kolkata', 'India',  'active'),
 ('NexusRetail Delhi',  'Delhi, India',   'en_IN', 'INR', 'Asia/Kolkata', 'India',  'active'),
 ('NexusRetail Dubai',  'Dubai, UAE',     'en_AE', 'AED', 'Asia/Dubai',   'UAE',    'active'),
 ('NexusRetail Paris',  'Paris, France',  'fr_FR', 'EUR', 'Europe/Paris', 'France', 'active');

-- (optional) tag any pre-existing stores with a country by currency
update store set country = 'India'  where country is null and currency_code = 'INR';
update store set country = 'UAE'    where country is null and currency_code = 'AED';
update store set country = 'France' where country is null and currency_code = 'EUR';

-- 2. ~55 luxury products (SKUs)
insert into sku (name, category, launch_date)
select
  (array['Heritage','Celeste','Aurum','Noir','Imperial','Royale','Lumiere','Eterna','Soliel','Vega'])[1+floor(random()*10)::int]
   || ' ' ||
  (array['Watch','Necklace','Bracelet','Handbag','Ring','Cufflinks','Wallet','Brooch','Earrings','Pendant'])[1+floor(random()*10)::int]
   || ' #' || g,
  (array['Watches','Jewelry','Leather Goods','Accessories'])[1+floor(random()*4)::int],
  current_date - (floor(random()*365)::int)
from generate_series(1,55) g;

-- 3. Price band (INR) for every SKU that doesn't have one: floor = 85% of base
insert into price_band (sku_id, currency_code, base_price, floor_price)
select s.id, 'INR', p.base, round(p.base * 0.85, 2)
from sku s
cross join lateral (select round((random()*400000 + 20000)::numeric, 2) as base) p
where not exists (
  select 1 from price_band pb where pb.sku_id = s.id and pb.currency_code = 'INR'
);

-- 4. Inventory per store for every SKU (some will be low-stock => alerts)
insert into inventory_item (sku_id, store_id, on_hand, reorder_threshold)
select s.id, st.id, floor(random()*20)::int, 5
from sku s
cross join store st
where st.status = 'active'
  and not exists (
    select 1 from inventory_item i where i.sku_id = s.id and i.store_id = st.id
  );

-- 5. ~55 completed orders spread over the last 180 days (this is your REVENUE)
insert into orders (store_id, order_type, status, total, created_at)
select
  (array(select id from store where status='active'))[
      1 + floor(random() * (select count(*) from store where status='active'))::int],
  (array['store','bopis','ship_from_warehouse']::order_type[])[1 + floor(random()*3)::int],
  'completed'::order_status,
  round((random()*280000 + 15000)::numeric, 2),
  now() - (floor(random()*180)::int || ' days')::interval
from generate_series(1,55);

-- 6. A few pending transfer requests (for the "Pending Transfers" KPI)
insert into transfer_request (sku_id, requesting_store_id, quantity, urgency, status)
select
  (select id from sku order by random() limit 1),
  (select id from store where status='active' order by random() limit 1),
  floor(random()*10 + 1)::int,
  (array['low','medium','high']::urgency_level[])[1 + floor(random()*3)::int],
  'pending'::transfer_status
from generate_series(1,6);

-- ============================================================
-- Quick check after running:
--   select sum(total) from orders where status='completed';      -- Total Revenue
--   select count(*) from store where status='active';            -- Active Stores
--   select count(*) from transfer_request where status='pending';-- Pending Transfers
--   select count(*) from inventory_item where on_hand <= reorder_threshold; -- Low-stock
--   select * from revenue_by_month(null);                        -- chart data
-- ============================================================
