select
    return_id,
    sale_id,
    try_to_date(return_date)              as return_date,
    reason,
    try_to_decimal(refund_amount, 12, 2)  as refund_amount
from {{ source('raw', 'returns') }}
