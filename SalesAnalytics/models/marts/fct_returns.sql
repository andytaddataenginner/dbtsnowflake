select
    r.return_id,
    r.sale_id,
    r.return_date,
    r.reason,
    r.refund_amount,
    s.product_id,
    s.store_id,
    s.customer_id
from {{ ref('stg_returns') }} r
left join {{ ref('fct_sales') }} s using (sale_id)
