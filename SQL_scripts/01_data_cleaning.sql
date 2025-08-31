-- LOADING THE DATA

-- To fix the secure-file-priv restriction

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE "local_infile";

-- CREATE A STAGING TABLE
-- Hold raw data safely as text without parsing into numbers/dates while loading

CREATE TABLE raw_cosmetics (
    CDPHId                VARCHAR(50) NULL,
    ProductName           VARCHAR(500) NULL,
    CSFId                 VARCHAR(50) NULL,
    CSF                   VARCHAR(255) NULL,
    CompanyId             VARCHAR(50) NULL,
    CompanyName           VARCHAR(500) NULL,
    BrandName             VARCHAR(255) NULL,
    PrimaryCategoryId     VARCHAR(50) NULL,
    PrimaryCategory       VARCHAR(255) NULL,
    SubCategoryId         VARCHAR(50) NULL,
    SubCategory           VARCHAR(255) NULL,
    CasId                 VARCHAR(50) NULL,
    CasNumber             VARCHAR(100) NULL,
    ChemicalId            VARCHAR(50) NULL,
    ChemicalName          VARCHAR(500) NULL,
    InitialDateReported   VARCHAR(50) NULL,
    MostRecentDateReported VARCHAR(50) NULL,
    DiscontinuedDate      VARCHAR(50) NULL,
    ChemicalCreatedAt     VARCHAR(50) NULL,
    ChemicalUpdatedAt     VARCHAR(50) NULL,
    ChemicalDateRemoved   VARCHAR(50) NULL,
    ChemicalCount         VARCHAR(50) NULL
);

-- Now bulk load the CSV

LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Documents/Git/cosmetics-SQL-EDA/data/raw/raw_cosmetics.csv'
INTO TABLE raw_cosmetics
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Checking the data

SELECT * FROM raw_cosmetics;
SELECT COUNT(CDPHId) FROM raw_cosmetics;
-- The data has successfully been loaded.



-- DATA TYPE CONVERSION

CREATE TABLE clean_cosmetics(
    CDPHId                INT,
    ProductName           VARCHAR(500),
    CSFId                 INT,
    CSF                   VARCHAR(255),
    CompanyId             INT,
    CompanyName           VARCHAR(255),
    BrandName             VARCHAR(255),
    PrimaryCategoryId     INT,
    PrimaryCategory       VARCHAR(255),
    SubCategoryId         INT,
    SubCategory           VARCHAR(255),
    CasId                 INT,
    CasNumber             VARCHAR(100),
    ChemicalId            INT,
    ChemicalName          VARCHAR(500),
    InitialDateReported   DATE,
    MostRecentDateReported DATE,
    DiscontinuedDate      DATE,
    ChemicalCreatedAt     DATE,
    ChemicalUpdatedAt     DATE,
    ChemicalDateRemoved   DATE,
    ChemicalCount         INT
);



-- NULL HANDLING

INSERT INTO clean_cosmetics
SELECT
    NULLIF(CDPHId, '') AS CDPHId,
    NULLIF(ProductName, '') AS ProductName,
    NULLIF(CSFId, '') AS CSFId,
    NULLIF(CSF, '') AS CSF,
    NULLIF(CompanyId, '') AS CompanyId,
    NULLIF(CompanyName, '') AS CompanyName,
    NULLIF(BrandName, '') AS BrandName,
    NULLIF(PrimaryCategoryId, '') AS PrimaryCategoryId,
    NULLIF(PrimaryCategory, '') AS PrimaryCategory,
    NULLIF(SubCategoryId, '') AS SubCategoryId,
    NULLIF(SubCategory, '') AS SubCategory,
    NULLIF(CasId, '') AS CasId,
    NULLIF(CasNumber, '') AS CasNumber,
    NULLIF(ChemicalId, '') AS ChemicalId,
    NULLIF(ChemicalName, '') AS ChemicalName,

    STR_TO_DATE(NULLIF(InitialDateReported, ''), '%m/%d/%Y') AS InitialDateReported,
    STR_TO_DATE(NULLIF(MostRecentDateReported, ''), '%m/%d/%Y') AS MostRecentDateReported,
    STR_TO_DATE(NULLIF(DiscontinuedDate, ''), '%m/%d/%Y') AS DiscontinuedDate,

    STR_TO_DATE(NULLIF(ChemicalCreatedAt, ''), '%m/%d/%Y') AS ChemicalCreatedAt,
    STR_TO_DATE(NULLIF(ChemicalUpdatedAt, ''), '%m/%d/%Y') AS ChemicalUpdatedAt,
    STR_TO_DATE(NULLIF(ChemicalDateRemoved, ''), '%m/%d/%Y') AS ChemicalDateRemoved,

    NULLIF(ChemicalCount, '') AS ChemicalCount
