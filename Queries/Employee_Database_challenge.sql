SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name, --statement selects only the columns we want to view from each table.
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments -- statement points to the first table to be joined, Departments (Table 1).
INNER JOIN dept_manager -- points to the second table to be joined, dept_manager (Table 2).
ON departments.dept_no = dept_manager.dept_no; -- indicates where Postgres should look for matches.

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
From retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables using alias 
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables using alias
SELECT dep.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as dep
INNER JOIN dept_manager as dm
ON dep.dept_no = dm.dept_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
Into current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

Select * from current_emp;

-- COUNT will count the rows of data in a dataset
-- GROUP BY will group our data by type
-- ORDER BY will arrange the data so it presents itself in descending or ascending order

-- Employee count by department number
Select count (ce.emp_no), de.dept_no -- count is used on the employee numbers.
INTO departments_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

select * from departments_count;

SELECT * FROM salaries
ORDER BY to_date DESC; -- sort that column in descending order

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

Select * from emp_info;
Drop table if exists emp_info CASCADE;

Select e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
Into emp_info
From employees as e 
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
 AND (de.to_date = '9999-01-01')
 --What's going on with the salaries?
 ;
 
SElect * from current_emp;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no)
--	Why are there only five active managers for nine departments?
;

Select ce.emp_no,
ce.last_name,
ce.first_name,
d.dept_name
-- INTO dept_info
From current_emp as ce
Inner Join dept_emp as de
	On (de.emp_no=ce.emp_no)
Inner join departments as d
	On (de.dept_no = d.dept_no)
--Why are some employees appearing twice?	
;

-- Sales
Select count (re.emp_no),
	re.first_name,
	re.last_name,
	de.dept_name
-- Into dept_sales
From retirement_info as re
Inner Join dept_info as de
 On(re.emp_no = de.emp_no)
Where dept_name = 'Sales'
GROUP BY (re.first_name,
	re.last_name,
	de.dept_name)
ORDER BY de.dept_name;

-- Sales_Development
Select count (re.emp_no),
	re.first_name,
	re.last_name,
	de.dept_name
-- Into dept_sales_development
From retirement_info as re
Inner Join dept_info as de
 On(re.emp_no = de.emp_no)
Where dept_name in ('Sales', 'Development')
GROUP BY (re.first_name,
	re.last_name,
	de.dept_name)
ORDER BY de.dept_name;

-- Starter code:
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
WHERE _______
ORDER BY _____, _____ DESC;


--Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955
Select e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
-- Into retirement_titles
From employees as e
Inner Join titles as t
	On (e.emp_no = t.emp_no)
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)
rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
--rt.from_date,
--rt.to_date
--INTO unique_titles
FROM retirement_titles as rt
WHERE to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

select * from unique_titles;

Select count (u.title),u.title
-- Into retiring_titles
From unique_titles as u
Group by u.title
ORDER BY count DESC;

-- The Employees Eligible for the Mentorship Program
Select Distinct On (e.emp_no)
e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
--Into mentorship_eligibilty
From employees as e
Inner Join dept_emp as de
	On(e.emp_no=de.emp_no)
Inner Join titles as t
	On (de.emp_no=t.emp_no)
Where (e.birth_date between '1965-01-01' and '1965-12-31')
And (de.to_date = '9999-01-01')	
Order by emp_no;




