select
    cast("ConsultantID" as varchar) as consultant_id,
    cast("Date" as varchar) as activity_date_raw,
    cast("YearMonth" as varchar) as year_month,
    cast("Billable Hours" as varchar) as billable_hours_raw,
    cast("Table NonBillableHours" as varchar) as non_billable_hours_raw,
    cast("FirstName" as varchar) as first_name,
    cast("LastName" as varchar) as last_name
from {{ source('core', 'NonBillable') }}
