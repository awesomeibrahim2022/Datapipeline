select
    projectid as project_id,
    created_at,
    clientid as client_id,
    unitid as business_unit_id,
    name as project_name,
    type as project_type,
    price,
    estimated_budget,
    planned_hours,
    planned_start_date,
    planned_end_date,
    status,
    actual_start_date,
    actual_end_date,
    progress,
    last_update
from {{ source('core', 'Project') }}
