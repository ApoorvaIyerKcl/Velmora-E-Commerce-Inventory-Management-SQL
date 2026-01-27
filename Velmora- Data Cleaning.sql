USE clothing_industry;

DROP TABLE customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date TEXT,
    city VARCHAR(50),
    state VARCHAR(30),
    email_opt_in_flag INT,
    customer_segment VARCHAR(30)
);


SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

DROP TABLE dates;
CREATE TABLE dates (
    dates TEXT,
    year INT,
    month INT,
    day INT,
    quarter INT,
    season VARCHAR(20)
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- dates.csv'
INTO TABLE dates
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;


DROP TABLE inventory;
CREATE TABLE inventory (
    sku_id INT,
    warehouse_id INT,
    opening_stock INT,
    closing_stock INT,
    reorder_level INT,
    inventory_status VARCHAR(30)
);


LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- inventory.csv'
INTO TABLE inventory
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    season VARCHAR(20),
    fabric_type VARCHAR(50),
    fit_type VARCHAR(30),
    launch_date TEXT,
    discontinued_flag INT
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

DROP TABLE promotions;
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY ,
    promotion_name VARCHAR(50),
    discount_type VARCHAR(20),
    discount_value INT,
    promotion_start_date TEXT,
    promotion_end_date TEXT
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- promotions.csv'
INTO TABLE promotions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;


DROP TABLE sales_transactions;
CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    order_id INT,
    order_date TEXT,
    shipped_date TEXT,
    expected_delivery_date TEXT,
    actual_delivery_date TEXT,
    customer_id BIGINT,
    sku_id INT,
    quantity_sold INT,
    selling_price_usd DECIMAL(10,2),
    discount_amount_usd DECIMAL(10,2),
    net_sales_amount_usd DECIMAL(10,2),
    payment_method VARCHAR(30),
    return_flag INT
);


LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- sales_transactions.csv'
INTO TABLE sales_transactions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(
transaction_id,
order_id,
order_date,
shipped_date,
expected_delivery_date,
actual_delivery_date,
customer_id,
sku_id,
quantity_sold,
selling_price_usd,
discount_amount_usd,
@net_sales_amount_usd,
payment_method,
return_flag
)
SET net_sales_amount_usd= NULLIF(@net_sales_amount_usd, '');

DROP TABLE skus;
CREATE TABLE skus (
    sku_id INT PRIMARY KEY,
    product_id INT,
    color VARCHAR(30),
    size VARCHAR(10),
    mrp_usd DECIMAL(10,2),
    cost_price_usd INT,
    active_flag INT
);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- sku.csv'
INTO TABLE skus
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(50),
    city VARCHAR(30),
    state VARCHAR(30),
    country VARCHAR(30),
    capacity_units INT

);

LOAD DATA INFILE 'C:/Apoorva/Acciojob/SQL/EE- warehouses.csv'
INTO TABLE warehouses
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- CREATING DUPLICATE TABLES

-- Creating CUSTOMERS table
CREATE TABLE customers_duplicate
LIKE customers; 

INSERT customers_duplicate
SELECT * FROM customers;

-- Creating DATES table
DROP TABLE dates_duplicate;
CREATE TABLE dates_duplicate
LIKE dates; 

INSERT dates_duplicate
SELECT * FROM dates;

SELECT * FROM dates_duplicate;

-- Creating INVENTORY table

CREATE TABLE inventory_duplicate
LIKE inventory;

INSERT inventory_duplicate
SELECT * FROM inventory;

-- Creating PRODUCTS table 

CREATE TABLE products_duplicate
LIKE products;

INSERT products_duplicate
SELECT * FROM products;

-- Creating PROMOTIONS table 

CREATE TABLE promotions_duplicate
LIKE promotions;

INSERT promotions_duplicate
SELECT * FROM promotions;

-- Creating SALES_TRANSACTIONS table 

CREATE TABLE sales_transactions_duplicate
LIKE sales_transactions;

INSERT sales_transactions_duplicate
SELECT * FROM sales_transactions;

-- Creating SKUS table 

CREATE TABLE skus_duplicate
LIKE skus;

INSERT skus_duplicate
SELECT * FROM skus;

-- Creating WAREHOUSES table 

CREATE TABLE warehouses_duplicate
LIKE warehouses;

INSERT warehouses_duplicate
SELECT * FROM warehouses;

-- STANDARDISING DATA
SELECT signup_date
FROM customers_duplicate;

UPDATE customers_duplicate
SET signup_date = STR_TO_DATE(signup_date, '%d-%m-%Y %H:%i');

ALTER TABLE customers_duplicate
ADD COLUMN signup_date_only DATE,
ADD COLUMN signup_time TIME;


UPDATE customers_duplicate
SET signup_date_only = DATE(signup_date),
signup_time = TIME(signup_date);


-- FINDING DUPLICATES
-- Finding duplicates in customers_duplicate

WITH customer_duplicates AS (
SELECT signup_date, city, state, email_opt_in_flag, customer_segment, signup_date_only, signup_time,
ROW_NUMBER() OVER (PARTITION BY signup_date, city, state, email_opt_in_flag, customer_segment, signup_date_only, signup_time
ORDER BY signup_date
) AS rank_value
FROM customers_duplicate
)
SELECT * FROM customer_duplicates
WHERE rank_value > 1;

