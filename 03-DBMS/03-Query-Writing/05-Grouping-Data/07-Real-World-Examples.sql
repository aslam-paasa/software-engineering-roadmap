/**
 * ============================================================================
 * REAL-WORLD SCENARIOS - COMPLETE BUSINESS USE CASES
 * Practical examples combining all SQL concepts learned
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. PROJECT RESOURCE PLANNING -------------- (Find teams needing resources)
 * 2. EVENT ANALYTICS ------------------------ (Conversion rates analysis)
 * 3. MARKETING ATTRIBUTION ------------------ (Referral source tracking)
 * 4. DUPLICATE DETECTION -------------------- (Find repeat users)
 * 5. TEAM PERFORMANCE DASHBOARD ------------- (Comprehensive project metrics)
 * 6. SALES ANALYSIS ------------------------- (Revenue and product performance)
 * 7. CUSTOMER BEHAVIOR ---------------------- (Purchase patterns)
 * 8. INVENTORY MANAGEMENT ------------------- (Stock level analysis)
 * 9. EMPLOYEE PERFORMANCE ------------------- (Hours and productivity)
 * 10. FINANCIAL REPORTING ------------------- (Revenue and profit analysis)
 * 11. CUSTOMER SEGMENTATION ----------------- (Group customers by behavior)
 * 12. TREND ANALYSIS ------------------------ (Monthly and quarterly trends)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL SCENARIOS
-- ============================================================================

/**
 * TABLE 1: EMPLOYEES - Project team data
 */
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    project VARCHAR(20),
    years_experience DECIMAL(3,1),
    hours_logged INT,
    role VARCHAR(20)
);

INSERT INTO employees VALUES
(1, 'Alice', 'Alpha', 3.0, 100, 'Developer'),
(2, 'Bob', 'Alpha', 5.0, 120, 'QA'),
(3, 'Carol', 'Alpha', 7.0, 105, 'Developer'),
(4, 'Dave', 'Alpha', NULL, 0, 'Manager'),
(5, 'Eve', 'Beta', 2.0, 80, 'Manager'),
(6, 'Frank', 'Beta', 3.0, 110, 'Developer'),
(7, 'Grace', 'Beta', 4.0, 130, 'Developer'),
(8, 'Hank', 'Beta', 3.0, NULL, 'Developer'),
(9, 'Heidi', 'Gamma', 5.0, 150, 'Developer'),
(10, 'Ivan', 'Gamma', 6.0, 140, 'QA');

/**
 * TABLE 2: REGISTRATIONS - Event data
 */
CREATE TABLE registrations (
    reg_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(100),
    event VARCHAR(20),
    ticket_type VARCHAR(10),
    referrer VARCHAR(20),
    registration_date DATE
);

INSERT INTO registrations VALUES
(1, 'Aisha', 'aisha@example.com', 'TechFest', 'Paid', 'Instagram', '2024-01-15'),
(2, 'Rohan', 'rohan@example.com', 'TechFest', 'Free', NULL, '2024-01-16'),
(3, 'Aisha', 'aisha@example.com', 'CodeCamp', 'Paid', 'Instagram', '2024-01-17'),
(4, 'Mohit', NULL, 'TechFest', 'Free', 'LinkedIn', '2024-01-18'),
(5, 'Neha', 'neha@example.com', 'CodeCamp', 'Free', 'Instagram', '2024-01-19'),
(6, NULL, 'unknown@example.com', 'DesignCon', 'Paid', 'Twitter', '2024-01-20'),
(7, 'Aisha', 'aisha@example.com', 'TechFest', 'Paid', 'Instagram', '2024-01-21'),
(8, 'Vishal', NULL, 'DesignCon', 'Free', NULL, '2024-01-22'),
(9, 'Rohan', 'rohan@example.com', 'TechFest', 'Free', 'Instagram', '2024-01-23'),
(10, 'Aisha', 'aisha@example.com', 'CodeCamp', 'Paid', NULL, '2024-01-24');

/**
 * TABLE 3: SALES - E-commerce data
 */
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(30),
    quantity INT,
    unit_price DECIMAL(10,2),
    sale_date DATE,
    customer_id INT
);

