-- Stage 3: review score vs delivery delay (delivered orders with a delivery date and at least one review)
-- Reviews are first reduced to one score per order (547 orders have more than one review).
-- Delay is measured in days between the delivered date and the estimated delivery date.
-- A first version compared full timestamps and counted same-day deliveries as late (7,661 instead of 6,381 late orders).
WITH puan AS (
  SELECT order_id, AVG(review_score) AS puan
  FROM order_reviews
  GROUP BY order_id
),
gecikme AS (
  SELECT
    o.order_id,
    o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date AS gun_farki
  FROM orders o
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
  CASE
    WHEN g.gun_farki <= 0 THEN '1_zamaninda_veya_erken'
    WHEN g.gun_farki <= 3 THEN '2_1-3_gun_gec'
    WHEN g.gun_farki <= 7 THEN '3_4-7_gun_gec'
    ELSE                       '4_8+_gun_gec'
  END AS teslimat,
  COUNT(*)              AS siparis,
  ROUND(AVG(p.puan), 2) AS ortalama_puan
FROM gecikme g
JOIN puan p ON p.order_id = g.order_id
GROUP BY 1
ORDER BY 1;