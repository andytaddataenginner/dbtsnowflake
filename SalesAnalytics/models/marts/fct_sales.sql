{{
    config(
        materialized='incremental',
        unique_key='sale_id',
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}

-- Incremental: only rows loaded since the last run are merged in.
-- Rows whose product is not in the catalogue are kept (left join) but flagged, so the
-- referential-integrity test can surface them instead of silently losing revenue.
with s as (

    select * from {{ ref('stg_sales') }}
    {% if is_incremental() %}
    where loaded_at > (select coalesce(max(loaded_at), '1900-01-01'::timestamp) from {{ this }})
    {% endif %}

),

p as (

    select product_id, unit_cost from {{ ref('dim_products') }}

)

select
    s.sale_id,
    s.order_id,
    s.customer_id,
    s.store_id,
    s.product_id,
    s.order_date,
    s.quantity,
    s.unit_price,
    s.discount_pct,
    s.order_status,
    s.payment_method,
    s.promo_code,
    s.sales_channel,
    s.gross_amount,
    s.net_amount,
    round(s.quantity * p.unit_cost, 2)                     as cost_amount,
    round(s.net_amount - s.quantity * p.unit_cost, 2)      as margin_amount,
    (p.product_id is null)                                 as is_orphan_product,
    (s.order_status = 'CANCELLED')                         as is_cancelled,
    s.source_batch,
    s.loaded_at
from s
left join p on p.product_id = s.product_id
