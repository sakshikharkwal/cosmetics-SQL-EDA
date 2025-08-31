-- This data contains a lot of null values, I would like to normalize it into constituent tables
-- We will create a new schema to hold these tables

CREATE SCHEMA cosmetics_clean;

USE cosmetics_clean;

-- companies
CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    company_name_clean VARCHAR(255)
);

-- brands
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL,
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE subcategories (
    subcategory_id INT PRIMARY KEY,
    subcategory_name VARCHAR(255) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


-- products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    cdph_id INT,
    product_name VARCHAR(255),
    csf_id INT,
    csf VARCHAR(255),
    category_id INT,
    subcategory_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

-- chemicals
CREATE TABLE chemicals (
    chemical_id INT PRIMARY KEY,
    chemical_name VARCHAR(255) NOT NULL,
    cas_id INT,
    cas_number VARCHAR(50),
    cas_number_clean VARCHAR(50),
    cas_number_unresolved VARCHAR(50),
    created_at DATE,
    updated_at DATE,
    date_removed DATE
);

-- mapping table
CREATE TABLE product_chemicals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    chemical_id INT,
    initial_date_reported DATE,
    most_recent_date_reported DATE,
    discontinued_date DATE,
    chemical_count INT,
    conflict_flag BOOLEAN,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (chemical_id) REFERENCES chemicals(chemical_id)
);

-- Time to migrate the data

-- companies
INSERT INTO cosmetics_clean.companies (company_id, company_name, company_name_clean)
SELECT DISTINCT
    CompanyId,
    CompanyName,
    CompanyName_Clean
FROM cosmetics.cosmetics_analysis
WHERE CompanyId IS NOT NULL;

SELECT * FROM companies;

-- brands
INSERT INTO cosmetics_clean.brands (brand_name, company_id)
SELECT DISTINCT
    BrandName,
    CompanyId
FROM cosmetics.cosmetics_analysis
WHERE BrandName IS NOT NULL;

SELECT * FROM brands;

-- categories
INSERT INTO cosmetics_clean.categories (category_id, category_name)
SELECT DISTINCT
    PrimaryCategoryId,
    PrimaryCategory
FROM cosmetics.cosmetics_analysis
WHERE PrimaryCategoryId IS NOT NULL;

SELECT * FROM categories;

-- subcategories
INSERT INTO cosmetics_clean.subcategories (subcategory_id, subcategory_name, category_id)
SELECT DISTINCT
    SubCategoryId,
    SubCategory,
    PrimaryCategoryId
FROM cosmetics.cosmetics_analysis
WHERE SubCategoryId IS NOT NULL;

SELECT * FROM subcategories;

-- products
INSERT INTO products
    (cdph_id, product_name, csf_id, csf, category_id, subcategory_id, brand_id)
SELECT
    CDPHId,
    ProductName,
    CSFId,
    CSF,
    PrimaryCategoryId,
    SubCategoryId,
    NULL  -- placeholder for brand_id
FROM cosmetics.cosmetics_analysis
WHERE CDPHId IS NOT NULL;

SELECT * FROM products;

-- chemicals
INSERT INTO chemicals
    (chemical_id, chemical_name, cas_id, cas_number, cas_number_clean, cas_number_unresolved,
     created_at, updated_at, date_removed)
SELECT DISTINCT
    ChemicalId,
    ChemicalName,
    CasId,
    CasNumber,
    CasNumber_Clean,
    CasNumber_Unresolved,
    ChemicalCreatedAt,
    ChemicalUpdatedAt,
    ChemicalDateRemoved
FROM cosmetics.cosmetics_analysis
WHERE ChemicalId IS NOT NULL AND ChemicalId <> 0;

SELECT * FROM chemicals ORDER BY 1 DESC;

-- Mapping-table
INSERT IGNORE INTO product_chemicals
    (product_id, chemical_id, initial_date_reported, most_recent_date_reported,
     discontinued_date, chemical_count, conflict_flag)
SELECT DISTINCT
    CDPHId, ChemicalId,
    InitialDateReported, MostRecentDateReported,
    DiscontinuedDate, ChemicalCount,
    CASE WHEN ConflictFlag = 1 THEN TRUE ELSE FALSE END
FROM cosmetics.cosmetics_analysis
WHERE CDPHId IS NOT NULL AND ChemicalId IS NOT NULL;

-- Update brand_ids in products table
UPDATE products p
JOIN cosmetics.cosmetics_analysis ca ON p.product_id = ca.CDPHId
JOIN brands b 
    ON ca.BrandName = b.brand_name AND ca.CompanyId = b.company_id
SET p.brand_id = b.brand_id;

SELECT * FROM products;