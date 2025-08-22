----Seeing what the data offers----
SELECT
  *
FROM
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS"
LIMIT
  10;
 ------------checking opening time/hours------
 SELECT
  MIN(transaction_time) AS opening_time
FROM
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS";
  ---------checking closing time/hours-----
   SELECT
  MAX(transaction_time) AS closing_time
FROM
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS";
 
 ----Naming of the days classification----
  SELECT TO_DATE(transaction_date) AS purchase_date,
    DAYOFMONTH(TO_DATE(transaction_date)) AS day_of_month,
    MONTHNAME(TO_DATE (transaction_date)) AS name_of_month,
    TO_CHAR(TO_DATE(transaction_date), 'YYYYMM') AS month_id,
    DAYNAME(TO_DATE(transaction_date)) AS day_name,
    CASE 
    WHEN day_name NOT IN ('Sat', 'Sun') THEN 'Weekday'
    ELSE 'Weekend'
    END AS day_classification,
FROM
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS";
-------Time bucket classification-------
SELECT TO_DATE(transaction_date) AS purchase_date,
    DAYOFMONTH(TO_DATE(transaction_date)) AS day_of_month,
    MONTHNAME(TO_DATE (transaction_date)) AS name_of_month,
    TO_CHAR(TO_DATE(transaction_date), 'YYYYMM') AS month_id,
    DAYNAME(TO_DATE(transaction_date)) AS day_name,
    CASE 
    WHEN day_name NOT IN ('Sat', 'Sun') THEN 'Weekday'
    ELSE 'Weekend'
    END AS day_classification,
    HOUR(transaction_time) hour_of_day,
    CASE
    WHEN transaction_time BETWEEN '06:00:00' AND '08:59:59' THEN 'Early Morning'
    WHEN transaction_time BETWEEN '09:00:00' AND '11:59:59' THEN 'Morning'
    WHEN transaction_time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    WHEN transaction_time BETWEEN '16:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night: +8pm,'
    END AS time_buckets,
 FROM
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS";
  ---------counts----
  
 SELECT COUNT(DISTINCT transaction_id) AS number_of_sales,
  COUNT(DISTINCT store_id) stores,
  COUNT(DISTINCT product_id) number_of_different_product,
  product_category,
  product_detail,
  product_type,store_location,

  -----revenue counts----
   ROUND(SUM(IFNULL(transaction_qty, 0) * IFNULL(unit_price, 0)), 0) AS total_revenue,
  ----------------FINAL CODE------------------
  SELECT 
  TO_DATE(transaction_date) AS purchase_date,
  DAYOFMONTH(TO_DATE(transaction_date)) AS day_of_month,
  MONTHNAME(TO_DATE(transaction_date)) AS name_of_month,
  TO_CHAR(TO_DATE(transaction_date), 'YYYYMM') AS month_id,
  DAYNAME(TO_DATE(transaction_date)) AS day_name,
  CASE 
    WHEN DAYNAME(TO_DATE(transaction_date)) NOT IN ('Sat', 'Sun') THEN 'Weekday' 
    ELSE 'Weekend' 
  END AS day_classification,
  HOUR(transaction_time) AS hour_of_day,
  CASE 
    WHEN transaction_time BETWEEN '06:00:00' AND '08:59:59' THEN 'Early Morning'
    WHEN transaction_time BETWEEN '09:00:00' AND '11:59:59' THEN 'Morning'
    WHEN transaction_time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    WHEN transaction_time BETWEEN '16:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night: +8pm'
  END AS time_buckets,
  ROUND(SUM(IFNULL(transaction_qty, 0) * IFNULL(unit_price, 0)), 0) AS total_revenue,
  COUNT(DISTINCT transaction_id) AS number_of_sales,
  COUNT(DISTINCT store_id) AS stores,
  COUNT(DISTINCT product_id) AS number_of_different_product,
  product_category,
  product_detail,
  product_type,
  store_location
FROM 
  "CoffeeShopAnalysis"."PUBLIC"."COFFEESHOPANALYSIS"
GROUP BY ALL;
