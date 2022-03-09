/* These queries ensured I gained appreciable mastery of different query structures and approaches to data exploration and cleaning*/

select * 
from dbo.Employees

Select * 
from dbo.orders

select * from dbo.Products

Select * from dbo.Suppliers

select * 
from dbo.Shippers

select * 
from dbo.Customers

Select * 
from dbo.orders

select * 
from dbo.[Order Details]

select * 
from dbo.Categories


Select * 
from dbo.orders 
where EmployeeID = '5'

Select SupplierID, ContactName , ContactTitle 
from dbo.Suppliers 
where ContactTitle != 'Marketing Manager'

select dbo.Products.ProductID, dbo.Products.ProductName 
from dbo.Products 
where ProductName like '%queso%'

select orderID, customerID, shipCountry 
from dbo.Orders 
where ShipCountry = 'france' or shipcountry = 'Belgium'

select orderID, customerID, shipCountry 
from dbo.Orders 
where ShipCountry in ('brazil', 'mexico', 'venezuela', 'argentina')

select firstname, lastname, title, birthdate 
from dbo.Employees 
order by BirthDate

select firstname, lastname, title, birthdate = convert (date, birthdate) 
from dbo.Employees 
order by BirthDate

select firstname, lastname, fullname = concat(firstname,' ',lastname) 
from dbo.Employees

select firstname, lastname, fullname = firstname+' '+lastname 
from dbo.Employees

select unitprice, quantity, Totalprice = unitprice*quantity 
from dbo.[Order Details]

Select TotalCustomers = count(*) 
from dbo.Customers

Select Firstorder = min(orderdate) 
from dbo.Orders

Select Country from dbo.Customers 
group by Country

select Totalnumber = count(contacttitle), contacttitle 
from dbo.Customers 
group by ContactTitle 
order by Totalnumber asc

select dbo.Products.SupplierID, dbo.Products.ProductID, dbo.Products.Productname, dbo.Suppliers.ContactName, dbo.Suppliers.companyname 
from dbo.Products 
inner join dbo.Suppliers on dbo.Products.SupplierID= dbo.Suppliers.SupplierID

select dbo.Orders.OrderID AS ID, OrderDate = convert (date, OrderDate), dbo.Shippers.CompanyName AS Mycompany 
from dbo.Orders 
inner join dbo.Shippers on dbo.Orders.ShipVia = dbo.Shippers.ShipperID 
where orderID < 10300 
order by dbo.Orders.OrderID

Select Total = count (dbo.Products.CategoryID), dbo.Categories.CategoryName 
from dbo.Products 
inner join dbo.Categories on dbo.products.CategoryID=dbo.Categories.CategoryID 
group by dbo.Categories.CategoryName 
order by Total desc

select country, city, TotalCustomers = count (*) 
from dbo.customers 
group by Country, city 
order by TotalCustomers desc

select * 
from dbo.Products 
where UnitsInStock <= ReorderLevel 
order by ProductID

Select productID, productname, unitsinstock, UnitsOnOrder, reorderlevel, Discontinued 
from dbo.Products 
where unitsinstock+UnitsOnOrder <= ReorderLevel and Discontinued = 0

Select customerID, CompanyName, ContactName, Region 
from Customers 
order by 
case when Region is NULL then 1 else 0 
End,
Region, CustomerID

Select Top 3 ShipCountry, AverageFreight = AVG(Freight) 
from dbo.Orders 
group by ShipCountry 
Order by AverageFreight desc

Select Top 3 ShipCountry, AverageFreight = AVG(Freight) 
from dbo.Orders 
where OrderDate like '%1997%' 
group by ShipCountry 
Order by AverageFreight desc

Select Top 3 ShipCountry, AverageFreight = AVG(Freight) 
from dbo.Orders 
where OrderDate >='19970101' and OrderDate <='19980101' 
group by ShipCountry 
Order by AverageFreight desc

Select Top 3 ShipCountry, AverageFreight = AVG(Freight) 
from dbo.Orders 
where year(OrderDate) = 1997 
group by ShipCountry 
Order by AverageFreight desc

