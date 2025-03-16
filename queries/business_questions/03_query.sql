with employee_with_info as (
    select
        title,
        employee_id,
        reports_to,
        concat(first_name, ' ', last_name) as full_name,
        extract(
            year
            from
                age(hire_date, birth_date)
        ) as employee_age,
        extract(
            year
            from
                age(now(), hire_date)
        ) as employee_tenure
    from
        public.employees
)
select
    e1.full_name as employee_full_name,
    e1.title as employee_title,
    e1.employee_age,
    e1.employee_tenure,
    e2.full_name as manager_full_name,
    e2.title as manager_title
from
    employee_with_info as e1
    left join employee_with_info as e2 on e1.reports_to = e2.employee_id
order by
    e1.employee_age,
    e1.full_name ASC;