-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles

--List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT e.first_name, e.last_name, e.hire_date, e.sex, s.salary
FROM employees e
INNER JOIN salaries s on e.emp_no=s.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986.
SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE EXTRACT(YEAR FROM hire_date)= '1986' ;

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT dm.dept_no,d.dept_name,dm.emp_no,e.first_name, e.last_name
FROM employees e
INNER JOIN dept_manager dm on e.emp_no=dm.emp_no
INNER JOIN departments d on dm.dept_no=d.dept_no;

--List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT e.first_name, e.last_name, e.emp_no, d.dept_name
FROM employees e
INNER JOIN dept_emp de on e.emp_no=de.emp_no
INNER JOIN departments d on d.dept_no=de.dept_no;

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees e
WHERE first_name = 'Hercules' and last_name LIKE 'B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT e.first_name, e.last_name, nbr.emp_no, nbr.dept_name
FROM employees e
INNER JOIN (
SELECT de.emp_no,d.dept_name
FROM departments d
LEFT JOIN dept_emp de on de.dept_no=d.dept_no
WHERE d.dept_name= 'Sales') AS nbr ON e.emp_no = nbr.emp_no

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT e.first_name, e.last_name, nbr.emp_no, nbr.dept_name
FROM employees e
INNER JOIN (
SELECT de.emp_no,d.dept_name
FROM departments d
LEFT JOIN dept_emp de on de.dept_no=d.dept_no
WHERE d.dept_name= 'Sales' or d.dept_name ='Development') AS nbr ON e.emp_no = nbr.emp_no

--List the frequency count of employee last names (i.e., how many employees share each last name) in descending order.
SELECT COUNT(last_name), last_name
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC

