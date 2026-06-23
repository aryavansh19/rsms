-- ============================================================
-- NexusRetail (RSMS) — Supabase / PostgreSQL schema
-- Run in Supabase SQL Editor (or as a migration).
-- Auth is handled by Supabase auth.users; app_user mirrors it with role + store.
-- ============================================================

create extension if not exists "pgcrypto";   -- gen_random_uuid()

-- ----------------------------------------------------------------
-- 1. ENUM TYPES
-- ----------------------------------------------------------------
create type user_role          as enum ('admin','manager','sales_associate','after_sales');
create type store_status       as enum ('active','archived');
create type terminal_type      as enum ('razorpay','card');
create type serial_status      as enum ('in_stock','sold','in_service');
create type appointment_type   as enum ('in_store','video');
create type order_type         as enum ('store','bopis','ship_from_warehouse');
create type order_status       as enum ('open','completed','cancelled');
create type payment_method     as enum ('razorpay','card');
create type payment_status     as enum ('authorized','declined','refunded');
create type urgency_level      as enum ('low','medium','high');
create type transfer_status    as enum ('pending','approved','routed','dispatched','delivered','unfulfillable');
create type po_status          as enum ('open','ordered','received','cancelled');
create type rsvp_status        as enum ('accepted','declined','pending');
create type ast_type           as enum ('exchange','return','repair','warranty');
create type warranty_coverage  as enum ('active','out_of_warranty','voided','unverifiable');
create type repair_stage       as enum ('received','in_repair','qa_check','completed');
create type estimate_status    as enum ('pending','approved','declined');
create type warranty_state     as enum ('active','expired','voided');
create type notification_channel as enum ('push','sms');

-- ----------------------------------------------------------------
-- 2. CORE TABLES
-- ----------------------------------------------------------------
create table store (
    id            uuid primary key default gen_random_uuid(),
    name          text not null,
    address       text,
    locale        text not null default 'en_US',
    currency_code text not null default 'INR',
    timezone      text not null default 'Asia/Kolkata',
    manager_id    uuid,                          -- FK added after app_user exists
    is_warehouse  boolean not null default false,
    status        store_status not null default 'active',
    created_at    timestamptz not null default now()
);

create table app_user (
    id         uuid primary key references auth.users(id) on delete cascade,
    name       text not null,
    email      text unique not null,
    role       user_role not null,
    store_id   uuid references store(id) on delete set null,   -- null for admin
    is_active  boolean not null default true,
    created_at timestamptz not null default now()
);

alter table store
    add constraint store_manager_fk foreign key (manager_id) references app_user(id) on delete set null;

create table payment_terminal (
    id        uuid primary key default gen_random_uuid(),
    store_id  uuid not null references store(id) on delete cascade,
    type      terminal_type not null,
    config    jsonb not null default '{}'::jsonb
);

create table sku (
    id          uuid primary key default gen_random_uuid(),
    name        text not null,
    category    text,
    description text,
    launch_date date not null,
    created_by  uuid references app_user(id),
    created_at  timestamptz not null default now()
);

create table price_band (
    id            uuid primary key default gen_random_uuid(),
    sku_id        uuid not null references sku(id) on delete cascade,
    currency_code text not null,
    base_price    numeric(12,2) not null,
    floor_price   numeric(12,2) not null,
    unique (sku_id, currency_code),
    check (floor_price <= base_price)
);

create table store_price (
    id          uuid primary key default gen_random_uuid(),
    sku_id      uuid not null references sku(id) on delete cascade,
    store_id    uuid not null references store(id) on delete cascade,
    local_price numeric(12,2) not null,
    unique (sku_id, store_id)
);

create table inventory_item (
    id                uuid primary key default gen_random_uuid(),
    sku_id            uuid not null references sku(id) on delete cascade,
    store_id          uuid not null references store(id) on delete cascade,
    on_hand           int not null default 0,
    reorder_threshold int not null default 0,
    unique (sku_id, store_id)
);

create table serial_item (
    id        uuid primary key default gen_random_uuid(),
    sku_id    uuid not null references sku(id) on delete cascade,
    store_id  uuid references store(id) on delete set null,
    serial_no text unique not null,
    status    serial_status not null default 'in_stock'
);

