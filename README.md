# Velmora- E-Commerce Inventory Management

## Executive Summary

Velmora is a US-based women’s western apparel e-commerce brand operating across **Spring, Summer, Fall, and Winter collections**. Despite consistent demand, the company faces **inventory inefficiencies at SKU level**, leading to **overstocking, stockouts, and seasonal discount pressure**. This project focuses on analysing **SKU performance, inventory movement, seasonal demand, and warehouse stock distribution** using SQL. The objective is to enable **data-driven inventory planning, better reorder decisions, and reduced dead stock**. **This is a full-scale inventory analytics project for the e-commerce fashion industry.**


## Business Problem

Velmora is experiencing operational challenges related to **inventory and SKU management**, including:

1. Overstocking of **slow-moving SKUs**, especially at season end
2. Frequent **stockouts of high-demand sizes and colours**
3. Inefficient **reorder levels** that do not reflect seasonal demand
4. High **inventory holding costs** due to poor warehouse stock distribution
5. Heavy reliance on **discounting** to clear unsold inventory

The absence of SKU-level inventory insights prevents leadership from making **accurate procurement, replenishment, and assortment decisions**, directly impacting profitability and cash flow.

## Tools Used

* **MySQL** – Data cleaning, joins, aggregations, and inventory analysis
* **SQL (Analytical Queries)** – SKU performance, seasonal trends, stock health
* **CSV Datasets** – Raw, unclean industry-style e-commerce data


## Dataset Used

This project uses an **unclean and unstructured e-commerce dataset** comprising **9 relational tables**, sourced as independent CSV files and later connected using **SQL joins**. The dataset represents a **US-based women’s apparel e-commerce business** and contains **328,135 rows** and **63 columns** in total (excluding any reference or metrics tables). 

### Dataset Overview

| Dataset Name                | Description                                                                                  |
| --------------------------- | -------------------------------------------------------------------------------------------- |
| EE- customers               | Customer-level attributes used to support **demand analysis and repeat purchase behaviour**  |
| EE- dates                   | Calendar reference table for **seasonal, monthly, and time-based analysis**                  |
| EE- inventory               | Warehouse-level stock details including **opening stock, closing stock, and reorder levels** |
| EE- products                | Product-level details including **category, season, fabric, and launch date**                |
| EE- promotions              | Promotional campaigns with **start and end dates**                                           |
| EE- sales_transactions      | Transaction-level sales data used to analyse **SKU demand and sell-through performance**     |
| EE- skus                    | SKU-level attributes such as **size, colour, MRP, cost price, and active status**            |
| EE- warehouses              | Warehouse locations and fulfilment types                                                     |


## Key Results & Insights

1. A limited number of SKUs account for a **disproportionately high share of inventory movement**, indicating strong demand concentration.
2. Certain **size and colour combinations** experience repeated stockouts, suggesting under-allocation of fast-moving variants.
3. Several SKUs remain **overstocked across multiple seasons**, locking working capital and increasing holding costs.
4. Demand patterns vary significantly between **Summer and Winter collections**, highlighting clear seasonality effects.
5. Inventory distribution across warehouses is uneven, leading to **regional fulfilment inefficiencies**.



## Business Recommendations

1. Apply **SKU-level, demand-driven reorder logic** instead of uniform replenishment rules.
2. Reduce procurement and gradually phase out **persistent low-velocity SKUs**.
3. Increase allocation for **high-demand size and colour combinations** to prevent stockouts.
4. Align inventory planning with **seasonal demand cycles** to minimise end-of-season excess stock.
5. Optimise warehouse-level stock placement to reduce **local overstocking and stock shortages**.



## Next Steps

1. Introduce **sell-through rate** and **inventory ageing** metrics for deeper inventory health assessment.
2. Develop **inventory monitoring dashboards** to track stock levels and SKU performance in near real time.
3. Incorporate **supplier lead times and procurement costs** into replenishment analysis.
4. Implement **seasonal demand forecasting models** to improve future SKU planning.





