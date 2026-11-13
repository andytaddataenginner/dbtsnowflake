-- Singular test: an order placed at an Online store must not be tagged IN_STORE (batch 2 only).
select f.sale_id, s.store_type, f.sales_channel
from {{ ref('fct_sales') }} f
join {{ ref('dim_stores') }} s using (store_id)
where f.source_batch = 2
  and s.store_type = 'Online'
  and f.sales_channel = 'IN_STORE'
