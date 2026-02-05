select * 
from {{ source('db', 'employees_table') }}