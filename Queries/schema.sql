-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees(
	emp_no int NOT NULL,
	birth_date date NOT NULL,	
	first_name varchar NOT NULL,
	last_name varchar NOT NULL, 
	gender varchar NOT NULL,
	hire_date date NOT NULL,
	primary key(emp_no)
)
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
 
)
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
)

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

-- Create new table for retiring employees
DROP TABLE retirement_info;
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM dept_emp;

SELECT departments.dept_no,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no= dept_manager.dept_no

SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no= dept_emp.emp_no

SELECT re.emp_no,
	re.first_name,
	re.last_name,
de.to_date
INTO current_emp
FROM retirement_info AS re
LEFT JOIN dept_emp as de
ON re.emp_no= de.emp_no
WHERE de.to_date = ('9999-01-01');

select * from employee_count_per_dept

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count_per_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no
Select * from salaries
-- employee number, their last name, first name, gender, and salary
SELECT em.emp_no,
	em.first_name,
	em.last_name,
	em.gender,
	s.salary,
	s.to_date
FROM employees AS em
JOIN LEFT salaries AS s
ON em.emp_no= s.emp_no
	
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, 
	first_name, 
last_name, 
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info

SELECT e.emp_no, 
	e.first_name, 
e.last_name, 
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no= s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	  AND (de.to_date = '9999-01-01');
	  
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- List of retiring employees per department
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (de.emp_no= ce.emp_no)
INNER JOIN departments AS d
	ON (d.dept_no=de.dept_no)

-- Create a query that will return only the information relevant to the Sales team.
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO sales_dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (de.emp_no= ce.emp_no)
INNER JOIN departments AS d
	ON (d.dept_no=de.dept_no)
WHERE (d.dept_name='Sales')

-- Create a query that will return only the information relevant to the Sales and Development teams:
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
--INTO sales_devp_dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (de.emp_no= ce.emp_no)
INNER JOIN departments AS d
	ON (d.dept_no=de.dept_no)
WHERE d.dept_name IN ('Sales', 'Development')