INSERT INTO sales VALUES
(1, 101, 'Laptop', 'Electronics', 2, 50000.00, '2024-01-05', 1),
(2, 102, 'Mouse', 'Electronics', 5, 500.00, '2024-01-10', 2),
(3, 101, 'Laptop', 'Electronics', 1, 50000.00, '2024-01-15', 3),
(4, 103, 'Keyboard', 'Electronics', 3, 1500.00, '2024-01-20', 1),
(5, 104, 'Monitor', 'Electronics', 2, 10000.00, '2024-02-05', 2),
(6, 105, 'Headphones', 'Accessories', 4, 2000.00, '2024-02-10', 3),
(7, 102, 'Mouse', 'Electronics', 10, 500.00, '2024-02-15', 1),
(8, 106, 'USB Cable', 'Accessories', 20, 300.00, '2024-02-20', 2),
(9, 103, 'Keyboard', 'Electronics', 2, 1500.00, '2024-03-05', 3),
(10, 101, 'Laptop', 'Electronics', 1, 50000.00, '2024-03-10', 1);

/**
 * TABLE 4: CUSTOMERS - Customer data
 */
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    join_date DATE,
    tier VARCHAR(20)
);

INSERT INTO customers VALUES
(1, 'Rajesh', 'Mumbai', '2023-01-15', 'Gold'),
(2, 'Priya', 'Delhi', '2023-02-20', 'Silver'),
(3, 'Amit', 'Bangalore', '2023-03-10', 'Gold'),
(4, 'Neha', 'Mumbai', '2023-04-05', 'Bronze'),
(5, 'Suresh', 'Delhi', '2023-05-12', 'Silver');

-- ============================================================================
-- SCENARIO 1: PROJECT RESOURCE PLANNING
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Find projects that need additional resources.
 * - Projects with total hours > 300 (overworked team)
 * - OR Projects with team size < 3 (understaffed team)
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    PROJECT RESOURCE PLANNING                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project,                                                 │   │
 * │   │        COUNT(*) AS team_size,                                   │   │
 * │   │        SUM(hours_logged) AS total_hours,                        │   │
 * │   │        ROUND(AVG(years_experience), 1) AS avg_exp               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE years_experience IS NOT NULL                              │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING SUM(hours_logged) > 300 OR COUNT(*) < 3                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT DATA:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 4 members, 325 hours                                    │   │
 * │   │ Beta:  4 members, 320 hours                                    │   │
 * │   │ Gamma: 2 members, 290 hours                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ANALYSIS:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: total_hours=325 >300 → NEEDS RESOURCES ✓                 │   │
 * │   │ Beta:  total_hours=320 >300 → NEEDS RESOURCES ✓                 │   │
 * │   │ Gamma: team_size=2 <3 → NEEDS RESOURCES ✓                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬───────────┬─────────────┬─────────┐                     │
 * │   │ project │ team_size │ total_hours │ avg_exp │                     │
 *   │   ├─────────┼───────────┼─────────────┼─────────┤                     │
 * │   │ Alpha   │ 3         │ 325         │ 5.0     │                     │
 * │   │ Beta    │ 3         │ 320         │ 3.0     │                     │
 * │   │ Gamma   │ 2         │ 290         │ 5.5     │                     │
 * │   └─────────┴───────────┴─────────────┴─────────┘                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_exp
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING SUM(hours_logged) > 300 OR COUNT(*) < 3;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┬─────────┐
 * │ project │ team_size │ total_hours │ avg_exp │
 * ├─────────┼───────────┼─────────────┼─────────┤
 * │ Alpha   │ 3         │ 325         │ 5.0     │
 * │ Beta    │ 3         │ 320         │ 3.0     │
 * │ Gamma   │ 2         │ 290         │ 5.5     │
 * └─────────┴───────────┴─────────────┴─────────┘
 * 
 * BUSINESS ACTION:
 * - Alpha: Overworked team (325 hours) → Consider hiring more developers
 * - Beta:  Overworked team (320 hours) → Consider hiring more developers
 * - Gamma: Understaffed team (only 2 members) → Need to hire 1 more person
 */

