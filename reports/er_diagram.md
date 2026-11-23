# Entity Relationship Diagram

Tables and relationships of `ecommerce_db`. PK = primary key, FK = foreign key.
The sellers and geolocation CSVs are not loaded in this project, so `seller_id` has no foreign key.

```mermaid
erDiagram
    customers ||--o{ orders : places
    orders ||--o{ order_items : contains
    products ||--o{ order_items : "appears in"
    orders ||--o{ order_payments : "paid by"
    orders ||--o{ order_reviews : receives

    customers {
        varchar customer_id PK
        varchar customer_unique_id
        varchar customer_zip_code_prefix
        text customer_city
        varchar customer_state
    }
    orders {
        varchar order_id PK
        varchar customer_id FK
        text order_status
        timestamp order_purchase_timestamp
        timestamp order_approved_at
        timestamp order_delivered_carrier_date
        timestamp order_delivered_customer_date
        timestamp order_estimated_delivery_date
    }
    order_items {
        varchar order_id PK, FK
        integer order_item_id PK
        varchar product_id FK
        varchar seller_id
        timestamp shipping_limit_date
        numeric price
        numeric freight_value
    }
    products {
        varchar product_id PK
        text product_category_name
        integer product_name_lenght
        integer product_description_lenght
        integer product_photos_qty
        integer product_weight_g
        integer product_length_cm
        integer product_height_cm
        integer product_width_cm
    }
    order_payments {
        varchar order_id PK, FK
        integer payment_sequential PK
        text payment_type
        integer payment_installments
        numeric payment_value
    }
    order_reviews {
        varchar review_id PK
        varchar order_id PK, FK
        integer review_score
        text review_comment_title
        text review_comment_message
        timestamp review_creation_date
        timestamp review_answer_timestamp
    }
```