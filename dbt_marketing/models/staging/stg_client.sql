select
    clientid as client_id,
    client_name,
    locationid as location_id,
    phone_number,
    lower(email) as email,
    last_update
from {{ source('core', 'Client') }}
