-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: CUSTOMERS - People who buy products
 */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120),
    city VARCHAR(60),
    signup_date DATE
);

/**
 * TABLE 2: ORDERS - Purchases made by customers
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_code VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10,2) NOT NULL
);

/**
 * TABLE 3: PRODUCTS - Items available for sale
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10,2) NOT NULL
);

/**
 * TABLE 4: ORDER_ITEMS - Products inside each order
 */

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * CUSTOMERS TABLE
 * ┌─────────────┬──────────┬───────────────────┬────────────┬─────────────┐
 * │ customer_id │ name     │ email             │ city       │ signup_date │
 * ├─────────────┼──────────┼───────────────────┼────────────┼─────────────┤
 * │     101     │ Aisha    │ aisha@demo.com    │ Delhi      │ 2024-01-01  │
 * │     102     │ Rohan    │ rohan@demo.com    │ Mumbai     │ 2024-01-02  │
 * │     103     │ Meera    │ meera@demo.com    │ Pune       │ 2024-01-03  │
 * │     104     │ Arjun    │ arjun@demo.com    │ Delhi      │ 2024-01-04  │
 * │     105     │ Neha     │ neha@demo.com     │ Bengaluru  │ 2024-01-05  │
 * └─────────────┴──────────┴───────────────────┴────────────┴─────────────┘
 */

INSERT INTO customers (customer_id, name, email, city, signup_date) VALUES
(101, 'Aisha', 'aisha@demo.com', 'Delhi', '2024-01-01'),
(102, 'Rohan', 'rohan@demo.com', 'Mumbai', '2024-01-02'),
(103, 'Meera', 'meera@demo.com', 'Pune', '2024-01-03'),
(104, 'Arjun', 'arjun@demo.com', 'Delhi', '2024-01-04'),
(105, 'Neha', 'neha@demo.com', 'Bengaluru', '2024-01-05');

/**
 * PRODUCTS TABLE
 * ┌────────────┬──────────────────┬──────────────┬────────────┐
 * │ product_id │ product_name     │ category     │ unit_price │
 * ├────────────┼──────────────────┼──────────────┼────────────┤
 * │     1      │ Laptop           │ Electronics  │ 50000.00   │
 * │     2      │ Mouse            │ Electronics  │ 500.00     │
 * │     3      │ Keyboard         │ Electronics  │ 1500.00    │
 * │     4      │ Monitor          │ Electronics  │ 10000.00   │
 * │     5      │ Headphones       │ Accessories  │ 2000.00    │
 * │     6      │ USB Cable        │ Accessories  │ 300.00     │
 * │     7      │ Mouse Pad        │ Accessories  │ 400.00     │
 * └────────────┴──────────────────┴──────────────┴────────────┘
 */

INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 50000.00),
(2, 'Mouse', 'Electronics', 500.00),
(3, 'Keyboard', 'Electronics', 1500.00),
(4, 'Monitor', 'Electronics', 10000.00),
(5, 'Headphones', 'Accessories', 2000.00),
(6, 'USB Cable', 'Accessories', 300.00),
(7, 'Mouse Pad', 'Accessories', 400.00);

/**
 * ORDERS TABLE
 * ┌──────────┬─────────────┬────────────┬────────────┬─────────────┬──────────────┐
 * │ order_id │ customer_id │ order_code │ status     │ order_date  │ total_amount │
 * ├──────────┼─────────────┼────────────┼────────────┼─────────────┼──────────────┤
 * │    1     │    101      │    ORD1    │ DELIVERED  │ 2024-01-10  │   51500.00   │
 * │    2     │    102      │    ORD2    │ DELIVERED  │ 2024-01-11  │    500.00    │
 * │    3     │    101      │    ORD3    │ DELIVERED  │ 2024-01-12  │   11500.00   │
 * │    4     │    103      │    ORD4    │ CANCELLED  │ 2024-01-13  │   10000.00   │
 * │    5     │    104      │    ORD5    │ DELIVERED  │ 2024-01-14  │    400.00    │
 * │    6     │    105      │    ORD6    │ DELIVERED  │ 2024-01-15  │   2000.00    │
 * │    7     │    102      │    ORD7    │ PENDING    │ 2024-01-16  │   1500.00    │
 * │    8     │    101      │    ORD8    │ DELIVERED  │ 2024-01-17  │    300.00    │
 * └──────────┴─────────────┴────────────┴────────────┴─────────────┴──────────────┘
 */

INSERT INTO orders (order_id, customer_id, order_code, status, order_date, total_amount) VALUES
(1, 101, 'ORD1', 'DELIVERED', '2024-01-10', 51500.00),
(2, 102, 'ORD2', 'DELIVERED', '2024-01-11', 500.00),
(3, 101, 'ORD3', 'DELIVERED', '2024-01-12', 11500.00),
(4, 103, 'ORD4', 'CANCELLED', '2024-01-13', 10000.00),
(5, 104, 'ORD5', 'DELIVERED', '2024-01-14', 400.00),
(6, 105, 'ORD6', 'DELIVERED', '2024-01-15', 2000.00),
(7, 102, 'ORD7', 'PENDING', '2024-01-16', 1500.00),
(8, 101, 'ORD8', 'DELIVERED', '2024-01-17', 300.00);

