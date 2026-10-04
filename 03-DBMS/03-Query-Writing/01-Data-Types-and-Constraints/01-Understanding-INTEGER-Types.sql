/**
 * Understanding INTEGER Types:
 * > Integers store whole numbers.
 * > Our database uses INTEGER for age, quantities, and IDs.
 * > INTEGER/INT stores:
 *   - whole numbers (-2147483648 to 2147483647). 
 *   - SERIAL is auto-incrementing integer. 
 * > Good for IDs, counts, ages.
*/

/**
 * Example: INTEGER DATA TYPE
 * > This table shows how INTEGER is used in real columns.
 */

CREATE TABLE users (
    user_id INTEGER,     -- stores whole number ID
    age INTEGER          -- stores whole number age
);
