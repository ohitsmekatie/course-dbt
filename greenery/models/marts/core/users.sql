select 
    stg_users.*,
    stg_addresses.country as user_country,
    stg_addresses.state as user_state 
from {{ ref('stg_users' )}}
left join {{ ref('stg_addresses')}}
on stg_users.address_id = stg_addresses.address_id