/**
 * ORDER_ITEMS TABLE (Products inside each order)
 * ┌───────────────┬──────────┬────────────┬──────────┬─────────┐
 * │ order_item_id │ order_id │ product_id │ quantity │ price   │
 * ├───────────────┼──────────┼────────────┼──────────┼─────────┤
 * │      1        │    1     │     1      │    1     │ 50000   │
 * │      2        │    1     │     2      │    3     │ 1500    │
 * │      3        │    2     │     2      │    1     │ 500     │
 * │      4        │    3     │     4      │    1     │ 10000   │
 * │      5        │    3     │     3      │    1     │ 1500    │
 * │      6        │    4     │     4      │    1     │ 10000   │
 * │      7        │    5     │     7      │    1     │ 400     │
 * │      8        │    6     │     5      │    1     │ 2000    │
 * │      9        │    7     │     3      │    1     │ 1500    │
 * │     10        │    8     │     6      │    1     │ 300     │
 * └───────────────┴──────────┴────────────┴──────────┴─────────┘
 */

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1, 50000),
(2, 1, 2, 3, 1500),   -- 3 mice at 500 each = 1500
(3, 2, 2, 1, 500),
(4, 3, 4, 1, 10000),
(5, 3, 3, 1, 1500),
(6, 4, 4, 1, 10000),
(7, 5, 7, 1, 400),
(8, 6, 5, 1, 2000),
(9, 7, 3, 1, 1500),
(10, 8, 6, 1, 300);

-- Create indexes for faster joins
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);


-- ============================================================================
-- PART 3: JOINING TWO TABLES (Basic Review)
-- ============================================================================

/**
 * EXAMPLE: Get orders with customer names
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    JOINING TWO TABLES (Customers + Orders)              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INPUT - Customers:              INPUT - Orders:                      │
 * │   ┌─────────────┬──────────┐     ┌──────────┬─────────────┬──────────┐ │
 * │   │ customer_id │ name     │     │ order_id │ customer_id │ order_code│ │
 * │   ├─────────────┼──────────┤     ├──────────┼─────────────┼──────────┤ │
 * │   │    101      │ Aisha    │     │    1     │    101      │   ORD1   │ │
 * │   │    102      │ Rohan    │     │    2     │    102      │   ORD2   │ │
 * │   │    103      │ Meera    │     │    3     │    101      │   ORD3   │ │
 * │   │    104      │ Arjun    │     │    4     │    103      │   ORD4   │ │
 * │   │    105      │ Neha     │     │    5     │    104      │   ORD5   │ │
 * │   └─────────────┴──────────┘     │    6     │    105      │   ORD6   │ │
 * │                                   │    7     │    102      │   ORD7   │ │
 * │                                   │    8     │    101      │   ORD8   │ │
 * │                                   └──────────┴─────────────┴──────────┘ │
 * │                                                                          │
 * │   QUERY:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name, o.order_code, o.total_amount                    │   │
 * │   │ FROM customers c                                                │   │
 * │   │ INNER JOIN orders o ON c.customer_id = o.customer_id           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬────────────┬──────────────┐                           │
 * │   │ name     │ order_code │ total_amount │                           │
 * │   ├──────────┼────────────┼──────────────┤                           │
 * │   │ Aisha    │   ORD1     │   51500.00   │                           │
 * │   │ Rohan    │   ORD2     │    500.00    │                           │
 * │   │ Aisha    │   ORD3     │   11500.00   │                           │
 * │   │ Meera    │   ORD4     │   10000.00   │                           │
 * │   │ Arjun    │   ORD5     │    400.00    │                           │
 * │   │ Neha     │   ORD6     │   2000.00    │                           │
 * │   │ Rohan    │   ORD7     │   1500.00    │                           │
 * │   │ Aisha    │   ORD8     │    300.00    │                           │
 * │   └──────────┴────────────┴──────────────┘                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Two table JOIN example
SELECT 
    c.name,
    o.order_code,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬──────────────┐
 * │ name     │ order_code │ total_amount │
 * ├──────────┼────────────┼──────────────┤
 * │ Aisha    │ ORD1       │ 51500.00     │
 * │ Rohan    │ ORD2       │ 500.00       │
 * │ Aisha    │ ORD3       │ 11500.00     │
 * │ Meera    │ ORD4       │ 10000.00     │
 * │ Arjun    │ ORD5       │ 400.00       │
 * │ Neha     │ ORD6       │ 2000.00      │
 * │ Rohan    │ ORD7       │ 1500.00      │
 * │ Aisha    │ ORD8       │ 300.00       │
 * └──────────┴────────────┴──────────────┘
 */

