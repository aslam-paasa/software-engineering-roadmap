/**
 * ============================================================================
 * INSERT INTO SELECT - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS INSERT INTO SELECT? ------------- (Copy data from query results)
 * 2. INSERT INTO SELECT - BASIC -------------- (Copy all columns)
 * 3. INSERT INTO SELECT - Specific Columns --- (Copy only needed columns)
 * 4. INSERT INTO SELECT with WHERE ----------- (Filter data before copying)
 * 5. INSERT INTO SELECT with JOIN ------------ (Copy from multiple tables)
 * 6. INSERT INTO SELECT with Aggregates ------ (Copy summarized data)
 * 7. INSERT INTO SELECT with DISTINCT -------- (Copy unique values only)
 * 8. INSERT INTO SELECT with LIMIT ----------- (Copy limited rows)
 * 9. INSERT INTO SELECT with ORDER BY -------- (Copy sorted data)
 * 10. INSERT INTO SELECT with Subquery ------- (Complex data transformation)
 * 11. INSERT INTO SELECT with NOT EXISTS ----- (Avoid duplicates)
 * 12. REAL-WORLD SCENARIOS ------------------- (Practical examples)
 * 13. COMMON MISTAKES ------------------------ (What to avoid)
 * 14. GOLDEN RULES --------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: PRODUCTS - Source product data
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    supplier VARCHAR(50),
    created_date DATE DEFAULT CURRENT_DATE
);

/**
 * TABLE 2: PRODUCTS_BACKUP - Backup destination
 */

CREATE TABLE products_backup (
    backup_id SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    backup_date DATE DEFAULT CURRENT_DATE
);

/**
 * TABLE 3: CATEGORIES - Unique categories
 */

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50),
    description TEXT,
    created_at DATE DEFAULT CURRENT_DATE
);

/**
 * TABLE 4: DISCOUNTED_PRODUCTS - Products with discount
 */

CREATE TABLE discounted_products (
    discount_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    original_price DECIMAL(10,2),
    discounted_price DECIMAL(10,2),
    discount_percent INT
);

/**
 * TABLE 5: SUPPLIER_SUMMARY - Supplier statistics
 */

