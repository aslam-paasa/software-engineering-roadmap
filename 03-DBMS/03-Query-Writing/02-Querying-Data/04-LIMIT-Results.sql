/**
 * LIMIT Results:
 * > Control how many rows are returned. 
 * > Useful when working with large datasets or when you only need a 
 *   sample.
 * 
 * > LIMIT restricts the number of rows returned. 
 * > Great for previewing data or pagination.
 * > Note: Use LIMIT number at the end of your query
*/

/**
 * ORDER BY & LIMIT — Sorting results and capping row count
 *
 * What they do:
 *   ORDER BY → Sorts the result set based on one or more columns.
 *              Default is ASC (ascending: small → large, A → Z).
 *              Add DESC to reverse the order (large → small, Z → A).
 *
 *   LIMIT    → Returns only a fixed number of rows from the top of
 *              the result. Useful for "top N" queries.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find the top 2 countries by land area (largest first)           │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Step 1: Sort by area from largest to smallest (DESC).           │
 * │ Step 2: Return only the top 2 rows (LIMIT 2).                   │
 * │                                                                 │
 * │   SELECT country, area                                          │
 * │   FROM countries                                                │
 * │   ORDER BY area DESC                                            │
 * │   LIMIT 2;                                                      │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------+---------+                                           │
 * │ | country | area    |                                           │
 * │ +---------+---------+                                           │
 * │ | USA     | 9834000 |                                           │
 * │ | Brazil  | 8516000 |                                           │
 * │ +---------+---------+                                           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ OFFSET — Skip rows before starting to return results            │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ OFFSET is used together with LIMIT to paginate results.         │
 * │                                                                 │
 * │ To get rows 3–4 (skip the first 2, then take the next 2):       │
 * │                                                                 │
 * │   SELECT country, area                                          │
 * │   FROM countries                                                │
 * │   ORDER BY area DESC                                            │
 * │   LIMIT 2 OFFSET 2;                                             │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+---------+                                         │
 * │ | country   | area    |                                         │
 * │ +-----------+---------+                                         │
 * │ | Australia | 7692000 |                                         │
 * │ | China     | 4287000 |                                         │
 * │ +-----------+---------+                                         │
 * └─────────────────────────────────────────────────────────────────┘
 */
