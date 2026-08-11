SELECT COUNT(*) as Total_no_of_orders,
  SUM(Total_Sales) AS total_sales,
  AVG(Total_Sales) AS mean,
  STDEV(Total_Sales) AS std_dev,
  MIN(Total_Sales) AS min_value,
  MAX(Total_Sales) AS max_value
FROM ApexPlanet_DataAnalytics_Dataset;
SELECT Top 1
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Total_Sales) OVER() AS median
FROM ApexPlanet_DataAnalytics_Dataset;

WITH customer_orders AS (
  SELECT Customer_ID, COUNT(*) AS num_orders
  FROM ApexPlanet_DataAnalytics_Dataset
  GROUP BY Customer_ID)
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(100.0 * SUM(CASE WHEN num_orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_customer_rate_pct
FROM customer_orders;

SELECT
  AVG(Age) AS mean_age,
  MIN(Age) AS min_age,
  MAX(Age) AS max_age,
  STDEV(Age) AS std_age
FROM ApexPlanet_DataAnalytics_Dataset;
SELECT Top 1
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Age) OVER () AS median_age
FROM ApexPlanet_DataAnalytics_Dataset;

SELECT Category, COUNT(*) AS freq,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY Category
ORDER BY freq DESC;

WITH SalesData AS(
    SELECT
        CASE
            WHEN Total_Sales < 100000 THEN '0-100k'
            WHEN Total_Sales < 200000 THEN '100k-200k'
            WHEN Total_Sales < 300000 THEN '200k-300k'
            WHEN Total_Sales < 400000 THEN '300k-400k'
            ELSE '400k+'
        END AS sales_bucket
    FROM ApexPlanet_DataAnalytics_Dataset)
SELECT
    sales_bucket,
    COUNT(*) AS frequency
FROM SalesData
GROUP BY sales_bucket
ORDER BY sales_bucket;

SELECT TOP 5
    Product,
    ROUND(SUM(Total_Sales), 2) AS revenue
FROM ApexPlanet_DataAnalytics_Dataset
WHERE Order_Date >= (
    SELECT DATEADD(MONTH, -6, MAX(Order_Date))
    FROM ApexPlanet_DataAnalytics_Dataset)
GROUP BY Product
ORDER BY revenue DESC;

SELECT
    FORMAT(Order_Date, 'yyyy-MM') AS month,
    COUNT(DISTINCT Customer_ID) AS active_customers,
    ROUND(SUM(Total_Sales), 2) AS revenue
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY  FORMAT(Order_Date, 'yyyy-MM')
ORDER BY month;

SELECT COALESCE(City, 'Unknown') AS City,
       COUNT(*) AS orders,
       ROUND(SUM(Total_Sales), 2) AS revenue,
       ROUND(AVG(Total_Sales), 2) AS avg_order_value
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY City
ORDER BY revenue DESC;

WITH AgeData AS(
    SELECT Category,
        CASE
            WHEN Age < 30 THEN '18-29'
            WHEN Age < 45 THEN '30-44'
            WHEN Age < 60 THEN '45-59'
            ELSE '60+'
        END AS age_group
    FROM ApexPlanet_DataAnalytics_Dataset
    WHERE Age IS NOT NULL )
SELECT Category, age_group,COUNT(*) AS orders
FROM AgeData
GROUP BY Category,age_group
ORDER BY Category,age_group;

SELECT TOP 5  
Customer_ID, Customer_Name,
       COUNT(*) AS num_orders,
       ROUND(SUM(Total_Sales), 2) AS total_spent
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY Customer_ID, Customer_Name
ORDER BY total_spent DESC;

SELECT Gender,
       COUNT(*) AS orders,
       ROUND(SUM(Total_Sales), 2) AS total_order_value
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY Gender;

CREATE TABLE category_targets (
    Category varchar(50),
    monthly_target DECIMAL(18, 2));
INSERT INTO category_targets (Category, monthly_target)
SELECT
    Category,
    ROUND(SUM(Total_Sales) * 1.10, 2)
FROM ApexPlanet_DataAnalytics_Dataset
GROUP BY Category;
SELECT a.Category,
       ROUND(SUM(a.Total_Sales), 2) AS actual_revenue,
       t.monthly_target,
       ROUND(SUM(a.Total_Sales) - t.monthly_target, 2) AS variance
FROM ApexPlanet_DataAnalytics_Dataset a
JOIN category_targets t ON a.Category = t.Category
GROUP BY a.Category, t.monthly_target
ORDER BY variance DESC;

SELECT Quantity, Unit_Price, Total_Sales, Age
FROM ApexPlanet_DataAnalytics_Dataset
WHERE Age IS NOT NULL;

WITH stats AS (
  SELECT AVG(Age) AS avg_x, AVG(Total_Sales) AS avg_y
  FROM ApexPlanet_DataAnalytics_Dataset WHERE Age IS NOT NULL)
SELECT
  ROUND(
    SUM((Age - avg_x) * (Total_Sales - avg_y)) /
    (SQRT(SUM((Age - avg_x)*(Age - avg_x))) *
     SQRT(SUM((Total_Sales - avg_y)*(Total_Sales - avg_y))))
  , 4) AS pearson_corr
FROM ApexPlanet_DataAnalytics_Dataset, stats
WHERE Age IS NOT NULL;

WITH AgeGroups AS(
    SELECT
        CASE
            WHEN Age < 30 THEN '18-29'
            WHEN Age < 45 THEN '30-44'
            WHEN Age < 60 THEN '45-59'
            ELSE '60+'
        END AS age_group,
        Category,
        Total_Sales
    FROM ApexPlanet_DataAnalytics_Dataset
    WHERE Age IS NOT NULL)
SELECT
    age_group,
    Category,
    ROUND(AVG(Total_Sales), 2) AS avg_sales
FROM AgeGroups
GROUP BY age_group, Category
ORDER BY age_group, Category;