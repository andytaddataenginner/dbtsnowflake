{#- One definition of "margin %" for every model. Change it here, it changes everywhere. -#}
{% macro margin_pct(revenue_col, cost_col) -%}
    round(100 * ({{ revenue_col }} - {{ cost_col }}) / nullif({{ revenue_col }}, 0), 1)
{%- endmacro %}