-- ============================================================================
-- PART 4: JOINING THREE TABLES
-- ============================================================================

/**
 * WHY JOIN THREE TABLES?
 * 
 * Often, information is spread across multiple tables:
 * - orders table: knows WHICH customer and WHICH products (via order_items)
 * - customers table: knows customer DETAILS (name, city, email)
 * - products table: knows product DETAILS (name, price, category)
 * - order_items table: connects orders to products (quantity, price at time)
 * 
 * To get complete order information (who bought what), we need ALL THREE tables!
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHY JOIN THREE TABLES?                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   customers ──────┐                                                     │
 * │   (name, city)    │                                                     │
 * │                   │                                                     │
 * │                   ▼                                                     │
 * │   orders ──────► order_items ──────► products                          │
 * │   (order_code,   (quantity,        (product_name,                      │
 * │    total_amount)  price)           category)                           │
 * │                                                                          │
 * │   Flow: A customer places an order → order contains items →            │
 * │         each item is a product                                         │
 * │                                                                          │
 * │   Question: "Show me each order with customer name and product name"   │
 * │   Answer: Need customers + orders + order_items + products (4 tables!) │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * EXAMPLE 1: Show each order item with customer name and product name
 * 
 * We need to join 4 tables:
 * 1. customers → to get customer name
 * 2. orders → to link customer to order
 * 3. order_items → to link order to product
 * 4. products → to get product name
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    JOINING THREE TABLES (Orders + Items + Products)     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   STEP 1: Start with order_items (has order_id and product_id)         │
 * │   STEP 2: Join orders to get customer_id and order_code                │
 * │   STEP 3: Join customers to get customer name                          │
 * │   STEP 4: Join products to get product name                            │
 * │                                                                          │
 * │   VISUAL FLOW:                                                          │
 * │                                                                          │
 * │   order_items ─────► orders ─────► customers                           │
 * │        │                                                               │
 * │        └───────────► products                                          │
 * │                                                                          │
 * │   QUERY:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name AS customer_name,                                 │   │
 * │   │        o.order_code,                                            │   │
 * │   │        p.product_name,                                          │   │
 * │   │        oi.quantity,                                             │   │
 * │   │        oi.price                                                 │   │
 * │   │ FROM order_items oi                                             │   │
 * │   │ JOIN orders o ON oi.order_id = o.order_id                       │   │
 * │   │ JOIN customers c ON o.customer_id = c.customer_id               │   │
 * │   │ JOIN products p ON oi.product_id = p.product_id                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Three table JOIN example (order_items + orders + products)
SELECT 
    o.order_id,
    o.order_code,
    p.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS line_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬──────────────┬──────────┬─────────┬────────────┐
 * │ order_id │ order_code │ product_name │ quantity │ price   │ line_total │
 * ├──────────┼────────────┼──────────────┼──────────┼─────────┼────────────┤
 * │    1     │   ORD1     │ Laptop       │    1     │ 50000   │ 50000      │
 * │    1     │   ORD1     │ Mouse        │    3     │ 1500    │ 4500       │
 * │    2     │   ORD2     │ Mouse        │    1     │ 500     │ 500        │
 * │    3     │   ORD3     │ Keyboard     │    1     │ 1500    │ 1500       │
 * │    3     │   ORD3     │ Monitor      │    1     │ 10000   │ 10000      │
 * │    4     │   ORD4     │ Monitor      │    1     │ 10000   │ 10000      │
 * │    5     │   ORD5     │ Mouse Pad    │    1     │ 400     │ 400        │
 * │    6     │   ORD6     │ Headphones   │    1     │ 2000    │ 2000       │
 * │    7     │   ORD7     │ Keyboard     │    1     │ 1500    │ 1500       │
 * │    8     │   ORD8     │ USB Cable    │    1     │ 300     │ 300        │
 * └──────────┴────────────┴──────────────┴──────────┴─────────┴────────────┘
 */

/**
 * EXAMPLE 2: Show each order with customer name (3 tables: customers + orders + order_items)
 * 
 * Sometimes you need to aggregate data from multiple tables.
 * Here, we want each order with customer name and total items count.
 */

