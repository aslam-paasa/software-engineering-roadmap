/**
 * Understanding VARCHAR vs TEXT:
 * > Both VARCHAR and TEXT are used to store STRING (text) data.
 * > VARCHAR(n) has a max length limit, TEXT has no limit. 
 * > Both store text/strings.
 * 
 * > VARCHAR(n) limits characters to n. 
 * > TEXT has no limit but might be slower. 
 * > Use VARCHAR for short text (names, codes), TEXT for long content 
 *   (descriptions, comments).
*/

/**
 * Q. Select name (VARCHAR 100) and description (TEXT) from products. 
 *    Notice VARCHAR has length limits, TEXT does not.
*/

/**
 * Example Table:
 * → name = short text → VARCHAR
 * → description = long text → TEXT
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),     -- max 100 characters
    description TEXT       -- no fixed limit
);