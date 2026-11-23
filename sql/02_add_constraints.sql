-- Stage 2: keys verified as unique by duplicate counts (0 duplicates each)
ALTER TABLE products       ADD PRIMARY KEY (product_id);
ALTER TABLE order_items    ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE order_payments ADD PRIMARY KEY (order_id, payment_sequential);