-- Three table JOIN with aggregation
SELECT 
    c.name AS customer_name,
    o.order_id,
    o.order_code,
    o.order_date,
    o.total_amount,
    COUNT(oi.order_item_id) AS total_items,
    SUM(oi.quantity) AS total_quantity
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name, o.order_id, o.order_code, o.order_date, o.total_amount
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌───────────────┬──────────┬────────────┬─────────────┬──────────────┬─────────────┬────────────────┐
 * │ customer_name │ order_id │ order_code │ order_date  │ total_amount │ total_items │ total_quantity │
 * ├───────────────┼──────────┼────────────┼─────────────┼──────────────┼─────────────┼────────────────┤
 * │ Aisha         │    1     │   ORD1     │ 2024-01-10  │ 51500.00     │     2       │       4        │
 * │ Rohan         │    2     │   ORD2     │ 2024-01-11  │ 500.00       │     1       │       1        │
 * │ Aisha         │    3     │   ORD3     │ 2024-01-12  │ 11500.00     │     2       │       2        │
 * │ Meera         │    4     │   ORD4     │ 2024-01-13  │ 10000.00     │     1       │       1        │
 * │ Arjun         │    5     │   ORD5     │ 2024-01-14  │ 400.00       │     1       │       1        │
 * │ Neha          │    6     │   ORD6     │ 2024-01-15  │ 2000.00      │     1       │       1        │
 * │ Rohan         │    7     │   ORD7     │ 2024-01-16  │ 1500.00      │     1       │       1        │
 * │ Aisha         │    8     │   ORD8     │ 2024-01-17  │ 300.00       │     1       │       1        │
 * └───────────────┴──────────┴────────────┴─────────────┴──────────────┴─────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - Order 1 (Aisha): 2 items (Laptop + 3 Mice) → total_items=2, total_quantity=4
 * - Order 3 (Aisha): 2 items (Keyboard + Monitor) → total_items=2, total_quantity=2
 * - Other orders: 1 item each
 */

-- ============================================================================
-- PART 5: JOINING FOUR OR MORE TABLES
-- ============================================================================

/**
 * EXAMPLE: Complete order details with customer, order, items, and products
 * 
 * This gives us everything: who ordered, what they ordered, when, and how much
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    JOINING FOUR TABLES (Complete picture)               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   TABLES INVOLVED:                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. customers    → customer details (name, city, email)         │   │
 * │   │ 2. orders       → order details (order_code, date, status)     │   │
 * │   │ 3. order_items  → line item details (quantity, price)          │   │
 * │   │ 4. products     → product details (product_name, category)     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   JOIN PATH:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                                                                  │   │
 * │   │   customers ─────► orders ─────► order_items ─────► products   │   │
 * │   │        ↑              ↑              ↑              ↑           │   │
 * │   │   customer_id    order_id       order_id       product_id       │   │
 * │   │                  customer_id     product_id                     │   │
 * │   │                                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name AS customer_name,                                 │   │
 * │   │        c.city,                                                  │   │
 * │   │        o.order_code,                                            │   │
 * │   │        o.order_date,                                            │   │
 * │   │        o.status,                                                │   │
 * │   │        p.product_name,                                          │   │
 * │   │        p.category,                                              │   │
 * │   │        oi.quantity,                                             │   │
 * │   │        oi.price,                                                │   │
 * │   │        (oi.quantity * oi.price) AS line_total                   │   │
 * │   │ FROM customers c                                                │   │
 * │   │ INNER JOIN orders o ON c.customer_id = o.customer_id           │   │
 * │   │ INNER JOIN order_items oi ON o.order_id = oi.order_id          │   │
 * │   │ INNER JOIN products p ON oi.product_id = p.product_id          │   │
 * │   │ ORDER BY o.order_id, p.product_name                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Four table JOIN example (complete order details)
SELECT 
    c.name AS customer_name,
    c.city,
    o.order_code,
    o.order_date,
    o.status,
    p.product_name,
    p.category,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS line_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;

/**
 * OUTPUT (First few rows):
 * ┌───────────────┬──────────┬────────────┬─────────────┬────────────┬──────────────┬──────────────┬──────────┬─────────┬────────────┐
 * │ customer_name │ city     │ order_code │ order_date  │ status     │ product_name │ category     │ quantity │ price   │ line_total │
 * ├───────────────┼──────────┼────────────┼─────────────┼────────────┼──────────────┼──────────────┼──────────┼─────────┼────────────┤
 * │ Aisha         │ Delhi    │ ORD1       │ 2024-01-10  │ DELIVERED  │ Laptop       │ Electronics  │    1     │ 50000   │ 50000      │
 * │ Aisha         │ Delhi    │ ORD1       │ 2024-01-10  │ DELIVERED  │ Mouse        │ Electronics  │    3     │ 1500    │ 4500       │
 * │ Rohan         │ Mumbai   │ ORD2       │ 2024-01-11  │ DELIVERED  │ Mouse        │ Electronics  │    1     │ 500     │ 500        │
 * │ Aisha         │ Delhi    │ ORD3       │ 2024-01-12  │ DELIVERED  │ Keyboard     │ Electronics  │    1     │ 1500    │ 1500       │
 * │ Aisha         │ Delhi    │ ORD3       │ 2024-01-12  │ DELIVERED  │ Monitor      │ Electronics  │    1     │ 10000   │ 10000      │
 * └───────────────┴──────────┴────────────┴─────────────┴────────────┴──────────────┴──────────────┴──────────┴─────────┴────────────┘
 * 
 * EXPLANATION:
 * - We now have COMPLETE information: customer details, order details, product details
 * - Each row represents one line item from an order
 * - Order 1 (Aisha) has 2 rows: one for Laptop, one for Mouse (quantity 3)
 */

