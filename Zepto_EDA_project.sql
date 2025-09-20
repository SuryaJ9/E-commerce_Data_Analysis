CREATE TABLE zepto (
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

-- step 1: Understand the Data first
-- preview dataset.

select * from zepto
limit 10;

--- Row count
select count(*) from zepto;

-- Goals gere:
--> See Categories,item names,quantities
--> Confirm data types and NULL values
--> know how many rows you're dealing with.

-- step 2: Data Quality checks:

--- checking missing values:

select 
sum(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS missing_category,
sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing,
sum(CASE WHEN mrp IS NULL THEN 1 ELSE 0 END) AS missing_mrp,
sum(CASE WHEN discountpercent IS NULL THEN 1 ELSE 0 END) AS missing_discountperecent,
sum(CASE WHEN mrp IS NULL THEN 1 ELSE 0 END) AS missing_mrp,
sum(CASE WHEN availableQuantity IS NULL THEN 1 ELSE 0 END) AS missing_availability
from zepto;

-- checking the duplicates:
select name,count(*)
from zepto
group by name
having count(*) > 1;

-- step 3: Descriptive Stats

-- Summary statistics

select 
MIN(mrp) AS min_mrp,
MAX(mrp) as max_mrp,
AVG(mrp) as avg_mrp,
MIN(discountPercent) as min_discount,
MAX(discountPercent) as max_discount,
avg(discountPercent) as avg_discount,
MIN(discountedSellingPrice) as min_selling,
MAX(discountedSellingPrice) as max_selling,
avg(discountedSellingPrice) as avg_selling
from zepto;

-- -MRP (Maximum Retail Price) should logically never be zero.

-- This likely indicates:

-- Data entry error (missing MRP not entered correctly).

-- System default (zeros filled where price wasn’t available).

-- Special cases (e.g., promotional free items, but those should usually be flagged differently).

-- Data cleaning:
-- Identify the how many rows have mrp = 0
select count(*) from zepto where mrp = 0;

-- step 4: Category-Level Analysis

-- Items by category:
select category,
count(*) as num_items
from zepto
group by category
order by num_items desc;

-- Category wise sales

select category,
round(sum(discountedsellingprice)::numeric/1000000,2) as revenue_in_millions
from zepto
group by category
order by revenue_in_millions desc 
limit 3;

-- Average discount per category:

select category,
round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 3;

-- Revenue by product name
select name,sum(discountedsellingprice) as total_revenue
from zepto
group by name
order by total_revenue desc
limit 3;

-- out-of-stock ratio
select category,
sum(
CASE WHEN outofstock = true then 1 else 0 END)::FLOAT / COUNT(*) * 100 AS out_of_stock_pct
from zepto
group by category
order by out_of_stock_pct DESC
limit 3;

-- Step 5: Pricing & Discount Insights

-- Biggest discounts

select name,
category,
mrp,
discountedSellingPrice,
discountPercent
from zepto
order by 4 desc
limit 5;

select name,
category,
avg(mrp) as avg_mrp,
avg(discountedSellingPrice) as dis_cnt_price,
avg(discountPercent) as avg_discount_percentage
from zepto
group by 1,2
order by dis_cnt_price desc
limit 10;

-- Profit gap (potential margin loss)
select 
name,
mrp,
discountedSellingPrice,
(mrp - discountedSellingPrice) as discount_value
from zepto
order by discount_value desc
limit 10;

-- Profit gap by category wise.

select
category,
round(sum(discountedsellingprice)::numeric/1000000,2) as Revenue_in_millions,
sum(mrp - discountedsellingprice) as total_discount_value
from zepto
group by category
order by 2 DESC;

-- Step 6: Inventory Insights

-- Top Stocked products

select name,sum(availableQuantity) as sum_of_quantity
from zepto
group by name
order by sum_of_quantity desc
limit 10;

select name,sum(availableQuantity) as sum_of_quantity
from zepto
group by name
having sum(sum_of_quantity) < 1
order by 2 desc
limit 10;

-- Write a query to retrieve the name of the products that have less stock_quantity.

with stock_quantity as (
select name,sum(availableQuantity) as sum_of_quantity
from zepto
group by name
)
select name,
sum_of_quantity
from stock_quantity
where sum_of_quantity < 1
order by sum_of_quantity desc;

--- step 7: Advanced EDA

-- Correlation Analysis:
-- Example: Higher discounts always linked with out-of-stock items?)
-- Category revenue potential:

select category,
round(sum((discountedSellingPrice * availableQuantity)::numeric)/1000000,2) as potential_revenue_in_millions
from zepto
group by category
order by potential_revenue_in_millions desc;

-- price per gram analysis
select name,category,
round(discountedsellingprice / NULLIF(weightInGms,0),2) as price_per_gm
from zepto
order by price_per_gm asc
limit 10;

-- client ready KPI metrics:
-- Number of  products per category

select count(distinct name) as num_items
from zepto;

-- Average discount (%) per category

-- Potential Revenue
select category,
round(sum((discountedSellingPrice * availableQuantity)::numeric)/1000000,2) as potential_revenue_in_millions
from zepto
group by category
order by potential_revenue_in_millions desc;

with stock_quantity as (
select name,sum(availableQuantity) as sum_of_quantity
from zepto
group by name
)
select name,
sum_of_quantity
from stock_quantity
where sum_of_quantity < 5
order by sum_of_quantity desc;

-- average discount(%) per category
SELECT 
    category,
    ROUND(AVG(discountPercent * quantity),2) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

-- Total Revenue

select 
ROUND(sum(discountPercent * quantity),2) AS total_revenue
from zepto;

-- Total Categories
select count( distinct category) as no_of_category
from zepto;

-- category wise revenue:

select category,
ROUND(sum(discountPercent * quantity),2) AS total_revenue
from zepto
group by category
order by total_revenue desc;