FROM raw_cosmetics;

SELECT *
FROM clean_cosmetics
LIMIT 20;



-- RUN SANITY CHECKS

-- Total rows
SELECT COUNT(*) FROM clean_cosmetics;

-- Missing values per column
SELECT
    SUM(CDPHId IS NULL) AS missing_CDPHId,
    SUM(ProductName IS NULL) AS missing_ProductName,
    SUM(CSFId IS NULL) AS missing_CSFId,
    SUM(CSF IS NULL) AS missing_CSF,
    SUM(CompanyId IS NULL) AS missing_CompanyId,
    SUM(CompanyName IS NULL) AS missing_CompanyName,
    SUM(BrandName IS NULL) AS missing_BrandName,
    SUM(PrimaryCategoryId IS NULL) AS missing_PrimaryCategoryId,
    SUM(PrimaryCategory IS NULL) AS missing_PrimaryCategory,
    SUM(SubCategoryId IS NULL) AS missing_SubCategoryId,
    SUM(SubCategory IS NULL) AS missing_SubCategory,
    SUM(CasId IS NULL) AS missing_CasId,
    SUM(CasNumber IS NULL) AS missing_CasNumber,
    SUM(ChemicalId IS NULL) AS missing_ChemicalId,
    SUM(ChemicalName IS NULL) AS missing_ChemicalName,
    SUM(InitialDateReported IS NULL) AS missing_InitialDateReported,
    SUM(MostRecentDateReported IS NULL) AS missing_MostRecentDateReported,
    SUM(DiscontinuedDate IS NULL) AS missing_DiscontinuedDate,
    SUM(ChemicalCreatedAt IS NULL) AS missing_ChemicalCreatedAt,
    SUM(ChemicalUpdatedAt IS NULL) AS missing_ChemicalUpdatedAt,
    SUM(ChemicalDateRemoved IS NULL) AS missing_ChemicalDateRemoved,
    SUM(ChemicalCount IS NULL) AS missing_ChemicalCount
FROM clean_cosmetics;

-- Number of unique entries in table
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT CDPHId, ProductName, CSFId, CSF, CompanyId, CompanyName, 
       BrandName, PrimaryCategoryId, PrimaryCategory, SubCategoryId,
       SubCategory, CasId, CasNumber, ChemicalId, ChemicalName, InitialDateReported,
       MostRecentDateReported, DiscontinuedDate, ChemicalCreatedAt, ChemicalUpdatedAt,
       ChemicalDateRemoved, ChemicalCount) AS unique_rows
FROM clean_cosmetics;



-- DUPLICATE DETECTION
SELECT CDPHId, CSFId, SubCategoryId, ChemicalId, ChemicalCount, COUNT(*) as dup_count
FROM clean_cosmetics
GROUP BY CDPHId, CSFId, SubCategoryId, ChemicalId, ChemicalCount
HAVING COUNT(*) > 1
ORDER BY 6 DESC;

-- Check a few entries to ensure they are truly duplicates or not
SELECT *
FROM clean_cosmetics
WHERE CDPHId=15886 AND SubCategoryId=92 AND ChemicalId=0 AND ChemicalCount=1;

SELECT *
FROM clean_cosmetics
WHERE CDPHId=3697 AND SubCategoryId=21 AND ChemicalId=0 AND ChemicalCount=1;



-- DEDUPLICATION

CREATE TABLE cosmetics_analysis AS
SELECT DISTINCT
    TRIM(CDPHId) AS CDPHId,
    TRIM(ProductName) AS ProductName,
    TRIM(CSFId) AS CSFId,
    TRIM(CSF) AS CSF,
    TRIM(CompanyId) AS CompanyId,
    TRIM(CompanyName) AS CompanyName,
    TRIM(BrandName) AS BrandName,
    TRIM(PrimaryCategoryId) AS PrimaryCategoryId,
    TRIM(PrimaryCategory) AS PrimaryCategory,
    TRIM(SubCategoryId) AS SubCategoryId,
    TRIM(SubCategory) AS SubCategory,
    TRIM(CasId) AS CasId,
    TRIM(CasNumber) AS CasNumber,
    TRIM(ChemicalId) AS ChemicalId,
    TRIM(ChemicalName) AS ChemicalName,
    DATE(InitialDateReported) AS InitialDateReported,
    DATE(MostRecentDateReported) AS MostRecentDateReported,
    DATE(DiscontinuedDate) AS DiscontinuedDate,
    DATE(ChemicalCreatedAt) AS ChemicalCreatedAt,
    DATE(ChemicalUpdatedAt) AS ChemicalUpdatedAt,
    DATE(ChemicalDateRemoved) AS ChemicalDateRemoved,
    ChemicalCount
