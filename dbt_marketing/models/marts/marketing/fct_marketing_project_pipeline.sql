with projects as (
    select * from {{ ref('stg_project') }}
),

deliverables as (
    select
        project_id,
        count(*) as deliverable_count,
        sum(price) as deliverable_value,
        avg(progress) as avg_deliverable_progress
    from {{ ref('stg_deliverable') }}
    group by 1
),

expenses as (
    select
        project_id,
        sum(amount) as total_expense,
        sum(case when is_billable = 1 then amount else 0 end) as billable_expense
    from {{ ref('stg_project_expense') }}
    group by 1
)

select
    p.project_id,
    p.client_id,
    p.project_name,
    p.project_type,
    p.status,
    p.planned_start_date,
    p.planned_end_date,
    p.actual_start_date,
    p.actual_end_date,
    p.price,
    p.estimated_budget,
    p.progress,
    coalesce(d.deliverable_count, 0) as deliverable_count,
    coalesce(d.deliverable_value, 0) as deliverable_value,
    d.avg_deliverable_progress,
    coalesce(e.total_expense, 0) as total_expense,
    coalesce(e.billable_expense, 0) as billable_expense,
    coalesce(p.price, 0) - coalesce(e.total_expense, 0) as gross_margin_estimate
from projects p
left join deliverables d using (project_id)
left join expenses e using (project_id)
