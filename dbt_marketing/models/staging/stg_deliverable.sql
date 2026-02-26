select
    deliverableid as deliverable_id,
    projectid as project_id,
    name as deliverable_name,
    created_at,
    price,
    planned_start_date,
    actual_start_date,
    planned_hours,
    due_date,
    status,
    progress,
    submission_date,
    invoiced_date,
    last_update
from {{ source('core', 'Deliverable') }}
