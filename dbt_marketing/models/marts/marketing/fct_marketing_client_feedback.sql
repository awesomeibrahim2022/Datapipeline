select
    feedback_id,
    *
from {{ ref('stg_client_feedback') }}
