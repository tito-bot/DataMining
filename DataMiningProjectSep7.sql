SELECT * FROM ModuleSQLSep7.online_retail;
use ModuleSQLSep7 ;

SELECT CustomerID, SUM(Quantity * UnitPrice) AS total_order_value
FROM online_retail
GROUP BY CustomerID
ORDER BY total_order_value DESC;

SELECT CustomerID, COUNT(DISTINCT StockCode) AS unique_products
FROM online_retail
GROUP BY CustomerID;

SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(InvoiceNo) = 1;

SELECT a.StockCode AS Product1, b.StockCode AS Product2, COUNT(*) AS Frequency
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode != b.StockCode
GROUP BY Product1, Product2
ORDER BY Frequency DESC
LIMIT 10;

SELECT CustomerID, purchase_frequency,
       CASE
           WHEN purchase_frequency > 50 THEN 'High'
           WHEN purchase_frequency BETWEEN 20 AND 50 THEN 'Medium'
           ELSE 'Low'
       END AS frequency_segment
FROM (
    SELECT CustomerID, COUNT(InvoiceNo) AS purchase_frequency
    FROM online_retail
    GROUP BY CustomerID
) AS freq;

SELECT Country, AVG(total_order_value) AS average_order_value
FROM (
    SELECT Country, (Quantity * UnitPrice) AS total_order_value
    FROM online_retail
) AS order_values
GROUP BY Country
ORDER BY average_order_value DESC;

SELECT CustomerID
FROM (
    SELECT CustomerID, MAX(InvoiceDate) AS last_purchase_date
    FROM online_retail
    GROUP BY CustomerID
) AS last_purchase
WHERE last_purchase_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SELECT Product1, Product2, COUNT(*) AS Frequency
FROM (
    SELECT a.StockCode AS Product1, b.StockCode AS Product2
    FROM online_retail a
    JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode != b.StockCode
) AS product_pairs
GROUP BY Product1, Product2
ORDER BY Frequency DESC
LIMIT 10;

SET SQL_SAFE_UPDATES = 0;

UPDATE online_retail
SET InvoiceDate = STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')
WHERE InvoiceDate IS NOT NULL;

ALTER TABLE online_retail
MODIFY COLUMN InvoiceDate DATETIME;

SELECT year, month_name, SUM(total_sales) AS total_sales
FROM (
    SELECT YEAR(InvoiceDate) AS year, 
           MONTHNAME(InvoiceDate) AS month_name,
           (Quantity * UnitPrice) AS total_sales
    FROM online_retail
    WHERE InvoiceDate IS NOT NULL
) AS monthly_sales
GROUP BY year, month_name
ORDER BY year, month_name;