CREATE TABLE `customers_duplicate1` (
  `customer_id` int NOT NULL,
  `signup_date` text,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `email_opt_in_flag` int DEFAULT NULL,
  `customer_segment` varchar(30) DEFAULT NULL,
  `signup_date_only` date DEFAULT NULL,
  `signup_time` time DEFAULT NULL,
      `rank_value` INT,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT customers_duplicate1
SELECT customer_id, signup_date, city, state, email_opt_in_flag, customer_segment, signup_date_only, signup_time,
ROW_NUMBER() OVER (PARTITION BY signup_date, city, state, email_opt_in_flag, customer_segment, signup_date_only, signup_time
ORDER BY signup_date
) AS rank_value
FROM customers_duplicate; 

SELECT signup_date, city, state, email_opt_in_flag, customer_segment, signup_date_only, signup_time, rank_value
FROM customers_duplicate1
WHERE rank_value > 1; 

DELETE FROM customers_duplicate1
WHERE rank_value > 1;

-- Finding duplicates in dates_duplicate

UPDATE dates_duplicate
SET dates = STR_TO_DATE(dates, '%d-%m-%Y');

UPDATE dates_duplicate
SET dates = STR_TO_DATE(dates, '%d-%m-%Y');

SELECT DATE_FORMAT(dates, '%d-%m-%Y') AS dates, year, month, day, quarter
FROM dates_duplicate;

SELECT * FROM dates_duplicate;
SELECT * FROM (SELECT dates, year, month, day, quarter, season,
ROW_NUMBER () OVER (PARTITION BY dates, year, month, day, quarter, season 
ORDER BY dates) AS rank_value
FROM dates_duplicate) AS row_number_value
WHERE rank_value > 1 ;

ALTER TABLE dates_duplicate
ADD COLUMN auto_increment_key BIGINT AUTO_INCREMENT PRIMARY KEY;

SELECT * FROM (
SELECT auto_increment_key, dates, year, month, day, quarter, season,
ROW_NUMBER () OVER (PARTITION BY dates, year, month, day, quarter, season 
ORDER BY auto_increment_key) AS rank_value
FROM dates_duplicate) AS row_number_value
WHERE rank_value > 1 ;

SELECT * FROM (
SELECT auto_increment_key, dates, year, month, day, quarter, season,
ROW_NUMBER () OVER (PARTITION BY dates, year, month, day, quarter, season 
ORDER BY auto_increment_key) AS rank_value
FROM dates_duplicate) AS row_number_value

DELETE FROM dates_duplicate
WHERE auto_increment_key IN ( 
SELECT auto_increment_key
FROM ( SELECT auto_increment_key, ROW_NUMBER() OVER ( PARTITION BY dates ORDER BY auto_increment_key) AS rank_value
FROM dates_duplicate) AS ranked_rows
WHERE rank_value > 1);

DELETE FROM dates_duplicate
WHERE auto_increment_key IN ( SELECT auto_increment_key 
FROM ( SELECT auto_increment_key, 
ROW_NUMBER() OVER ( PARTITION BY dates ORDER BY auto_increment_key) AS rank_value
FROM dates_duplicate) AS ranked_rows
WHERE rank_value > 1
);

-- Finding duplicates in inventory_duplicate

SELECT * FROM inventory_duplicate; 
ALTER TABLE inventory_duplicate
DROP COLUMN auto_row_number;
 
ALTER TABLE inventory_duplicate
ADD COLUMN auto_row_number BIGINT AUTO_INCREMENT PRIMARY KEY;

SELECT * FROM (SELECT sku_id, warehouse_id, opening_stock, closing_stock, reorder_level, inventory_status,
ROW_NUMBER() OVER (PARTITION BY warehouse_id, opening_stock, closing_stock, reorder_level, inventory_status
ORDER BY auto_row_number) AS rank_value FROM inventory_duplicate
) AS row_number_value
WHERE rank_value > 1;

SELECT sku_id, COUNT(*) AS row_count
FROM inventory_duplicate
GROUP BY sku_id
HAVING COUNT(*) > 1;

-- Finding duplicates in products_duplicate

SELECT launch_date
FROM products_duplicate;

UPDATE products_duplicate
SET launch_date = STR_TO_DATE (launch_date, '%d-%m-%Y');

SELECT * FROM 
(SELECT product_id, product_name, product_category, season, fabric_type, fit_type, launch_date, discontinued_flag,
ROW_NUMBER () OVER (PARTITION BY product_name, product_category, season, fabric_type, fit_type, launch_date, discontinued_flag) AS rank_value
FROM products_duplicate ORDER BY product_id) AS row_number_value
WHERE rank_value > 1;

-- Finding duplicates in promotions_duplicate
UPDATE promotions_duplicate
SET promotion_start_date = STR_TO_DATE (promotion_start_date, '%d-%m-%Y')
SET promotion_end_date = STR_TO_DATE (promotion_end_date, '%d-%m-%Y');

SELECT * FROM (SELECT promotion_id, promotion_name, discount_type, discount_value, promotion_start_date, promotion_end_date,
ROW_NUMBER() OVER (PARTITION BY promotion_name, discount_type, discount_value, promotion_start_date, promotion_end_date) AS rank_value
FROM promotions_duplicate ORDER BY promotion_id) AS row_number_value
WHERE rank_value > 1;


-- Finding duplicates in skus_duplicate
SELECT * FROM ( SELECT sku_id, product_id, color, size, mrp_usd, cost_price_usd, active_flag, 
ROW_NUMBER() OVER ( PARTITION BY product_id, color, size, mrp_usd, cost_price_usd, active_flag ORDER BY sku_id ) AS rank_value 
FROM skus_duplicate ) AS row_number_value 
WHERE rank_value > 1;

WITH CTE AS 
( SELECT sku_id, product_id, color, size, mrp_usd, cost_price_usd, active_flag, 
ROW_NUMBER() OVER ( PARTITION BY product_id, color, size, mrp_usd, cost_price_usd, active_flag ORDER BY sku_id ) AS rank_value 
FROM skus_duplicate)
DELETE FROM skus_duplicate
WHERE sku_id IN ( SELECT sku_id
FROM CTE
WHERE rank_value > 1
); 

-- Finding duplicates in sales_transactions_duplicate

SELECT * FROM (SELECT transaction_id, order_id, order_date, shipped_date, expected_delivery_date, actual_delivery_date, customer_id, sku_id, quantity_sold, selling_price_usd, 
discount_amount_usd, net_sales_amount_usd, payment_method, return_flag, 
ROW_NUMBER() OVER (PARTITION BY order_id, order_date, customer_id, sku_id, quantity_sold, selling_price_usd, discount_amount_usd, net_sales_amount_usd, payment_method, 
return_flag ORDER BY transaction_id) AS rank_value 
FROM sales_transactions_duplicate) AS row_number_value 
WHERE rank_value > 1;

-- STANDARDINSING DATA
-- Standardising data in customers_duplicate1

SELECT * FROM customers_duplicate1;
UPDATE customers_duplicate1 
SET city = COALESCE (NULLIF(LOWER(TRIM(city)), ''), 'not available'),
state = COALESCE (NULLIF(LOWER(TRIM(state)), ''), 'not available'),
email_opt_in_flag = COALESCE (NULLIF(LOWER(TRIM(email_opt_in_flag)), ''), 'not available'),
customer_segment = COALESCE (NULLIF(LOWER(TRIM(customer_segment)), ''),'not available');

-- Standardising data in inventory_duplicate

SELECT * FROM inventory_duplicate;

UPDATE inventory_duplicate
SET inventory_status = COALESCE(NULLIF(LOWER(TRIM(inventory_status)), ''), 'not available');

-- Standardising data in products_duplicate

UPDATE products_duplicate
SET product_name = COALESCE(NULLIF(LOWER(TRIM(product_name)), ''), 'not available'),
product_category = COALESCE(NULLIF(LOWER(TRIM(product_category)),''), 'not available'),
season = COALESCE(NULLIF(LOWER(TRIM(season)),''), 'Not Available'),
fabric_type = COALESCE(NULLIF(LOWER(TRIM(fabric_type)),''), 'not available'),
fit_type = COALESCE(NULLIF(LOWER(TRIM(fit_type)),''), 'not available');

-- Standardising data in promotions_duplicate
UPDATE promotions_duplicate 
SET promotion_name = COALESCE(NULLIF(LOWER(TRIM(promotion_name)),''),'not available'), 
discount_type = COALESCE(NULLIF(LOWER(TRIM(discount_type)),''),'not available'), 

-- Standardising data in sales_transactions_duplicate

UPDATE sales_transactions_duplicate 
SET payment_method = COALESCE(NULLIF(LOWER(TRIM(payment_method)),''),'not available');

UPDATE sales_transactions_duplicate 
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y %H-%i'), 
shipped_date = STR_TO_DATE(shipped_date, '%d-%m-%Y %H-%i-%s'), 
expected_delivery_date = STR_TO_DATE(expected_delivery_date, '%d-%m-%Y %H-%i'), 
actual_delivery_date = STR_TO_DATE(actual_delivery_date, '%d-%m-%Y %H-%i');

SELECT * FROM sales_transactions_duplicate;

--  Standardising data in skus_duplicate

UPDATE skus_duplicate 
SET color = COALESCE(NULLIF(LOWER(TRIM(color)),''),'not available'), 
size = COALESCE(NULLIF(UPPER(TRIM(size)),''),'not available');

--  Standardising data in warehouses_duplicate

UPDATE warehouses_duplicate
SET warehouse_name = LOWER(TRIM(COALESCE(warehouse_name,'unknown'))), 
city = LOWER(TRIM(COALESCE(city,'unknown'))), 
state = LOWER(TRIM(COALESCE(state,'unknown'))), 
country = LOWER(TRIM(COALESCE(country,'unknown')));

SELECT * FROM skus_duplicate;