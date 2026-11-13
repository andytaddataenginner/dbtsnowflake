{#- SCD Type 2: when a customer's loyalty tier (or segment) changes in RAW.CUSTOMERS, dbt closes
    the old row (dbt_valid_to) and inserts a new one (dbt_valid_from).
    Demo: run once with customers_v1 loaded, reload RAW.CUSTOMERS with v2, run again. -#}
{% snapshot snap_customers %}

{{
    config(
        target_schema='STAGING',
        unique_key='customer_id',
        strategy='check',
        check_cols=['loyalty_tier', 'segment', 'country'],
    )
}}

select * from {{ ref('stg_customer') }}

{% endsnapshot %}
