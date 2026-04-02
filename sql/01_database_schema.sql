 /* DATABASE SCHEMA */
CREATE DATABASE IF NOT EXISTS ecommerce;

USE ecommerce;

-- create table
CREATE TABLE ecommerce_transactions (
	order_id VARCHAR(60),
    customer_name VARCHAR(100),
	customer_email VARCHAR(50),
    city VARCHAR(100),
    order_date DATE,
    product VARCHAR(50),
    quantity int,
    discount DECIMAL(5,2),
    revenue DECIMAL(10,2),
    payment_method VARCHAR(50),
    shipped VARCHAR(10),
    customer_id VARCHAR(100),
    unit_price DECIMAL(10,2),
    order_month VARCHAR(30),
    order_year INT,
    month_num INT
);

-- add primary key
ALTER TABLE ecommerce_transactions
ADD PRIMARY KEY (order_id);

-- creted index table
CREATE INDEX idx_customer ON ecommerce_transactions(customer_id);

SELECT * FROM ecommerce_transactions;