FROM clean_cosmetics;

SELECT COUNT(*) FROM cosmetics_analysis;

-- Checking if any duplicates still passed through
SELECT CDPHId, CSFId, SubCategoryId, ChemicalId, ChemicalCount, COUNT(*) as dup_count
FROM cosmetics_analysis
GROUP BY CDPHId, CSFId, SubCategoryId, ChemicalId, ChemicalCount
HAVING COUNT(*) > 1
ORDER BY 6 DESC;

-- Checking the duplicate entries
SELECT *
FROM cosmetics_analysis
WHERE CDPHId=13031 AND SubCategoryId=102 AND ChemicalId=0 AND ChemicalCount=1;

SELECT *
FROM cosmetics_analysis
WHERE CDPHId=14249 AND SubCategoryId=25 AND ChemicalId=0 AND ChemicalCount=1;

SELECT *
FROM cosmetics_analysis
WHERE CDPHId=2930 AND SubCategoryId=162 AND ChemicalId=0 AND ChemicalCount=1;

SELECT *
FROM cosmetics_analysis
WHERE CDPHId=4566 AND SubCategoryId=35 AND ChemicalId=0 AND ChemicalCount=1;
-- Apparently, all of them differ with their "duplicate" in ChemicalDateRemoved



-- CONFLICT FLAG

ALTER TABLE cosmetics_analysis
ADD COLUMN ConflictFlag BOOLEAN DEFAULT FALSE;

ALTER TABLE cosmetics_analysis
DROP COLUMN ConflictFlag;

UPDATE cosmetics_analysis c
JOIN (
    SELECT CDPHId, SubCategoryId, ChemicalId, ChemicalCount
    FROM cosmetics_analysis
    GROUP BY CDPHId, SubCategoryId, ChemicalId, ChemicalCount
    HAVING COUNT(DISTINCT COALESCE(ChemicalDateRemoved, '0000-00-00')) > 1
) t
  ON c.CDPHId = t.CDPHId
 AND c.SubCategoryId = t.SubCategoryId
 AND c.ChemicalId = t.ChemicalId
 AND c.ChemicalCount = t.ChemicalCount
SET c.ConflictFlag = TRUE;

-- Now, the Conflict Flag has been updated to True where there are variations in ChemicalDateRemoved



-- STANDARDIZE DATA

SELECT * FROM cosmetics_analysis;



-- TEXT CASING

UPDATE cosmetics_analysis
SET
	ProductName = TRIM(ProductName),
	CompanyName = LOWER(TRIM(CompanyName)),
    BrandName = LOWER(TRIM(BrandName)),
    PrimaryCategory = LOWER(TRIM(PrimaryCategory));
    
    
    
-- WHITESPACES AND SPECIAL CHARACTERS

UPDATE cosmetics_analysis
SET
	ProductName = REGEXP_REPLACE(ProductName, '\\s+', ' '),
	CompanyName = REGEXP_REPLACE(CompanyName, '\\s+', ' '),
    BrandName = REGEXP_REPLACE(BrandName, '\\s+', ' '),
    PrimaryCategory = REGEXP_REPLACE(PrimaryCategory, '\\s+', ' ');
    
-- CATEGORY CHECK

SELECT distinct PrimaryCategory
from cosmetics_analysis
order by 1;

-- DATES CHECK

SELECT MIN(InitialDateReported), MAX(InitialDateReported)
FROM cosmetics_analysis;

SELECT MIN(MostRecentDateReported), MAX(MostRecentDateReported)
FROM cosmetics_analysis;

SELECT MIN(DiscontinuedDate), MAX(DiscontinuedDate)
FROM cosmetics_analysis;

SELECT MIN(ChemicalCreatedAt), MAX(ChemicalCreatedAt)
FROM cosmetics_analysis;

SELECT MIN(ChemicalUpdatedAt), MAX(ChemicalUpdatedAt)
FROM cosmetics_analysis;

SELECT MIN(ChemicalDateRemoved), MAX(ChemicalDateRemoved)
FROM cosmetics_analysis;

-- We found an outlier in ChemicalDateRemoved
SELECT *
FROM cosmetics_analysis
WHERE ChemicalDateRemoved > '2021-01-01';

