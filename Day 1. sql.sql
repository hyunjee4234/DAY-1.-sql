Use Northwind
Go

--Select statement: identify which columns we want to retrieve.

--1. SELECT all columns and rows.

SELECT *
FROM employees


--2. SELECT a list of columns

SELECT ProductID, Name
FROM Production.Product

--Avoid using SELECT*

--1) unnecessary data because if we use *, don't need to retrieve all data. increasing network traffic(relational database) take longer time in client side and server side.
--also use more memory for memory that we don't need datas.

--2) name conflict
--when we join two or more tables such as same name, country etc, there will be name confliction.


--3. SELECT DISTICT Value: list all the cities that employees located at (Only unique value)
Select DISTINCT color
from Production.Product



--4. SELECT combined with plain text: retrieve the full name of employees(Concentinate data)

Select Name, Color + Name + ' ' + color AS [Name with Color] --we can use [] or "" for having space between words
from Production.Product

--identifiers: name to database, tables columns...
--sql server is not case sensitive, no matter upper or lower case.

--1) regular identifier: complies certain rules for the format
	--a) first character: a-z, A-Z, @, #
	--@: declare variable
	declare @today datetime
	select @today = getdate()
	print @today
	--#: declare a temporary table

	--b) subsequent chars: a-z, A-Z, @, #, $, _
	--c) must not be sql reserved word, both upper and lower case. ex) select, max, avg

	--e) embedded space is not allowed. but with [] or "" is okay


--2) delimited identifiers: [] or "" is okay


--WHERE statement : filter records
--1. equal
--Customers who are in Germany

SELECT ContactName, Country
FROM Customers
WHERE country = 'germany'


--Product which price is $18
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice = 18



--Customer who are not from UK
SELECT ContactName, Country
FROM Customers
WHERE COUNTRY != 'UK' -- instead of using ! we can use <>


--IN Operator: retrieve among a list of discrete values
--Orders that ship to USA and CANADA
SELECT OrderName, Country
FROM Orders
WHERE ShipCountry = 'USA' or ShipCOuntry = 'Canada'
--  ==
SELECT OrderName, Country
FROM Orders
WHERE ShipCountry in ('USA', 'CANADA')

--BETWEEN Operator: retrieve in a consecutive range
--1. retrieve products whose SafetyStockLevel is between 800 and 1000
SELECT name, SafetyStockLevel
FROM Production.Product
WHERE SafetyStockLevel between 800 and 1000

--==
SELECT name, SafetyStockLevel
FROM Production.Product
WHERE SafetyStockLevel >= 800 and SafetyStockLevel <= 1000

--NOT Operator: display records if the condition is not true
--list orders that does not ship to USA of CANADA
SELECT OrderName, Country
FROM Orders
WHERE not ShipCountry in ('USA', 'CANADA')
-- or WHERE ShiptCountry not in ('USA', 'CANADA')

--NULL value: no value
--check which employee's region information is empty
SELECT EmployeeID, Firstname, Lastname
FROM Employees
WHERE region is NULL

CREATE TABLE TestSalary(EId int primary key identity(1,1), Salary money, Comm money)
INSERT INTO TestSalary VALUES(2000, 500), (2000, NULL), (1500, 500), (2000, 0), (NULL, 500)

SELECT *
FROM TestSalary

--NULL is numerical operation
SELECT salary, comm, IsNull(salary, 0) + ISNull(comm, 0) as total
FROM TestSalary

--LIKE Operator: search expression
--1. work with % wildcard character:
--retrieve all the employees whose last name starts with D

SELECT name
FROM Production.Product
Where name like 'd%'

--2. work with [] and % to search in ranges: find name whose ReorderPoint starts with number between 3 and 5

SELECT name, ReorderPoint
FROM Production.Product
where reorderpoint LIKE '[3-5]%'

--3. work with NOT:

SELECT name, ReorderPoint
FROM Production.Product
where reorderpoint not LIKE '[3-5]%'

--4. Work with ^:
SELECT name, ReorderPoint
FROM Production.Product
where reorderpoint LIKE '[^3-5]%'

--Customer name starting from letter A but not followed by 1-n
SELECT name
FROM Production.Product
where name like 'b[^d-z]%'

--Order by statement: sort the result in ascending or descending order
--1. retrieve all customers except those in Boston and sort by Name

