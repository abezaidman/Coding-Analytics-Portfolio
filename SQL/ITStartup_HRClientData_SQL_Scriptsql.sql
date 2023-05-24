USE [ITStartUp];

--It's a good idea to check the existing tables
SELECT * FROM sys.objects WHERE [type]='U';

--FR1(Human Resources) (Hint: Review Module 3 .sql file to refresh your knowledge)
--Add a third department, Operations, to the Department table.
--You will assign your positions, salaries, etc. and the Department field will be “Operations”.
INSERT INTO [HumanResources].[Department](Dept_ID,Dept_Name)
VALUES(3, 'Operations');

SELECT * FROM [HumanResources].[Department];

--Add executives' data (up to three individuals including yourselves) into the Employee table
INSERT INTO [HumanResources].[Employee](Employee_ID, FirstName, LastName, Gender,Position, Dept_ID, Salary)
values(3011, 'Daniel', 'Cohen', 'M', 'President', 3, 300000), 
(3012, 'Abe', 'Zaidman', 'M', 'Janitor', 3, 700000),
(3013, 'Matthew', 'Pattman', 'M', 'CEO', 3, 80000);

SELECT * FROM [HumanResources].[Employee]

--CREATE TABLES Client, [View], Pricing, ClientType, RegionAgent
Create Table Client(
ClientID int,
[Name] varchar(255), 
TypeID int,
City varchar (255),
Region varchar(255),
Pricing int);

Create Table [View](
ViewID int, 
ViewDate datetime,
ID int, 
Device varchar(255),
Browser varchar(255),
Host varchar (255));

Create Table Pricing(
PlanNo int,
PlanName varchar (255),
Monthly int);

Create Table ClientType(
TypeName varchar (255),
TypeID int)

Create Table RegionAgent(
Region varchar (255),
EmployeeID int)

--BULK INSERT commands for Client and View and filling other tables with copy and paste
BULK Insert [APP].[Client]
FROM 'C:\Users\dcohe\Desktop\Client.csv'
WITH(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
FIRSTROW = 2); 

BULK INSERT [APP].[View]
FROM 'C:\Users\dcohe\Desktop\View.txt'
WITH (
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n',
FIRSTROW = 2); 

--FR3.Q1: Top ten Spas & Salons’ names, regions, and the number of views, with the highest views.

SELECT TOP 10 c.[Name], c.Region, COUNT(v.ID) AS [NUMBER OF VIEWS] FROM [APP].[Client] c
	JOIN [APP].[View] v on c.clientID = v.ID
	JOIN [APP].[ClientType] ct on ct.TypeID = c.TypeID
WHERE ct.TYPEID = 14
GROUP BY c.[Name], c.Region
ORDER BY [NUMBER OF VIEWS] DESC

--FR3.Q2: All clients whose names start OR end with the text ‘Grill’, along with their cities, 
--subscription fees**, and number of views.
SELECT c.[Name], c.Region, c.City, Format(p.Monthly,'C') AS [SUBSCRIPTION FEES], COUNT(v.ID) AS [NUMBER OF VIEWS] FROM [APP].[Client] c
	JOIN [APP].[View] v on c.clientID = v.ID
	JOIN [APP].[ClientType] ct on ct.TypeID = c.TypeID
	JOIN [APP].[Pricing] p on p.PlanNo = c.Pricing
WHERE c.[Name] LIKE 'Grill%' OR c.[NAME] LIKE '%GRILL'
GROUP BY c.[Name], c.Region, c.City, p.Monthly
ORDER BY [NUMBER OF VIEWS] DESC

--FR3.Q3: Count of client types (Arts & Entertainment, Bakery, etc.) with their average views per client* 
--and average subscription fees per client** sorted with respect to average views per client in descending order.
SELECT ct.TypeName, ct.TypeID, 
FORMAT(AVG(p.Monthly),'C') AS [Average Sub Fees],
COUNT(Distinct c.ClientID) AS [Count of Client Types],
ROUND(COUNT([Count of Views])/CAST(COUNT(DISTINCT c.ClientID) AS float),2) AS [Average View Per Client]
	   FROM (SELECT CAST(COUNT(v.ViewID) AS float) as [Count of Views]
	   , c.ClientID 
	   FROM [App].[View] v
		JOIN [App].[Client] c ON v.ViewID = c.ClientID
	   GROUP BY c.ClientID) AS [Count of Views]
	JOIN [APP].[View] v ON [Count of Views].clientID = v.ID
	JOIN [App].[Client] c ON v.ID = c.ClientID
	JOIN [APP].[ClientType] ct ON ct.TypeID = c.TypeID
	JOIN [APP].[Pricing] p ON p.PlanNo = c.Pricing
