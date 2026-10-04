-- ============================================================================
-- PART 10: NATURAL JOIN (Auto join by column names)
-- ============================================================================

/**
 * NATURAL JOIN automatically joins tables on ALL columns with the same name.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          NATURAL JOIN                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - customers table:          INPUT - customer_loyalty table:     │
 * │   ┌─────────────┬──────────┐        ┌─────────────┬─────────┐           │
 * │   │ customer_id │ name     │        │ customer_id │ tier    │           │
 * │   ├─────────────┼──────────┤        ├─────────────┼─────────┤           │
 * │   │    101      │ Aisha    │        │    101      │ GOLD    │           │
 * │   │    102      │ Rohan    │        │    102      │ SILVER  │           │
 * │   │    103      │ Meera    │        │    104      │ BRONZE  │           │
 * │   │    104      │ Arjun    │        │    106      │ GOLD    │           │
 * │   └─────────────┴──────────┘        └─────────────┴─────────┘           │
 * │                                                                         │
 * │   NATURAL JOIN automatically joins on customer_id (same name)           │
 * │                                                                         │
 * │   OUTPUT:                                                               │
 * │   ┌─────────────┬──────────┬─────────┐                                  │
 * │   │ customer_id │ name     │ tier    │                                  │
 * │   ├─────────────┼──────────┼─────────┤                                  │
 * │   │    101      │ Aisha    │ GOLD    │                                  │
 * │   │    102      │ Rohan    │ SILVER  │                                  │
 * │   │    104      │ Arjun    │ BRONZE  │                                  │
 * │   │    106      │ Neha     │ GOLD    │                                  │
 * │   └─────────────┴──────────┴─────────┘                                  │
 * │                                                                         │
 * │   ⚠️⚠️  WARNING: NATURAL JOIN can be DANGEROUS!                        │
 * │   If both tables gain another same-named column (e.g., 'name'),         │
 * │   the join will silently start matching on both columns!                │
 * │   Always use EXPLICIT JOIN with ON condition for clarity.               │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Create customer_loyalty table
CREATE TEMP TABLE customer_loyalty (
    customer_id INT,
    tier VARCHAR(20)
);

INSERT INTO customer_loyalty VALUES
(101, 'GOLD'),
(102, 'SILVER'),
(104, 'BRONZE'),
(106, 'GOLD'),
(201, 'PINNACLE');

-- NATURAL JOIN (AUTO join on same column names)
SELECT 
    c.customer_id,
    c.name,
    cl.tier
FROM customers c
NATURAL JOIN customer_loyalty cl
ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬─────────┐
 * │ customer_id │ name     │ tier    │
 * ├─────────────┼──────────┼─────────┤
 * │    101      │ Aisha    │ GOLD    │
 * │    102      │ Rohan    │ SILVER  │
 * │    104      │ Arjun    │ BRONZE  │
 * │    106      │ Neha     │ GOLD    │
 * └─────────────┴──────────┴─────────┘
 * 
 * EXPLANATION:
 * - Automatically joined on customer_id (only common column name)
 * - Customer 103,107,108,109 have no loyalty record → not included
 * - Loyalty customer 201 has no customer record → not included
 */

-- Better way: EXPLICIT JOIN (RECOMMENDED)
SELECT 
    c.customer_id,
    c.name,
    cl.tier
FROM customers c
INNER JOIN customer_loyalty cl
    ON c.customer_id = cl.customer_id
ORDER BY c.customer_id;

-- Clean up
DROP TABLE customer_loyalty;

