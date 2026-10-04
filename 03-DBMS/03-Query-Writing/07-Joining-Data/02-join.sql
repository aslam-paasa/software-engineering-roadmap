-- ============================================================================
-- PART 2: WHAT IS A JOIN?
-- ============================================================================

/**
 * REAL LIFE EXAMPLE:
 * 
 * You have two notebooks:
 *   Notebook 1: Student names with Roll Numbers
 *   Notebook 2: Exam scores with Roll Numbers
 * 
 * To find which student got which score, you need to MATCH them by Roll Number.
 * This is exactly what a JOIN does!
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          WHAT IS A JOIN?                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   CUSTOMERS TABLE                    ORDERS TABLE                       │
 * │   ┌─────────────┬──────────┐        ┌──────────┬─────────────┐         │
 * │   │ customer_id │ name     │        │ order_id │ customer_id │         │
 * │   ├─────────────┼──────────┤        ├──────────┼─────────────┤         │
 * │   │    101      │ Aisha    │        │    1     │    101      │         │
 * │   │    102      │ Rohan    │        │    2     │    102      │         │
 * │   │    103      │ Meera    │        │    3     │    105      │         │
 * │   └─────────────┴──────────┘        └──────────┴─────────────┘         │
 * │                                                                          │
 * │   JOIN ON customer_id = customer_id                                     │
 * │                                                                          │
 * │   RESULT (Combined data):                                               │
 * │   ┌─────────────┬──────────┬──────────┬─────────────┐                  │
 * │   │ customer_id │ name     │ order_id │ customer_id │                  │
 * │   ├─────────────┼──────────┼──────────┼─────────────┤                  │
 * │   │    101      │ Aisha    │    1     │    101      │  ← MATCH!        │
 * │   │    102      │ Rohan    │    2     │    102      │  ← MATCH!        │
 * │   └─────────────┴──────────┴──────────┴─────────────┘                  │
 * │                                                                          │
 * │   Customer 103 has no order → depends on JOIN type                      │
 * │   Order 3 has customer 105 (not in customers) → depends on JOIN type    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * VISUAL REPRESENTATION OF ALL JOINS:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                        VISUAL JOIN REFERENCE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INNER JOIN                      LEFT JOIN                            │
 * │   ┌─────────────┐                 ┌─────────────┐                      │
 * │   │   ╔═════╗   │                 │   ╔═════════╗│                      │
 * │   │   ║ A∩B ║   │                 │   ║ A       ║│                      │
 * │   │   ╚═════╝   │                 │   ╚═════════╝│                      │
 * │   └─────────────┘                 └─────────────┘                      │
 * │   Only matching rows               All left + matching right           │
 * │                                                                          │
 * │   RIGHT JOIN                      FULL OUTER JOIN                      │
 * │   ┌─────────────┐                 ┌─────────────┐                      │
 * │   │┌═════════╗  │                 │┌═══════════┐│                      │
 * │   ││       B ║  │                 ││ A ∪ B     ││                      │
 * │   │└═════════╝  │                 │└═══════════┘│                      │
 * │   └─────────────┘                 └─────────────┘                      │
 * │   All right + matching left       All rows from both tables            │
 * │                                                                          │
 * │   CROSS JOIN                      SELF JOIN                            │
 * │   ┌─────────────┐                 ┌─────────────┐                      │
 * │   │  Every row  │                 │ Table joins │                      │
 * │   │  with every │                 │  with itself │                     │
 * │   │   other row │                 │             │                      │
 * │   └─────────────┘                 └─────────────┘                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */
