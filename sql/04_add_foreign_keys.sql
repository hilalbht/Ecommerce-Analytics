-- Orphan checks returned 0 for every relationship below.
ALTER TABLE order_items
    ADD FOREIGN KEY (order_id)   REFERENCES orders (order_id),
    ADD FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE order_payments
    ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE order_reviews
    ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);