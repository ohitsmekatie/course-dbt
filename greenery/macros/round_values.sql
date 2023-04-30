{% macro round_values(column_name) %}

round( {{ column_name }}, 2)

{% endmacro %}