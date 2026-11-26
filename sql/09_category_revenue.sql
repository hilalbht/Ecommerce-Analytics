-- Stage 3: category revenue (delivered orders, revenue = order_items.price)

-- 1. Revenue share of categorised, uncategorised and untranslated products
SELECT
  CASE
    WHEN p.product_category_name IS NULL THEN 'kategorisiz'
    WHEN t.product_category_name IS NULL THEN 'cevirisi_yok'
    ELSE 'cevirili'
  END AS grup,
  COUNT(DISTINCT p.product_id) AS urun,
  ROUND(SUM(oi.price), 2)      AS gelir,
  ROUND(100.0 * SUM(oi.price) / SUM(SUM(oi.price)) OVER (), 2) AS gelir_yuzde
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t
       ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY gelir DESC;

-- 2. Top 10 categories by revenue (products without a category shown as 'unknown')
SELECT
  COALESCE(t.product_category_name_english, 'unknown') AS kategori,
  COUNT(DISTINCT o.order_id)                            AS siparis,
  ROUND(SUM(oi.price), 2)                               AS gelir,
  ROUND(100.0 * SUM(oi.price) / SUM(SUM(oi.price)) OVER (), 2) AS gelir_yuzde
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t
       ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY gelir DESC
LIMIT 10;