-- ============================================================================
-- SCENARIO 2: EVENT ANALYTICS — Conversion Rates
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Calculate paid ticket conversion rate for each event.
 * Conversion rate = (Paid registrations / Total registrations) × 100
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    EVENT CONVERSION RATES                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT event,                                                   │   │
 * │   │        COUNT(*) AS total_regs,                                  │   │
 * │   │        COUNT(CASE WHEN ticket_type='Paid' THEN 1 END) AS paid,  │   │
 * │   │        ROUND(COUNT(CASE WHEN ticket_type='Paid' THEN 1 END) *   │   │
 * │   │              100.0 / COUNT(*), 1) AS conversion_rate            │   │
 * │   │ FROM registrations                                              │   │
 * │   │ GROUP BY event                                                  │   │
 * │   │ ORDER BY conversion_rate DESC;                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   CALCULATIONS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CodeCamp:  Paid=2, Total=3 → 2/3×100 = 66.7%                   │   │
 * │   │ DesignCon: Paid=1, Total=2 → 1/2×100 = 50.0%                   │   │
 * │   │ TechFest:  Paid=2, Total=5 → 2/5×100 = 40.0%                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────────┬────────────┬───────┬─────────────────┐                │
 * │   │ event     │ total_regs │ paid  │ conversion_rate │                │
 * │   ├───────────┼────────────┼───────┼─────────────────┤                │
 * │   │ CodeCamp  │ 3          │ 2     │ 66.7            │                │
 * │   │ DesignCon │ 2          │ 1     │ 50.0            │                │
 * │   │ TechFest  │ 5          │ 2     │ 40.0            │                │
 * │   └───────────┴────────────┴───────┴─────────────────┘                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    event,
    COUNT(*) AS total_regs,
    COUNT(CASE WHEN ticket_type = 'Paid' THEN 1 END) AS paid_regs,
    ROUND(COUNT(CASE WHEN ticket_type = 'Paid' THEN 1 END) * 100.0 / COUNT(*), 1) AS conversion_rate
FROM registrations
GROUP BY event
ORDER BY conversion_rate DESC;

/**
 * OUTPUT:
 * ┌───────────┬────────────┬───────────┬─────────────────┐
 * │ event     │ total_regs │ paid_regs │ conversion_rate │
 * ├───────────┼────────────┼───────────┼─────────────────┤
 * │ CodeCamp  │ 3          │ 2         │ 66.7            │
 * │ DesignCon │ 2          │ 1         │ 50.0            │
 * │ TechFest  │ 5          │ 2         │ 40.0            │
 * └───────────┴────────────┴───────────┴─────────────────┘
 * 
 * BUSINESS INSIGHT:
 * - CodeCamp has highest conversion rate (66.7%) → Most profitable event
 * - TechFest has lowest conversion rate (40%) despite most registrations
 * - Consider adjusting pricing or offers for TechFest
 */

-- ============================================================================
-- SCENARIO 3: MARKETING ATTRIBUTION — Referral Sources
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Which marketing channels are bringing the most registrations?
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MARKETING ATTRIBUTION                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COALESCE(referrer, 'Direct/Unknown') AS source,          │   │
 * │   │        COUNT(*) AS registrations,                               │   │
 * │   │        COUNT(DISTINCT user_name) AS unique_users                │   │
 * │   │ FROM registrations                                              │   │
 * │   │ GROUP BY referrer                                               │   │
 * │   │ ORDER BY registrations DESC;                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ANALYSIS:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Instagram: 5 registrations, 3 unique users → BEST channel      │   │
 * │   │ Direct:    3 registrations, 2 unique users → Second best        │   │
 * │   │ LinkedIn:  1 registration, 1 unique user                       │   │
 * │   │ Twitter:   1 registration, 1 unique user                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────────┬──────────────┬──────────────┐                   │
 * │   │ source          │ registrations │ unique_users │                   │
 * │   ├─────────────────┼──────────────┼──────────────┤                   │
 * │   │ Instagram       │ 5            │ 3            │                   │
 * │   │ Direct/Unknown  │ 3            │ 2            │                   │
 * │   │ LinkedIn        │ 1            │ 1            │                   │
 * │   │ Twitter         │ 1            │ 1            │                   │
 * │   └─────────────────┴──────────────┴──────────────┘                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    COALESCE(referrer, 'Direct/Unknown') AS source,
    COUNT(*) AS registrations,
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations
GROUP BY referrer
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌─────────────────┬──────────────┬──────────────┐
 * │ source          │ registrations │ unique_users │
 * ├─────────────────┼──────────────┼──────────────┤
 * │ Instagram       │ 5            │ 3            │
 * │ Direct/Unknown  │ 3            │ 2            │
 * │ LinkedIn        │ 1            │ 1            │
 * │ Twitter         │ 1            │ 1            │
 * └─────────────────┴──────────────┴──────────────┘
 * 
 * BUSINESS INSIGHT:
 * - Instagram is the best performing channel (5 registrations)
 * - Invest more marketing budget in Instagram
 * - LinkedIn and Twitter need improvement or reallocation of budget
 */

