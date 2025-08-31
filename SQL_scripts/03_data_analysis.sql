-- WHICH CATEGORY DO MOST PRODUCTS BELONG TO?

SELECT c.category_name AS category,
	count(*) AS product_count
FROM products p JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY 2 DESC
LIMIT 15;



-- WHICH BRAND DO MOST PRODUCTS BELONG TO?

SELECT b.brand_name AS brand,
	count(*) AS product_count
FROM products p JOIN brands b
ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY 2 DESC;



-- WHICH BRANDS HAVE THE HIGHEST % OF HARMFUL PRODUCTS?

select count(distinct chemical_name)
from chemicals;

select distinct chemical_name
from chemicals;

-- We should first add a flag to determine which chemicals are harmful and which are not

ALTER TABLE chemicals
ADD COLUMN is_harmful BOOLEAN DEFAULT FALSE;

-- Now update values in the column is_harmful

UPDATE chemicals
SET is_harmful = TRUE
WHERE chemical_name NOT IN (
'Trade Secret',
'Titanium dioxide',
'Retinol',
'Vitamin A',
'Coffea arabica extract',
'Coffee',
'Genistein (purified)',
'Mica',
'Aspirin',
'Talc',
'Benzophenone-3',
'Acetylsalicylic acid',
'Selenium sulfide',
'Nickel (Metallic)',
'Caffeic acid',
'Cosmetic talc',
'Caffeine',
'Coffee extract',
'Retinol palmitate',
'Propylene glycol mono-t-butyl ether',
'Coffee bean extract',
'Avobenzone',
'Ginkgo biloba extract',
'Benzophenone-4',
'Talc (powder)',
'Extract of coffee bean',
'Aloe vera, whole leaf extract',
'Goldenseal root powder'
);

SELECT * FROM chemicals;

-- Verify

SELECT COUNT(*) AS total_chemicals,
       SUM(is_harmful = TRUE) AS harmful_chemicals,
       SUM(is_harmful = FALSE) AS safe_chemicals
FROM chemicals;

-- Now let's answer our query

SELECT
    b.brand_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT CASE WHEN c.is_harmful=TRUE THEN p.product_id END) AS harmful_products,
    (COUNT(DISTINCT CASE WHEN c.is_harmful=TRUE THEN p.product_id END) * 100.0 / COUNT(DISTINCT p.product_id)) AS harmful_percentage
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN product_chemicals pc ON p.product_id = pc.product_id
JOIN chemicals c ON c.chemical_id = pc.chemical_id
GROUP BY b.brand_name
ORDER BY harmful_percentage DESC;



-- DID HARMFUL CHEMICALS INCREASE OR DECREASE OVER TIME?

SELECT
    YEAR(pc.most_recent_date_reported) AS year,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT CASE WHEN c.is_harmful = TRUE THEN p.product_id END) AS harmful_products,
    (COUNT(DISTINCT CASE WHEN c.is_harmful = TRUE THEN p.product_id END) * 100.0 / COUNT(DISTINCT p.product_id)) AS harmful_percentage
FROM products p
LEFT JOIN product_chemicals pc ON p.product_id = pc.product_id
LEFT JOIN chemicals c ON pc.chemical_id = c.chemical_id
WHERE pc.most_recent_date_reported IS NOT NULL
GROUP BY year
ORDER BY year;



-- WHICH PRODUCTS WITH HARMFUL CHEMICALS HAVE BEEN FIXED OR DISCONTINUED?

SELECT 
	YEAR(pc.most_recent_date_reported) AS report_year,
	COUNT(DISTINCT p.product_id) AS total_harmful_products,
	COUNT(DISTINCT CASE
    WHEN pc.discontinued_date IS NOT NULL OR c.date_removed IS NOT NULL
    THEN p.product_id
		END) AS resolved_harmful_products,
	(COUNT(DISTINCT CASE
    WHEN pc.discontinued_date IS NOT NULL OR c.date_removed IS NOT NULL
    THEN p.product_id
	   END) * 100.0 / COUNT(DISTINCT p.product_id)) AS resolved_percentage
FROM products p
JOIN product_chemicals pc ON p.product_id = pc.product_id
JOIN chemicals c ON pc.chemical_id = c.chemical_id
WHERE c.is_harmful = TRUE
GROUP BY report_year
ORDER BY report_year;



-- WHICH ARE THE MOST COMMON HARMFUL CHEMICALS?

SELECT 
    c.chemical_name,
    COUNT(pc.product_id) AS frequency
FROM product_chemicals pc
JOIN chemicals c ON pc.chemical_id = c.chemical_id
WHERE c.is_harmful = TRUE
GROUP BY c.chemical_name
ORDER BY frequency DESC
LIMIT 10;



-- WHAT IS THE PERCENTAGE OF HARMFUL vs. SAFE PRODUCTS?

SELECT
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT CASE WHEN c.is_harmful = TRUE THEN p.product_id END) AS harmful_products,
    COUNT(DISTINCT CASE WHEN c.is_harmful = FALSE THEN p.product_id END) AS safe_products,
    (COUNT(DISTINCT CASE WHEN c.is_harmful = TRUE THEN p.product_id END) * 100.0 
        / COUNT(DISTINCT p.product_id)) AS harmful_percentage,
    (COUNT(DISTINCT CASE WHEN c.is_harmful = FALSE THEN p.product_id END) * 100.0 
        / COUNT(DISTINCT p.product_id)) AS safe_percentage
FROM products p
JOIN product_chemicals pc ON p.product_id = pc.product_id
JOIN chemicals c ON c.chemical_id = pc.chemical_id;