CREATE TABLE supplier_summary (
    supplier_name VARCHAR(50),
    total_products INT,
    avg_price DECIMAL(10,2),
    total_value DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert products
INSERT INTO products (product_name, category, price, stock_quantity, supplier) VALUES
('Laptop', 'Electronics', 50000, 10, 'TechSupplier'),
('Mouse', 'Electronics', 500, 50, 'TechSupplier'),
('Keyboard', 'Electronics', 1500, 30, 'OfficeMart'),
('Monitor', 'Electronics', 10000, 5, 'TechSupplier'),
('Headphones', 'Accessories', 2000, 20, 'AudioWorld'),
('USB Cable', 'Accessories', 300, 100, 'OfficeMart'),
('Laptop Stand', 'Accessories', 2500, 15, 'OfficeMart'),
('Webcam', 'Electronics', 3500, 8, 'TechSupplier'),
('Desk', 'Furniture', 8000, 5, 'FurnitureInc'),
('Chair', 'Furniture', 5000, 10, 'FurnitureInc'),
('Notebook', 'Stationery', 50, 200, 'OfficeMart'),
('Pen', 'Stationery', 10, 500, 'OfficeMart');

-- ============================================================================
-- PART 1: WHAT IS INSERT INTO SELECT?
-- ============================================================================

/**
 * INSERT INTO SELECT copies data from a SELECT query into a table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              INSERT INTO SELECT - EXPLANATION                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO destination_table (col1, col2, col3)               │   │
 * │   │ SELECT col1, col2, col3                                         │   │
 * │   │ FROM source_table                                               │   │
 * │   │ WHERE condition;                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY USE INSERT INTO SELECT?                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Backup data: Copy important data to backup table            │   │
 * │   │ 2. Data migration: Move data between tables                    │   │
 * │   │ 3. Create summaries: Aggregate data into summary table         │   │
 * │   │ 4. Transform data: Apply calculations while copying            │   │
 * │   │ 5. Archive old data: Copy old records to archive table         │   │
 * │   │ 6. Populate lookup tables: Extract unique values               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              INSERT INTO SELECT - EXAMPLE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE (products table):                                              │
 * │   ┌────────────┬──────────────┬─────────────┬─────────┐                │
 * │   │ product_id │ product_name │ category    │ price   │                │
 *   │   ├────────────┼──────────────┼─────────────┼─────────┤                │
 * │   │ 1          │ Laptop       │ Electronics │ 50000   │                │
 * │   │ 2          │ Mouse        │ Electronics │ 500     │                │
 * │   │ 3          │ Keyboard     │ Electronics │ 1500    │                │
 * │   └────────────┴──────────────┴─────────────┴─────────┘                │
 * │                                                                          │
 * │   BEFORE (products_backup table): Empty                                 │
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO products_backup (product_name, price)               │   │
 * │   │ SELECT product_name, price                                      │   │
 * │   │ FROM products                                                   │   │
 * │   │ WHERE price > 1000;                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER (products_backup table):                                        │
 * │   ┌──────────────┬─────────┐                                          │
 * │   │ product_name │ price   │                                          │
 * │   ├──────────────┼─────────┤                                          │
 * │   │ Laptop       │ 50000   │                                          │
 * │   │ Keyboard     │ 1500    │                                          │
 * │   │ Monitor      │ 10000   │                                          │
 * │   │ Laptop Stand │ 2500    │                                          │
 * │   │ Webcam       │ 3500    │                                          │
 * │   │ Desk         │ 8000    │                                          │
 * │   │ Chair        │ 5000    │                                          │
 * │   └──────────────┴─────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: INSERT INTO SELECT - BASIC (Copy all columns)
-- ============================================================================

-- EXAMPLE 1: Copy all products to backup table
INSERT INTO products_backup (product_id, product_name, category, price, backup_date)
SELECT product_id, product_name, category, price, CURRENT_DATE
FROM products;

SELECT backup_id, product_name, price, backup_date FROM products_backup;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬─────────┬────────────┐
 * │ backup_id│ product_name │ price   │ backup_date│
 * ├──────────┼──────────────┼─────────┼────────────┤
 * │ 1        │ Laptop       │ 50000   │ 2024-01-15 │
 * │ 2        │ Mouse        │ 500     │ 2024-01-15 │
 * │ 3        │ Keyboard     │ 1500    │ 2024-01-15 │
 * │ 4        │ Monitor      │ 10000   │ 2024-01-15 │
 * │ 5        │ Headphones   │ 2000    │ 2024-01-15 │
 * │ 6        │ USB Cable    │ 300     │ 2024-01-15 │
 * │ 7        │ Laptop Stand │ 2500    │ 2024-01-15 │
 * │ 8        │ Webcam       │ 3500    │ 2024-01-15 │
 * │ 9        │ Desk         │ 8000    │ 2024-01-15 │
 * │ 10       │ Chair        │ 5000    │ 2024-01-15 │
 * │ 11       │ Notebook     │ 50      │ 2024-01-15 │
 * │ 12       │ Pen          │ 10      │ 2024-01-15 │
 * └──────────┴──────────────┴─────────┴────────────┘
 */

-- ============================================================================
-- PART 3: INSERT INTO SELECT - Specific Columns (Copy only needed columns)
-- ============================================================================

-- Clear categories table
TRUNCATE categories RESTART IDENTITY;

-- EXAMPLE: Insert unique categories into categories table
INSERT INTO categories (category_name, description)
SELECT DISTINCT category, 'Imported from products'
FROM products
WHERE category IS NOT NULL;

SELECT category_id, category_name, description FROM categories;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┬─────────────────────────┐
 * │ category_id │ category_name │ description             │
 * ├─────────────┼───────────────┼─────────────────────────┤
 * │ 1           │ Electronics   │ Imported from products  │
 * │ 2           │ Accessories   │ Imported from products  │
 * │ 3           │ Furniture     │ Imported from products  │
 * │ 4           │ Stationery    │ Imported from products  │
 * └─────────────┴───────────────┴─────────────────────────┘
 */

-- ============================================================================
-- PART 4: INSERT INTO SELECT with WHERE (Filter data before copying)
-- ============================================================================

-- Clear discounted_products table
TRUNCATE discounted_products RESTART IDENTITY;

-- EXAMPLE: Copy expensive products (price > 5000) to discounted_products
INSERT INTO discounted_products (product_name, original_price, discounted_price, discount_percent)
SELECT 
    product_name,
    price,
    price * 0.90 AS discounted_price,
    10 AS discount_percent
FROM products
WHERE price > 5000;

SELECT product_name, original_price, discounted_price, discount_percent 
FROM discounted_products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬───────────────────┬──────────────────┐
 * │ product_name │ original_price  │ discounted_price  │ discount_percent │
 * ├──────────────┼─────────────────┼───────────────────┼──────────────────┤
 * │ Laptop       │ 50000.00        │ 45000.00          │ 10               │
 * │ Monitor      │ 10000.00        │ 9000.00           │ 10               │
 * │ Desk         │ 8000.00         │ 7200.00           │ 10               │
 * │ Chair        │ 5000.00         │ 4500.00           │ 10               │
 * └──────────────┴─────────────────┴───────────────────┴──────────────────┘
 */

-- ============================================================================
-- PART 5: INSERT INTO SELECT with JOIN (Copy from multiple tables)
-- ============================================================================

-- Create a sales table for this example
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    sale_date DATE,
    quantity INT
);