-- It looks like a mistype problem where the 2nd and 3rd digit in the year column have been replaced.
UPDATE cosmetics_analysis
SET ChemicalDateRemoved = DATE_SUB(ChemicalDateRemoved, INTERVAL 90 YEAR)
WHERE YEAR(ChemicalDateRemoved) = 2103 OR YEAR(ChemicalDateRemoved) = 2104;



-- IDENTIFIERS

SELECT CasNumber, COUNT(*) 
FROM cosmetics_analysis
GROUP BY CasNumber
ORDER BY 2 DESC;

-- Let's check where CasNumber doesn't match standard format
SELECT CasNumber
FROM cosmetics_analysis
WHERE CasNumber IS NOT NULL
  AND CasNumber NOT REGEXP '^[0-9]{1,7}-[0-9]{2}-[0-9]$';
  
ALTER TABLE cosmetics_analysis
ADD COLUMN CasNumber_Clean VARCHAR(50),
ADD COLUMN CasNumber_Unresolved VARCHAR(50);

UPDATE cosmetics_analysis
SET CasNumber_Clean = NULL
WHERE CasNumber = '0';

UPDATE cosmetics_analysis
SET CasNumber_Clean = TRIM(
    REGEXP_REPLACE(
        REPLACE(REPLACE(REPLACE(UPPER(CasNumber), 'CAS#', ''), 'CAS #', ''), 'RN:', ''),
        '[[:space:]]+', ''
    )
)
WHERE CasNumber REGEXP '^[0-9 -]+$';

UPDATE cosmetics_analysis
SET CasNumber_Unresolved = CasNumber,
    CasNumber_Clean = NULL
WHERE CasNumber_Clean IS NULL
  AND CasNumber IS NOT NULL
  AND CasNumber NOT IN ('0');

UPDATE cosmetics_analysis
SET 
    CasNumber_Unresolved = CasNumber,
    CasNumber_Clean = NULL
WHERE CasNumber_Clean NOT REGEXP '^[0-9]{2,7}-[0-9]{2}-[0-9]$';

SELECT CasNumber, CasNumber_Clean, CasNumber_Unresolved
FROM cosmetics_analysis;

SELECT DISTINCT CasNumber_Unresolved
FROM cosmetics_analysis;



-- NUMERIC FIELDS

-- IDs
SELECT 'CDPHId' col, COUNT(*) total,
       SUM(CDPHId IS NULL) nulls, SUM(CDPHId=0) zeros,
       MIN(CDPHId) minv, MAX(CDPHId) maxv, COUNT(DISTINCT CDPHId) ndistinct
FROM cosmetics_analysis
UNION ALL
SELECT 'CSFId', COUNT(*),
       SUM(CSFId IS NULL), SUM(CSFId=0),
       MIN(CSFId), MAX(CSFId), COUNT(DISTINCT CSFId)
FROM cosmetics_analysis
UNION ALL
SELECT 'CompanyId', COUNT(*),
       SUM(CompanyId IS NULL), SUM(CompanyId=0),
       MIN(CompanyId), MAX(CompanyId), COUNT(DISTINCT CompanyId)
FROM cosmetics_analysis
UNION ALL
SELECT 'PrimaryCategoryId', COUNT(*),
       SUM(PrimaryCategoryId IS NULL), SUM(PrimaryCategoryId=0),
       MIN(PrimaryCategoryId), MAX(PrimaryCategoryId), COUNT(DISTINCT PrimaryCategoryId)
FROM cosmetics_analysis
UNION ALL
SELECT 'SubCategoryId', COUNT(*),
       SUM(SubCategoryId IS NULL), SUM(SubCategoryId=0),
       MIN(SubCategoryId), MAX(SubCategoryId), COUNT(DISTINCT SubCategoryId)
FROM cosmetics_analysis
UNION ALL
SELECT 'CasId', COUNT(*),
       SUM(CasId IS NULL), SUM(CasId=0),
       MIN(CasId), MAX(CasId), COUNT(DISTINCT CasId)
FROM cosmetics_analysis
UNION ALL
SELECT 'ChemicalId', COUNT(*),
       SUM(ChemicalId IS NULL), SUM(ChemicalId=0),
       MIN(ChemicalId), MAX(ChemicalId), COUNT(DISTINCT ChemicalId)
FROM cosmetics_analysis;

-- Count field
SELECT COUNT(*) total,
       SUM(ChemicalCount IS NULL) nulls,
       SUM(ChemicalCount = 0) zeros,
       SUM(ChemicalCount < 0) negatives,
       MIN(ChemicalCount) minv,
       MAX(ChemicalCount) maxv,
       AVG(ChemicalCount) avgv
FROM cosmetics_analysis;

