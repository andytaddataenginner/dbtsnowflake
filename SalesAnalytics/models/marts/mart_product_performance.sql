-- One row per product: what sold, how profitable it is, how often it comes back.
with sold as (

    select
        product_id,
        sum(quantity)           as units_sold,
        sum(net_amount)         as net_revenue,
        sum(margin_amount)      as margin_amount,
        count(distinct sale_id) as lines_sold
    from {{ ref('fct_sales') }}
    where not is_cancelled and not is_orphan_product
    group by 1

),

returned as (

    select product_id, count(distinct sale_id) as lines_returned, sum(refund_amount) as refunds
    from {{ ref('fct_returns') }}
    group by 1

)

select
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    coalesce(s.units_sold, 0)                                       as units_sold,
    coalesce(s.net_revenue, 0)                                      as net_revenue,
    coalesce(s.margin_amount, 0)                                    as margin_amount,
    round(100 * coalesce(r.lines_returned, 0) / nullif(s.lines_sold, 0), 1) as return_rate_pct,
    coalesce(r.refunds, 0)                                          as refunds
from {{ ref('dim_products') }} p
left join sold s     using (product_id)
left join returned r using (product_id)
