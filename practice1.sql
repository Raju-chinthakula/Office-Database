create database office;

use office;

CREATE TABLE EmployeeInfo (
    EmpID INT PRIMARY KEY,
    EmpFname VARCHAR(50),
    EmpLname VARCHAR(50),
    Department VARCHAR(50),
    Project VARCHAR(50),
    Address VARCHAR(100),
    DOB DATE,
    Gender CHAR(1)
);

INSERT INTO EmployeeInfo (EmpID, EmpFname, EmpLname, Department, Project, Address, DOB, Gender)
VALUES
    (1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-01-12', 'M'),
    (2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', '1968-02-05', 'F'),
    (3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', '1980-01-01', 'M'),
    (4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', '1992-02-05', 'F'),
    (5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', '1994-03-07', 'M');

CREATE TABLE EmployeePosition (
    EmpID INT,
    EmpPosition VARCHAR(50),
    DateOfJoining DATE,
    Salary DECIMAL(10, 2),
);

INSERT INTO EmployeePosition (EmpID, EmpPosition, DateOfJoining, Salary)
VALUES
    (1, 'Manager', '2022-01-05', 500000.00),
    (2, 'Executive', '2022-02-05', 75000.00),
    (3, 'Manager', '2022-01-05', 90000.00),
    (2, 'Lead', '2022-02-05', 85000.00),
    (1, 'Executive', '2022-01-05', 300000.00);

select * from EmployeeInfo;
select * from EmployeePosition;

--Q1.  Write a query to fetch the EmpFname from the EmployeeInfo table in upper case and use the ALIAS name as EmpName.

select upper(EmpFname) as EmpName from EmployeeInfo;

--Q2. Write a query to fetch the number of employees working in the department ‘HR’.

select count(*) from EmployeeInfo
where Department='HR';

--Q3. Write a query to get the current date

select getdate();

--Q4. Write a query to retrieve the first four characters of  EmpLname from the EmployeeInfo table.

select substring(EmpLname,1,4) from EmployeeInfo;

--Q5. Write a query to fetch only the place name(string before brackets) from the Address column of EmployeeInfo table.

select substring(Address,1,charindex('(',Address)) from EmployeeInfo;

--Q6.  Write a query to create a new table which consists of data and structure copied from the other table.

select * into new_EmployeeInfo from EmployeeInfo;

select *  from new_EmployeeInfo;

--Q7. Write q query to find all the employees whose salary is between 50000 to 100000.

select * from EmployeePosition
where Salary between 50000 and 100000;

--Q8. Write a query to find the names of employees that begin with ‘S’

select * from EmployeeInfo
where EmpFname like 's%';

--Q9. Write a query to fetch top N records.

select top 3 * from EmployeePosition
order by Salary desc;

--Q10. Write a query to retrieve the EmpFname and EmpLname in a single column as “FullName”. The first name and the last name must be separated with space.

select concat(EmpFname,' ',EmpLname) as 'FullName' from EmployeeInfo;

--Q11. Write a query find number of employees whose DOB is between 02/05/1970 to 31/12/1975 and are grouped according to gender

select Gender,count(*) from EmployeeInfo
where DOB between '1970-05-02' and '1975-12-31'
group by Gender;

--Q12. Write a query to fetch all the records from the EmployeeInfo table ordered by EmpLname in descending order and Department in the ascending order.

select * from EmployeeInfo
order by EmpLname desc,Department;

--Q13. Write a query to fetch details of employees whose EmpLname ends with an alphabet ‘A’ and contains five alphabets.

select * from EmployeeInfo
where EmpLname like '____A%'

--Q14. Write a query to fetch details of all employees excluding the employees with first names, “Sanjay” and “Sonia” from the EmployeeInfo table.

select * from EmployeeInfo
where EmpFname not in ('Sanjay','Sonia');

--Q15. Write a query to fetch details of employees with the address as “DELHI(DEL)”.

select * from EmployeeInfo
where address like '%DELHI(DEL)%';

--Q16. Write a query to fetch all employees who also hold the managerial position.

select * from EmployeeInfo as ei
inner join EmployeePosition as ep on ei.EmpID=ep.EmpID
where EmpPosition='Manager';

SELECT E.EmpFname, E.EmpLname, P.EmpPosition 
FROM EmployeeInfo E INNER JOIN EmployeePosition P ON
E.EmpID = P.EmpID AND P.EmpPosition IN ('Manager');

--Q17. Write a query to fetch the department-wise count of employees sorted by department’s count in ascending order.

select department,count(*) from EmployeeInfo
group by department
order by count(*);

--Q18. Write a query to calculate the even and odd records from a table.

with Numbered_Records as 
(select *,ROW_NUMBER() over(order by (select null)) as RowNum from EmployeeInfo)
select * from Numbered_Records
where RowNum%2=0; -- Even records

-- To select odd records, you can use:
-- WHERE RowNum % 2 <> 0; -- Odd records

--Q19. Write a SQL query to retrieve employee details from EmployeeInfo table who have a date of joining in the EmployeePosition table.

SELECT ei.*
FROM EmployeeInfo ei INNER JOIN EmployeePosition ep ON
ei.EmpID=ep.EmpID
where ep.DateOfJoining is not null;

select * from EmployeeInfo ei
where exists (select * from EmployeePosition ep where ei.EmpID=ep.EmpID);

--Q20. Write a query to retrieve two minimum and maximum salaries from the EmployeePosition table.
select
(select min(Salary) from EmployeePosition) AS MinSalary1,
(select min(Salary) from EmployeePosition where salary not in(select min(Salary) from EmployeePosition)) AS MinSalary2,
(select max(Salary) from EmployeePosition) AS MaxSalary1,
(select max(Salary) from EmployeePosition where salary not in(select max(Salary) from EmployeePosition)) AS MaxSalary2;

--Q21. Write a query to find the Nth highest salary from the table without using TOP/limit keyword.

select Salary from 
(select Salary ,row_number() over(order by Salary desc) as rnk from EmployeePosition)  as emppos
where rnk=2;

--Q22. Write a query to retrieve duplicate records from a table.

SELECT EmpID, EmpFname, COUNT(*) 
FROM EmployeeInfo GROUP BY EmpID, EmpFname, Department 
HAVING COUNT(*) > 1;

--Q23. Write a query to retrieve the list of employees working in the same department.

select  E1.EmpID,E1.EmpFname,E1.Department  from EmployeeInfo E1
inner join EmployeeInfo E2 on E1.Department=E2.Department
where E1.EmpID<>E2.EmpID;

--Q24. Write a query to retrieve the last 3 records from the EmployeeInfo table.

select top 3 * from EmployeeInfo
order by EmpID desc;

--Q25. Write a query to find the third-highest salary from the EmpPosition table.

select Salary from 
(select Salary,dense_rank() over(order by Salary desc) as rnk from EmployeePosition) as high_sal
where rnk=3;

SELECT DISTINCT Salary
FROM EmployeePosition
ORDER BY Salary DESC
OFFSET 2 ROWS
FETCH NEXT 1 ROW ONLY;

SELECT TOP 1 salary
FROM(
SELECT TOP 3 salary
FROM EmployeePosition
ORDER BY salary DESC) AS emp
ORDER BY salary ASC;

--Q26. Write a query to display the first and the last record from the EmployeeInfo table.

select top 1 * from EmployeeInfo;
select top 1 * from (select top 1 * from EmployeeInfo order by EmpID desc) as emp order by EmpID;

SELECT * FROM EmployeeInfo WHERE EmpID = (SELECT MIN(EmpID) FROM EmployeeInfo);
SELECT * FROM EmployeeInfo WHERE EmpID = (SELECT MAX(EmpID) FROM EmployeeInfo);

--Q27. Write a query to add email validation to your database

alter table EmployeeInfo
add email varchar(50);

update EmployeeInfo
set email='raju@hello.com';

alter table EmployeeInfo
add constraint chk_email
check (email like '%@%.%');

select * from EmployeeInfo;
--Q28. Write a query to retrieve Departments who have less than 2 employees working in it.

select Department,count(*) from EmployeeInfo
group by Department
having count(*)<2;

--Q29. Write a query to retrieve EmpPostion along with total salaries paid for each of them.

SELECT EmpPosition, SUM(Salary) AS TotalSalariesPaid
FROM EmployeePosition
GROUP BY EmpPosition;

--Q30. Write a query to fetch 50% records from the EmployeeInfo table.

select top 50 percent * from EmployeeInfo;