Select Top 3 ShipCountry, AverageFreight = AVG(freight) 
from dbo.orders 
where OrderDate >= Dateadd(yyyy,-1,(Select Max(orderDate) from dbo.orders)) 
group by ShipCountry 
order by AverageFreight desc

Select dbo.Employees.EmployeeID, dbo.Employees.LastName, dbo.orders.orderID, dbo.Products.ProductName, dbo.[Order Details].Quantity 
from dbo.Employees 
inner join dbo.Orders on dbo.employees.EmployeeID = dbo.orders.EmployeeID 
join dbo.[Order Details] on dbo.Orders.OrderID = dbo.[Order Details].OrderID 
join dbo.Products on dbo.[Order Details].ProductID = dbo.Products.ProductID 
order by OrderID, dbo.Products.ProductID

Select NoOrderCustomers = CustomerID 
from dbo.Customers 
where CustomerID not in 
(
Select CustomerID 
from dbo.orders
)

Select CustomerID 
from dbo.Customers 
where CustomerID not in 
(
Select CustomerID 
from dbo.orders 
where EmployeeID = 4
) 

Select Getdate() AS TodaysDate

Select isdate ('2022/01/16') AS "YYYY/MM/DD"

SELECT DATEPART(Month, '2007-06-01') AS "Month"

Select Datepart(dy,Getdate())

Select Customers.CustomerID, Customers.CompanyName, orders.OrderID, Round(Sum(unitprice*Quantity*(1-Discount)),2) AS OrderValue 
from Customers 
join Orders on Customers.CustomerID = Orders.CustomerID 
join [Order Details] on Orders.OrderID = [Order Details].OrderID 
where Orders.OrderDate >= '19970101' and Orders.OrderDate < '19980101' 
group by Customers.CustomerID, Customers.CompanyName, orders.OrderID 
having Sum(unitprice*Quantity*(1-Discount)) < 15000 
order by OrderValue desc

Select OrderID, EmployeeID, orderdate = Convert(date,orderdate) 
from Orders 
where OrderDate = EOMONTH (orderdate) 
order by EmployeeID, OrderID

select top 10 Orders.OrderID, count([Order Details].OrderID) 
from Orders 
join [Order Details] on Orders.OrderID = [Order Details].OrderID 
group by Orders.OrderID 
order by count([Order Details].OrderID) desc

select top 2 percent orderID 
from Orders 
order by NEWID ()

Select orderID, count(quantity) 
from [Order Details] 
where Quantity >= 60 
group by orderID 
having count(quantity)>1 
order by OrderID

With PotentialDuplicates as 
(
Select OrderID 
from [Order Details] 
where Quantity >= 60 
group by OrderID 
having count(quantity)>1
) 
select * 
from [Order Details] 
where OrderID in 
(
Select OrderID 
from PotentialDuplicates
) 
order by OrderID, Quantity

With PotentialDuplicates as
(
Select OrderID 
from [Order Details] 
where Quantity >= 60 
group by OrderID 
having count(quantity)>1
) 
select [Order Details].ProductID, [Order Details].Quantity, Orders.OrderDate, Orders.Freight 
from [Order Details] 
join Orders on [Order Details].OrderID = Orders.OrderID 
where [Order Details].OrderID in 
(
Select OrderID 
from PotentialDuplicates
) 
order by [Order Details].OrderID, [Order Details].Quantity

Select orderid 
from Orders 
where RequiredDate <= ShippedDate

Select Fullname = Employees.LastName+' '+Employees.FirstName, count(*) as Occurences 
from Employees 
join orders on Employees.EmployeeID = Orders.EmployeeID 
where Orders.RequiredDate <= orders.ShippedDate 
group by Employees.LastName, Employees.FirstName 
order by Occurences desc

With AllOrders as 
(
Select EmployeeID, Count (*) as TotalOrders 
from Orders 
group by EmployeeID
), 
LateOrders as 
(
Select EmployeeID, count (*) as TotalOrders 
from Orders 
where RequiredDate <= ShippedDate 
group by EmployeeID
) 
Select Employees.EmployeeID, Employees.LastName, AllOrders = AllOrders.TotalOrders, LateOrders = LateOrders.TotalOrders 
from Employees 
join AllOrders on Employees.EmployeeID = AllOrders.EmployeeID 
join LateOrders on AllOrders.EmployeeID = LateOrders.EmployeeID 
group by Employees.EmployeeID, Employees.LastName, AllOrders.TotalOrders, LateOrders.TotalOrders

