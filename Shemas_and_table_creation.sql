-- SCHEMA: coffeeSalesData

-- DROP SCHEMA IF EXISTS "coffeeSalesData" ;

CREATE SCHEMA IF NOT EXISTS "coffeeSalesData"
    AUTHORIZATION postgres;

show search_path;
select current_database();
select schema_name from information_schema.schemata;
where schema_name = 'coffeeSalesData';
set search_path to coffeeSalesData;

select * from city;
select * from product;
select * from customers;
select * from sales;

drop table if exists city;
drop table if exists product;
drop table if exists customer;
drop table if exists sales;

create table coffeesalesdata.city (
	city_id int primary key,
	city_name varchar(50),
	population bigint,
	estimated_rent float,
	city_rank int
);

create table product (
	product_id int primary key,
	product_name varchar(50),
	price int
);

create table customers (
	customer_id int primary key,
	customer_name varchar(50),
	city_id int,
	constraint fk_city foreign key (city_id) references city(city_id) 
);

create table sales (
	sale_id int primary key,
	sale_date date,
	product_id int,
	customer_id int,
	total float,
	rating int,
	constraint fk_customers foreign key (customer_id) references customers(customer_id),
	constraint fk_product foreign key (product_id) references product(product_id)
);



copy coffeeSalesData.city
from 'C:/Users/USER/Desktop/sql tutorial/coffee_business/Monday-Coffee-Expansion-Project-P8-main/city.csv'
delimiter ','
csv header
null '';