SELECT Name, CityName
FROM Production.Product
WHERE CityName !='Boston'
Order By Name

--2. retrieve product name and unit price, and sort by unit price in descending order
Select ProductName, UnitPrice
From Products
Order By UnitPrice DESC

--3. Order by multiple columns

Select ProductName, UnitPrice
From Products
Order By 2 DESC, 1 DESC


--JOIN
--1. INNER JOIN : return the records that have matching values in both tables
--find employees who have deal with any orders
SELECT e.employeeID, e.Firstname +'' + e.Lastname as FullName, o.OrderID
FROM Employees e inner join orders o on e.EmployeeID = e.EmployeeID

--default join is inner join. JOIN = INNER JOIN


--Curstomers information and corresponding order date

SELECT c.ContactName, city, country, o.OrderDate
From customers c inner join orders o on c.customerID = o.CustomerID

--join multiple tables:
--get customer name, the corresponding employee who is responsible for this order, and the order date
SELECT c.ContactName,c.city, o.OrderDate, e.EmployeeID, e.FirstName
From customers c inner join orders o on c.customerID = o.CustomerID inner join employees e on e.employeeID = o.EmployeeID
order by 1

--add detailes information about quantity and price, join order details
SELECT c.ContactName,c.city, o.OrderDate, e.EmployeeID, e.FirstName, od.quantity, od.UnitPrice
From customers c inner join orders o on c.customerID = o.CustomerID inner join employees e on e.employeeID = o.EmployeeID inner join [Order Details] od on od.orderID = o.orderID
order by 1

--2. OUTER JOIN
--1) LEFT OUTER JOIN: return all records from left table, matched records from right tables, for the non-matched records in the right table, return null values
--list all customers whether they have made any purchase or not

SELECT c.contactName, o.OrderID
FROM Customers c left join orders o on c.customerID = o.CustomerID
order by o.OrderID

--Join with WHERE: find out customers who have never placed anu order

SELECT c.contactName, o.OrderID
FROM Customers c left join orders o on c.customerID = o.CustomerID
WHERE o.orderID is null

--2) RIGHT OUTER JOIN: return all records from right table, matched records from left table, non-matched ->null
SELECT o.orderID, e.LastName, e.firstName
FROM orders o right join employees e on o.employeeID = e.EmployeeID
order by o.orderID

--3) FULL OUTER JOIN:
--Match all customers and suppliers by country
SELECT c.ContactName, c.country as customercountry, s.country as suppliercountry, s.CompanyName
FROM customers c full join suppliers s on c.country = s.Country
order by c.country, s.country

--minimal rows returned: the row number of the largest table
--t1: 10 rows; t2: 20 rows; 10 matched rows on join condigtion -->20 columns
--maximum rows returned: the product of number of rows in both table if the join condition is always true

Select *
From Customers c Full JOIN Orders o on 1=1



--4) CROSS JOIN: create the cartesian product of two table, no JOIN CONDITION
--table 1: 10 rows; table 2: 20 rows; 10 matched rows
--cross join always return 200 columns

SELECT COUNT(*)
FROM Suppliers

SELECT*
FROM SUppliers cross join products

--5) SELF JOIN: join a table with itself
SELECT Employeeid, firstname, lastname, reportsto
from employees

--CFO: Andrew
--Manager: Nancy, Janet, Margaret, Steven, Laura
--Employee: Michale, Robert, Anne

-- employees with the their manager name

SELECT e.firstname +''+ e.lastname as employeename, m.firstname + ''+m.lastname as manager
FROM employees e inner join employees m on e.reportsto = m.employeeID

SELECT e.firstname +''+ e.lastname as employeename, isnull(m.firstname + '' +m.lastname, 'N/A') as manager
FROM employees e left join employees m on e.reportsto = m.employeeID


--find customers who make purchase for consecutive 3 years
select *
from orders

select distinct o1.customerID, year(o1.orderdate) as year1, year(o2.orderdate) as year2, year(o3.orderdate) as year3
from orders o1, orders o2, orders o3
where Year(o1.orderdate) = year(o2.orderdate) -1 and year(o1.orderdate) = year(o3.orderdate) -2 and o1.customerID = o2.customerID and o1.customerID = o3.CustomerID
order by o1.customerid

--batch directives //executing by batch
create database septbatch
go
use septbatch
go
create table employee(id int, ename varchar(20), salary money)

select *
from employee
