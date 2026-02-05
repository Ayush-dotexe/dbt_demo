{% macro databricks__today_date(timezone=None) %}
  {%- if timezone is none -%}
    -- Uses the session time zone (default) to compute today's date
    current_date()
  {%- else -%}
    -- If you need a specific time zone (e.g. 'Asia/Kolkata'):
    -- IMPORTANT: This assumes your session is set to UTC. If not, set:
    --   spark.conf.set("spark.sql.session.timeZone", "UTC")
    --
    -- Explanation:
    --   from_utc_timestamp(ts, tz) converts a UTC timestamp to the given timezone.
    --   We use 'date(...)' to strip the time and compare date-only.
    date(from_utc_timestamp(current_timestamp(), '{{ timezone }}'))
  {%- endif -%}
{% endmacro %}

{% test is_today(model, column_name, timezone=None, fail_on_null=False) %}
-- Fails if any row has column_name::date not equal to "today".
with base as (
  select
    cast({{ column_name }} as date) as _d
  from {{ model }}
),
invalid as (
  select 1
  from base
  where _d <> {{ databricks__today_date(timezone) }}
  {%- if fail_on_null %}
     or _d is null
  {%- endif %}
)
select count(*) as failures
from invalid
{% endtest %}