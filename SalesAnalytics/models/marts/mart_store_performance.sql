-- One row per store per month: revenue, margin, returns. The table Power BI reads.
-- Cancelled orders are excluded from revenue.
with sales as (

    select
        store_id,
        date_trunc('month', order_date)         as month_start,
        count(distinct order_id)                as orders,
        sum(quantity)                           as units,
        sum(net_amount)                         as net_revenue,
        sum(cost_amount)                        as cost
    from {{ ref('fct_sales') }}
    where not is_cancelled and not is_orphan_product
    group by 1, 2

),

refunds as (

    select
        store_id,
        date_trunc('month', return_date)        as month_start,
        sum(refund_amount)                      as refunds
    from {{ ref('fct_returns') }}
    group by 1, 2

)

select
    st.store_id,
    st.store_name,
    st.region,
    st.store_type,
    s.month_start,
    s.orders,
    s.units,
    s.net_revenue,
    s.cost,
    {{ margin_pct('s.net_revenue', 's.cost') }}                     as margin_pct,
    round(s.net_revenue / nullif(s.orders, 0), 2)                   as avg_order_value,
    coalesce(r.refunds, 0)                                          as refunds,
    s.net_revenue - coalesce(r.refunds, 0)                          as revenue_after_refunds
from sales s
join {{ ref('dim_stores') }} st using (store_id)
left join refunds r on r.store_id = s.store_id and r.month_start = s.month_start
