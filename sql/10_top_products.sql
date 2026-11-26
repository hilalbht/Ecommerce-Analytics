-- Stage 3: top 10 products by units sold and by revenue (delivered orders)
-- Product names are not in the dataset, so products are shown by id and category.

-- 1. Top 10 by units sold
SELECT
  oi.product_id,
  COALESCE(t.product_category_name_english, 'unknown') AS kategori,
  COUNT(*)                 AS satilan_adet,
  ROUND(SUM(oi.price), 2)  AS gelir
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t
       ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY satilan_adet DESC
LIMIT 10;

-- 2. Top 10 by revenue
SELECT
  oi.product_id,
  COALESCE(t.product_category_name_english, 'unknown') AS kategori,
  COUNT(*)                 AS satilan_adet,
  ROUND(SUM(oi.price), 2)  AS gelir,
  ROUND(AVG(oi.price), 2)  AS ortalama_fiyat
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t
       ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY gelir DESC
LIMIT 10;