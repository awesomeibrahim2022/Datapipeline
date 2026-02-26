select
    consultant_id,
    business_unit_id,
    first_name,
    last_name,
    email,
    contact,
    hire_year,
    case
        when hire_year is null then null
        else year(current_date()) - hire_year
    end as tenure_years,
    last_update
from {{ ref('stg_consultant') }}
