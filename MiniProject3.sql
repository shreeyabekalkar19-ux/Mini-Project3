USE classicmodels;
SELECT * FROM customers;
-- 1. Handling Missing Data (NULL Handling)

SELECT customerNumber, customerName, contactLastName, contactFirstName, addressLine1, 
        COALESCE(addressLine2, 'N/A') AS addressLine2,
        city,
        COALESCE(state, 'Unknown') AS state,
        COALESCE(postalCode, 'Unknown') AS postalCode,
        country
FROM customers;

-- 2. Standardizing Name Formatting

SELECT customerNumber,
	   TRIM(CONCAT(ContactFirstName,' ',ContactLastName)) AS contactFullName,
	   phone
FROM customers;

-- 3. Email Cleaning

SELECT * FROM employees;
SELECT EmployeeNumber,
	   TRIM(CONCAT(FirstName,' ',LastName)) AS FullName,
	   LOWER(TRIM(email)) AS cleaned_email
FROM employees;

-- 4. Formatting and Cleaning Phone Numbers

SELECT * FROM offices;

SELECT officeCode, 
		city,
        phone AS original_phone,
        REGEXP_REPLACE(phone, '[^0-9]','') as cleaned_phone_number
FROM offices;

SELECT * FROM customers;

SELECT customerNumber, customerName, city,
        phone AS original_phone,
         REGEXP_REPLACE(phone, '[^0-9]','') as cleaned_phone_number
FROM customers;

-- 5. Identifying Duplicates Payments

SELECT * FROM payments;

SELECT customerNumber, paymentDate, amount,
    COUNT(*) AS duplicate_count
FROM payments
GROUP BY
	customerNumber,
    paymentDate,
    amount
HAVING COUNT(*) > 1;

SELECT * FROM orderdetails;
SELECT * FROM orders;

-- Query to find out whether same customer has ordered same product on the same date or not.

SELECT 
	o.customerNumber,
    c.customerName,
    o.orderDate,
    od.productCode,
    p.productName,
    COUNT(*) AS total_times_ordered
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.OrderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN products p ON od.productCode = p.productCode
GROUP BY
	o.customerNumber,
    c.customerName,
    o.orderDate,
    od.productCode,
    p.productName
HAVING COUNT(*) > 1;

-- 6. Categorizing Incomplete or Unshipped Orders

SELECT 
	orderNumber,
    orderDate,
    shippedDate, 
    status,
    CASE 
		WHEN shippedDate IS NULL THEN "Not Shipped Yet"
        ELSE CAST(DATEDIFF(shippedDate,orderDate) AS CHAR)
	END AS fullfillment_days
FROM orders;

-- 7. Extracting Product Scale Numbers form Strings

SELECT 
	productCode,
    productName,
    productScale,
    CAST(SUBSTRING_INDEX(productScale,':',-1) AS unsigned) AS ScaleFactor
FROM products;

-- 8. Detecting DATA Inconsistencies (Invalid Credit Limits) 

SELECT 
	DISTINCT c.customerNumber,
    c.customerName,
    COALESCE(c.creditLimit, 0.00) AS current_credit_limit,
    COUNT(o.orderNumber) AS total_orders_placed
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE c.creditLimit IS NULL OR c.creditLimit = 0.00
GROUP BY c.customerNumber, c.customerName, c.creditLimit;

-- 9. Updating and Standardizing Region Names

SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET country = CASE 
			WHEN country = 'USA' Then 'United States'
            WHEN country = 'UK' THEN 'United Kingdom'
            ELSE country
		END
WHERE country IN ('USA','UK');
SELECT * FROM customers;