-- ============================================================================
-- SCENARIO 4: DUPLICATE DETECTION — Users with multiple registrations
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Find users who registered for multiple events (repeat customers)
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    DUPLICATE DETECTION                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT user_name,                                               │   │
 * │   │        COUNT(*) AS registration_count,                          │   │
 * │   │        STRING_AGG(DISTINCT event, ', ' ORDER BY event) AS events│   │
 * │   │ FROM registrations                                              │   │
 * │   │ WHERE user_name IS NOT NULL                                     │   │
 * │   │ GROUP BY user_name                                              │   │
 * │   │ HAVING COUNT(*) > 1                                             │   │
 * │   │ ORDER BY registration_count DESC;                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ANALYSIS:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Aisha: 4 registrations (TechFest twice, CodeCamp twice)        │   │
 * │   │ Rohan: 2 registrations (TechFest twice)                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────────┬─────────────────────┬─────────────────────────┐       │
 * │   │ user_name │ registration_count │ events                  │       │
 * │   ├───────────┼─────────────────────┼─────────────────────────┤       │
 * │   │ Aisha     │ 4                   │ CodeCamp, TechFest      │       │
 * │   │ Rohan     │ 2                   │ TechFest                │       │
 * │   └───────────┴─────────────────────┴─────────────────────────┘       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    user_name,
    COUNT(*) AS registration_count,
    STRING_AGG(DISTINCT event, ', ' ORDER BY event) AS events
FROM registrations
WHERE user_name IS NOT NULL
GROUP BY user_name
HAVING COUNT(*) > 1
ORDER BY registration_count DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────────┬─────────────────────────┐
 * │ user_name │ registration_count │ events                  │
 * ├───────────┼─────────────────────┼─────────────────────────┤
 * │ Aisha     │ 4                   │ CodeCamp, TechFest      │
 * │ Rohan     │ 2                   │ TechFest                │
 * └───────────┴─────────────────────┴─────────────────────────┘
 * 
 * BUSINESS INSIGHT:
 * - Aisha is a loyal customer (registered 4 times for 2 events)
 * - Send loyalty rewards and special offers to Aisha
 * - Rohan is also a repeat customer for TechFest
 */

-- ============================================================================
-- SCENARIO 5: TEAM PERFORMANCE DASHBOARD
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Create a comprehensive project summary with key metrics
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    TEAM PERFORMANCE DASHBOARD                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬───────────┬───────────┬─────────┬─────────┬─────────────┐│
 * │   │ project │ team_size │ developers│ qa_count│ managers│ total_hours ││
 * │   ├─────────┼───────────┼───────────┼─────────┼─────────┼─────────────┤│
 * │   │ Alpha   │ 4         │ 2         │ 1       │ 1       │ 325         ││
 * │   │ Beta    │ 4         │ 3         │ 0       │ 1       │ 320         ││
 * │   │ Gamma   │ 2         │ 1         │ 1       │ 0       │ 290         ││
 * │   └─────────┴───────────┴───────────┴─────────┴─────────┴─────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    COUNT(CASE WHEN role = 'Developer' THEN 1 END) AS developers,
    COUNT(CASE WHEN role = 'QA' THEN 1 END) AS qa_count,
    COUNT(CASE WHEN role = 'Manager' THEN 1 END) AS managers,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_experience,
    ROUND(AVG(CASE WHEN hours_logged IS NOT NULL THEN hours_logged END), 1) AS avg_hours_logged
