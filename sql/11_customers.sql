-- Stage 3: customer analysis (delivered orders, customers identified by customer_unique_id)

-- 1. Distribution of customers by number of orders
WITH musteri AS (
  SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS siparis
  FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT
  siparis                                              AS siparis_sayisi,
  COUNT(*)                                             AS musteri,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)   AS yuzde
FROM musteri
GROUP BY 1
ORDER BY 1;

-- 2. Top 10 customers by total spend
SELECT
  c.customer_unique_id,
  COUNT(DISTINCT o.order_id) AS siparis,
  ROUND(SUM(oi.price), 2)    AS toplam_harcama
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers  c  ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY toplam_harcama DESC
LIMIT 10;

-- 3. Revenue share of one-time vs repeat customers
WITH musteri AS (
  SELECT c.customer_unique_id,
         COUNT(DISTINCT o.order_id) AS siparis,
         SUM(oi.price)              AS harcama
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN customers  c  ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT
  CASE WHEN siparis = 1 THEN 'tek_siparis' ELSE 'tekrar_eden' END AS grup,
  COUNT(*)                                                       AS musteri,
  ROUND(SUM(harcama), 2)                                         AS gelir,
  ROUND(100.0 * SUM(harcama) / SUM(SUM(harcama)) OVER (), 2)     AS gelir_yuzde,
  ROUND(AVG(harcama), 2)                                         AS musteri_basina_harcama
FROM musteri
GROUP BY 1;

-- 4. ROW_NUMBER vs RANK vs DENSE_RANK on customers ranked by order count
WITH musteri AS (
  SELECT c.customer_unique_id,
         COUNT(DISTINCT o.order_id) AS siparis,
         ROUND(SUM(oi.price), 2)    AS harcama
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN customers  c  ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY 1
)
SELECT
  customer_unique_id,
  siparis,
  harcama,
  ROW_NUMBER() OVER (ORDER BY siparis DESC, harcama DESC) AS row_no,
  RANK()       OVER (ORDER BY siparis DESC)               AS rank_no,
  DENSE_RANK() OVER (ORDER BY siparis DESC)               AS dense_rank_no
FROM musteri
ORDER BY siparis DESC, harcama DESC
LIMIT 15;