with clients as (
    select * from {{ ref('stg_client') }}
),

project_counts as (
    select
        client_id,
        count(*) as total_projects,
        count_if(status = 'Completed') as completed_projects,
        max(last_update) as latest_project_update
    from {{ ref('stg_project') }}
    group by 1
)

select
    c.client_id,
    c.client_name,
    c.location_id,
    c.email,
    c.phone_number,
    coalesce(p.total_projects, 0) as total_projects,
    coalesce(p.completed_projects, 0) as completed_projects,
    p.latest_project_update,
    c.last_update as client_last_update
from clients c
left join project_counts p
    on c.client_id = p.client_id
