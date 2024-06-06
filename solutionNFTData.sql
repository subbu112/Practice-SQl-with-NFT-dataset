USE nftdata;
select count(*) As Total_Sales
from pricedata;

SELECT name, eth_price, usd_price, event_date
FROM pricedata
ORDER BY usd_price DESC
LIMIT 5;
 
SELECT 
    event_date,
    usd_price,
    AVG(usd_price) OVER (ORDER BY event_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_avg_usd_price
FROM 
    pricedata;

SELECT 
    CONCAT(
        name, ' was sold for $', ROUND(usd_price, 3), ' to ', buyer_address, 
        ' from ', seller_address, ' on ', event_date
    ) AS summary
FROM 
    pricedata;
    
CREATE VIEW 1919_purchases AS
SELECT *
FROM pricedata
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

SELECT
    CONCAT(
        ROUND(eth_price, -2), ' - ', ROUND(eth_price, -2) + 99
    ) AS eth_price_range,
    COUNT(*) AS frequency
FROM
    pricedata
GROUP BY
    ROUND(eth_price, -2)
ORDER BY
    ROUND(eth_price, -2);

-- Highest price each NFT was bought for
SELECT 
    name, 
    MAX(usd_price) AS price, 
    'highest' AS status
FROM 
    pricedata
GROUP BY 
    name

UNION

-- Lowest price each NFT was bought for
SELECT 
    name, 
    MIN(usd_price) AS price, 
    'lowest' AS status
FROM 
    pricedata
GROUP BY 
    name

ORDER BY 
    name, 
    status ASC;
--
SELECT 
    t.year_month,
    t.name,
    t.usd_price
FROM (
    SELECT 
        name,
        usd_price,
        DATE_FORMAT(STR_TO_DATE(event_date, '%Y-%m-%d'), '%Y-%m') AS yearmonth,
        RANK() OVER (PARTITION BY DATE_FORMAT(STR_TO_DATE(event_date, '%Y-%m-%d'), '%Y-%m') ORDER BY usd_price DESC) AS rank
    FROM 
        pricedata
) t
WHERE 
    t.rank = 1
ORDER BY 
    t.year_month ASC;
