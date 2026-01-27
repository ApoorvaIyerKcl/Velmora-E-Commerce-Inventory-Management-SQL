
-- PRIMARY BUSINESS QUESTIONS 


-- 1. Which SKUs sell the highest units overall?
SELECT sku_identifier, SUM(quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate
GROUP BY sku_identifier
ORDER BY total_units_sold DESC;



-- 2. Which product categories generate the highest demand?
SELECT product_category, SUM(quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
JOIN products_duplicate p ON s.product_identifier = p.product_identifier
GROUP BY product_category
ORDER BY total_units_sold DESC;



-- 3. Which sizes sell the fastest across all products?
SELECT size, SUM(quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
GROUP BY size
ORDER BY total_units_sold DESC;



-- 4. Which colors have the highest sales volume?
SELECT color, SUM(quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
GROUP BY color
ORDER BY total_units_sold DESC;



-- 5. Which SKUs experience frequent stockouts?
SELECT sku_identifier, COUNT(*) AS out_of_stock_events
FROM inventory_duplicate
WHERE inventory_status = 'Out of Stock'
GROUP BY sku_identifier
ORDER BY out_of_stock_events DESC;



-- 6. Which SKUs are slow-moving despite high stock levels?
SELECT sku_identifier, SUM(closing_stock) AS total_closing_stock
FROM inventory_duplicate
GROUP BY sku_identifier
HAVING SUM(closing_stock) > 300
ORDER BY total_closing_stock DESC;



-- 7. Which seasons generate the highest sales volume?
SELECT d.season, SUM(f.quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN dates_duplicate d ON f.order_date = d.date
GROUP BY d.season
ORDER BY total_units_sold DESC;



-- 8. Which warehouses hold the highest inventory?
SELECT warehouse_identifier, SUM(closing_stock) AS total_stock
FROM inventory_duplicate
GROUP BY warehouse_identifier
ORDER BY total_stock DESC;



-- 9. Which SKUs should be considered for discontinuation?
SELECT s.sku_identifier, SUM(f.quantity_sold) AS total_units_sold
FROM skus_duplicate s
LEFT JOIN sales_transactions_duplicate f ON s.sku_identifier = f.sku_identifier
GROUP BY s.sku_identifier
HAVING SUM(f.quantity_sold) < 20;



-- 10. Which products suffer repeated low-stock situations?
SELECT s.product_identifier, COUNT(*) AS low_stock_count
FROM inventory_duplicate i
JOIN skus_duplicate s ON i.sku_identifier = s.sku_identifier
WHERE inventory_status = 'Low Stock'
GROUP BY s.product_identifier
ORDER BY low_stock_count DESC;



-- SECONDARY BUSINESS QUESTIONS 




-- 11. What is the average selling price per category?
SELECT product_category, AVG(selling_price_usd) AS avg_selling_price
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
JOIN products_duplicate p ON s.product_identifier = p.product_identifier
GROUP BY product_category;



-- 12. Which months show peak demand?
SELECT d.month, SUM(f.quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN dates_duplicate d ON f.order_date = d.date
GROUP BY d.month
ORDER BY total_units_sold DESC;



-- 13. Which SKUs receive the highest discounts?
SELECT sku_identifier, AVG(discount_amount_usd) AS avg_discount
FROM sales_transactions_duplicate
GROUP BY sku_identifier
ORDER BY avg_discount DESC;



-- 14. What percentage of sales result in returns?
SELECT return_flag, COUNT(*) AS transaction_count
FROM sales_transactions_duplicate
GROUP BY return_flag;



-- 15. Which customer segments drive most inventory movement?
SELECT customer_segment, SUM(quantity_sold) AS total_units_sold
FROM sales_transactions_duplicate f
JOIN customers_duplicate1 c ON f.customer_identifier = c.customer_identifier
GROUP BY customer_segment
ORDER BY total_units_sold DESC;



-- 16. Which SKUs sell better in winter compared to summer?
SELECT s.sku_identifier, d.season, SUM(f.quantity_sold) AS total_units
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
JOIN dates_duplicate d ON f.order_date = d.date
GROUP BY s.sku_identifier, d.season;



-- 17. Which products depend heavily on promotions?
SELECT p.product_identifier, COUNT(pr.promotion_identifier) AS promo_usage
FROM sales_transactions_duplicate f
JOIN promotions_duplicate pr ON f.order_date BETWEEN pr.promotion_start_date AND pr.promotion_end_date
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
JOIN products_duplicate p ON s.product_identifier = p.product_identifier
GROUP BY p.product_identifier
ORDER BY promo_usage DESC;



-- 18. Which warehouses frequently face low stock?
SELECT warehouse_identifier, COUNT(*) AS low_stock_events
FROM inventory_duplicate
WHERE inventory_status = 'Low Stock'
GROUP BY warehouse_identifier
ORDER BY low_stock_events DESC;



-- 19. Which SKUs generate the lowest net sales value?
SELECT sku_identifier, SUM(net_sales_amount_usd) AS total_net_sales
FROM sales_transactions_duplicate
GROUP BY sku_identifier
ORDER BY total_net_sales ASC;



-- 20. Which products show declining demand over time?
SELECT p.product_identifier, d.year, SUM(f.quantity_sold) AS yearly_units_sold
FROM sales_transactions_duplicate f
JOIN skus_duplicate s ON f.sku_identifier = s.sku_identifier
JOIN products_duplicate p ON s.product_identifier = p.product_identifier
JOIN dates_duplicate d ON f.order_date = d.date
GROUP BY p.product_identifier, d.year
ORDER BY p.product_identifier, d.year;



