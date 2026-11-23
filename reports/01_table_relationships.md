# Table Relationships and Data Quality Notes (Stage 2)

## Relationships (all enforced as foreign keys)

| From table | Column | To table | Column |
|---|---|---|---|
| orders | customer_id | customers | customer_id |
| order_items | order_id | orders | order_id |
| order_items | product_id | products | product_id |
| order_payments | order_id | orders | order_id |
| order_reviews | order_id | orders | order_id |

Orphan-record checks returned 0 for every relationship above.

## Primary keys (verified with duplicate counts)

- customers: customer_id
- orders: order_id
- products: product_id
- order_items: (order_id, order_item_id)
- order_payments: (order_id, payment_sequential)
- order_reviews: (review_id, order_id)

## Findings

- customer_id is unique per order; customer_unique_id identifies the real customer (96,096 unique vs 99,441 orders). Use customer_unique_id for customer counts and repeat purchase.
- order_reviews: 789 review_id values repeat, each across different orders (max 3 rows). review_id alone is not a key.
- 547 orders have more than one review: joining orders to reviews multiplies rows (fan-out).
- 775 orders have no order_items: 603 unavailable, 164 canceled, 5 created, 2 invoiced, 1 shipped. None are delivered.
- 2,965 orders have no delivery date. 8 of them are marked delivered; 619 of 625 canceled orders have no delivery date.
- Order dates range from 2016-09-04 to 2018-10-17.