-- Stage 3: LEAD window function and query optimization basics

-- 1. LEAD: next month's revenue and the change to next month (Jan 2017 onwards)
WITH aylik AS (
  SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS ay,
    ROUND(SUM(oi.price), 2) AS gelir
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
  GROUP BY 1
)
SELECT
  ay,
  gelir,
  LEAD(gelir) OVER (ORDER BY ay) AS sonraki_ay_gelir,
  ROUND(100.0 * (LEAD(gelir) OVER (ORDER BY ay) - gelir) / gelir, 1) AS sonraki_aya_degisim
FROM aylik
ORDER BY ay;

-- 2. Query plan WITHOUT an index on order_items.product_id:
--    Seq Scan, 112,123 rows removed by filter, 2,320 buffers, ~12.96 ms
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*)
FROM order_items
WHERE product_id = 'aca2eb7d00ea1a7b8ebd4e68314663af';

-- 3. Foreign key columns do not get an index automatically, so add one
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
ANALYZE order_items;

-- 4. Same query WITH the index (rerun the EXPLAIN above):
--    Index Only Scan, 4 buffers, ~0.49 ms (about 27x faster execution)