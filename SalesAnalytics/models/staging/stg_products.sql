select
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    try_to_decimal(unit_cost, 10, 2)   as unit_cost,
    try_to_decimal(list_price, 10, 2)  as list_price
from {{ source('raw', 'products') }}
