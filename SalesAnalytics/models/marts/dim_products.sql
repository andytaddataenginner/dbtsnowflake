select
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    unit_cost,
    list_price,
    {{ margin_pct('list_price', 'unit_cost') }} as list_margin_pct
from {{ ref('stg_products') }}