GROUP BY ct.TypeName, ct.TypeID
ORDER BY [Average View Per Client] DESC
--Used a subquery to calculate count of views, and then consequently, average view per client 

--FR3.Q4: Cities (along with their regions) for which total number of views 
--for non-restaurant clients are more than 15
SELECT c.City, c.Region, COUNT(v.ViewID) AS [NUMBER OF VIEWS] FROM [APP].[Client] c
	LEFT JOIN [APP].[View] v ON c.clientID = v.ID
	LEFT JOIN [APP].[ClientType] ct ON ct.TypeID = c.TypeID
	LEFT JOIN [APP].[Pricing] p ON p.PlanNo = c.Pricing
WHERE ct.TypeID != 13
GROUP BY c.Region, c.City
HAVING COUNT(v.ViewID) > 15
ORDER BY [NUMBER OF VIEWS] DESC

--FR3.Q5: States (regions) with number of clients and number of coffee customers 
--for those states (regions) in which there are both types of customers.
SELECT c.Region, COUNT(c.REGION) AS [NUMBER OF CLIENTS] INTO #TEMP1 FROM [APP].[Client] c
GROUP BY c.REGION

SELECT cu.[State], COUNT(cu.[State]) AS [NUMBER OF COFEE CUSTOMERS] INTO #TEMP2 FROM [Restaurant].[Customer] cu
GROUP BY cu.[State] 

SELECT Region, [State],[NUMBER OF COFEE CUSTOMERS], [NUMBER OF CLIENTS] FROM #TEMP1 Right Join #TEMP2 ON Region = [State]
-- Created temporary tables and then joined them. We did this because you cannot group by those two things together.

--FR3.Q6: Number of clients, their total fees**, total views, and average fees per view** 
--with respect to regions, sorted in descending order of average fees per views.
--Hint: You can use Derived Table (i.e, subquery with an alias)

SELECT Region,
FORMAT(COUNT(DISTINCT(c.ClientID)),'C') AS [Number of clients],
SUM(p.monthly) AS [Total Fees], 
COUNT(v.viewID) AS [Total Views],
FORMAT(AVG(p.monthly),'C') As [Avg Fees]
FROM [APP].[Client] c
	JOIN [APP].[Pricing] p ON c.Pricing = p.PlanNo
	JOIN [APP].[View] v ON v.ID = c.ClientID
GROUP BY Region
ORDER BY [Avg Fees] DESC

--FR3.Q7: All views (all columns) that took place after October 15th, by Kindle devices, 
--hosted by Yelp from cities where there are more than 20 clients. 
--Also add the name and the city of the client as last columns for each view.

SELECT ViewID, ViewDate, ID, Device, Browser, Host, ClientID, TypeID, Region, Pricing, [Name], City 
FROM [APP].[View] v
	JOIN [APP].[Client] c ON v.ID = c.ClientID
WHERE v.ViewDate > '2022-10-15'
	AND v.HOST = 'yelp'
	AND v.Device = 'Kindle'
	AND c.City IN
(SELECT City FROM [APP].[Client]
Group BY City
HAVING Count(ClientID) >20)

--FR3.Q8: All non-executive employee full names, number of their regions, number of their clients, 
--number of views for those clients, number of distinct coffee customers, and total coffee sales**. 
--If there is no coffee sale for an employee, write “Not coffee agent” instead of NULL values. 
--Hint: you can use CASE statements.

SELECT e.Employee_ID, FirstName + ' ' + LastName AS [FULL NAME],
COUNT(DISTINCT(r.Region)) AS [NUMBER OF REGIONS],
COUNT(DISTINCT (c.ClientID)) AS [Number of their Clients],
COUNT(DISTINCT(v.ViewID)) AS [Number of Views For Those Clients],
COUNT(DISTINCT(cu.CustomerNum)) AS [NUMBER OF CUSTOMERS],
CASE WHEN SUM(o.OrderAmountKg *co.PricePerKg) IS NULL THEN 'Not Coffee Agent'
ELSE ([TCF].[Total Coffee Sales])
END AS [Total Coffee Sales]
	FROM (SELECT c.[State], Format(SUM(o.OrderAmountKg*co.PricePerKg),'C') AS [Total Coffee Sales],r.EmployeeID
	FROM [Restaurant].[Coffee] co
		JOIN [Restaurant].[Order] o ON co.CoffeeID = o.CoffeeID
		JOIN [Restaurant].[Customer] c ON c.CustomerNum = o.CustomerNum
		JOIN [HumanResources].[RegionAgent] r ON c.[State] = r.Region
	Group By c.[State], r.EmployeeID) AS [TCF]
	RIGHT JOIN [HumanResources].[Employee] e ON e.Employee_ID = [TCF].EmployeeID
	JOIN [HumanResources].[RegionAgent] r ON e.Employee_ID = r.EmployeeID
	JOIN [APP].[Client] c ON r.Region = c.Region
	JOIN [APP].[View] v ON c.ClientID = v.ID
	LEFT JOIN [Restaurant].[Customer] cu ON r.Region = cu.[State]
	LEFT JOIN [Restaurant].[Order] o ON cu.CustomerNum = o.CustomerNum
	LEFT JOIN [Restaurant].[Coffee] co ON co.CoffeeID = o.CoffeeID
