# E-Commerce Sales and Customer Analytics

End-to-end data analysis project on the Olist Brazilian E-Commerce dataset, built with PostgreSQL, Python and Power BI.

**Status:** in progress. Stages 1-3 (data setup, database, SQL analysis) are done; Python EDA and the Power BI dashboard are next.

## Business Problem

Acting as a Data Analyst for an e-commerce company, the goal is to answer management questions with data: total revenue and orders, average order value, best-selling products and categories, monthly sales trend, most valuable customers, repeat purchase behaviour, regional performance, and the relationship between customer reviews and order performance.

## Dataset

[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).

- 99,441 orders placed between 2016-09-04 and 2018-10-17
- Six CSV files are used: customers, orders, order_items, products, order_payments, order_reviews, plus the category translation file
- Raw CSV files are not stored in this repository (see Installation and Usage)

Database schema: see [reports/er_diagram.md](reports/er_diagram.md). Relationships and data quality notes: see [reports/01_table_relationships.md](reports/01_table_relationships.md).

## Technologies Used

- PostgreSQL, pgAdmin 4, psql
- Python (Pandas, NumPy, Matplotlib, Seaborn, Jupyter)
- Power BI (Power Query, DAX)
- Git and GitHub

## Metric Definitions

- **Revenue:** sum of `order_items.price` for orders with status `delivered`. Freight is excluded. Amounts are in the dataset's currency unit.
- **Orders and customers:** delivered orders only. Customers are counted with `customer_unique_id`, because `customer_id` is generated per order.
- **Average order value:** revenue divided by the number of delivered orders.
- **Late delivery:** delivered date is after the estimated delivery date, compared by calendar day.

Revenue by `price` and total payments differ slightly: 13,221,498.11 (price) + 2,198,275.64 (freight) = 15,419,773.75, versus 15,422,461.77 in `order_payments` (difference 2,688.02). 299 delivered orders have a payment that differs from items plus freight by more than 0.01, the largest difference being 182.81. The dataset does not explain the difference.

## Data Cleaning

In progress.

## SQL Analysis

All queries are in `sql/` and use delivered orders only. Techniques used: GROUP BY, HAVING, INNER and LEFT JOIN, subqueries, CTEs, CASE WHEN, aggregate functions, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, date functions and EXPLAIN ANALYZE with an index.

| File | Content |
|---|---|
| 05_kpi_queries.sql | Orders, customers, revenue, average order value |
| 06_monthly_sales.sql | Monthly orders and revenue, month-over-month change (LAG) |
| 07-08 | Category name translation table and two manual additions |
| 09_category_revenue.sql | Revenue by category |
| 10_top_products.sql | Top 10 products by units and by revenue |
| 11_customers.sql | Repeat purchases, customer ranking window functions |
| 12_regional_sales.sql | Revenue by customer state |
| 13_reviews_vs_delivery.sql | Review score vs delivery delay |
| 14_lead_and_indexing.sql | LEAD example and index optimization |

## Exploratory Data Analysis

In progress.

## Power BI Dashboard

In progress.

## Key Findings

Results of the SQL analysis (observations only; causes are not tested in this analysis).

**Headline numbers (delivered orders):** 96,478 orders, 93,358 customers, revenue 13,221,498.11, average order value 137.04.

**Monthly trend**
- Revenue grew through 2017: 750 orders and 111,798.36 in Jan 2017, then 7,289 orders and 987,765.37 in Nov 2017, the highest month by orders.
- In 2018 monthly revenue stayed between 826,437 and 977,545 (peak in May 2018) and orders between 6,099 and 7,069: growth levelled off.
- Percentage changes in early 2017 look large because the starting level is small (Feb 2017: +109.5%, about +122 thousand in revenue, versus +52.4% and about +340 thousand in Nov 2017).
- Data limits: no orders in Nov 2016 and only one delivered order in Dec 2016; Sep-Oct 2018 contain only 20 orders, none delivered. Trend analysis uses Jan 2017 to Aug 2018.

**Categories and products**
- Revenue is spread across many categories: the top 10 categories hold about 62% of revenue, led by health_beauty (9.33%), watches_gifts (8.82%) and bed_bath_table (7.74%).
- 1.29% of revenue comes from products without a category; 0.04% from two categories missing in the translation file.
- Revenue is also spread across products: the top 10 products by revenue hold about 3.3% of total revenue. Ranking by units and by revenue gives different lists (5 of 10 products appear in both).

**Customers**
- 97.0% of customers (90,557) ordered once; 2,801 customers (3.0%) ordered more than once and generate 5.51% of revenue.
- Repeat customers spend more per customer (260.05 vs 137.96) because they place more orders, not larger ones (about 123 per order vs 137.96).
- The customers with the most orders are not the highest spenders: the top spender placed one order of 13,440.

**Regions**
- Sao Paulo (SP) accounts for 38.33% of revenue, followed by RJ (13.31%) and MG (11.74%).

**Reviews and delivery**
- 6,381 of 95,824 reviewed orders (6.7%) arrived after the estimated date.
- Average review score falls as the delay grows: 4.29 (on time or early), 3.29 (1-3 days late), 2.11 (4-7 days late), 1.70 (8+ days late). This is an association; the analysis does not show that lateness causes the lower scores.

**Data quality**
- customer_id is unique per order; customer_unique_id identifies the real customer.
- review_id is not unique: 789 values repeat across different orders. 547 orders have more than one review, so reviews are reduced to one score per order before joining.
- 775 orders have no items (603 unavailable, 164 canceled, 5 created, 2 invoiced, 1 shipped); none are delivered.
- 2,965 orders have no delivery date; 8 of them are marked delivered. One delivered order has no payment record.

## Business Recommendations

Will be added after the analysis stages and will be based only on results from the data.

## Installation and Usage

1. Install PostgreSQL and create a database named ecommerce_db.
2. Download the dataset from Kaggle and place the CSV files in data/raw/.
3. Create tables and constraints with the scripts in sql/ (01, 02, 03), then load the CSV files with psql, customers first, then orders, then the other tables:

```
\copy customers FROM 'data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
```

4. Add the foreign keys after loading: sql/04_add_foreign_keys.sql
5. Create and load the category translation table (sql/07, then load product_category_name_translation.csv, then sql/08).
6. Run the analysis queries (05, 06, 09-14) in pgAdmin or psql.

Note for Windows with Turkish locale: the PostgreSQL installer can fail at the initdb step because the locale name contains non-ASCII characters. Creating the database cluster manually with initdb --locale=C worked around this.