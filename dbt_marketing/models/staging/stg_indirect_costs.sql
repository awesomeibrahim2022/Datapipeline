select
    cast("YearMonth" as varchar) as year_month,
    cast("Business Unit ID" as varchar) as business_unit_id,
    cast("Non-proj Labor Costs" as varchar) as non_project_labor_costs_raw,
    cast("Other Expense Costs" as varchar) as other_expense_costs_raw,
    cast("Total Indirect Costs" as varchar) as total_indirect_costs_raw
from {{ source('core', 'IndirectCosts') }}
