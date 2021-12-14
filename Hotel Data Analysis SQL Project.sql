-- Using union to combine data from 2018,2019,2020
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']

-- Checking to see if our hotel revenue is growing YoY
-- Creating a temp table to merge and query the revenue data

with hoteltemp as (

select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']
)

select * from hoteltemp

-- Creating a new revenue column based on ADR and stay in nights
-- grouping data by year and hotel to check revenue growth

with hoteltemp as (

select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']
)

select arrival_date_year, Hotel, 
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue 
from hoteltemp
group by arrival_date_year, Hotel

-- Join market segment and meal cost table to the temp table
-- Preview market segment table
select * from market_segment$

-- Join market segment and meal cost table to the temp table
with hoteltemp as (

select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']
)

select * from hoteltemp
left join market_segment$
on hoteltemp.market_segment = market_segment$.market_segment
left join
dbo.meal_cost$
on meal_cost$.meal = hoteltemp.meal

-- Next step is to bring the data into powerbi