GROUP BY FirstName + ' ' + LastName, e.Employee_ID,TCF.[Total Coffee Sales]
ORDER By e.Employee_ID
-- we used subqueries to get the correct amount of total coffee sales. 


--FR3.Q9: Create a view named vEmployeeClientCustomer based on the query in FR3.Q8.
CREATE VIEW [vEmployeeClientCustomer] AS
SELECT e.Employee_ID, FirstName + ' ' + LastName AS [FULL NAME],
COUNT(DISTINCT(r.Region)) AS [NUMBER OF REGIONS],
COUNT(DISTINCT (c.ClientID)) AS [Number of their Clients],
COUNT(DISTINCT(v.ViewID)) AS [Number of Views For Those Clients],
COUNT(DISTINCT(cu.CustomerNum)) AS [NUMBER OF CUSTOMERS],
CASE WHEN SUM(o.OrderAmountKg *co.PricePerKg) IS NULL THEN 'Not Coffee Agent'
ELSE ([TCF].[Total Coffee Sales])
END AS [Total Coffee Sales]
	FROM (SELECT c.[State], Format(SUM(o.OrderAmountKg*co.PricePerKg),'C') AS [Total Coffee Sales],r.EmployeeID
	FROM [Restaurant].[Coffee] co
		JOIN [Restaurant].[Order] o ON co.CoffeeID = o.CoffeeID
		JOIN [Restaurant].[Customer] c ON c.CustomerNum = o.CustomerNum
		JOIN [HumanResources].[RegionAgent] r ON c.[State] = r.Region
	Group By c.[State], r.EmployeeID) AS [TCF]
	RIGHT JOIN [HumanResources].[Employee] e ON e.Employee_ID = [TCF].EmployeeID
	JOIN [HumanResources].[RegionAgent] r ON e.Employee_ID = r.EmployeeID
	JOIN [APP].[Client] c ON r.Region = c.Region
	JOIN [APP].[View] v ON c.ClientID = v.ID
	LEFT JOIN [Restaurant].[Customer] cu ON r.Region = cu.[State]
	LEFT JOIN [Restaurant].[Order] o ON cu.CustomerNum = o.CustomerNum
	LEFT JOIN [Restaurant].[Coffee] co ON co.CoffeeID = o.CoffeeID
GROUP BY FirstName + ' ' + LastName, e.Employee_ID,TCF.[Total Coffee Sales]
ORDER By e.Employee_ID

--FR3.Q10: Create a stored procedure named spEmployeeReport based on the view in FR3.Q9, 
--for which you will pass the last name of the employee only. 
--The [HumanResources].[RegionAgent]result should be FR3.Q9 only for that employee. 

CREATE PROCEDURE spEmployeeReport @LastName nvarchar(50)
AS BEGIN 
SELECT * FROM [dbo].[vEmployeeClientCustomer]
WHERE [FULL NAME] LIKE '%'+@LastName
END;


--FR4 (Business Intelligence): 
--Query for FR4.BI1

SELECT DATEPART(HOUR, v.ViewDate) + 1 AS [Hour of Day],
ROUND ((COUNT (v.ViewID)/31.0), 2) AS [Average Restaurant Views]
FROM [App].[View] v
	JOIN [App].[Client] c on c.ClientID = v.ID
	JOIN [APP].[ClientType] ct on c.TypeID = ct.TypeID
WHERE ct.TypeID = 13 AND MONTH (V. ViewDate) = 10
GROUP BY DATEPART (HOUR, v.ViewDate)
ORDER BY DATEPART (HOUR, v. ViewDate) ASC;

SELECT DATEPART(HOUR, v.ViewDate) + 1 AS [Hour of Day],
ROUND ((COUNT (v.ViewID)/31.0), 2) AS [Average Non-Restaurant Views]
FROM [App].[View] v
	JOIN [App].[Client] c on c.ClientID = v.ID
	JOIN [APP].[ClientType] ct on c.TypeID = ct.TypeID
WHERE ct.TypeID != 13 AND MONTH (V. ViewDate) = 10
GROUP BY DATEPART (HOUR, v.ViewDate)
ORDER BY DATEPART (HOUR, v. ViewDate) ASC;
--we used datepart and hour functions to extract the hours. 