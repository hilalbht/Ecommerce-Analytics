# E-Commerce Sales and Customer Analytics

End-to-end data analysis project on the Olist Brazilian E-Commerce dataset, built with PostgreSQL, Python and Power BI.

**Status:** in progress. Stages 1-2 (data setup, database) are done; SQL analysis, Python EDA and the Power BI dashboard are next.

## Business Problem

Acting as a Data Analyst for an e-commerce company, the goal is to answer management questions with data: total revenue and orders, average order value, best-selling products and categories, monthly sales trend, most valuable customers, repeat purchase behaviour, regional performance, and the relationship between customer reviews and order performance.

## Dataset

[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).

- 99,441 orders placed between 2016-09-04 and 2018-10-17
- Six CSV files are used: customers, orders, order_items, products, order_payments, order_reviews
- Raw CSV files are not stored in this repository (see Installation and Usage)

Database schema: see [reports/er_diagram.md](reports/er_diagram.md). Relationships and data quality notes: see [reports/01_table_relationships.md](reports/01_table_relationships.md).

## Technologies Used

- PostgreSQL, pgAdmin 4, psql
- Python (Pandas, NumPy, Matplotlib, Seaborn, Jupyter)
- Power BI (Power Query, DAX)
- Git and GitHub

## Data Cleaning

In progress.

## SQL Analysis

In progress.

## Exploratory Data Analysis

In progress.

## Power BI Dashboard

In progress.

## Key Findings

Data quality findings so far (business findings will be added after the analysis stages):

- customer_id is unique per order, so real customers must be counted with customer_unique_id (96,096 unique customers vs 99,441 orders).
- review_id is not unique: 789 review_id values repeat across different orders. The key of order_reviews is (review_id, order_id).
- 547 orders have more than one review, so joining orders to reviews multiplies rows (fan-out).
- 775 orders have no items: 603 unavailable, 164 canceled, 5 created, 2 invoiced, 1 shipped. None of them are delivered.
- 2,965 orders have no delivery date; 8 of them are marked delivered.

## Business Recommendations

Will be added after the analysis stages and will be based only on results from the data.

## Installation and Usage

1. Install PostgreSQL and create a database named ecommerce_db.
2. Download the dataset from Kaggle and place the six CSV files in data/raw/.
3. Create tables and constraints by running the scripts in sql/ in order:

```
psql -U postgres -h localhost -d ecommerce_db -f sql/01_create_tables.sql
psql -U postgres -h localhost -d ecommerce_db -f sql/02_add_constraints.sql
psql -U postgres -h localhost -d ecommerce_db -f sql/03_add_reviews_key.sql
```

4. Load the CSV files with psql, customers first, then orders, then the other four tables:

```
\copy customers FROM 'data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
```

5. Add the foreign keys after loading: sql/04_add_foreign_keys.sql

Note for Windows with Turkish locale: the PostgreSQL installer can fail at the initdb step because the locale name contains non-ASCII characters. Creating the database cluster manually with initdb --locale=C worked around this.