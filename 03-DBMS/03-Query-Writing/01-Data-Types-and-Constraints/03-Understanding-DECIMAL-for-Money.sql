/**
 * Understanding DECIMAL for Money:
 * > DECIMAL(precision, scale) stores exact numbers. 
 * > Essential for money to avoid rounding errors.
 * 
 * > DECIMAL(10,2) stores exact numbers with 2 decimal places. 
 * > Never use FLOAT/REAL for money! 
 * > DECIMAL avoids rounding errors. 
 * > Our prices have exactly 2 decimal places.
*/

/**
 * Q. Select name and price from products. 
 *    Price is DECIMAL(10,2) - 10 total digits, 2 after decimal point.
*/

/**
* Example Table:
* → name = product name
* → price = exact money value
*/

CREATE TABLE products (
   product_id SERIAL PRIMARY KEY,
   name VARCHAR(100),
   price DECIMAL(10,2)   -- exact price with 2 decimal places
);