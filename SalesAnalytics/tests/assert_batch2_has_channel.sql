-- Singular test: every batch 2 (2026) row must carry a sales channel.
-- Batch 1 (2025) rows legitimately have NULL, because the column did not exist yet.
-- dbt fails the test if this query returns any rows.
select sale_id, source_batch, sales_channel
from {{ ref('fct_sales') }}
where source_batch = 2
  and sales_channel is null
