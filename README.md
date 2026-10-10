# Mini Project 03: Data Cleaning, Validation & Standardization in SQL


## Project Overview
This project executes a robust end-to-end data cleaning and preprocessing pipeline on the classicmodels relational database. The goal is to address data hygiene issues—including missing values, inconsistent string formatting, duplicate records, structural text extraction, and database standardization.


## 1. What Issues You Identified
During the exploratory data audit of the database, several data hygiene and consistency issues were uncovered:
* *Missing & Null Values:* Multiple records contained NULL values in critical fields such as addressLine2, state, postalCode, and creditLimit, which can break downstream mathematical calculations or reporting dashboards.
* *Messy Formatting & Extra Whitespace:* Names and text attributes contained irregular spacing, and corporate emails lacked uniform lowercase standards.
* *Unstructured Phone Numbers:* Phone number entries across offices included inconsistent symbols, parenthesis, dashes, and whitespace, preventing clean numerical categorization.
* *Product Scale Formatting:* The productScale column stored scale ratios as formatted text strings, making direct mathematical sorting impossible.
* *Unshipped Order Tracking Gaps:* Orders lacking a shippedDate returned NULL values when attempting to calculate delivery lead times.
* *Inconsistent Country Naming:* Global regions lacked uniform naming conventions.

---

## 2. How Were The Issue Handled
To resolve these issues, a multi-step data transformation and standardization workflow was implemented:
* *NULL Substitution:* Replaced blank fields with logical placeholders to maintain dataset continuity without dropping records.
* *String Regularization:* Standardized text strings by trimming leading/trailing whitespace, concatenating name fields cleanly, and forcing emails to lowercase.
* *Pattern Extraction via Regex:* Stripped all non-numeric characters (dashes, parentheses, spaces) out of phone numbers to isolate pure numerical values.
* *Data Parsing & Type Casting:* Extracted numerical scaling ratios from text strings by isolating values after the colon delimiter and casting them into unsigned integers for proper sorting.
* *Conditional Fulfillment Tracking:* Handled incomplete order statuses dynamically by evaluating shippedDate nullability—flagging active orders as "Not Shipped Yet" while calculating delivery lead times for fulfilled items.
* *Bulk Standardization Updates:* Executed bulk update scripts using conditional case mapping to transition shorthand country codes into clean, formal geographic names.

---

## 3. SQL Concepts Used
* *COALESCE()*: Evaluates expressions sequentially to substitute default fallback values for NULL data.
* *String Functions*: TRIM(), CONCAT(), and LOWER() for text cleaning and concatenation.
* *Regular Expressions*: REGEXP_REPLACE() for targeting and removing specific patterns (non-digit characters) from strings.
* *Data Type Casting*: CAST(... AS UNSIGNED) and CAST(... AS CHAR) to convert data types for calculations and conditional display.
* *Conditional Logic (CASE Statements)*: Built custom conditional logic to categorize fulfillment states and remap geographic country entries.
* *Date & Mathematical Functions*: Utilized DATEDIFF() to calculate cross-date metrics.
* *Aggregations & Grouping*: GROUP BY paired with HAVING COUNT(*) > 1 to examine duplicate payment events and multi-order matches.
* *Database Updates (UPDATE)*: Performed safe row updates using SET SQL_SAFE_UPDATES = 0 for regional data normalization.
--

## Repository Structure
```text
├── MiniProject3.sql     # Main cleaning script with custom validations
├── screenshots2                   # Result grids showing cleaned outputs
└── README.md                      # Project documentation
