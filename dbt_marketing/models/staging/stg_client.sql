select
    cast(clientid as varchar) as client_id,
    client_name,
    cast(locationid as varchar) as location_id,
    phone_number,
    lower(email) as email,
    last_update
from {{ source('core', 'Client') }}
