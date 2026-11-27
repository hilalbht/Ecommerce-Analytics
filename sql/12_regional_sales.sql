-- Stage 3: regional sales by customer state (delivered orders, revenue = order_items.price)
SELECT
  c.customer_state                                      AS eyalet,
  COUNT(DISTINCT o.order_id)                            AS siparis,
  COUNT(DISTINCT c.customer_unique_id)                  AS musteri,
  ROUND(SUM(oi.price), 2)                               AS gelir,
  ROUND(100.0 * SUM(oi.price) / SUM(SUM(oi.price)) OVER (), 2) AS gelir_yuzde,
  ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2)  AS siparis_basina_gelir
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers  c  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY gelir DESC;