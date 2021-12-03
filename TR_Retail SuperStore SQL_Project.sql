-- Find the maximum quantity sold in a transaction

select max(Quantity) as Max_Quantity from TR_OrderDetails

-- Find the count / frequency of the max quantity sold in a transaction

select max(Quantity) as Max_Quantity, count(1) as Counter from TR_OrderDetails

-- Find the unique products in all the transactions

select distinct ProductID from TR_OrderDetails

-- Find and sort the unique Product ID and associated Quantity

select distinct ProductID, Quantity from TR_OrderDetails
order by ProductID asc, Quantity desc

-- Find and sort the unique Product ID and associated Quantity where max quantity is 3

select distinct ProductID, Quantity from TR_OrderDetails
where Quantity = 3
order by ProductID asc, Quantity desc

-- Identify the unique PropertyIDs

select distinct PropertyID from TR_OrderDetails

-- Find the product category that has the maximum products

select ProductCategory, count(1) as ProductCount 
from TR_Products group by ProductCategory
order by 2 desc

-- Find the state where most of the stores are present

select PropertyState, count(PropertyCity) as CityCount 
from TR_PropertyInfo group by PropertyState
order by 2 desc

-- Find the top 5 Product IDs that did maximum sales in terms of quantity

select top 5 ProductID, sum(Quantity) as QtySum 
from TR_OrderDetails group by ProductID
order by QtySum desc

-- Find the top 5 Property IDs that did maximum quantity

select top 5 PropertyID, sum(Quantity) as QtySum 
from TR_OrderDetails group by PropertyID
order by QtySum desc

-- Find the top 5 product names that did maximum sales in terms of quantity

select top 5 p.ProductName, sum(od.Quantity) as QtySum
from TR_OrderDetails as od
inner join TR_Products as p
on od.ProductID = p.ProductID
group by p.ProductName
order by 2 desc

-- -- Find the top 5 product names that did maximum sales in terms of quantity -- alternate version

select t1.ProductID, t1.QtySum, t2.ProductName
from (
select top 5 ProductID, sum(Quantity) as QtySum 
from TR_OrderDetails group by ProductID
order by QtySum desc
)
as t1
join TR_Products t2
on t1.ProductID = t2.ProductID
order by QtySum desc

-- Find the top 5 product names that did maximum sales in terms of revenue

select top 5 p.ProductName, sum(od.Quantity*p.Price) as SalesRevenue
from TR_OrderDetails as od
inner join TR_Products as p
on od.ProductID = p.ProductID
group by p.ProductName
order by 2 desc

-- Find the top 5 cities that did maximum sales in terms of q

select top 5 pi.PropertyCity, sum(od.Quantity*p.Price) as SalesRevenue
from TR_OrderDetails as od
inner join 
TR_Products as p on od.ProductID = p.ProductID
inner join 
TR_PropertyInfo as pi on od.PropertyID = pi.[Prop ID]
group by pi.PropertyCity
order by 2 desc

-- Find the top 5 products in each of the cities (Arlington)

select top 5 pi.PropertyCity, p.ProductName, sum(od.Quantity*p.Price) as SalesRevenue
from TR_OrderDetails as od
inner join 
TR_Products as p on od.ProductID = p.ProductID
inner join 
TR_PropertyInfo as pi on od.PropertyID = pi.[Prop ID]
where pi.PropertyCity = 'Arlington'
group by pi.PropertyCity, p.ProductName
order by 3 desc

-- Find the top 5 products in each of the cities (New York)

select top 5 pi.PropertyCity, p.ProductName, sum(od.Quantity*p.Price) as SalesRevenue
from TR_OrderDetails as od
inner join 
TR_Products as p on od.ProductID = p.ProductID
inner join 
TR_PropertyInfo as pi on od.PropertyID = pi.[Prop ID]
where pi.PropertyCity = 'New York'
group by pi.PropertyCity, p.ProductName
order by 3 desc

