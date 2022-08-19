DROP TABLE dept_manager CASCADE;
DROP TABLE retirement_info;

----Pre-Work-------------------------------------------
-- 1 departments TABLE ---------------------------------
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name) ---adds the unique constraint to the dept_name column
);
SELECT * FROM departments;
--2 managers TABLE ----------------------------------------------------
CREATE TABLE managers (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
SELECT * FROM managers;
-- 3 employees TABLE--------------------------------------------------
CREATE TABLE employees (   emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
----4 salaries TABLE ---------------------------------------------------------
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no), ------????
  PRIMARY KEY (emp_no)
);
SELECT * FROM salaries;
---------5 dept_emp TABLE
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	external_key VARCHAR NOT NULL,
	PRIMARY KEY (external_key)
);
SELECT * FROM dept_emp;
------- 6 retirement_info TABLE
--  Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
--Joining (departments and dept_manager) tables
SELECT departments.dept_name,
       dept_manager.emp_no,
       dept_manager.from_date,
       dept_manager.to_date
INSERT INTO retirement_titles
FROM departments
INNER JOIN dept_manager 
ON departments.dept_no = dept_manager.dept_no;


----CHALLENGE 7

-- Create Table 'titles'
CREATE TABLE titles (   
	 emp_no INT NOT NULL,
     title VARCHAR NOT NULL,
     from_date DATE NOT NULL,
     to_date DATE NOT NULL);      
SELECT * FROM titles					 

-- Create Table 1 with DISTINCT ON (recent titles for each employee)/ Delete duplicates
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no ASC;
SELECT * FROM unique_titles

-- Create Table 2 with COUNT (number of (retirement-employees) by most recent job title)
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;
SELECT * FROM retiring_titles

-- Retirement titles Table 3 with JOIN ---
SELECT employees.emp_no,
       employees.first_name,
       employees.last_name,
       titles.title,
       titles.from_date,
       titles.to_date
INTO retirement_titles
FROM employees
INNER JOIN titles 
ON (employees.emp_no = titles.emp_no)
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY employees.emp_no;
SELECT * FROM retirement_titles

------ Create Table 4 : Mentorship Eligibility-------
SELECT DISTINCT ON (employees.emp_no) employees.emp_no,
                    employees.first_name,
                    employees.last_name,
                    employees.birth_date,
                    dept_emp.from_date,
                    dept_emp.to_date,
                    titles.title
INTO mentorship_elegibility
FROM employees 
INNER JOIN dept_emp 
ON (employees.emp_no = dept_emp.emp_no)
INNER JOIN titles 
ON (employees.emp_no = titles.emp_no)
WHERE (dept_emp.to_date = '9999-01-01')
AND (employees.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY employees.emp_no;
SELECT * FROM mentorship_elegibility






