with non_billable as (
    select
        consultant_id,
        year_month,
        try_to_number(non_billable_hours_raw, 18, 2) as non_billable_hours,
        try_to_number(billable_hours_raw, 18, 2) as billable_hours
    from {{ ref('stg_non_billable') }}
),

consultants as (
    select
        consultant_id,
        business_unit_id
    from {{ ref('stg_consultant') }}
),

indirect_costs as (
    select
        year_month,
        business_unit_id,
        try_to_number(non_project_labor_costs_raw, 18, 2) as non_project_labor_costs,
        try_to_number(other_expense_costs_raw, 18, 2) as other_expense_costs,
        try_to_number(total_indirect_costs_raw, 18, 2) as total_indirect_costs
    from {{ ref('stg_indirect_costs') }}
)

select
    nb.year_month,
    c.business_unit_id,
    sum(coalesce(nb.billable_hours, 0)) as total_billable_hours,
    sum(coalesce(nb.non_billable_hours, 0)) as total_non_billable_hours,
    count(distinct nb.consultant_id) as consultants_reporting_hours,
    max(ic.non_project_labor_costs) as non_project_labor_costs,
    max(ic.other_expense_costs) as other_expense_costs,
    max(ic.total_indirect_costs) as total_indirect_costs
from non_billable nb
left join consultants c
    on nb.consultant_id = c.consultant_id
left join indirect_costs ic
    on nb.year_month = ic.year_month
   and c.business_unit_id = ic.business_unit_id
group by 1, 2