With AllOrders as 
(
Select EmployeeID, Count (*) as TotalOrders 
from Orders 
group by EmployeeID
), 
LateOrders as (
Select EmployeeID, count (*) as TotalOrders 
from Orders 
where RequiredDate <= ShippedDate 
group by EmployeeID
) 
Select Employees.EmployeeID, Employees.LastName, AllOrders = AllOrders.TotalOrders, LateOrders = LateOrders.TotalOrders, PercentageLateOrders = Convert(Decimal(2,2), (LateOrders.TotalOrders * 1.00/AllOrders.TotalOrders)) 
from Employees 
join AllOrders on Employees.EmployeeID = AllOrders.EmployeeID join LateOrders on AllOrders.EmployeeID = LateOrders.EmployeeID 
group by Employees.EmployeeID, Employees.LastName, AllOrders.TotalOrders, LateOrders.TotalOrders

Select Customers.CustomerID, Customers.CompanyName, Count([Order Details].OrderID) as NumberOfOrders 
from customers 
join Orders on Customers.CustomerID = Orders.CustomerID 
join [Order Details] on Orders.OrderID = [Order Details].OrderID 
where Orders.OrderDate >= '19970101' and Orders.OrderDate < '19980101' 
group by Customers.CustomerID, Customers.CompanyName 
order by NumberOfOrders desc

With Orders1997 as 
(
Select Customers.CustomerID, Customers.CompanyName, HowMuchOrdered = [Order Details].Quantity*[Order Details].UnitPrice 
from customers 
join Orders on Customers.CustomerID = Orders.CustomerID 
join [Order Details] on Orders.OrderID = [Order Details].OrderID 
where Orders.OrderDate >= '19970101' and Orders.OrderDate < '19980101' 
group by Customers.CustomerID, Customers.CompanyName, [Order Details].Quantity*[Order Details].UnitPrice
) 
Select CustomerID, CompanyName, HowMuchOrdered, OrderCategories = 
Case when HowMuchOrdered between 0 and 1000 
then 'Small' 
when HowMuchOrdered between 1000 and 5000 
then 'Medium' 
when HowMuchOrdered between 5000 and 10000 
then 'Large' 
when HowMuchOrdered >10000 
then 'ExtremelyLarge' 
End 
from Orders1997 
group by CustomerID, CompanyName, HowMuchOrdered 
order by HowMuchOrdered desc

Select Country 
from Suppliers 
UNION 
Select Country 
from Customers 
group by Country

With SupplierCountry as 
(
Select distinct Country 
from Suppliers
),
CustomerCountry as 
(
Select distinct Country 
from Customers
) 
Select CountryOfSupplier = SupplierCountry.Country, CountryOfCustomer = CustomerCountry.Country 
from SupplierCountry 
Full outer join CustomerCountry on SupplierCountry.Country = CustomerCountry.Country

With SupplierCountry as 
(
Select Country, TotalSuppliers = count (*) 
from Suppliers group by Country
), 
CustomerCountry as 
(
Select Country, TotalCustomers = count (*) 
from Customers group by Country
)
Select CountryOfSupplier = SupplierCountry.Country, Total_Suppliers = IsNull(SupplierCountry.TotalSuppliers,0), CountryOfCustomer = CustomerCountry.Country, Total_Customers = Isnull(CustomerCountry.TotalCustomers,0) 
from SupplierCountry 
Full outer join CustomerCountry on SupplierCountry.Country = CustomerCountry.Country

With SupplierCountry as 
(
Select Country, TotalSuppliers = count (*) 
from Suppliers 
group by Country
),
CustomerCountry as 
(
Select Country, TotalCustomers = count (*) 
from Customers 
group by Country
)
Select Country = IsNull(SupplierCountry.Country,CustomerCountry.Country), Total_Suppliers = IsNull(SupplierCountry.TotalSuppliers,0), Total_Customers = Isnull(CustomerCountry.TotalCustomers,0) 
from SupplierCountry 
Full outer join CustomerCountry on SupplierCountry.Country = CustomerCountry.Country