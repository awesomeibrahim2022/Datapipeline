with client_base as (
    select * from {{ ref('stg_client') }}
),

project_activity as (
    select
        client_id,
        count(*) as project_count,
        count_if(status = 'Completed') as completed_project_count,
        min(planned_start_date) as first_project_start_date,
        max(coalesce(actual_end_date, planned_end_date)) as latest_project_end_date,
        sum(coalesce(price, 0)) as total_booked_revenue,
        avg(coalesce(progress, 0)) as avg_project_progress
    from {{ ref('stg_project') }}
    group by 1
),

feedback as (
    select
        try_to_varchar(clientid) as client_id,
        count(*) as feedback_response_count
    from {{ source('core', 'ClientFeedbackInitial') }}
    group by 1
)

select
    c.client_id,
    c.client_name,
    c.email,
    c.location_id,
    c.last_update as client_last_update,
    coalesce(p.project_count, 0) as project_count,
    coalesce(p.completed_project_count, 0) as completed_project_count,
    p.first_project_start_date,
    p.latest_project_end_date,
    coalesce(p.total_booked_revenue, 0) as total_booked_revenue,
    p.avg_project_progress,
    coalesce(f.feedback_response_count, 0) as feedback_response_count
from client_base c
left join project_activity p using (client_id)
left join feedback f using (client_id)