-- ----------------------------------------------------------------
-- 3. CLIENTS, ORDERS, PAYMENTS
-- ----------------------------------------------------------------
create table client (
    id                uuid primary key default gen_random_uuid(),
    name              text not null,
    phone             text,
    style_preferences jsonb not null default '{}'::jsonb,
    consent_granted   boolean not null default false,
    created_by        uuid references app_user(id),
    created_at        timestamptz not null default now()
);

create table appointment (
    id           uuid primary key default gen_random_uuid(),
    client_id    uuid not null references client(id) on delete cascade,
    associate_id uuid references app_user(id),
    type         appointment_type not null,
    scheduled_at timestamptz not null,
    status       text not null default 'booked'
);

create table orders (
    id           uuid primary key default gen_random_uuid(),
    client_id    uuid references client(id),
    store_id     uuid not null references store(id),
    associate_id uuid references app_user(id),
    order_type   order_type not null,
    status       order_status not null default 'open',
    total        numeric(12,2) not null default 0,
    created_at   timestamptz not null default now()
);

create table order_line_item (
    id            uuid primary key default gen_random_uuid(),
    order_id      uuid not null references orders(id) on delete cascade,
    sku_id        uuid not null references sku(id),
    serial_id     uuid references serial_item(id),
    quantity      int not null default 1,
    applied_price numeric(12,2) not null
);

create table payment (
    id          uuid primary key default gen_random_uuid(),
    order_id    uuid not null references orders(id) on delete cascade,
    method      payment_method not null,
    amount      numeric(12,2) not null,
    status      payment_status not null,
    receipt_url text,
    created_at  timestamptz not null default now()
);

-- ----------------------------------------------------------------
-- 4. TRANSFERS & PURCHASE ORDERS
-- ----------------------------------------------------------------
create table transfer_request (
    id                  uuid primary key default gen_random_uuid(),
    sku_id              uuid not null references sku(id),
    requesting_store_id uuid not null references store(id),
    source_store_id     uuid references store(id),
    quantity            int not null,
    urgency             urgency_level not null default 'medium',
    status              transfer_status not null default 'pending',
    created_at          timestamptz not null default now()
);

create table purchase_order (
    id            uuid primary key default gen_random_uuid(),
    sku_id        uuid not null references sku(id),
    transfer_id   uuid references transfer_request(id),
    quantity      int not null,
    supplier      text,
    expected_date date,
    status        po_status not null default 'open'
);

-- ----------------------------------------------------------------
-- 5. EVENTS
-- ----------------------------------------------------------------
create table event (
    id            uuid primary key default gen_random_uuid(),
    store_id      uuid not null references store(id) on delete cascade,
    launch_sku_id uuid references sku(id),
    name          text not null,
    scheduled_at  timestamptz not null,
    venue         text,
    description   text
);

create table invitation (
    id          uuid primary key default gen_random_uuid(),
    event_id    uuid not null references event(id) on delete cascade,
    client_id   uuid not null references client(id) on delete cascade,
    rsvp_status rsvp_status not null default 'pending'
);

-- ----------------------------------------------------------------
-- 6. AFTER-SALES
-- ----------------------------------------------------------------
create table after_sales_ticket (
    id              uuid primary key default gen_random_uuid(),
    type            ast_type not null,
    serial_id       uuid references serial_item(id),
    client_id       uuid references client(id),
    store_id        uuid not null references store(id),
    specialist_id   uuid references app_user(id),
    warranty_status warranty_coverage,
    stage           repair_stage not null default 'received',
    created_at      timestamptz not null default now()
);

create table condition_photo (
    id     uuid primary key default gen_random_uuid(),
    ast_id uuid not null references after_sales_ticket(id) on delete cascade,
    url    text not null
);

create table estimate (
    id              uuid primary key default gen_random_uuid(),
    ast_id          uuid not null references after_sales_ticket(id) on delete cascade,
    parts_cost      numeric(12,2) not null default 0,
    labour_cost     numeric(12,2) not null default 0,
    timeline        text,
    total           numeric(12,2) generated always as (parts_cost + labour_cost) stored,
    approval_status estimate_status not null default 'pending'
);

create table qa_checklist (
    id          uuid primary key default gen_random_uuid(),
    ast_id      uuid not null references after_sales_ticket(id) on delete cascade,
    is_complete boolean not null default false,
    items       jsonb not null default '[]'::jsonb
);

create table warranty (
    id         uuid primary key default gen_random_uuid(),
    serial_id  uuid not null references serial_item(id) on delete cascade,
    order_id   uuid references orders(id),
    start_date date not null,
    end_date   date not null,
    status     warranty_state not null default 'active'
);