INSERT INTO sales (product_name, sale_date, quantity) VALUES
('Laptop', '2024-01-15', 2),
('Mouse', '2024-01-16', 5),
('Keyboard', '2024-01-17', 3),
('Laptop', '2024-01-18', 1);

-- Create a product_sales_summary table
CREATE TABLE product_sales_summary (
    product_name VARCHAR(100),
    total_quantity INT,
    total_revenue DECIMAL(10,2)
);

-- EXAMPLE: Join products and sales to create summary
INSERT INTO product_sales_summary (product_name, total_quantity, total_revenue)
SELECT 
    p.product_name,
    SUM(s.quantity) AS total_quantity,
    SUM(s.quantity * p.price) AS total_revenue
FROM products p
JOIN sales s ON p.product_name = s.product_name
GROUP BY p.product_name;

SELECT * FROM product_sales_summary;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬───────────────┐
 * │ product_name │ total_quantity  │ total_revenue │
 * ├──────────────┼─────────────────┼───────────────┤
 * │ Laptop       │ 3               │ 150000.00     │
 * │ Mouse        │ 5               │ 2500.00       │
 * │ Keyboard     │ 3               │ 4500.00       │
 * └──────────────┴─────────────────┴───────────────┘
 */

-- ============================================================================
-- PART 6: INSERT INTO SELECT with Aggregates (Copy summarized data)
-- ============================================================================

-- Clear supplier_summary table
TRUNCATE supplier_summary;

-- EXAMPLE: Create supplier summary with aggregates
INSERT INTO supplier_summary (supplier_name, total_products, avg_price, total_value)
SELECT 
    supplier,
    COUNT(*) AS total_products,
    AVG(price) AS avg_price,
    SUM(price * stock_quantity) AS total_value
FROM products
GROUP BY supplier;

SELECT * FROM supplier_summary ORDER BY total_value DESC;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────────┬─────────────┬─────────────┐
 * │ supplier_name │ total_products  │ avg_price   │ total_value │
 * ├───────────────┼─────────────────┼─────────────┼─────────────┤
 * │ TechSupplier  │ 4               │ 16000.00    │ 500000      │
 * │ OfficeMart    │ 4               │ 965.00      │ 15000       │
 * │ FurnitureInc  │ 2               │ 6500.00     │ 90000       │
 * │ AudioWorld    │ 1               │ 2000.00     │ 40000       │
 * └───────────────┴─────────────────┴─────────────┴─────────────┘
 */

-- ============================================================================
-- PART 7: INSERT INTO SELECT with DISTINCT (Copy unique values only)
-- ============================================================================

-- Clear categories table
TRUNCATE categories RESTART IDENTITY;

-- EXAMPLE: Insert distinct categories (already did above)
INSERT INTO categories (category_name, description)
SELECT DISTINCT category, 'Product category'
FROM products
WHERE category IS NOT NULL;