FROM employees
GROUP BY project
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────┬──────────┬─────────┬─────────────┬────────────────┬─────────────────┐
 * │ project │ team_size │ developers │ qa_count │ managers │ total_hours │ avg_experience │ avg_hours_logged │
 * ├─────────┼───────────┼───────────┼──────────┼─────────┼─────────────┼────────────────┼─────────────────┤
 * │ Alpha   │ 4         │ 2         │ 1        │ 1       │ 325         │ 5.0            │ 108.3           │
 * │ Beta    │ 4         │ 3         │ 0        │ 1       │ 320         │ 3.0            │ 106.7           │
 * │ Gamma   │ 2         │ 1         │ 1        │ 0       │ 290         │ 5.5            │ 145.0           │
 * └─────────┴───────────┴───────────┴──────────┴─────────┴─────────────┴────────────────┴─────────────────┘
 * 
 * BUSINESS INSIGHT:
 * - Alpha: Balanced team (Dev, QA, Manager), experienced (5.0 years)
 * - Beta:  QA missing, less experienced (3.0 years) → Need QA hire
 * - Gamma: Small but highly productive (145 avg hours), experienced
 */

-- ============================================================================
-- SCENARIO 6: SALES ANALYSIS — Revenue and Product Performance
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Analyze sales performance by product category and month
 */

-- First, add month column for trend analysis
ALTER TABLE sales ADD COLUMN sale_month VARCHAR(7);
UPDATE sales SET sale_month = TO_CHAR(sale_date, 'YYYY-MM');

SELECT 
    category,
    sale_month,
    COUNT(*) AS num_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(quantity * unit_price) AS total_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS avg_transaction_value
FROM sales
GROUP BY category, sale_month
ORDER BY category, sale_month;

/**
 * OUTPUT:
 * ┌──────────────┬───────────┬──────────────────┬──────────────────┬───────────────┬────────────────────────┐
 * │ category     │ sale_month │ num_transactions │ total_units_sold │ total_revenue │ avg_transaction_value  │
 * ├──────────────┼───────────┼──────────────────┼──────────────────┼───────────────┼────────────────────────┤
 * │ Accessories  │ 2024-02   │ 2                │ 24               │ 8000.00       │ 4000.00                │
 * │ Electronics  │ 2024-01   │ 4                │ 11               │ 114500.00     │ 28625.00               │
 * │ Electronics  │ 2024-02   │ 3                │ 14               │ 40000.00      │ 13333.33               │
 * │ Electronics  │ 2024-03   │ 2                │ 3                │ 51500.00      │ 25750.00               │
 * └──────────────┴───────────┴──────────────────┴──────────────────┴───────────────┴────────────────────────┘
 */

-- Best selling products
SELECT 
    product_name,
    COUNT(*) AS times_ordered,
    SUM(quantity) AS total_quantity,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;

/**
 * OUTPUT:
 * ┌──────────────┬────────────────┬─────────────────┬───────────────┐
 * │ product_name │ times_ordered  │ total_quantity  │ total_revenue │
 * ├──────────────┼────────────────┼─────────────────┼───────────────┤
 * │ Laptop       │ 3              │ 4               │ 200000.00     │
 * │ Mouse        │ 2              │ 15              │ 7500.00       │
 * │ Monitor      │ 1              │ 2               │ 20000.00      │
 * │ Keyboard     │ 2              │ 5               │ 7500.00       │
 * │ Headphones   │ 1              │ 4               │ 8000.00       │
 * └──────────────┴────────────────┴─────────────────┴───────────────┘
 */

-- ============================================================================
-- SCENARIO 7: CUSTOMER BEHAVIOR — Purchase Patterns
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Understand customer purchase behavior and loyalty
 */

-- Customer purchase summary
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.tier,
    COUNT(s.sale_id) AS total_orders,
    SUM(s.quantity) AS total_items,
    SUM(s.quantity * s.unit_price) AS total_spent,
    ROUND(AVG(s.quantity * s.unit_price), 2) AS avg_order_value,
    MIN(s.sale_date) AS first_purchase,
    MAX(s.sale_date) AS last_purchase
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.city, c.tier
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┬───────────┬────────┬──────────────┬─────────────┬─────────────┬──────────────────┬────────────────┬────────────────┐
 * │ customer_id │ customer_name │ city      │ tier   │ total_orders │ total_items │ total_spent │ avg_order_value  │ first_purchase │ last_purchase  │
 * ├─────────────┼───────────────┼───────────┼────────┼──────────────┼─────────────┼─────────────┼──────────────────┼────────────────┼────────────────┤
 * │ 1           │ Rajesh        │ Mumbai    │ Gold   │ 4            │ 16          │ 114500.00   │ 28625.00         │ 2024-01-05     │ 2024-03-10     │
 * │ 3           │ Amit          │ Bangalore │ Gold   │ 3            │ 8           │ 103000.00   │ 34333.33         │ 2024-01-15     │ 2024-03-05     │
 * │ 2           │ Priya         │ Delhi     │ Silver │ 3            │ 17          │ 25500.00    │ 8500.00          │ 2024-01-10     │ 2024-02-20     │
 * │ 4           │ Neha          │ Mumbai    │ Bronze │ 0            │ 0           │ 0.00        │ NULL             │ NULL           │ NULL           │
 * │ 5           │ Suresh        │ Delhi     │ Silver │ 0            │ 0           │ 0.00        │ NULL             │ NULL           │ NULL           │
 * └─────────────┴───────────────┴───────────┴────────┴──────────────┴─────────────┴─────────────┴──────────────────┴────────────────┴────────────────┘
 */

