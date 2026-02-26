select
    cast(recordid as varchar) as expense_id,
    cast(projectid as varchar) as project_id,
    cast(deliverableid as varchar) as deliverable_id,
    date as expense_ts,
    amount,
    description,
    category,
    is_billable
from {{ source('core', 'ProjectExpense') }}