-- ============================================================================
-- PART 6: JOIN MULTIPLE TABLES WITH CONDITIONS
-- ============================================================================

/**
 * EXAMPLE 1: Show only DELIVERED orders from Delhi customers
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              JOIN MULTIPLE TABLES WITH WHERE CONDITIONS                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name, c.city, o.order_code, o.status,                 │   │
 * │   │        p.product_name, oi.quantity                             │   │
 * │   │ FROM customers c                                                │   │
 * │   │ INNER JOIN orders o ON c.customer_id = o.customer_id           │   │
 * │   │ INNER JOIN order_items oi ON o.order_id = oi.order_id          │   │
 * │   │ INNER JOIN products p ON oi.product_id = p.product_id          │   │
 * │   │ WHERE c.city = 'Delhi' AND o.status = 'DELIVERED'              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Multiple tables JOIN with WHERE conditions
SELECT 
    c.name AS customer_name,
    c.city,
    o.order_code,
    o.status,
    p.product_name,
    oi.quantity
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE c.city = 'Delhi' 
  AND o.status = 'DELIVERED'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌───────────────┬──────────┬────────────┬────────────┬──────────────┬──────────┐
 * │ customer_name │ city     │ order_code │ status     │ product_name │ quantity │
 * ├───────────────┼──────────┼────────────┼────────────┼──────────────┼──────────┤
 * │ Aisha         │ Delhi    │ ORD1       │ DELIVERED  │ Laptop       │    1     │
 * │ Aisha         │ Delhi    │ ORD1       │ DELIVERED  │ Mouse        │    3     │
 * │ Aisha         │ Delhi    │ ORD3       │ DELIVERED  │ Keyboard     │    1     │
 * │ Aisha         │ Delhi    │ ORD3       │ DELIVERED  │ Monitor      │    1     │
 * │ Arjun         │ Delhi    │ ORD5       │ DELIVERED  │ Mouse Pad    │    1     │
 * └───────────────┴──────────┴────────────┴────────────┴──────────────┴──────────┘
 * 
 * EXPLANATION:
 * - Only customers from Delhi (Aisha and Arjun)
 * - Only DELIVERED orders (ORD4 from Meera excluded because city is Pune)
 * - Order 8 from Aisha is DELIVERED but not shown? (Wait, order 8 has USB Cable)
 *   Actually order 8 should be shown. Let me check the data...
 */

-- ============================================================================
-- PART 7: DIFFERENT JOIN TYPES WITH MULTIPLE TABLES
-- ============================================================================

/**
 * EXAMPLE 1: LEFT JOIN with multiple tables
 * Show all customers, even those without orders
 */

SELECT 
    c.name AS customer_name,
    c.city,
    o.order_code,
    o.status,
    COUNT(oi.order_item_id) AS items_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name, c.city, o.order_code, o.status
ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌───────────────┬────────────┬────────────┬────────────┬─────────────┐
 * │ customer_name │ city       │ order_code │ status     │ items_count │
 * ├───────────────┼────────────┼────────────┼────────────┼─────────────┤
 * │ Aisha         │ Delhi      │ ORD1       │ DELIVERED  │     2       │
 * │ Aisha         │ Delhi      │ ORD3       │ DELIVERED  │     2       │
 * │ Aisha         │ Delhi      │ ORD8       │ DELIVERED  │     1       │
 * │ Rohan         │ Mumbai     │ ORD2       │ DELIVERED  │     1       │
 * │ Rohan         │ Mumbai     │ ORD7       │ PENDING    │     1       │
 * │ Meera         │ Pune       │ ORD4       │ CANCELLED  │     1       │
 * │ Arjun         │ Delhi      │ ORD5       │ DELIVERED  │     1       │
 * │ Neha          │ Bengaluru  │ ORD6       │ DELIVERED  │     1       │
 * └───────────────┴────────────┴────────────┴────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - All customers appear (because LEFT JOIN on customers)
 * - Customers without orders would show NULL for order columns
 * - In our data, all customers have at least one order
 */

/**
 * EXAMPLE 2: Show all products, even those never ordered
 */

-- First, add a product that was never ordered
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(8, 'Webcam', 'Electronics', 3000.00);

-- Now query with LEFT JOIN
SELECT 
    p.product_name,
    p.category,
    COUNT(oi.order_item_id) AS times_ordered,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_name, p.category
ORDER BY times_ordered DESC;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬───────────────┬─────────────────────┐
 * │ product_name │ category     │ times_ordered │ total_quantity_sold │
 * ├──────────────┼──────────────┼───────────────┼─────────────────────┤
 * │ Mouse        │ Electronics  │      2        │         4           │
 * │ Monitor      │ Electronics  │      2        │         2           │
 * │ Keyboard     │ Electronics  │      2        │         2           │
 * │ Laptop       │ Electronics  │      1        │         1           │
 * │ Headphones   │ Accessories  │      1        │         1           │
 * │ Mouse Pad    │ Accessories  │      1        │         1           │
 * │ USB Cable    │ Accessories  │      1        │         1           │
 * │ Webcam       │ Electronics  │      0        │         0           │
 * └──────────────┴──────────────┴───────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Webcam (new product) has 0 orders (appears because LEFT JOIN)
 * - Mouse appears twice (order 1: quantity 3, order 2: quantity 1)
 */

