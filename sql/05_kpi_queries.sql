-- Stage 3: KPI queries (delivered orders only; revenue = order_items.price, freight excluded)

-- 1. Orders by status
SELECT order_status, COUNT(*) AS siparis_sayisi
FROM orders
GROUP BY order_status
ORDER BY siparis_sayisi DESC;

-- 2. Revenue components for delivered orders
SELECT
  (SELECT SUM(oi.price)
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   WHERE o.order_status = 'delivered') AS urun_geliri,
  (SELECT SUM(oi.freight_value)
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   WHERE o.order_status = 'delivered') AS kargo_ucreti,
  (SELECT SUM(op.payment_value)
   FROM order_payments op
   JOIN orders o ON o.order_id = op.order_id
   WHERE o.order_status = 'delivered') AS odeme_toplami;

-- 3. Delivered orders without a payment record (1 order found)
SELECT o.order_id, o.order_status
FROM orders o
WHERE o.order_status = 'delivered'
  AND NOT EXISTS (SELECT 1 FROM order_payments p WHERE p.order_id = o.order_id);

-- 4. Main KPIs: orders, customers, revenue, average order value
SELECT
  COUNT(DISTINCT o.order_id)           AS siparis,
  COUNT(DISTINCT c.customer_unique_id) AS musteri,
  ROUND(SUM(oi.price), 2)              AS gelir,
  ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS ortalama_siparis_tutari
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers  c  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';