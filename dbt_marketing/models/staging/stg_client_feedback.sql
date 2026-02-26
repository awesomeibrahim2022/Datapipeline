select
    row_number() over (order by 1) as feedback_id,
    *
from {{ source('core', 'ClientFeedbackInitial') }}
