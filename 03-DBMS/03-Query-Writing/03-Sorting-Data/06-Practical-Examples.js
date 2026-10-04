/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: List countries from least to most populated
 *   SELECT country, population
 *   FROM countries
 *   ORDER BY population ASC;
 *   → Australia appears first, India last
 *
 * Example 2: Find the 3 countries with the largest area
 *   SELECT country, area
 *   FROM countries
 *   ORDER BY area DESC
 *   LIMIT 3;
 *   → Returns USA, Brazil, Australia
 *
 * Example 3: Find the single cheapest product
 *   SELECT product_name, price
 *   FROM products
 *   ORDER BY price ASC
 *   LIMIT 1;
 *   → Returns USB-C Cable ($15)
 *
 * Example 4: Sort products alphabetically by name
 *   SELECT product_name
 *   FROM products
 *   ORDER BY product_name ASC;
 *   → Curved Monitor, Ergonomic Chair, Gaming Mouse, ...
 *
 * Example 5: Sort by computed total value, highest first
 *   SELECT product_name, price * stock_quantity AS total_value
 *   FROM products
 *   ORDER BY total_value DESC;
 *   → Sorts by calculated column using the alias in ORDER BY
 *
 * Example 6: Top 2 products by stock in the Accessories category
 *   SELECT product_name, stock_quantity
 *   FROM products
 *   WHERE category = 'Accessories'
 *   ORDER BY stock_quantity DESC
 *   LIMIT 2;
 *   → Combines WHERE, ORDER BY, and LIMIT in the correct clause order
 *
 * Example 7: Sort by category, then alphabetically within each category
 *   SELECT product_name, category
 *   FROM products
 *   ORDER BY category ASC, product_name ASC;
 *   → Accessories: Gaming Mouse, Mechanical Keyboard
 *     Cables: USB-C Cable
 *     Electronics: Curved Monitor
 *     Furniture: Ergonomic Chair
 */
