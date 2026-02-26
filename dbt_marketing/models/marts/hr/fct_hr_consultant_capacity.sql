with consultants as (
    select * from {{ ref('stg_consultant') }}
),

hours_by_consultant as (
    select
        consultant_id,
        year_month,
        sum(coalesce(try_to_number(billable_hours_raw, 18, 2), 0)) as billable_hours,
        sum(coalesce(try_to_number(non_billable_hours_raw, 18, 2), 0)) as non_billable_hours
    from {{ ref('stg_non_billable') }}
    group by 1, 2
)

select
    h.year_month,
    c.consultant_id,
    c.business_unit_id,
    c.first_name,
    c.last_name,
    c.email,
    c.hire_year,
    h.billable_hours,
    h.non_billable_hours,
    h.billable_hours + h.non_billable_hours as total_reported_hours,
    case
        when (h.billable_hours + h.non_billable_hours) = 0 then 0
        else h.billable_hours / nullif((h.billable_hours + h.non_billable_hours), 0)
    end as billable_utilization_ratio
from hours_by_consultant h
left join consultants c using (consultant_id)
