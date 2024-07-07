SELECT * FROM retail.new_retail_data;

-- Identify Duplicates
WITH duplicate_data AS(
	SELECT  *, ROW_NUMBER() OVER(PARTITION BY Transaction_ID) as dup
	FROM new_retail_data
) 
SELECT * FROM duplicate_data 
WHERE dup>1;

-- Identify the  number of transactions
SELECT COUNT(Transaction_ID) as number_of_transactions, COUNT(distinct Transaction_ID) as num_unique_transactions
from new_retail_data;

DELETE 
FROM  duplicate_data
WHERE dup > 1;

-- View all the duplicate data   
SELECT *
FROM new_retail_data
WHERE Transaction_ID IN (1129797, 1636104, 3060058, 4117992, 4428772, 7176556);

CREATE TABLE `retail_data_final` (
  `Transaction_ID` double DEFAULT NULL,
  `Customer_ID` double DEFAULT NULL,
  `Name` text,
  `Email` text,
  `Phone` double DEFAULT NULL,
  `Address` text,
  `City` text,
  `State` text,
  `Zipcode` double DEFAULT NULL,
  `Country` text,
  `Age` double DEFAULT NULL,
  `Gender` text,
  `Income` text,
  `Customer_Segment` text,
  `Date` text,
  `Year` double DEFAULT NULL,
  `Month` text,
  `Time` text,
  `Total_Purchases` double DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `Total_Amount` double DEFAULT NULL,
  `Product_Category` text,
  `Product_Brand` text,
  `Product_Type` text,
  `Feedback` text,
  `Shipping_Method` text,
  `Payment_Method` text,
  `Order_Status` text,
  `Ratings` double DEFAULT NULL,
  `products` text,
  `dup` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO retail_data_final
SELECT  *, ROW_NUMBER() OVER(PARTITION BY Transaction_ID) as dup
	FROM new_retail_data;

-- Delete the duplicate entries 
DELETE 
FROM retail_data_final 
WHERE dup > 1;

SELECT *
FROM retail_data_final 
WHERE dup > 1 ;

-- Identify columns with same customer ID
WITH duplicate_customer AS 
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY Customer_ID) as dup_cus
FROM retail_data_final
)
SELECT * 
FROM duplicate_customer
WHERE dup_cus >1;


CREATE TABLE `retail_data_final1` (
  `Transaction_ID` double DEFAULT NULL,
  `Customer_ID` double DEFAULT NULL,
  `Name` text,
  `Email` text,
  `Phone` double DEFAULT NULL,
  `Address` text,
  `City` text,
  `State` text,
  `Zipcode` double DEFAULT NULL,
  `Country` text,
  `Age` double DEFAULT NULL,
  `Gender` text,
  `Income` text,
  `Customer_Segment` text,
  `Date` text,
  `Year` double DEFAULT NULL,
  `Month` text,
  `Time` text,
  `Total_Purchases` double DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `Total_Amount` double DEFAULT NULL,
  `Product_Category` text,
  `Product_Brand` text,
  `Product_Type` text,
  `Feedback` text,
  `Shipping_Method` text,
  `Payment_Method` text,
  `Order_Status` text,
  `Ratings` double DEFAULT NULL,
  `products` text,
  `dup` int,
  `dup_cus` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO retail_data_final1
SELECT  *, ROW_NUMBER() OVER(PARTITION BY Customer_ID) as dup_cus
	FROM retail_data_final;

-- Delete the duplicate entries 
DELETE 
FROM retail_data_final1 
WHERE dup_cus > 1;

SELECT `Date`,
STR_TO_DATE(`DATE`,'%m/%d/%Y')
FROM retail_data_final1;

UPDATE retail_data_final1
SET `Date` = STR_TO_DATE(`Date`,'%m/%d/%Y');

ALTER TABLE retail_data_final1
MODIFY COLUMN `Date` DATE;

-- NULL VALUES 
SELECT Product_Category
FROM retail_data_final1 
WHERE 'Product_Category' IS NULL;

SELECT  MAX(AMOUNT)
FROM retail_data_final1;

SELECT Transaction_ID, round(Amount,2) AS Amount_Spent FROM retail_data_final1;

UPDATE retail_data_final1
SET `Amount` = round(Amount,2), `Total_Amount` = round(Total_Amount,2);


ALTER TABLE  retail_data_final1 
DROP COLUMN `Products`;


SELECT * FROM retail_data_final1;