-- ============================================================================
-- SCENARIO 8: INVENTORY MANAGEMENT — Stock Level Analysis
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Analyze which products need restocking based on sales velocity
 */

SELECT 
    product_name,
    category,
    SUM(quantity) AS total_sold,
    COUNT(DISTINCT sale_month) AS months_active,
    ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT sale_month), 1) AS avg_monthly_demand,
    CASE 
        WHEN SUM(quantity) > 20 THEN 'High Demand - Restock Soon'
        WHEN SUM(quantity) > 10 THEN 'Medium Demand - Monitor'
        ELSE 'Low Demand - No urgent action'
    END AS restock_priority
FROM sales
GROUP BY product_name, category
ORDER BY total_sold DESC;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬────────────┬───────────────┬─────────────────────┬──────────────────────────────┐
 * │ product_name │ category     │ total_sold │ months_active │ avg_monthly_demand  │ restock_priority             │
 * ├──────────────┼──────────────┼────────────┼───────────────┼─────────────────────┼──────────────────────────────┤
 * │ Mouse        │ Electronics  │ 15         │ 2             │ 7.5                 │ Medium Demand - Monitor      │
 * │ USB Cable    │ Accessories  │ 20         │ 1             │ 20.0                │ High Demand - Restock Soon   │
 * │ Laptop       │ Electronics  │ 4          │ 3             │ 1.3                 │ Low Demand - No urgent action│
 * │ Keyboard     │ Electronics  │ 5          │ 2             │ 2.5                 │ Low Demand - No urgent action│
 * │ Headphones   │ Accessories  │ 4          │ 1             │ 4.0                 │ Low Demand - No urgent action│
 * │ Monitor      │ Electronics  │ 2          │ 1             │ 2.0                 │ Low Demand - No urgent action│
 * └──────────────┴──────────────┴────────────┴───────────────┴─────────────────────┴──────────────────────────────┘
 */

-- ============================================================================
-- SCENARIO 9: EMPLOYEE PERFORMANCE — Hours and Productivity
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Identify top performers and those who need support
 */

SELECT 
    employee_name,
    project,
    role,
    years_experience,
    hours_logged,
    CASE 
        WHEN hours_logged > 130 THEN 'Top Performer'
        WHEN hours_logged > 100 THEN 'Good Performance'
        WHEN hours_logged > 0 THEN 'Needs Improvement'
        ELSE 'Inactive'
    END AS performance_rating
FROM employees
ORDER BY hours_logged DESC NULLS LAST;

/**
 * OUTPUT:
 * ┌───────────────┬─────────┬───────────┬───────────────────┬──────────────┬─────────────────────┐
 * │ employee_name │ project │ role      │ years_experience  │ hours_logged │ performance_rating  │
 * ├───────────────┼─────────┼───────────┼───────────────────┼──────────────┼─────────────────────┤
 * │ Heidi         │ Gamma   │ Developer │ 5.0               │ 150          │ Top Performer       │
 * │ Ivan          │ Gamma   │ QA        │ 6.0               │ 140          │ Top Performer       │
 * │ Grace         │ Beta    │ Developer │ 4.0               │ 130          │ Top Performer       │
 * │ Bob           │ Alpha   │ QA        │ 5.0               │ 120          │ Good Performance    │
 * │ Frank         │ Beta    │ Developer │ 3.0               │ 110          │ Good Performance    │
 * │ Carol         │ Alpha   │ Developer │ 7.0               │ 105          │ Good Performance    │
 * │ Alice         │ Alpha   │ Developer │ 3.0               │ 100          │ Good Performance    │
 * │ Eve           │ Beta    │ Manager   │ 2.0               │ 80           │ Needs Improvement   │
 * │ Dave          │ Alpha   │ Manager   │ NULL              │ 0            │ Inactive            │
 * │ Hank          │ Beta    │ Developer │ 3.0               │ NULL         │ Inactive            │
 * └───────────────┴─────────┴───────────┴───────────────────┴──────────────┴─────────────────────┘
 */

