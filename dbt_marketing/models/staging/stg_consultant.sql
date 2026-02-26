select
    cast(consultantid as varchar) as consultant_id,
    cast(businessunitid as varchar) as business_unit_id,
    first_name,
    last_name,
    email,
    contact,
    hire_year,
    last_update
from {{ source('core', 'Consultant') }}
