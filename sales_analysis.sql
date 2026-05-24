select * from city;
select * from product;
select * from sales;
select * from customers;

show search_path;
set search_path to coffeesalesdata;

-- -- Q.1
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

select city.city_name, sum(total) as total_revenue
from sales as sale
join product as prod
on sale.product_id = prod.product_id
join customers as cust
on cust.customer_id = sale.customer_id
join city
on cust.city_id = city.city_id
where
	extract(year from sale_date)  = 2023
		and
		extract(quarter from sale_date) = 4
group by 1
order by 2 desc;


-- Q.2
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?

select product_name, count(*) as sale_count
from sales as sale
join product as prod
on sale.product_id = prod.product_id
group by 1
order by 2 desc;


-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?

select city_name, sum(total) as avg_sales, count(distinct(sale.customer_id)) as total_customers
from sales as sale
join customers as cust
on cust.customer_id = sale.customer_id
join city
on cust.city_id = city.city_id
group by 1
order by 3 desc;


-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city.
with monthly_sales as (
	select city_name,  
	extract(month from sale_date) as sale_month, 
	extract(year from sale_date) as sale_year,
	sum(s.total) as cr_month_sale
	from sales as s
	join customers as cu
	on s.customer_id = cu.customer_id
	join city as c
	on cu.city_id = c.city_id
	group by city_name, 2, 3
	order by city_name, 3, 2
), growth_ratio as ( SELECT
	city_name,
	sale_month,
	sale_year,
	cr_month_sale,
	LAG(cr_month_sale, 1)OVER(PARTITION BY city_name ORDER BY sale_year, sale_month) as last_month_sale
FROM monthly_sales
) select 
	city_name,
	sale_month,
	sale_year,
	cr_month_sale,
	last_month_sale,
	ROUND(
		((cr_month_sale-last_month_sale)::numeric/last_month_sale::numeric) * 100
		, 2
		) as growth_ratio
	from growth_ratio
	where last_month_sale is not null
;