-- ============================================================================
-- SCENARIO 10: FINANCIAL REPORTING — Revenue and Profit Analysis
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Calculate total revenue, average order value, and monthly trends
 */

SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units,
    SUM(quantity * unit_price) AS revenue,
    ROUND(AVG(quantity * unit_price), 2) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;

/**
 * OUTPUT:
 * ┌─────────┬──────────────┬─────────────┬─────────────┬──────────────────┬───────────────────┐
 * │ month   │ total_orders │ total_units │ revenue     │ avg_order_value  │ unique_customers  │
 * ├─────────┼──────────────┼─────────────┼─────────────┼──────────────────┼───────────────────┤
 * │ 2024-01 │ 4            │ 11          │ 114500.00   │ 28625.00         │ 3                 │
 * │ 2024-02 │ 4            │ 36          │ 53000.00    │ 13250.00         │ 3                 │
 * │ 2024-03 │ 2            │ 3           │ 51500.00    │ 25750.00         │ 2                 │
 * └─────────┴──────────────┴─────────────┴─────────────┴──────────────────┴───────────────────┘
 * 
 * BUSINESS INSIGHT:
 * - January had highest revenue (₹114,500) due to laptop sales
 * - February had most units sold (36) but lower revenue (accessories)
 * - March revenue recovered with laptop sales
 */

-- ============================================================================
-- SCENARIO 11: CUSTOMER SEGMENTATION — Group by Behavior
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Segment customers based on their purchase behavior
 */

SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_spent,
    ROUND(AVG(total_orders), 1) AS avg_orders
FROM (
    SELECT 
        c.customer_id,
        COALESCE(SUM(s.quantity * s.unit_price), 0) AS total_spent,
        COUNT(s.sale_id) AS total_orders,
        CASE 
            WHEN COALESCE(SUM(s.quantity * s.unit_price), 0) > 50000 THEN 'High Value'
            WHEN COALESCE(SUM(s.quantity * s.unit_price), 0) > 10000 THEN 'Medium Value'
            WHEN COALESCE(SUM(s.quantity * s.unit_price), 0) > 0 THEN 'Low Value'
            ELSE 'Inactive'
        END AS customer_segment
    FROM customers c
    LEFT JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
) AS customer_analysis
GROUP BY customer_segment
ORDER BY avg_spent DESC;

/**
 * OUTPUT:
 * ┌──────────────────┬────────────────┬─────────────┬────────────┐
 * │ customer_segment │ customer_count │ avg_spent   │ avg_orders │
 * ├──────────────────┼────────────────┼─────────────┼────────────┤
 * │ High Value       │ 2              │ 108750.00   │ 3.5        │
 * │ Medium Value     │ 1              │ 25500.00    │ 3.0        │
 * │ Inactive         │ 2              │ 0.00        │ 0.0        │
 * └──────────────────┴────────────────┴─────────────┴────────────┘
 * 
 * BUSINESS INSIGHT:
 * - 2 High Value customers (Rajesh, Amit) → Priority for retention
 * - 1 Medium Value customer (Priya) → Encourage to upgrade
 * - 2 Inactive customers (Neha, Suresh) → Send re-engagement campaign
 */

-- ============================================================================
-- SCENARIO 12: TREND ANALYSIS — Monthly and Quarterly Trends
-- ============================================================================

/**
 * BUSINESS PROBLEM:
 * Analyze business trends over time (monthly, quarterly)
 */

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    COUNT(*) AS orders,
    SUM(quantity * unit_price) AS revenue,
    LAG(SUM(quantity * unit_price), 1) OVER (ORDER BY MIN(sale_date)) AS previous_month_revenue,
    ROUND(((SUM(quantity * unit_price) - LAG(SUM(quantity * unit_price), 1) OVER (ORDER BY MIN(sale_date))) * 100.0 / 
          NULLIF(LAG(SUM(quantity * unit_price), 1) OVER (ORDER BY MIN(sale_date)), 0)), 1) AS growth_pct
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date), TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY year, quarter, month;