-- ----------------------------------------------------------------
-- 7. CROSS-CUTTING
-- ----------------------------------------------------------------
create table notification (
    id          uuid primary key default gen_random_uuid(),
    ast_id      uuid references after_sales_ticket(id) on delete cascade,
    transfer_id uuid references transfer_request(id) on delete cascade,
    channel     notification_channel not null,
    message     text not null,
    sent_at     timestamptz not null default now()
);

create table performance_metric (
    id           uuid primary key default gen_random_uuid(),
    associate_id uuid not null references app_user(id) on delete cascade,
    units_sold   int not null default 0,
    upsell_rate  numeric(5,2) not null default 0,
    csat         numeric(3,2) not null default 0,
    period       text not null
);

create table shift (
    id           uuid primary key default gen_random_uuid(),
    associate_id uuid not null references app_user(id) on delete cascade,
    store_id     uuid not null references store(id) on delete cascade,
    start_at     timestamptz not null,
    end_at       timestamptz not null
);

-- ----------------------------------------------------------------
-- 8. INDEXES
-- ----------------------------------------------------------------
create index on app_user(store_id);
create index on inventory_item(store_id);
create index on store_price(store_id);
create index on orders(store_id);
create index on transfer_request(requesting_store_id);
create index on after_sales_ticket(store_id);

-- ----------------------------------------------------------------
-- 9. PRICE-FLOOR ENFORCEMENT (TEAM5-18/19/67)
-- ----------------------------------------------------------------
create or replace function enforce_price_floor() returns trigger as $$
declare fp numeric;
begin
    select pb.floor_price into fp
      from price_band pb
      join store s on s.id = new.store_id
     where pb.sku_id = new.sku_id
       and pb.currency_code = s.currency_code;
    if fp is not null and new.local_price < fp then
        raise exception 'Local price % is below the floor price %', new.local_price, fp;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_price_floor
    before insert or update on store_price
    for each row execute function enforce_price_floor();

-- ----------------------------------------------------------------
-- 10. RLS HELPER FUNCTIONS
-- ----------------------------------------------------------------
create or replace function auth_role() returns user_role as $$
    select role from app_user where id = auth.uid()
$$ language sql security definer stable;

create or replace function auth_store() returns uuid as $$
    select store_id from app_user where id = auth.uid()
$$ language sql security definer stable;

create or replace function is_admin() returns boolean as $$
    select coalesce(auth_role() = 'admin', false)
$$ language sql security definer stable;

-- ----------------------------------------------------------------
-- 11. ROW-LEVEL SECURITY
--   Admin  -> full access everywhere.
--   Others -> scoped to their own store (auth_store()).
-- ----------------------------------------------------------------
-- enable RLS on every table
do $$
declare t text;
begin
    for t in select tablename from pg_tables where schemaname = 'public'
    loop
        execute format('alter table %I enable row level security;', t);
    end loop;
end $$;

-- Admin: full access on all tables
do $$
declare t text;
begin
    for t in select tablename from pg_tables where schemaname = 'public'
    loop
        execute format($f$
            create policy admin_all on %I
                for all to authenticated
                using (is_admin()) with check (is_admin());
        $f$, t);
    end loop;
end $$;

-- Store-scoped read/write for non-admin roles (tables that carry a store_id)
do $$
declare t text;
begin
    for t in select c.relname
             from pg_class c join pg_attribute a on a.attrelid = c.oid
             where a.attname = 'store_id' and c.relkind = 'r'
               and c.relnamespace = 'public'::regnamespace
    loop
        execute format($f$
            create policy store_scope_select on %I
                for select to authenticated
                using (store_id = auth_store());
            create policy store_scope_write on %I
                for all to authenticated
                using (store_id = auth_store()) with check (store_id = auth_store());
        $f$, t, t);
    end loop;
end $$;

-- Catalog (sku, price_band) is global: any authenticated user may read; only admin writes (admin_all already covers writes).
create policy catalog_read_sku   on sku        for select to authenticated using (true);
create policy catalog_read_band  on price_band for select to authenticated using (true);

-- app_user: a user can always read their own row (for role/store lookup)
create policy self_read on app_user for select to authenticated using (id = auth.uid());

-- ============================================================
-- NOTE: review/tighten policies per feature before production.
-- e.g. managers edit store_price (floor enforced by trigger), associates create orders, etc.
-- ============================================================
