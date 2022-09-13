#This queries were done in BigQuery using the cleaned file in the "Data" folder

/*1. this query monthly count of sales of each sale type (Regular and Bulge) exluding Cancelled transactions using a subquery in 
the WHERE clause, this query also includes total monthly sales of each sale type */
SELECT
  Month,
  SaleType,
  COUNT(*) AS num_transactions,
  SUM(TransactionTotal) AS Transaction_total
FROM 
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  SaleType NOT IN
    (
    SELECT
      SaleType
    FROM
      `my-project-gac-2022.ecommerce_sales.transactions`
    WHERE
      SaleType = "Cancelled"
    )
GROUP BY
  Month,
  SaleType
ORDER BY
  Month,
  SaleType ;

#2. with this query we want to find out what is the last day of this datset.
SELECT
  DISTINCT(Date)
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
ORDER BY
  Date DESC;
#we found out the dataset is missing the last 22 days of December.

#to avoid any wrong conclusions because of the missing days in December we are going to run the next query to get the average sales per month creatin a temporary table using WITH grouping transactions in days then run another query with the new table.

#this is the temp table using WITH.
WITH daily_sales AS 
(
SELECT 
  Month,
  Date,
  SUM(TransactionTotal) AS DailySale
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  SaleType NOT IN
  (
  SELECT
    SaleType
  FROM
    `my-project-gac-2022.ecommerce_sales.transactions`
  WHERE
    SaleType = "Cancelled"
  )
GROUP BY
  Month,
  Date
ORDER BY
  Date
)
#this is the query with the temp table, you need to run both together to make it work.
SELECT 
  Month,
  AVG(DailySale)
FROM
  daily_sales
GROUP BY
  Month
ORDER BY
 Month ;
#the last part of the query groups the sales by month and takes out the average.

#top 3 best months
WITH daily_sales AS 
(
SELECT 
  Month,
  Date,
  SUM(TransactionTotal) AS DailySale
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  SaleType NOT IN
  (
  SELECT
    SaleType
  FROM
    `my-project-gac-2022.ecommerce_sales.transactions`
  WHERE
    SaleType = "Cancelled"
  )
GROUP BY
  Month,
  Date
ORDER BY
  Date
)
SELECT 
  Month,
  AVG(DailySale) AS total_sales
FROM
  daily_sales
GROUP BY
  Month
ORDER BY
 Month DESC
LIMIT
  3;

#top 3 worst months
WITH daily_sales AS 
(
SELECT 
  Month,
  Date,
  SUM(TransactionTotal) AS DailySale
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  SaleType NOT IN
  (
  SELECT
    SaleType
  FROM
    `my-project-gac-2022.ecommerce_sales.transactions`
  WHERE
    SaleType = "Cancelled"
  )
GROUP BY
  Month,
  Date
ORDER BY
  Date
)
SELECT 
  Month,
  AVG(DailySale) AS total_sales
FROM
  daily_sales
GROUP BY
  Month
ORDER BY
 Month
LIMIT
  3;

#3. now we want to predict the best 2 days to add offers to in January, for that we will use a similar query than last one to compare the last 3 months before January and the last January to see which weekdays would be better.
WITH weekday_sales AS 
(
SELECT 
  Month,
  Date,
  Weekday,
  SUM(TransactionTotal) AS DailySale
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  Month IN (1, 11, 12) AND
  SaleType NOT IN
  (
  SELECT
    SaleType
  FROM
    `my-project-gac-2022.ecommerce_sales.transactions`
  WHERE
    SaleType = "Cancelled"
  )
GROUP BY
  Month,
  Weekday,
  Date
ORDER BY
  Month
)
SELECT 
  Month,
  Weekday,
  AVG(DailySale)
FROM
  weekday_sales
GROUP BY
  Month,
  Weekday
ORDER BY
 Month,
 Weekday ;
#this gives us the weekdays average per month, but we need to put them all 3 together and take the average from that.

#this query puts it all together
WITH weekday_sales AS 
(
SELECT 
  Month,
  Date,
  Weekday,
  SUM(TransactionTotal) AS DailySale
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  Year = 2019 AND
  Month IN (1, 11, 12) AND
  SaleType NOT IN
  (
  SELECT
    SaleType
  FROM
    `my-project-gac-2022.ecommerce_sales.transactions`
  WHERE
    SaleType = "Cancelled"
  )
GROUP BY
  Month,
  Weekday,
  Date
ORDER BY
  Month
)
SELECT 
  Weekday,
  AVG(DailySale) AS avg_weekday_sales
FROM
  weekday_sales
GROUP BY
  Weekday
ORDER BY
 avg_weekday_sales DESC ;

#5. this query tells us which countries performed the best in the last year excluding the United Kingdom.
SELECT
  Country,
  SUM(TransactionTotal) AS Sales
FROM
  `my-project-gac-2022.ecommerce_sales.transactions`
WHERE
  SaleType NOT LIKE "Cancelle%" AND
  Country NOT LIKE "United Kingdo%"
GROUP BY
  Country
ORDER BY
  Sales DESC ;