with project_base as (
    select * from {{ ref('stg_project') }}
),

deliverable_rollup as (
    select
        project_id,
        count(*) as total_deliverables,
        count_if(status = 'Complete') as completed_deliverables,
        count_if(status = 'Pending') as pending_deliverables,
        avg(progress) as avg_deliverable_progress,
        min(planned_start_date) as first_planned_start_date,
        max(due_date) as latest_due_date
    from {{ ref('stg_deliverable') }}
    group by 1
),

expense_rollup as (
    select
        project_id,
        sum(amount) as total_project_expense,
        sum(case when is_billable = 1 then amount else 0 end) as billable_expense,
        sum(case when is_billable = 0 then amount else 0 end) as non_billable_expense
    from {{ ref('stg_project_expense') }}
    group by 1
)

select
    p.project_id,
    p.client_id,
    p.business_unit_id,
    p.project_name,
    p.project_type,
    p.status,
    p.planned_start_date,
    p.planned_end_date,
    p.actual_start_date,
    p.actual_end_date,
    p.price,
    p.estimated_budget,
    p.progress as project_progress,
    coalesce(d.total_deliverables, 0) as total_deliverables,
    coalesce(d.completed_deliverables, 0) as completed_deliverables,
    coalesce(d.pending_deliverables, 0) as pending_deliverables,
    d.avg_deliverable_progress,
    d.first_planned_start_date,
    d.latest_due_date,
    coalesce(e.total_project_expense, 0) as total_project_expense,
    coalesce(e.billable_expense, 0) as billable_expense,
    coalesce(e.non_billable_expense, 0) as non_billable_expense,
    coalesce(p.price, 0) - coalesce(e.total_project_expense, 0) as project_margin_estimate
from project_base p
left join deliverable_rollup d using (project_id)
left join expense_rollup e using (project_id)
