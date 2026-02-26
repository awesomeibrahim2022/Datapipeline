select
    recordid as expense_id,
    projectid as project_id,
    deliverableid as deliverable_id,
    date as expense_ts,
    amount,
    description,
    category,
    is_billable
from {{ source('core', 'ProjectExpense') }}