SELECT * FROM categories;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┬─────────────────┐
 * │ category_id │ category_name │ description     │
 * ├─────────────┼───────────────┼─────────────────┤
 * │ 1           │ Electronics   │ Product category│
 * │ 2           │ Accessories   │ Product category│
 * │ 3           │ Furniture     │ Product category│
 * │ 4           │ Stationery    │ Product category│
 * └─────────────┴───────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 8: INSERT INTO SELECT with LIMIT (Copy limited rows)
-- ============================================================================

-- Create top_products table
CREATE TABLE top_products (
    rank INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- EXAMPLE: Copy top 5 most expensive products
INSERT INTO top_products (rank, product_name, price)
SELECT 
    ROW_NUMBER() OVER (ORDER BY price DESC),
    product_name,
    price
FROM products
LIMIT 5;

SELECT * FROM top_products ORDER BY rank;

/**
 * OUTPUT:
 * ┌──────┬──────────────┬─────────┐
 * │ rank │ product_name │ price   │
 * ├──────┼──────────────┼─────────┤
 * │ 1    │ Laptop       │ 50000   │
 * │ 2    │ Monitor      │ 10000   │
 * │ 3    │ Desk         │ 8000    │
 * │ 4    │ Chair        │ 5000    │
 * │ 5    │ Webcam       │ 3500    │
 * └──────┴──────────────┴─────────┘
 */

-- ============================================================================
-- PART 9: INSERT INTO SELECT with ORDER BY (Copy sorted data)
-- ============================================================================

-- Create sorted_products table
CREATE TABLE sorted_products (
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- EXAMPLE: Copy products sorted by price
INSERT INTO sorted_products (product_name, price)
SELECT product_name, price
FROM products
ORDER BY price DESC;

SELECT * FROM sorted_products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * │ Monitor      │ 10000   │
 * │ Desk         │ 8000    │
 * │ Chair        │ 5000    │
 * │ Webcam       │ 3500    │
 * │ Laptop Stand │ 2500    │
 * │ Headphones   │ 2000    │
 * │ Keyboard     │ 1500    │
 * │ Mouse        │ 500     │
 * │ USB Cable    │ 300     │
 * │ Notebook     │ 50      │
 * │ Pen          │ 10      │
 * └──────────────┴─────────┘
 */

-- ============================================================================
-- PART 10: INSERT INTO SELECT with Subquery (Complex data transformation)
-- ============================================================================

-- Create category_stats table
CREATE TABLE category_stats (
    category_name VARCHAR(50),
    product_count INT,
    avg_price DECIMAL(10,2),
    above_avg_count INT
);

-- EXAMPLE: Insert category statistics including count of products above category average
INSERT INTO category_stats (category_name, product_count, avg_price, above_avg_count)
SELECT 
    category,
    COUNT(*) AS product_count,
    AVG(price) AS avg_price,
    (
        SELECT COUNT(*)
        FROM products p2
        WHERE p2.category = p1.category
          AND p2.price > (SELECT AVG(price) FROM products p3 WHERE p3.category = p1.category)
    ) AS above_avg_count
FROM products p1
GROUP BY category;

SELECT * FROM category_stats;

/**
 * OUTPUT:
 * ┌───────────────┬───────────────┬─────────────┬─────────────────┐
 * │ category_name │ product_count │ avg_price   │ above_avg_count │
 * ├───────────────┼───────────────┼─────────────┼─────────────────┤
 * │ Accessories   │ 3             │ 1600.00     │ 1               │
 * │ Electronics   │ 4             │ 16000.00    │ 2               │
 * │ Furniture     │ 2             │ 6500.00     │ 1               │
 * │ Stationery    │ 2             │ 30.00       │ 0               │
 * └───────────────┴───────────────┴─────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 11: INSERT INTO SELECT with NOT EXISTS (Avoid duplicates)
-- ============================================================================

-- Create archived_products table
CREATE TABLE archived_products (
    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    archived_date DATE DEFAULT CURRENT_DATE
);

-- Insert some products into archive
INSERT INTO archived_products (product_id, product_name, price) VALUES
(9, 'Desk', 8000),
(10, 'Chair', 5000);

-- EXAMPLE: Insert only products not already archived (avoid duplicates)
INSERT INTO archived_products (product_id, product_name, price)
SELECT product_id, product_name, price
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM archived_products a 
    WHERE a.product_id = p.product_id
);

SELECT * FROM archived_products ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┬────────────┐
 * │ product_id │ product_name │ price   │ archived_date│
 * ├────────────┼──────────────┼─────────┼────────────┤
 * │ 1          │ Laptop       │ 50000   │ 2024-01-15  │
 * │ 2          │ Mouse        │ 500     │ 2024-01-15  │
 * │ 3          │ Keyboard     │ 1500    │ 2024-01-15  │
 * │ 4          │ Monitor      │ 10000   │ 2024-01-15  │
 * │ 5          │ Headphones   │ 2000    │ 2024-01-15  │
 * │ 6          │ USB Cable    │ 300     │ 2024-01-15  │
 * │ 7          │ Laptop Stand │ 2500    │ 2024-01-15  │
 * │ 8          │ Webcam       │ 3500    │ 2024-01-15  │
 * │ 9          │ Desk         │ 8000    │ 2024-01-15  │
 * │ 10         │ Chair        │ 5000    │ 2024-01-15  │
 * │ 11         │ Notebook     │ 50      │ 2024-01-15  │
 * │ 12         │ Pen          │ 10      │ 2024-01-15  │
 * └────────────┴──────────────┴─────────┴────────────┘
 */

-- ============================================================================
-- PART 12: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Create Category Summary
 * 
 * Insert category-wise product summary into a reporting table
 */

-- Create category_report table
CREATE TABLE category_report (
    category_name VARCHAR(50),
    total_products INT,
    min_price DECIMAL(10,2),
    max_price DECIMAL(10,2),
    avg_price DECIMAL(10,2),
    total_inventory_value DECIMAL(10,2)
);

-- Insert summary data
INSERT INTO category_report (category_name, total_products, min_price, max_price, avg_price, total_inventory_value)
SELECT 
    category,
    COUNT(*) AS total_products,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    SUM(price * stock_quantity) AS total_inventory_value
FROM products
GROUP BY category;

SELECT * FROM category_report ORDER BY total_inventory_value DESC;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────────┬───────────┬───────────┬─────────────┬────────────────────────┐
 * │ category_name │ total_products  │ min_price │ max_price │ avg_price   │ total_inventory_value   │
 * ├───────────────┼─────────────────┼───────────┼───────────┼─────────────┼────────────────────────┤
 * │ Electronics   │ 4               │ 500       │ 50000     │ 16000.00    │ 500000                 │
 * │ Furniture     │ 2               │ 5000      │ 8000      │ 6500.00     │ 90000                  │
 * │ Accessories   │ 3               │ 300       │ 2500      │ 1600.00     │ 40000                  │
 * │ Stationery    │ 2               │ 10        │ 50        │ 30.00       │ 15000                  │
 * └───────────────┴─────────────────┴───────────┴───────────┴─────────────┴────────────────────────┘
 */

/**
 * SCENARIO 2: Monthly Sales Summary
 * 
 * Aggregate sales data by month for reporting
 */

-- Create monthly_sales table
CREATE TABLE monthly_sales (
    year INT,
    month INT,
    month_name VARCHAR(20),
    total_sales DECIMAL(10,2),
    total_orders INT
);

-- Create some sales data
CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO sales_data (sale_date, amount) VALUES
('2024-01-15', 50000),
('2024-01-20', 1500),
('2024-01-25', 2000),
('2024-02-01', 10000),
('2024-02-05', 3500),
('2024-02-10', 8000),
('2024-03-01', 1200),
('2024-03-15', 2500);

-- Insert monthly summary
INSERT INTO monthly_sales (year, month, month_name, total_sales, total_orders)
SELECT 
    EXTRACT(YEAR FROM sale_date)::INT AS year,
    EXTRACT(MONTH FROM sale_date)::INT AS month,
    TO_CHAR(sale_date, 'Month') AS month_name,
    SUM(amount) AS total_sales,
    COUNT(*) AS total_orders
FROM sales_data
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date), TO_CHAR(sale_date, 'Month')
ORDER BY year, month;

SELECT * FROM monthly_sales;

/**
 * OUTPUT:
 * ┌──────┬───────┬────────────┬─────────────┬─────────────┐
 * │ year │ month │ month_name │ total_sales │ total_orders│
 * ├──────┼───────┼────────────┼─────────────┼─────────────┤
 * │ 2024 │ 1     │ January    │ 53500.00    │ 3           │
 * │ 2024 │ 2     │ February   │ 21500.00    │ 3           │
 * │ 2024 │ 3     │ March      │ 3700.00     │ 2           │
 * └──────┴───────┴────────────┴─────────────┴─────────────┘
 */

/**
 * SCENARIO 3: Archive Old Products
 * 
 * Move products older than 1 year to archive table
 */

-- Create old_products_archive table
CREATE TABLE old_products_archive (
    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    archived_date DATE DEFAULT CURRENT_DATE
);

-- Add created_date to products for this example
ALTER TABLE products ADD COLUMN IF NOT EXISTS created_date DATE DEFAULT CURRENT_DATE;
UPDATE products SET created_date = '2022-01-01' WHERE product_id IN (1, 2, 3);
UPDATE products SET created_date = '2023-01-01' WHERE product_id IN (4, 5, 6);
UPDATE products SET created_date = '2024-01-01' WHERE product_id IN (7, 8, 9, 10, 11, 12);

-- Archive products older than 1 year
INSERT INTO old_products_archive (product_id, product_name, price)
SELECT product_id, product_name, price
FROM products
WHERE created_date < CURRENT_DATE - INTERVAL '1 year';

SELECT * FROM old_products_archive;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┬────────────┐
 * │ product_id │ product_name │ price   │ archived_date│
 * ├────────────┼──────────────┼─────────┼────────────┤
 * │ 1          │ Laptop       │ 50000   │ 2024-01-15  │
 * │ 2          │ Mouse        │ 500     │ 2024-01-15  │
 * │ 3          │ Keyboard     │ 1500    │ 2024-01-15  │
 * └────────────┴──────────────┴─────────┴────────────┘
 */

/**
 * SCENARIO 4: Create Price Tier Table
 * 
 * Categorize products into price tiers
 */

-- Create price_tiers table
CREATE TABLE price_tiers (
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    price_tier VARCHAR(20)
);

-- Insert products with price tiers
INSERT INTO price_tiers (product_name, price, price_tier)
SELECT 
    product_name,
    price,
    CASE 
        WHEN price >= 50000 THEN 'Premium'
        WHEN price >= 10000 THEN 'High'
        WHEN price >= 1000 THEN 'Medium'
        WHEN price >= 100 THEN 'Low'
        ELSE 'Budget'
    END AS price_tier
FROM products;

SELECT price_tier, COUNT(*) FROM price_tiers GROUP BY price_tier;

/**
 * OUTPUT:
 * ┌────────────┬───────┐
 * │ price_tier │ count │
 * ├────────────┼───────┤
 * │ Premium    │ 1     │
 * │ High       │ 2     │
 * │ Medium     │ 5     │
 * │ Low        │ 2     │
 * │ Budget     │ 2     │
 * └────────────┴───────┘
 */

/**
 * SCENARIO 5: Insert New Categories from Products
 * 
 * Extract unique categories from products and insert into categories table
 * (This is the answer to the question asked)
 */

-- Clear categories table
TRUNCATE categories RESTART IDENTITY;

-- Insert unique categories with description
INSERT INTO categories (category_name, description)
SELECT DISTINCT 
    category AS "New Category",
    'Imported from products' AS description
FROM products
WHERE category IS NOT NULL
  AND category NOT IN (SELECT category_name FROM categories);

SELECT * FROM categories;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┬─────────────────────────┐
 * │ category_id │ category_name │ description             │
 * ├─────────────┼───────────────┼─────────────────────────┤
 * │ 1           │ Electronics   │ Imported from products  │
 * │ 2           │ Accessories   │ Imported from products  │
 * │ 3           │ Furniture     │ Imported from products  │
 * │ 4           │ Stationery    │ Imported from products  │
 * └─────────────┴───────────────┴─────────────────────────┘
 */

-- ============================================================================
-- PART 13: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Column count mismatch                                      │
 * │                                                                          │
 * │   ❌ INSERT INTO categories (category_name) SELECT category, price     │
 * │      → 1 column in INSERT, 2 columns in SELECT!                        │
 * │                                                                          │
 * │   ✅ INSERT INTO categories (category_name, description)               │
 * │      SELECT category, 'Imported' FROM products;                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong - column count mismatch
-- INSERT INTO categories (category_name) SELECT category, price FROM products;

-- ✅ Correct
INSERT INTO categories (category_name, description) 
SELECT category, 'Imported' FROM products;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Data type mismatch                                         │
 * │                                                                          │
 * │   ❌ INSERT INTO categories (category_id, category_name)               │
 * │      SELECT category_name, category_id FROM products;                  │
 * │      → category_id expects INT, but getting VARCHAR                    │
 * │                                                                          │
 * │   ✅ Match data types correctly                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting to handle NULLs                                 │
 * │                                                                          │
 *   │   ❌ INSERT INTO categories (category_name)                           │
 * │      SELECT category FROM products;                                    │
 * │      → If category has NULL, it will insert NULL                       │
 * │                                                                          │
 * │   ✅ Filter out NULLs:                                                  │
 * │      SELECT category FROM products WHERE category IS NOT NULL;         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Not handling duplicate key violations                      │
 * │                                                                          │
 * │   ❌ INSERT INTO categories (category_name)                            │
 * │      SELECT category FROM products;                                    │
 * │      → If category already exists, error!                              │
 * │                                                                          │
 * │   ✅ Use NOT EXISTS to avoid duplicates:                                │
 * │      WHERE NOT EXISTS (SELECT 1 FROM categories c WHERE c.category_name = p.category)│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 14: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Number of columns in INSERT must match SELECT                  │
 * │         → Same number of columns in both                               │
 * │                                                                          │
 * │ RULE 2: Data types must be compatible                                  │
 * │         → Column types should match or be convertible                  │
 * │                                                                          │
 * │ RULE 3: Use WHERE to filter data before copying                        │
 * │         → Copy only what you need                                      │
 * │                                                                          │
 * │ RULE 4: Use DISTINCT to avoid duplicates when inserting unique values  │
 * │         → SELECT DISTINCT column FROM source                           │
 * │                                                                          │
 * │ RULE 5: Use NOT EXISTS to avoid inserting existing records             │
 * │         → WHERE NOT EXISTS (SELECT 1 FROM dest WHERE ...)              │
 * │                                                                          │
 * │ RULE 6: Use ORDER BY with LIMIT for top-N queries                      │
 * │         → ORDER BY column DESC LIMIT 10                                │
 * │                                                                          │
 * │ RULE 7: Handle NULLs appropriately                                     │
 * │         → Use WHERE column IS NOT NULL                                 │
 * │         → Or use COALESCE for default values                           │
 * │                                                                          │
 * │ RULE 8: Test SELECT before INSERT                                      │
 * │         → Run SELECT alone to verify data                              │
 * │         → Then add INSERT INTO                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ -- Basic INSERT INTO SELECT                                            │
 * │ INSERT INTO dest (col1, col2)                                          │
 * │ SELECT col1, col2 FROM source;                                         │
 * │                                                                          │
 * │ -- INSERT with WHERE                                                   │
 * │ INSERT INTO dest (col1, col2)                                          │
 * │ SELECT col1, col2 FROM source WHERE condition;                         │
 * │                                                                          │
 * │ -- INSERT with DISTINCT                                                │
 * │ INSERT INTO dest (col1)                                                │
 * │ SELECT DISTINCT col1 FROM source WHERE col1 IS NOT NULL;               │
 * │                                                                          │
 * │ -- INSERT with JOIN                                                    │
 * │ INSERT INTO dest (col1, col2)                                          │
 * │ SELECT t1.col1, t2.col2 FROM table1 t1 JOIN table2 t2 ON t1.id = t2.id;│
 * │                                                                          │
 * │ -- INSERT with Aggregate                                               │
 * │ INSERT INTO dest (group_col, total)                                    │
 * │ SELECT group_col, SUM(value) FROM source GROUP BY group_col;           │
 * │                                                                          │
 * │ -- INSERT with NOT EXISTS (avoid duplicates)                           │
 * │ INSERT INTO dest (col1)                                                │
 * │ SELECT col1 FROM source s                                              │
 * │ WHERE NOT EXISTS (SELECT 1 FROM dest d WHERE d.col1 = s.col1);         │
 * │                                                                          │
 * │ -- INSERT with LIMIT                                                   │
 * │ INSERT INTO dest (col1, col2)                                          │
 * │ SELECT col1, col2 FROM source ORDER BY col2 DESC LIMIT 10;             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Copy all electronics products to a new table
 * 
 * Answer:
 *   CREATE TABLE electronics_products AS 
 *   SELECT * FROM products WHERE category = 'Electronics';
 */

/**
 * EXERCISE 2: Insert distinct suppliers into a suppliers table
 * 
 * Answer:
 *   INSERT INTO suppliers (supplier_name) 
 *   SELECT DISTINCT supplier FROM products WHERE supplier IS NOT NULL;
 */

/**
 * EXERCISE 3: Create a summary of total stock value by category
 * 
 * Answer:
 *   INSERT INTO category_value (category, total_value)
 *   SELECT category, SUM(price * stock_quantity) 
 *   FROM products GROUP BY category;
 */

/**
 * EXERCISE 4: Copy products with price > 2000 to premium_products
 * 
 * Answer:
 *   INSERT INTO premium_products (product_name, price)
 *   SELECT product_name, price FROM products WHERE price > 2000;
 */

/**
 * EXERCISE 5: Insert product categories that don't already exist in categories table
 * 
 * Answer:
 *   INSERT INTO categories (category_name)
 *   SELECT DISTINCT category FROM products p
 *   WHERE NOT EXISTS (SELECT 1 FROM categories c WHERE c.category_name = p.category);
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS price_tiers;
DROP TABLE IF EXISTS old_products_archive;
DROP TABLE IF EXISTS monthly_sales;
DROP TABLE IF EXISTS sales_data;
DROP TABLE IF EXISTS category_report;
DROP TABLE IF EXISTS archived_products;
DROP TABLE IF EXISTS category_stats;
DROP TABLE IF EXISTS sorted_products;
DROP TABLE IF EXISTS top_products;
DROP TABLE IF EXISTS product_sales_summary;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS supplier_summary;
DROP TABLE IF EXISTS discounted_products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products_backup;
DROP TABLE IF EXISTS products;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. INSERT INTO SELECT copies data from a SELECT query into a table     │
 * │                                                                          │
 * │ 2. Syntax:                                                              │
 * │    INSERT INTO dest (col1, col2)                                       │
 * │    SELECT col1, col2 FROM source WHERE condition;                      │
 * │                                                                          │
 * │ 3. Use cases:                                                           │
 * │    → Backup data (copy to backup table)                                │
 * │    → Data migration (move between tables)                              │
 * │    → Create summaries (aggregate data)                                 │
 * │    → Populate lookup tables (extract unique values)                    │
 * │    → Archive old data (copy to archive)                                │
 * │                                                                          │
 * │ 4. Can combine with:                                                    │
 * │    → WHERE (filter)                                                    │
 * │    → JOIN (multiple tables)                                            │
 * │    → Aggregates (SUM, AVG, COUNT)                                      │
 * │    → DISTINCT (unique values)                                          │
 * │    → LIMIT (top N)                                                     │
 * │    → ORDER BY (sorting)                                                │
 * │    → NOT EXISTS (avoid duplicates)                                     │
 * │                                                                          │
 * │ 5. Best practices:                                                      │
 * │    → Match column count and data types                                 │
 * │    → Filter out NULLs                                                  │
 * │    → Test SELECT before INSERT                                         │
 * │    → Use NOT EXISTS to avoid duplicates                                │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Column count must match                                            │
 * │   - Data types must be compatible                                      │
 * │   - Test SELECT first                                                 │
 * │   - Handle NULLs appropriately                                         │
 * │   - Use DISTINCT for unique values                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF INSERT INTO SELECT GUIDE
-- ============================================================================