/**
 * OUTPUT:
 * ┌──────┬─────────┬─────────┬────────┬─────────────┬────────────────────────┬────────────┐
 * │ year │ quarter │ month   │ orders │ revenue     │ previous_month_revenue │ growth_pct │
 * ├──────┼─────────┼─────────┼────────┼─────────────┼────────────────────────┼────────────┤
 * │ 2024 │ 1       │ 2024-01 │ 4      │ 114500.00   │ NULL                   │ NULL       │
 * │ 2024 │ 1       │ 2024-02 │ 4      │ 53000.00    │ 114500.00              │ -53.7      │
 * │ 2024 │ 1       │ 2024-03 │ 2      │ 51500.00    │ 53000.00               │ -2.8       │
 * └──────┴─────────┴─────────┴────────┴─────────────┴────────────────────────┴────────────┘
 * 
 * BUSINESS INSIGHT:
 * - February saw 53.7% decline in revenue from January
 * - March revenue stabilized (only -2.8% decline)
 * - Need to investigate what caused the February drop
 */

-- ============================================================================
-- QUICK REFERENCE: Real-World Scenario Patterns
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COMMON BUSINESS PATTERNS                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. RESOURCE PLANNING:                                                   │
 * │    HAVING SUM(hours) > threshold OR COUNT(*) < min_team_size           │
 * │                                                                          │
 * │ 2. CONVERSION RATES:                                                    │
 * │    COUNT(CASE WHEN condition THEN 1 END) * 100.0 / COUNT(*)            │
 * │                                                                          │
 * │ 3. MARKETING ATTRIBUTION:                                               │
 * │    GROUP BY referrer, COUNT(*), COUNT(DISTINCT user)                   │
 * │                                                                          │
 * │ 4. DUPLICATE DETECTION:                                                 │
 * │    HAVING COUNT(*) > 1                                                 │
 * │                                                                          │
 * │ 5. PERFORMANCE DASHBOARD:                                               │
 * │    Multiple CASE statements inside COUNT                               │
 * │                                                                          │
 * │ 6. SALES ANALYSIS:                                                      │
 * │    SUM(quantity * price) AS revenue                                    │
 * │                                                                          │
 * │ 7. CUSTOMER SEGMENTATION:                                               │
 * │    CASE WHEN total_spent > X THEN 'Segment' END                        │
 * │                                                                          │
 * │ 8. INVENTORY MANAGEMENT:                                                │
 * │    SUM(quantity) AS total_sold, CASE WHEN > threshold THEN 'Action'    │
 * │                                                                          │
 * │ 9. TREND ANALYSIS:                                                      │
 * │    LAG() OVER (ORDER BY date) for month-over-month comparison          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ WHAT YOU LEARNED:                                                       │
 * │                                                                          │
 * │ 1. Resource Planning → Use HAVING with SUM and COUNT                   │
 * │ 2. Conversion Rates → Use CASE inside COUNT with percentage calculation│
 * │ 3. Marketing Attribution → GROUP BY with COALESCE for NULL handling    │
 * │ 4. Duplicate Detection → HAVING COUNT(*) > 1                           │
 * │ 5. Performance Dashboards → Multiple CASE statements in one query      │
 * │ 6. Sales Analysis → SUM(quantity * price) for revenue                  │
 * │ 7. Customer Segmentation → Nested CASE statements with subqueries      │
 * │ 8. Inventory Management → Demand forecasting with business rules       │
 * │ 9. Trend Analysis → Window functions (LAG) for growth calculation     │
 * │                                                                          │
 * │ KEY TAKEAWAYS:                                                          │
 * │                                                                          │
 * │ - Real-world problems need COMBINATION of SQL concepts                 │
 * │ - GROUP BY + HAVING + CASE = Powerful analytical tool                  │
 * │ - Always think about the BUSINESS QUESTION first                       │
 * │ - NULL handling (COALESCE) is crucial for accurate reporting           │
 * │ - Window functions help with trend analysis                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF REAL-WORLD SCENARIOS GUIDE
-- ============================================================================