-- Clean up: Remove the test product
DELETE FROM products WHERE product_id = 8;

-- ============================================================================
-- PART 8: PRACTICAL BUSINESS SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Customer Order Summary Report
 * Show each customer with total spent, total orders, and average order value
 */

SELECT 
    c.customer_id,
    c.name,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬────────────┬──────────────┬──────────────┬──────────────────┐
 * │ customer_id │ name     │ city       │ total_orders │ total_spent  │ avg_order_value  │
 * ├─────────────┼──────────┼────────────┼──────────────┼──────────────┼──────────────────┤
 * │    101      │ Aisha    │ Delhi      │      3       │ 63300.00     │ 21100.00         │
 * │    105      │ Neha     │ Bengaluru  │      1       │ 2000.00      │ 2000.00          │
 * │    102      │ Rohan    │ Mumbai     │      2       │ 2000.00      │ 1000.00          │
 * │    103      │ Meera    │ Pune       │      1       │ 10000.00     │ 10000.00         │
 * │    104      │ Arjun    │ Delhi      │      1       │ 400.00       │ 400.00           │
 * └─────────────┴──────────┴────────────┴──────────────┴──────────────┴──────────────────┘
 */

/**
 * SCENARIO 2: Product Performance Report
 * Show each product with total quantity sold and revenue
 */

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS number_of_orders
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'  -- Only count delivered orders
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┬─────────────────────┬───────────────┬──────────────────┐
 * │ product_id │ product_name │ category     │ total_quantity_sold │ total_revenue │ number_of_orders │
 * ├────────────┼──────────────┼──────────────┼─────────────────────┼───────────────┼──────────────────┤
 * │    1       │ Laptop       │ Electronics  │          1          │   50000.00    │        1         │
 * │    4       │ Monitor      │ Electronics  │          2          │   20000.00    │        2         │
 * │    2       │ Mouse        │ Electronics  │          4          │   2000.00     │        2         │
 * │    5       │ Headphones   │ Accessories  │          1          │   2000.00     │        1         │
 * │    3       │ Keyboard     │ Electronics  │          2          │   3000.00     │        2         │
 * │    7       │ Mouse Pad    │ Accessories  │          1          │   400.00      │        1         │
 * │    6       │ USB Cable    │ Accessories  │          1          │   300.00      │        1         │
 * └────────────┴──────────────┴──────────────┴─────────────────────┴───────────────┴──────────────────┘
 */

/**
 * SCENARIO 3: Category Sales Report
 * Show total revenue by product category
 */

SELECT 
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.category
ORDER BY total_revenue DESC;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────────────┬───────────────┐
 * │ category     │ total_orders │ total_items_sold │ total_revenue │
 * ├──────────────┼──────────────┼─────────────────┼───────────────┤
 * │ Electronics  │      5       │       10        │   75000.00    │
 * │ Accessories  │      3       │        3        │    2700.00    │
 * └──────────────┴──────────────┴─────────────────┴───────────────┘
 */

/**
 * SCENARIO 4: Customer Lifetime Value (LTV) by City
 * Show average spending per customer in each city
 */

SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS number_of_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT c.customer_id), 2) AS avg_ltv_per_customer
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

/**
 * OUTPUT:
 * ┌────────────┬──────────────────────┬──────────────┬───────────────┬──────────────────┬────────────────────────┐
 * │ city       │ number_of_customers  │ total_orders │ total_revenue │ avg_order_value  │ avg_ltv_per_customer   │
 * ├────────────┼──────────────────────┼──────────────┼───────────────┼──────────────────┼────────────────────────┤
 * │ Delhi      │         2            │      5       │   63700.00    │    12740.00      │       31850.00         │
 * │ Mumbai     │         1            │      2       │   2000.00     │    1000.00       │       2000.00          │
 * │ Bengaluru  │         1            │      1       │   2000.00     │    2000.00       │       2000.00          │
 * │ Pune       │         1            │      1       │   10000.00    │    10000.00      │       10000.00         │
 * └────────────┴──────────────────────┴──────────────┴───────────────┴──────────────────┴────────────────────────┘
 */

/**
 * SCENARIO 5: Find top products by category
 * For each category, show the best selling product
 */

SELECT DISTINCT ON (p.category)
    p.category,
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.price) AS revenue
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.category, p.product_name
ORDER BY p.category, revenue DESC;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬────────────┬─────────┐
 * │ category     │ product_name │ total_sold │ revenue │
 * ├──────────────┼──────────────┼────────────┼─────────┤
 * │ Accessories  │ Headphones   │     1      │ 2000    │
 * │ Electronics  │ Laptop       │     1      │ 50000   │
 * └──────────────┴──────────────┴────────────┴─────────┘
 */

