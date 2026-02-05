{% macro validate_valid_db(allowed_dbs) %}

    {% if execute %}

        {% set selected_db = var('valid_db', none) %}

        {% if selected_db is none %}
            {{ exceptions.raise_compiler_error(
                "❌ valid_db variable not provided. Please pass --vars '{valid_db: <db_name>}'"
            ) }}
        {% endif %}

        {% if selected_db not in allowed_dbs %}
            {{ exceptions.raise_compiler_error(
                "❌ Invalid valid_db: " ~ selected_db ~
                ". Allowed values are: " ~ allowed_dbs | join(', ')
            ) }}
        {% endif %}

    {% endif %}

{% endmacro %}