-- Let's create a view to perform EDA
CREATE OR REPLACE VIEW cosmetics_numeric_std AS
SELECT
    CDPHId, CSFId, CompanyId, PrimaryCategoryId, SubCategoryId, CasId, ChemicalId, ChemicalCount,

    NULLIF(CDPHId, 0)              AS CDPHId_std,
    NULLIF(CSFId, 0)               AS CSFId_std,
    NULLIF(CompanyId, 0)           AS CompanyId_std,
    NULLIF(PrimaryCategoryId, 0)   AS PrimaryCategoryId_std,
    NULLIF(SubCategoryId, 0)       AS SubCategoryId_std,
    NULLIF(CasId, 0)               AS CasId_std,
    NULLIF(ChemicalId, 0)          AS ChemicalId_std,

    -- No negatives , allow zeros
    CASE WHEN ChemicalCount < 0 THEN NULL ELSE ChemicalCount END AS ChemicalCount_std,

    -- Flags
    (CDPHId = 0 OR CDPHId IS NULL)                    AS CDPHId_missing,
    (CSFId = 0 OR CSFId IS NULL)                      AS CSFId_missing,
    (CompanyId = 0 OR CompanyId IS NULL)              AS CompanyId_missing,
    (PrimaryCategoryId = 0 OR PrimaryCategoryId IS NULL) AS PrimaryCategoryId_missing,
    (SubCategoryId = 0 OR SubCategoryId IS NULL)      AS SubCategoryId_missing,
    (CasId = 0 OR CasId IS NULL)                      AS CasId_missing,
    (ChemicalId = 0 OR ChemicalId IS NULL)            AS ChemicalId_missing,
    (ChemicalCount < 0 OR ChemicalCount IS NULL)      AS ChemicalCount_problem
FROM cosmetics_analysis;



-- Categorical Inconsistencies in CompanyName

select distinct CompanyName
from cosmetics_analysis
order by 1;

-- alberto culver, alberto culver usa, inc.
-- american consumer products, american consumer products, llc
-- apollo health and beauty care, apollo health and beauty care inc.
-- arcadia beauty labs llc, arcadia beauty labs, llc
-- athena cosmetics, athena cosmetics, inc.
-- cover fx skin care inc., cover fx skincare inc
-- fresh inc, fresh inc., fresh, inc.
-- interparfums, interparfums inc., interparfums usa, llc
-- kmc exim, kmc exim corporation/dashing diva franchise corp
-- lvmh fragrance brands, lvmh fragrance brands - kenzo parfums
-- nail alliance - entity, nail alliance, llc
-- neostrata company, inc., neostrata company, inc., a johnson & johnson company
-- shiseido america, inc., shiseido americas corporation, shiseido co., ltd.,
-- stila style llc., stila styles llc
-- vi-jon, inc, vi-jon, inc.

ALTER TABLE cosmetics_analysis
ADD COLUMN CompanyName_Clean VARCHAR(255);

UPDATE cosmetics_analysis
SET CompanyName_Clean = LOWER(TRIM(CompanyName));

-- Remove , and .
UPDATE cosmetics_analysis
SET CompanyName_Clean = REPLACE(REPLACE(CompanyName_Clean, '.', ''), ',', '');

-- Remove legal suffixes
UPDATE cosmetics_analysis
SET CompanyName_Clean = TRIM(
    REGEXP_REPLACE(
        CompanyName_Clean,
        '(\\s+(incorporated|inc|llc|corporation|corp|co|ltd|usa))$',
        '',
        1, 0, 'i'
    )
);

-- Create mapping table for manual correction of rest
CREATE TABLE company_aliases (
    alias VARCHAR(255) PRIMARY KEY,
    standard_name VARCHAR(255)
);

INSERT INTO company_aliases (alias, standard_name) VALUES 
('cover fx skin care', 'cover fx skincare'),
('kmc exim corporation/dashing diva franchise', 'kmc exim'),
('lvmh fragrance brands - kenzo parfums', 'lvmh fragrance brands'),
('nail alliance - entity', 'nail alliance'),
('neostrata company inc a johnson & johnson company', 'neostrata company'),
('shiseido america', 'shiseido'),
('shiseido americas', 'shiseido'),
('stila style', 'stila styles');

SELECT * FROM company_aliases;
SELECT distinct CompanyName_Clean FROM cosmetics_analysis order by 1;

UPDATE cosmetics_analysis ca
LEFT JOIN company_aliases a
  ON ca.CompanyName_Clean = a.alias
SET ca.CompanyName_Clean = COALESCE(a.standard_name, ca.CompanyName_Clean);