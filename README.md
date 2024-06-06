This repository contains all the Files realted to SQL  Practice questions and solutions. This readme file contains all solutions to answers but I have also uploaded datsets and Questions so that you can practice yourself

Here's a README file for your GitHub repository based on the content of your document:

---

# SolutionNFT Dataset Analysis

This repository contains SQL queries and their explanations for analyzing the SolutionNFT dataset. The queries help in extracting various insights from the dataset such as total sales, top transactions, moving averages, and more.

## Table of Contents

- [Total Sales](#total-sales)
- [Top 5 Most Expensive Transactions](#top-5-most-expensive-transactions)
- [Moving Average of USD Price](#moving-average-of-usd-price)
- [Average Sale Price by NFT](#average-sale-price-by-nft)
- [Sales by Day of the Week](#sales-by-day-of-the-week)
- [Transaction Summary](#transaction-summary)
- [1919 Purchases View](#1919-purchases-view)
- [ETH Price Histogram](#eth-price-histogram)
- [Highest and Lowest NFT Prices](#highest-and-lowest-nft-prices)
- [Most Expensive NFT Each Month/Year](#most-expensive-nft-each-month-year)
- [Monthly Sales Volume](#monthly-sales-volume)
- [Transactions for Specific Wallet](#transactions-for-specific-wallet)
- [Estimated Average Value Calculator](#estimated-average-value-calculator)

## Total Sales

```sql
SELECT COUNT(*) AS total_sales FROM pricedata;
```

This query counts all rows in the `pricedata` table to determine the total number of sales in the dataset.

## Top 5 Most Expensive Transactions

```sql
SELECT name, eth_price, usd_price, event_date
FROM pricedata
ORDER BY usd_price DESC
LIMIT 5;
```

This query retrieves the top 5 most expensive transactions by USD price from the `pricedata` table.

## Moving Average of USD Price

```sql
SELECT event_date, usd_price,
       AVG(usd_price) OVER (ORDER BY event_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_avg_usd_price
FROM pricedata;
```

This query calculates a moving average of the USD price over the last 50 transactions.

## Average Sale Price by NFT

```sql
SELECT name, AVG(usd_price) AS average_price
FROM pricedata
GROUP BY name
ORDER BY average_price DESC;
```

This query retrieves the average sale price in USD for each NFT and sorts them in descending order of average price.

## Sales by Day of the Week

```sql
SELECT DAYNAME(STR_TO_DATE(event_date, '%Y-%m-%d')) AS day_of_week,
       COUNT(*) AS number_of_sales,
       AVG(eth_price) AS average_eth_price
FROM pricedata
GROUP BY day_of_week
ORDER BY number_of_sales ASC;
```

This query groups transactions by the day of the week, counting the number of sales and calculating the average ETH price for each day.

## Transaction Summary

```sql
SELECT CONCAT(name, ' was sold for $', ROUND(usd_price, 3), ' to ', buyer_address,
              ' from ', seller_address, ' on ', event_date) AS summary
FROM pricedata;
```

This query constructs a summary column for each sale, including relevant transaction details.

## 1919 Purchases View

```sql
CREATE VIEW 1919_purchases AS
SELECT *
FROM pricedata
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
```

This query creates a view containing all transactions where the specified wallet address was the buyer.

## ETH Price Histogram

```sql
SELECT CONCAT(ROUND(eth_price, -2), ' - ', ROUND(eth_price, -2) + 99) AS eth_price_range,
       COUNT(*) AS frequency
FROM pricedata
GROUP BY ROUND(eth_price, -2)
ORDER BY ROUND(eth_price, -2);
```

This query creates a histogram of ETH price ranges rounded to the nearest hundred and counts the number of transactions in each range.

## Highest and Lowest NFT Prices

```sql
-- Highest price each NFT was bought for
SELECT name, MAX(usd_price) AS price, 'highest' AS status
FROM pricedata
GROUP BY name

UNION

-- Lowest price each NFT was bought for
SELECT name, MIN(usd_price) AS price, 'lowest' AS status
FROM pricedata
GROUP BY name

ORDER BY name, status ASC;
```

This query combines the highest and lowest prices each NFT was bought for, along with their statuses, and orders the results accordingly.

## Most Expensive NFT Each Month/Year

```sql
SELECT SUBSTRING(event_date, 1, 7) AS month_year, name,
       MAX(usd_price) AS max_price
FROM pricedata
GROUP BY month_year, name
ORDER BY month_year, max_price DESC;
```

This query identifies the most expensive NFTs sold each month/year along with their names and prices.

## Monthly Sales Volume

```sql
SELECT SUBSTRING(event_date, 1, 7) AS month_year,
       ROUND(SUM(usd_price), -2) AS total_volume
FROM pricedata
GROUP BY month_year
ORDER BY month_year;
```

This query calculates the total sales volume for each month/year, rounded to the nearest hundred.

## Transactions for Specific Wallet

```sql
SELECT COUNT(*) AS transaction_count
FROM pricedata
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685'
   OR seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
```

This query counts the number of transactions involving the specified wallet address.

## Estimated Average Value Calculator

### Part A

```sql
CREATE TEMPORARY TABLE daily_averages AS
SELECT event_date, usd_price,
       AVG(usd_price) OVER (PARTITION BY event_date) AS daily_average
FROM pricedata;
```

This query creates a temporary table with daily averages of USD prices for each event date.

### Part B

```sql
SELECT event_date, AVG(usd_price) AS estimated_value
FROM daily_averages
WHERE usd_price >= 0.1 * daily_average
GROUP BY event_date;
```

This query filters out daily outlier sales and calculates the daily average of the remaining transactions to get an estimated value for each day.

---

Feel free to edit or expand upon this README as needed for your project.
