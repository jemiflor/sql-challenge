-- Schema sql
-- Create table
drop table dept;
create table dept(
	dept_no varchar(50),
	dept_name varchar(30),
	CONSTRAINT dept_pkey PRIMARY KEY (dept_no)
);

select * from dept;

drop table dept_emp;
create table dept_emp(
	emp_no int,
	dept_no varchar(50)
);
-- Index: index_dept_emp_dep_no_emp_no
--DROP INDEX public.index_dept_emp_dep_no_emp_no;
CREATE INDEX IF NOT EXISTS index_dept_emp_dep_no_emp_no
    ON public.dept_emp USING btree
    (dept_no ASC NULLS LAST, emp_no ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;

select * from dept_emp; 

drop table dept_manager;
create table dept_manager(
	dept_no varchar(50),
	emp_no int
);
-- Index: index_dept_manager_dep_no_emp_no
--DROP INDEX public.index_dept_manager_dep_no_emp_no
CREATE INDEX IF NOT EXISTS index_dept_manager_dep_no_emp_no
    ON public.dept_manager USING btree
    (dept_no ASC NULLS LAST, emp_no ASC NULLS LAST)
    WITH (FILLFACTOR=90)
    TABLESPACE pg_default;


select * from dept_manager;

drop table employees;
create table employees(
	emp_no int,
	emp_title varchar(30),
	birth_date date,
	first_name varchar(30),
	last_name varchar(30),
	sex char(1),
	hire_date date, 
	CONSTRAINT employees_pkey PRIMARY KEY (emp_no)
);

select * from employees;

drop table salaries;
create table salaries( 
	emp_no int,
	salary float
);
-- Index: index_salaries_emp_no
--DROP INDEX public.index_salaries_emp_no;
CREATE INDEX IF NOT EXISTS index_salaries_emp_no
    ON public.salaries USING btree
    (emp_no ASC NULLS LAST)
    TABLESPACE pg_default;


select * from salaries;

drop table titles;
create table titles(
	title_id varchar(50),
	title varchar(50)
);

SELECT * FROM titles;

--*************************************************************************************************
-- 1. List the following details of each employee: employee number, last name,
-- first name, sex, and salary
-- SELECT ('emp_no', 'last_name', 'first_name', 'sex') from employees 
SELECT 
	e.emp_no AS EmployeeNumber,
	e.last_name AS LastName,
	e.first_name AS FirstName,
	e.sex AS Gender,
	s.salary AS Salary
FROM 
employees e
INNER JOIN salaries s
	ON s.emp_no = e.emp_no
--*************************************************************************************************	

--*************************************************************************************************
-- 2. List first name, last name, and hire date for employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
where  date_part('year', hire_date)
= 1986;
--*************************************************************************************************

--*************************************************************************************************
-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name.
SELECT 
	d.dept_no AS DepartmentNumber,
	d.dept_name AS DepartmentName,
	dm.emp_no AS ManagerEmployeeNumber,
	e.first_name AS FirstName,
	e.last_name AS LastName
FROM 
	dept d
INNER JOIN dept_manager dm
	ON dm.dept_no = d.dept_no
INNER JOIN employees e
	on e.emp_no = dm.emp_no


--*************************************************************************************************

--*************************************************************************************************
-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT 
	e.emp_no AS EmployeeNumber,
	e.last_name AS LastName,
	e.first_name AS FirstName,
	d.dept_name AS DepartmentName
FROM
	dept d
INNER JOIN dept_emp de
	ON de.dept_no = d.dept_no
INNER JOIN employees e
	ON e.emp_no = de.emp_no
--*************************************************************************************************

--*************************************************************************************************
-- List first name, last name, and sex for employees whose first name is 
-- "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE  first_name = 'Hercules'
AND last_name like 'B%';

	

--*************************************************************************************************

--*************************************************************************************************
-- 6. List all employees in the Sales department, including their employee
-- number, last name, first name, and department name.
SELECT 
	e.emp_no AS EmployeeNumber, 
	e.last_name AS LastName, 
	e.first_name AS FirstName,
	d.dept_name AS DepartmentName
FROM
	dept d 
INNER JOIN dept_emp de
	ON de.dept_no = d.dept_no
INNER JOIN employees e
	on e.emp_no = de.emp_no
where 
	d.dept_name = 'Sales'

--*************************************************************************************************

--*************************************************************************************************
-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department 
-- name.
SELECT 
	e.emp_no AS EmployeeNumber, 
	e.last_name AS LastName, 
	e.first_name AS FirstName,
	d.dept_name AS DepartmentName
FROM
	dept d 
INNER JOIN dept_emp de
	ON de.dept_no = d.dept_no
INNER JOIN employees e
	on e.emp_no = de.emp_no
where 
	d.dept_name in ('Sales', 'Development')


--*************************************************************************************************

--*************************************************************************************************
-- 8. In descending order, list the frequency count of employee last names,
-- i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) AS Frequency_of_employee_last_names
FROM employees
group by last_name
ORDER BY Frequency_of_employee_last_names DESC;

--*************************************************************************************************

