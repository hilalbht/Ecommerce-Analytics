-- Stage 3: monthly sales (delivered orders, revenue = order_items.price)
-- Data note: no orders in Nov 2016; Sep-Oct 2018 contain only 20 orders, none delivered.

-- 1. Monthly orders and revenue
SELECT
  DATE_TRUNC('month', o.order_purchase_timestamp)::date AS ay,
  COUNT(DISTINCT o.order_id)                            AS siparis,
  ROUND(SUM(oi.price), 2)                               AS gelir
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- 2. Orders by status in the sparse months (Nov-Dec 2016, Aug 2018 onwards)
SELECT
  DATE_TRUNC('month', order_purchase_timestamp)::date AS ay,
  order_status,
  COUNT(*) AS siparis
FROM orders
WHERE order_purchase_timestamp >= '2018-08-01'
   OR (order_purchase_timestamp >= '2016-11-01' AND order_purchase_timestamp < '2017-01-01')
GROUP BY 1, 2
ORDER BY 1, 2;

-- 3. Month-over-month revenue change (Jan 2017 onwards, LAG window function)
WITH aylik AS (
  SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS ay,
    COUNT(DISTINCT o.order_id) AS siparis,
    ROUND(SUM(oi.price), 2)    AS gelir
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
  GROUP BY 1
)
SELECT
  ay,
  siparis,
  gelir,
  LAG(gelir) OVER (ORDER BY ay) AS onceki_ay_gelir,
  ROUND(100.0 * (gelir - LAG(gelir) OVER (ORDER BY ay))
        / LAG(gelir) OVER (ORDER BY ay), 1) AS degisim_yuzde
FROM aylik
ORDER BY ay;