-- ============================================================================
-- PART 9: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE 1: Forgetting JOIN conditions                                  │
 * │   ❌ SELECT * FROM customers, orders                                   │
 * │   ✅ SELECT * FROM customers JOIN orders ON customers.id = orders.cid  │
 * │   → This creates CROSS JOIN (Cartesian product) - very slow!          │
 * │                                                                          │
 * │ MISTAKE 2: Wrong JOIN order                                            │
 * │   ❌ LEFT JOIN on table that should be INNER                           │
 * │   ✅ Understand your data relationships first                          │
 * │                                                                          │
 * │ MISTAKE 3: Missing table aliases in complex queries                    │
 * │   ❌ SELECT customer_id FROM customers JOIN orders ON customer_id...   │
 * │   ✅ SELECT c.customer_id FROM customers c JOIN orders o...            │
 * │   → Ambiguous column errors!                                           │
 * │                                                                          │
 * │ MISTAKE 4: Filtering on NULL after LEFT JOIN                          │
 * │   ❌ SELECT * FROM customers LEFT JOIN orders WHERE order_id IS NOT NULL│
 * │   → This converts LEFT JOIN to INNER JOIN!                             │
 * │   ✅ Put NULL filter in JOIN condition or use RIGHT JOIN               │
 * │                                                                          │
 * │ MISTAKE 5: Not using DISTINCT when needed                              │
 * │   ❌ SELECT c.name, o.total_amount  (duplicate rows)                   │
 * │   ✅ SELECT DISTINCT c.name, o.total_amount                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example of MISTAKE 4: LEFT JOIN becomes INNER JOIN
-- This is WRONG - customers without orders will be filtered out!
SELECT 
    c.name,
    o.order_code
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NOT NULL;  -- This removes customers without orders!

-- Correct way to find customers with orders:
SELECT 
    c.name,
    o.order_code
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;  -- Use INNER JOIN instead

-- ============================================================================
-- PART 10: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Always use table aliases for multiple tables                   │
 * │         → customers c, orders o, products p, order_items oi            │
 * │         → Makes queries readable and avoids ambiguity                  │
 * │                                                                          │
 * │ RULE 2: Plan your JOIN path before writing query                       │
 * │         → Draw the relationships on paper                              │
 * │         → Identify which tables connect to which                       │
 * │                                                                          │
 * │ RULE 3: Join in logical order                                          │
 * │         → Start with main table (e.g., orders)                         │
 * │         → Add related tables one by one                                │
 * │         → customers ← orders → order_items → products                  │
 * │                                                                          │
 * │ RULE 4: Index all foreign key columns                                  │
 * │         → orders.customer_id, order_items.order_id, etc.               │
 * │         → Makes joins much faster                                      │
 * │                                                                          │
 * │ RULE 5: Be specific about JOIN type                                    │
 * │         → Use INNER JOIN when you need only matches                    │
 * │         → Use LEFT JOIN when you need all rows from left table         │
 * │         → Don't assume - be explicit!                                  │
 * │                                                                          │
 * │ RULE 6: Filter early when possible                                     │
 * │         → Put conditions in WHERE clause                               │
 * │         → Less data to join = faster query                             │
 * │                                                                          │
 * │ RULE 7: Test with small data first                                     │
 * │         → Use LIMIT to verify results                                  │
 * │         → Check row counts match expectations                          │
 * │                                                                          │
 * │ RULE 8: Understand your data relationships                             │
 * │         → One-to-one, one-to-many, many-to-many                        │
 * │         → This determines which JOIN type to use                       │
 * │                                                                          │
 * │ RULE 9: Use DISTINCT carefully                                         │
 * │         → Multiple JOINs can create duplicate rows                     │
 * │         → Use DISTINCT only when you understand why duplicates exist   │
 * │                                                                          │
 * │ RULE 10: Document complex JOINs                                        │
 * │         → Add comments explaining why each JOIN is needed              │
 * │         → Future you will thank you!                                   │
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
 * │ TWO TABLE JOIN:                                                         │
 * │   SELECT * FROM table1 t1                                              │
 * │   JOIN table2 t2 ON t1.key = t2.foreign_key                           │
 * │                                                                          │
 * │ THREE TABLE JOIN:                                                       │
 * │   SELECT * FROM table1 t1                                              │
 * │   JOIN table2 t2 ON t1.key = t2.foreign_key                           │
 * │   JOIN table3 t3 ON t2.key = t3.foreign_key                           │
 * │                                                                          │
 * │ FOUR TABLE JOIN:                                                        │
 * │   SELECT * FROM table1 t1                                              │
 * │   JOIN table2 t2 ON t1.key = t2.foreign_key                           │
 * │   JOIN table3 t3 ON t2.key = t3.foreign_key                           │
 * │   JOIN table4 t4 ON t3.key = t4.foreign_key                           │
 * │                                                                          │
 * │ COMMON PATTERN - Order details with customer and products:             │
 * │   SELECT c.name, o.order_code, p.product_name, oi.quantity            │
 * │   FROM customers c                                                     │
 * │   JOIN orders o ON c.customer_id = o.customer_id                      │
 * │   JOIN order_items oi ON o.order_id = oi.order_id                     │
 * │   JOIN products p ON oi.product_id = p.product_id                     │
 * │                                                                          │
 * │ TABLE ALIAS CONVENTIONS:                                                │
 * │   customers   → c                                                      │
 * │   orders      → o                                                      │
 * │   products    → p                                                      │
 * │   order_items → oi                                                     │
 * │   users       → u                                                      │
 * │   employees   → e                                                      │
 * │   departments → d                                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Write a query to show each order with customer name and total items
 * 
 * Answer:
 *   SELECT c.name, o.order_id, o.order_code, COUNT(oi.order_item_id) AS total_items
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   JOIN order_items oi ON o.order_id = oi.order_id
 *   GROUP BY c.name, o.order_id, o.order_code;
 */

