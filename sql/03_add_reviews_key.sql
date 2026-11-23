-- review_id alone has 789 repeated values (each across different orders);
-- the pair (review_id, order_id) has 0 duplicates.
ALTER TABLE order_reviews ADD PRIMARY KEY (review_id, order_id);