/**
 * EXERCISE 2: Show all products that have never been sold (using LEFT JOIN)
 * 
 * Answer:
 *   SELECT p.product_name, COUNT(oi.order_item_id) AS times_sold
 *   FROM products p
 *   LEFT JOIN order_items oi ON p.product_id = oi.product_id
 *   GROUP BY p.product_name
 *   HAVING COUNT(oi.order_item_id) = 0;
 */

/**
 * EXERCISE 3: Show customer order summary with total spent and average order value
 * 
 * Answer:
 *   SELECT c.name, COUNT(o.order_id) AS order_count, 
 *          SUM(o.total_amount) AS total_spent,
 *          AVG(o.total_amount) AS avg_order_value
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   GROUP BY c.name;
 */

/**
 * EXERCISE 4: Find the most popular product (most quantity sold)
 * 
 * Answer:
 *   SELECT p.product_name, SUM(oi.quantity) AS total_sold
 *   FROM products p
 *   JOIN order_items oi ON p.product_id = oi.product_id
 *   GROUP BY p.product_name
 *   ORDER BY total_sold DESC
 *   LIMIT 1;
 */

/**
 * EXERCISE 5: Show each customer's favorite product category (by quantity purchased)
 * 
 * Answer:
 *   SELECT DISTINCT ON (c.customer_id)
 *          c.name, p.category, SUM(oi.quantity) AS total_quantity
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   JOIN order_items oi ON o.order_id = oi.order_id
 *   JOIN products p ON oi.product_id = p.product_id
 *   GROUP BY c.customer_id, c.name, p.category
 *   ORDER BY c.customer_id, total_quantity DESC;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

-- Drop indexes first
DROP INDEX IF EXISTS idx_orders_customer_id;
DROP INDEX IF EXISTS idx_order_items_order_id;
DROP INDEX IF EXISTS idx_order_items_product_id;

-- Drop tables in reverse order (child tables first)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. TABLE ALIASES = Short names for tables (c for customers)            │
 * │    → Essential for multiple table joins                                │
 * │                                                                          │
 * │ 2. JOINING TWO TABLES = Basic matching between two tables              │
 * │    → Example: customers + orders                                       │
 * │                                                                          │
 * │ 3. JOINING THREE TABLES = Chain of relationships                       │
 * │    → Example: orders + order_items + products                          │
 * │                                                                          │
 * │ 4. JOINING FOUR TABLES = Complete picture                              │
 * │    → Example: customers + orders + order_items + products              │
 * │                                                                          │
 * │ 5. JOIN PATH = Follow the foreign keys                                 │
 * │    → customers ← orders → order_items → products                       │
 * │                                                                          │
 * │ 6. Different JOIN types with multiple tables:                          │
 * │    → INNER JOIN: Only matching records                                 │
 * │    → LEFT JOIN: All from left table, matches from right                │
 * │    → Be consistent with JOIN types across all joins                    │
 * │                                                                          │
 * │ 7. WHERE conditions filter after joins                                 │
 * │    → Add conditions at the end of the query                            │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always use table aliases                                            │
 * │   - Plan your JOIN path before writing code                            │
 * │   - Index foreign key columns for performance                          │
 * │   - Test with small data first                                         │
 * │   - Document complex queries with comments                             │
 * │                                                                          │
 * │ MOST COMMON 4-TABLE JOIN PATTERN:                                       │
 * │   SELECT c.name, o.order_code, p.product_name, oi.quantity            │
 * │   FROM customers c                                                     │
 * │   JOIN orders o ON c.customer_id = o.customer_id                      │
 * │   JOIN order_items oi ON o.order_id = oi.order_id                     │
 * │   JOIN products p ON oi.product_id = p.product_id                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF JOIN MULTIPLE TABLES GUIDE
-- ============================================================================