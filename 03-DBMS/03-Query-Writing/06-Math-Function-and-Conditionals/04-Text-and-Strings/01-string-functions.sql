/**
 * ============================================================================
 * STRING FUNCTIONS - COMPLETE BEGINNER'S GUIDE
 * (CONCAT, LOWER, UPPER, TRIM, LENGTH, LEFT, RIGHT, SUBSTRING, LOCATE, REPLACE, LIKE)
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE STRING FUNCTIONS? ----------------- (Why we need them)
 * 2. COLLATION ---------------------------------- (How SQL compares text)
 * 3. CONCAT() and CONCAT_WS() ------------------- (Joining strings)
 * 4. LOWER() and UPPER() ------------------------ (Changing case)
 * 5. TRIM(), LTRIM(), RTRIM() ------------------- (Removing spaces)
 * 6. LENGTH() vs CHAR_LENGTH() ------------------ (Bytes vs characters)
 * 7. LEFT(), RIGHT(), SUBSTRING() --------------- (Extracting parts)
 * 8. LOCATE() / INSTR() ------------------------- (Finding position)
 * 9. REPLACE() ---------------------------------- (Find and replace)
 * 10. LIKE Pattern Matching ---------------------- (% and _ wildcards)
 * 11. REAL-WORLD SCENARIOS ---------------------- (Practical examples)
 * 12. COMMON MISTAKES --------------------------- (What to avoid)
 * 13. GOLDEN RULES ------------------------------ (Key principles)
 * 14. QUICK REFERENCE CARD ---------------------- (Cheat sheet)
 * 15. PRACTICE EXERCISES ------------------------ (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLE FOR ALL EXAMPLES
-- ============================================================================

CREATE TABLE sales (
    item VARCHAR(30) NOT NULL,
    quantity INT DEFAULT NULL
);

INSERT INTO sales (item, quantity) VALUES
('Laptop', 5),
('laptop', 3),
('LAPTOP', 2),
('  Mouse  ', 10),
('Keyboard', 8),
('Monitor', 0),
('café', 1),
('cafe', 2),
('😀 Smiley', 1);

-- Display the data
SELECT item, quantity FROM sales ORDER BY item;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┐
 * │ item        │ quantity │
 * ├─────────────┼──────────┤
 * │   Mouse     │ 10       │
 * │ LAPTOP      │ 2        │
 * │ Laptop      │ 5        │
 * │ Monitor     │ 0        │
 * │ cafe        │ 2        │
 * │ café        │ 1        │
 * │ keyboard    │ 8        │
 * │ 😀 Smiley   │ 1        │
 * └─────────────┴──────────┘
 */

-- ============================================================================
-- PART 1: WHAT ARE STRING FUNCTIONS?
-- ============================================================================

/**
 * In real databases, text data is rarely clean or consistent.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHY STRING FUNCTIONS?                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEMS YOU WILL SEE:                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Different letter cases (Apple, apple, APPLE)                   │   │
 * │   │ • Accents (café, cafe)                                           │   │
 * │   │ • Extra spaces ("  Mouse  ")                                      │   │
 * │   │ • Mixed formats                                                  │   │
 * │   │ • Special characters and emojis (😀)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   String functions help us:                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Normalize text (standardize case, remove spaces)            │   │
 * │   │ 2. Format text for display                                      │   │
 * │   │ 3. Filter text data (search patterns)                           │   │
 * │   │ 4. Compare text correctly                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: COLLATION (How SQL compares text)
-- ============================================================================

/**
 * COLLATION defines the rules for comparing and sorting strings.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS COLLATION?                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   COLLATION answers questions like:                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Is "Apple" equal to "apple"?                                  │   │
 * │   │ • Is "café" equal to "cafe"?                                    │   │
 * │   │ • Which comes first: "Zoo" or "apple"?                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   COLLATION FLAGS:                                                      │
 * │   ┌────────────┬─────────────────┬────────────────────────────────────┐│
 * │   │ Flag       │ Meaning         │ Example                            ││
 * │   ├────────────┼─────────────────┼────────────────────────────────────┤│
 * │   │ ai         │ Accent-Insensitive │ cafe = café (equal)             ││
 * │   │ as         │ Accent-Sensitive   │ cafe ≠ café (not equal)         ││
 * │   │ ci         │ Case-Insensitive   │ Apple = apple (equal)           ││
 * │   │ cs         │ Case-Sensitive     │ Apple ≠ apple (not equal)       ││
 * │   └────────────┴─────────────────┴────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate case sensitivity with LIKE (depends on collation)
SELECT item FROM sales WHERE item = 'Laptop';
-- May return 'Laptop', 'laptop', 'LAPTOP' depending on collation

-- ============================================================================
-- PART 3: CONCAT() and CONCAT_WS() (Joining strings)
-- ============================================================================

/**
 * CONCAT() joins strings as-is. Returns NULL if any argument is NULL.
 * CONCAT_WS() joins strings with a separator. Skips NULL values.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CONCAT() and CONCAT_WS()                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT 'Hello' || ' ' || 'Raj' AS basic_concat;                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: Hello Raj                                                    │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT 'Hello' || NULL || 'Raj' AS concat_with_null;            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: NULL (any NULL makes whole result NULL)                     │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT CONCAT_WS(' ', 'Hello', NULL, 'Raj') AS concat_ws;       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: Hello Raj (NULL skipped)                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- CONCAT examples (PostgreSQL uses ||)
SELECT 'Hello' || ' ' || 'Raj' AS basic_concat;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ basic_concat│
 * ├─────────────┤
 * │ Hello Raj   │
 * └─────────────┘
 */

-- CONCAT with NULL
SELECT 'Hello' || NULL || 'Raj' AS concat_with_null;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ concat_with_null │
 * ├──────────────────┤
 * │ NULL             │
 * └──────────────────┘
 */

-- CONCAT_WS (with separator) - PostgreSQL uses CONCAT_WS
SELECT CONCAT_WS(' ', 'Hello', NULL, 'Raj') AS concat_ws;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ concat_ws │
 * ├───────────┤
 * │ Hello Raj │
 * └───────────┘
 * 
 * EXPLANATION: NULL is skipped, separator only between real values
 */

-- CONCAT_WS with dot separator
SELECT CONCAT_WS('. ', NULL, 'Hi', 'Raj') AS concat_ws_dot;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ concat_ws_dot │
 * ├───────────────┤
 * │ Hi. Raj       │
 * └───────────────┘
 */

-- ============================================================================
-- PART 4: LOWER() and UPPER() (Changing case)
-- ============================================================================

/**
 * LOWER() converts text to lowercase.
 * UPPER() converts text to uppercase.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LOWER() and UPPER()                                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LOWER('RAjstriveR') AS lower_result;                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: rajstriver                                                   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT UPPER('RAjstriveR') AS upper_result;                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: RAJSTRIVER                                                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT LOWER('RAjstriveR') AS lower_result;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ lower_result │
 * ├──────────────┤
 * │ rajstriver   │
 * └──────────────┘
 */

SELECT UPPER('RAjstriveR') AS upper_result;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ upper_result │
 * ├──────────────┤
 * │ RAJSTRIVER   │
 * └──────────────┘
 */

-- Practical: Standardize case for comparison
SELECT item, LOWER(item) AS item_lowercase FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────────┐
 * │ item        │ item_lowercase  │
 * ├─────────────┼─────────────────┤
 * │   Mouse     │    mouse        │
 * │ LAPTOP      │ laptop          │
 * │ Laptop      │ laptop          │
 * │ Monitor     │ monitor         │
 * │ cafe        │ cafe            │
 * │ café        │ café            │
 * │ keyboard    │ keyboard        │
 * │ 😀 Smiley   │ 😀 smiley       │
 * └─────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 5: TRIM(), LTRIM(), RTRIM() (Removing spaces)
-- ============================================================================

/**
 * TRIM() removes spaces from both sides.
 * LTRIM() removes spaces from left only.
 * RTRIM() removes spaces from right only.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              TRIM() Functions                                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT TRIM('  RAJ  ') AS trimmed;                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: RAJ                                                         │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LTRIM(' RAJ ') AS left_trimmed;                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: RAJ (space removed from left only)                         │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT RTRIM(' RAJ ') AS right_trimmed;                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT:  RAJ (space removed from right only)                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT TRIM('  RAJ  ') AS trimmed;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ trimmed │
 * ├─────────┤
 * │ RAJ     │
 * └─────────┘
 */

SELECT LTRIM(' RAJ ') AS left_trimmed;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ left_trimmed │
 * ├──────────────┤
 * │ RAJ          │
 * └──────────────┘
 */

SELECT RTRIM(' RAJ ') AS right_trimmed;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ right_trimmed │
 * ├───────────────┤
 * │  RAJ          │
 * └───────────────┘
 */

-- Practical: Clean the item column
SELECT item, TRIM(item) AS cleaned_item FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬──────────────┐
 * │ item        │ cleaned_item │
 * ├─────────────┼──────────────┤
 * │   Mouse     │ Mouse        │
 * │ LAPTOP      │ LAPTOP       │
 * │ Laptop      │ Laptop       │
 * │ Monitor     │ Monitor      │
 * │ cafe        │ cafe         │
 * │ café        │ café         │
 * │ keyboard    │ keyboard     │
 * │ 😀 Smiley   │ 😀 Smiley    │
 * └─────────────┴──────────────┘
 */

-- ============================================================================
-- PART 6: LENGTH() vs CHAR_LENGTH() (Bytes vs characters)
-- ============================================================================

/**
 * LENGTH() returns number of BYTES.
 * CHAR_LENGTH() returns number of CHARACTERS.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LENGTH() vs CHAR_LENGTH()                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LENGTH('RAJ') AS bytes, CHAR_LENGTH('RAJ') AS chars;     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: bytes=3, chars=3                                            │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LENGTH('é') AS bytes, CHAR_LENGTH('é') AS chars;         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: bytes=2, chars=1 (é takes 2 bytes in UTF-8)               │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LENGTH('😀') AS bytes, CHAR_LENGTH('😀') AS chars;       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: bytes=4, chars=1 (emoji takes 4 bytes)                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Regular ASCII characters
SELECT LENGTH('RAJ') AS bytes, CHAR_LENGTH('RAJ') AS chars;

/**
 * OUTPUT:
 * ┌───────┬───────┐
 * │ bytes │ chars │
 * ├───────┼───────┤
 * │ 3     │ 3     │
 * └───────┴───────┘
 */

-- Accented character
SELECT LENGTH('é') AS bytes, CHAR_LENGTH('é') AS chars;

/**
 * OUTPUT:
 * ┌───────┬───────┐
 * │ bytes │ chars │
 * ├───────┼───────┤
 * │ 2     │ 1     │
 * └───────┴───────┘
 */

-- Emoji
SELECT LENGTH('😀') AS bytes, CHAR_LENGTH('😀') AS chars;

/**
 * OUTPUT:
 * ┌───────┬───────┐
 * │ bytes │ chars │
 * ├───────┼───────┤
 * │ 4     │ 1     │
 * └───────┴───────┘
 */

-- Practical: Check item name lengths
SELECT item, LENGTH(item) AS byte_length, CHAR_LENGTH(item) AS char_length 
FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬────────────┐
 * │ item        │ byte_length │ char_length│
 * ├─────────────┼─────────────┼────────────┤
 * │   Mouse     │ 9           │ 9          │
 * │ LAPTOP      │ 6           │ 6          │
 * │ Laptop      │ 6           │ 6          │
 * │ Monitor     │ 7           │ 7          │
 * │ cafe        │ 4           │ 4          │
 * │ café        │ 5           │ 4          │
 * │ keyboard    │ 8           │ 8          │
 * │ 😀 Smiley   │ 11          │ 9          │
 * └─────────────┴─────────────┴────────────┘
 * 
 * NOTE: café has 5 bytes but 4 characters (é is 2 bytes)
 * 😀 Smiley: emoji is 4 bytes, space and letters are 1 byte each
 */

-- ============================================================================
-- PART 7: LEFT(), RIGHT(), SUBSTRING() (Extracting parts)
-- ============================================================================

/**
 * LEFT(str, n) - first n characters
 * RIGHT(str, n) - last n characters
 * SUBSTRING(str, start, len) - slice from position
 * 
 * Note: PostgreSQL uses 1-based indexing
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LEFT(), RIGHT(), SUBSTRING()                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LEFT('plus_user', 3) AS left_3;                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: plu                                                        │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT RIGHT('plus_user', 4) AS right_4;                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: user                                                       │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT SUBSTRING('plus_user', 3) AS from_3;                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: us_user                                                    │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT SUBSTRING('plus_user', 3, 2) AS from_3_len_2;            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: us                                                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT LEFT('plus_user', 3) AS left_3;

/**
 * OUTPUT:
 * ┌────────┐
 * │ left_3 │
 * ├────────┤
 * │ plu    │
 * └────────┘
 */

SELECT RIGHT('plus_user', 4) AS right_4;

/**
 * OUTPUT:
 * ┌────────┐
 * │ right_4│
 * ├────────┤
 * │ user   │
 * └────────┘
 */

SELECT SUBSTRING('plus_user', 3) AS from_3;

/**
 * OUTPUT:
 * ┌────────┐
 * │ from_3 │
 * ├────────┤
 * │ us_user│
 * └────────┘
 */

SELECT SUBSTRING('plus_user', 3, 2) AS from_3_len_2;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ from_3_len_2  │
 * ├───────────────┤
 * │ us            │
 * └───────────────┘
 */

-- Practical: Extract first 3 characters of item names
SELECT item, LEFT(TRIM(item), 3) AS first_3_chars FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┐
 * │ item        │ first_3_chars │
 * ├─────────────┼───────────────┤
 * │   Mouse     │ Mou           │
 * │ LAPTOP      │ LAP           │
 * │ Laptop      │ Lap           │
 * │ Monitor     │ Mon           │
 * │ cafe        │ caf           │
 * │ café        │ caf           │
 * │ keyboard    │ key           │
 * │ 😀 Smiley   │ 😀 S          │
 * └─────────────┴───────────────┘
 */

-- ============================================================================
-- PART 8: LOCATE() / INSTR() (Finding position)
-- ============================================================================

/**
 * LOCATE(substr, str) - returns position of substring (1-based)
 * INSTR(str, substr) - same thing, different argument order
 * Returns 0 if not found
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LOCATE() / INSTR()                                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT LOCATE('@', 'Raj@gmail.com') AS position;               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: 4                                                          │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT INSTR('Raj@gmail.com', '@') AS position;                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: 4                                                          │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT INSTR('Raj@gmail.com', '7') AS position;                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: 0 (not found)                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT LOCATE('@', 'Raj@gmail.com') AS position;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ position │
 * ├──────────┤
 * │ 4        │
 * └──────────┘
 */

SELECT INSTR('Raj@gmail.com', '@') AS position;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ position │
 * ├──────────┤
 * │ 4        │
 * └──────────┘
 */

SELECT INSTR('Raj@gmail.com', '7') AS position;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ position │
 * ├──────────┤
 * │ 0        │
 * └──────────┘
 */

-- Practical: Find items containing 'top'
SELECT item FROM sales WHERE INSTR(LOWER(item), 'top') > 0;

/**
 * OUTPUT:
 * ┌────────┐
 * │ item   │
 * ├────────┤
 * │ LAPTOP │
 * │ Laptop │
 * └────────┘
 */

-- ============================================================================
-- PART 9: REPLACE() (Find and replace)
-- ============================================================================

/**
 * REPLACE(str, old_substring, new_substring)
 * Replaces ALL occurrences of old_substring with new_substring.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              REPLACE()                                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT REPLACE('a_b_c', '_', '-') AS replaced;                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   OUTPUT: a-b-c                                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT REPLACE('a_b_c', '_', '-') AS replaced;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ replaced │
 * ├──────────┤
 * │ a-b-c    │
 * └──────────┘
 */

-- Practical: Replace spaces with underscores
SELECT item, REPLACE(TRIM(item), ' ', '_') AS no_spaces FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┐
 * │ item        │ no_spaces   │
 * ├─────────────┼─────────────┤
 * │   Mouse     │ Mouse       │
 * │ LAPTOP      │ LAPTOP      │
 * │ Laptop      │ Laptop      │
 * │ Monitor     │ Monitor     │
 * │ cafe        │ cafe        │
 * │ café        │ café        │
 * │ keyboard    │ keyboard    │
 * │ 😀 Smiley   │ 😀_Smiley   │
 * └─────────────┴─────────────┘
 */

-- ============================================================================
-- PART 10: LIKE Pattern Matching (% and _ wildcards)
-- ============================================================================

/**
 * LIKE is used for pattern matching.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LIKE Pattern Matching                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   WILDCARDS:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ % = any length (zero or more characters)                        │   │
 * │   │ _ = exactly one character                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 'plus_user' LIKE 'plus%'  → TRUE (starts with 'plus')         │   │
 * │   │ 'plus1user' LIKE 'plus_us_r' → TRUE (matches pattern)          │   │
 * │   │ 'plus_user' LIKE 'plus\_user' → FALSE (_ is escaped)           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Starts with 'lap' (case-sensitive depends on collation)
SELECT item FROM sales WHERE item LIKE 'lap%';

/**
 * OUTPUT:
 * ┌────────┐
 * │ item   │
 * ├────────┤
 * │ Laptop │
 * └────────┘
 */

-- Contains 'top' anywhere
SELECT item FROM sales WHERE item LIKE '%top%';

/**
 * OUTPUT:
 * ┌────────┐
 * │ item   │
 * ├────────┤
 * │ LAPTOP │
 * │ Laptop │
 * └────────┘
 */

-- Pattern matching with _ (single character)
SELECT 'plus1user' LIKE 'plus_us_r' AS matches;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ matches │
 * ├─────────┤
 * │ true    │
 * └─────────┘
 */

-- Escaping wildcards
SELECT 'plus_user' LIKE 'plus\_user' AS matches;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ matches │
 * ├─────────┤
 * │ false   │
 * └─────────┘
 */

-- Case-insensitive search using LOWER()
SELECT item FROM sales WHERE LOWER(item) LIKE '%top%';

/**
 * OUTPUT:
 * ┌────────┐
 * │ item   │
 * ├────────┤
 * │ LAPTOP │
 * │ Laptop │
 * └────────┘
 */

-- ============================================================================
-- PART 11: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Clean and Standardize Product Names
 * 
 * Remove spaces, convert to proper case, and remove accents
 */

SELECT 
    TRIM(item) AS cleaned,
    UPPER(TRIM(item)) AS upper_case,
    LOWER(TRIM(item)) AS lower_case
FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬─────────────┐
 * │ cleaned     │ upper_case  │ lower_case  │
 * ├─────────────┼─────────────┼─────────────┤
 * │ Mouse       │ MOUSE       │ mouse       │
 * │ LAPTOP      │ LAPTOP      │ laptop      │
 * │ Laptop      │ LAPTOP      │ laptop      │
 * │ Monitor     │ MONITOR     │ monitor     │
 * │ cafe        │ CAFE        │ cafe        │
 * │ café        │ CAFÉ        │ café        │
 * │ keyboard    │ KEYBOARD    │ keyboard    │
 * │ 😀 Smiley   │ 😀 SMILEY   │ 😀 smiley   │
 * └─────────────┴─────────────┴─────────────┘
 */

/**
 * SCENARIO 2: Extract Domain from Email
 * 
 * Using SUBSTRING and LOCATE to get domain part
 */

CREATE TEMP TABLE users (email VARCHAR(100));
INSERT INTO users VALUES ('raj@gmail.com'), ('sneha@yahoo.com'), ('amit@company.co.in');

SELECT 
    email,
    SUBSTRING(email, LOCATE('@', email) + 1) AS domain
FROM users;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────┐
 * │ email               │ domain          │
 * ├─────────────────────┼─────────────────┤
 * │ raj@gmail.com       │ gmail.com       │
 * │ sneha@yahoo.com     │ yahoo.com       │
 * │ amit@company.co.in  │ company.co.in   │
 * └─────────────────────┴─────────────────┘
 */

/**
 * SCENARIO 3: Find Potential Duplicates (Case-insensitive)
 * 
 * Group by lowercase version to find duplicates
 */

SELECT 
    LOWER(TRIM(item)) AS normalized_item,
    COUNT(*) AS count,
    STRING_AGG(item, ', ') AS original_values
FROM sales
GROUP BY LOWER(TRIM(item))
HAVING COUNT(*) > 1;

/**
 * OUTPUT:
 * ┌─────────────────┬───────┬─────────────────────────┐
 * │ normalized_item │ count │ original_values         │
 * ├─────────────────┼───────┼─────────────────────────┤
 * │ laptop          │ 3     │ LAPTOP, Laptop, laptop  │
 * └─────────────────┴───────┴─────────────────────────┘
 * 
 * EXPLANATION: 'laptop', 'LAPTOP', 'Laptop' are treated as same
 */

/**
 * SCENARIO 4: Validate Email Format (Basic)
 * 
 * Check if email contains @ and .
 */

SELECT 
    email,
    CASE 
        WHEN email LIKE '%@%.%' THEN 'Valid Format'
        ELSE 'Invalid Format'
    END AS email_status
FROM users;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────┐
 * │ email               │ email_status    │
 * ├─────────────────────┼─────────────────┤
 * │ raj@gmail.com       │ Valid Format    │
 * │ sneha@yahoo.com     │ Valid Format    │
 * │ amit@company.co.in  │ Valid Format    │
 * └─────────────────────┴─────────────────┘
 */

/**
 * SCENARIO 5: Create Username from Email
 * 
 * Extract part before @
 */

SELECT 
    email,
    LEFT(email, LOCATE('@', email) - 1) AS username
FROM users;

/**
 * OUTPUT:
 * ┌─────────────────────┬──────────┐
 * │ email               │ username │
 * ├─────────────────────┼──────────┤
 * │ raj@gmail.com       │ raj      │
 * │ sneha@yahoo.com     │ sneha    │
 * │ amit@company.co.in  │ amit     │
 * └─────────────────────┴──────────┘
 */

DROP TABLE users;

-- ============================================================================
-- PART 12: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Assuming LENGTH() counts characters                        │
 * │                                                                          │
 * │   ❌ LENGTH('é') returns 2 (bytes), not 1 (characters)                 │
 * │   ✅ Use CHAR_LENGTH() for character count                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong assumption
SELECT LENGTH('é') AS bytes, CHAR_LENGTH('é') AS chars;

/**
 * OUTPUT:
 * ┌───────┬───────┐
 * │ bytes │ chars │
 * ├───────┼───────┤
 * │ 2     │ 1     │
 * └───────┴───────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using = NULL instead of IS NULL with CONCAT               │
 * │                                                                          │
 * │   CONCAT('Hello', NULL, 'Raj') returns NULL, not 'Hello Raj'           │
 * │   ✅ Use CONCAT_WS() which skips NULLs                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Returns NULL
SELECT 'Hello' || NULL || 'Raj' AS result;

-- ✅ Returns 'Hello Raj'
SELECT CONCAT_WS(' ', 'Hello', NULL, 'Raj') AS result;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting to TRIM before comparison                       │
 * │                                                                          │
 * │   '  Mouse  ' = 'Mouse' is FALSE                                       │
 * │   ✅ TRIM('  Mouse  ') = 'Mouse'                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ False
SELECT '  Mouse  ' = 'Mouse' AS is_equal;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ is_equal│
 * ├─────────┤
 * │ false   │
 * └─────────┘
 */

-- ✅ True
SELECT TRIM('  Mouse  ') = 'Mouse' AS is_equal;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ is_equal│
 * ├─────────┤
 * │ true    │
 * └─────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Case sensitivity in LIKE (depends on collation)            │
 * │                                                                          │
 * │   'Laptop' LIKE 'lap%' may return FALSE if case-sensitive              │
 * │   ✅ Use LOWER(item) LIKE 'lap%' for case-insensitive                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 13: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Always TRIM user input before comparison                       │
 * │         → Spaces cause false mismatches                                 │
 * │                                                                          │
 * │ RULE 2: Use LOWER() or UPPER() for case-insensitive comparison         │
 * │         → LOWER(item) = LOWER('Laptop')                                │
 * │                                                                          │
 * │ RULE 3: Use CHAR_LENGTH() for character count, LENGTH() for bytes      │
 * │         → Emojis and accents affect byte count                         │
 * │                                                                          │
 * │ RULE 4: Use CONCAT_WS() when NULLs might exist                         │
 * │         → CONCAT_WS skips NULLs, CONCAT returns NULL                   │
 * │                                                                          │
 * │ RULE 5: Escape wildcards when searching for literal % or _             │
 * │         → LIKE '%\_%' to find strings containing underscore           │
 * │                                                                          │
 * │ RULE 6: Use SUBSTRING with LOCATE for dynamic extraction               │
 * │         → Extract domain from email: SUBSTRING(email, LOCATE('@',...)) │
 * │                                                                          │
 * │ RULE 7: Remember string functions are usually case-sensitive           │
 * │         → Use LOWER() to normalize when needed                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 14: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ CONCAT & CONCAT_WS:                                                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 'Hello' || ' ' || 'World'  → Hello World                           ││
 * │ │ CONCAT_WS(' ', 'Hello', NULL, 'World') → Hello World               ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ CASE CONVERSION:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LOWER('SQL') → sql                                                  ││
 * │ │ UPPER('sql') → SQL                                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ TRIM FUNCTIONS:                                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ TRIM('  text  ') → text                                             ││
 * │ │ LTRIM('  text') → text                                              ││
 * │ │ RTRIM('text  ') → text                                              ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ LENGTH FUNCTIONS:                                                       │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LENGTH('café') → 5 (bytes)                                          ││
 * │ │ CHAR_LENGTH('café') → 4 (characters)                               ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ EXTRACTING:                                                             │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LEFT('string', 3) → str                                             ││
 * │ │ RIGHT('string', 3) → ing                                            ││
 * │ │ SUBSTRING('string', 2, 3) → tri                                     ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ FINDING:                                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LOCATE('@', 'email@domain.com') → 6                                 ││
 * │ │ INSTR('email@domain.com', '@') → 6                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ REPLACE:                                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ REPLACE('a_b_c', '_', '-') → a-b-c                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ LIKE PATTERNS:                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ '%' → any characters                                                ││
 * │ │ '_' → single character                                              ││
 * │ │ 'start%' → starts with 'start'                                      ││
 * │ │ '%end' → ends with 'end'                                            ││
 * │ │ '%middle%' → contains 'middle'                                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 15: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Convert all item names to uppercase
 * 
 * Answer:
 *   SELECT UPPER(item) FROM sales;
 */

/**
 * EXERCISE 2: Remove spaces from item names
 * 
 * Answer:
 *   SELECT TRIM(item) FROM sales;
 */

/**
 * EXERCISE 3: Find the position of 'a' in 'Database'
 * 
 * Answer:
 *   SELECT LOCATE('a', 'Database');
 */

/**
 * EXERCISE 4: Extract first 5 characters of each item
 * 
 * Answer:
 *   SELECT LEFT(item, 5) FROM sales;
 */

/**
 * EXERCISE 5: Find all items containing 'top' (case-insensitive)
 * 
 * Answer:
 *   SELECT item FROM sales WHERE LOWER(item) LIKE '%top%';
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS sales;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. CONCAT() / CONCAT_WS() - Join strings                               │
 * │    → CONCAT returns NULL if any NULL                                   │
 * │    → CONCAT_WS skips NULL values                                       │
 * │                                                                          │
 * │ 2. LOWER() / UPPER() - Change case                                     │
 * │    → Use for case-insensitive comparisons                              │
 * │                                                                          │
 * │ 3. TRIM() / LTRIM() / RTRIM() - Remove spaces                          │
 * │    → Always trim user input before comparison                          │
 * │                                                                          │
 * │ 4. LENGTH() vs CHAR_LENGTH()                                           │
 * │    → LENGTH = bytes, CHAR_LENGTH = characters                          │
 * │    → Important for Unicode (emojis, accents)                           │
 * │                                                                          │
 * │ 5. LEFT() / RIGHT() / SUBSTRING() - Extract parts                      │
 * │    → 1-based indexing                                                  │
 * │                                                                          │
 * │ 6. LOCATE() / INSTR() - Find position                                  │
 * │    → Returns 0 if not found                                            │
 * │                                                                          │
 * │ 7. REPLACE() - Find and replace                                        │
 * │    → Replaces ALL occurrences                                          │
 * │                                                                          │
 * │ 8. LIKE - Pattern matching                                             │
 * │    → % = any characters, _ = one character                             │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always trim spaces                                                 │
 * │   - Normalize case for comparison                                      │
 * │   - Use CHAR_LENGTH for user-visible characters                        │
 * │   - Escape wildcards when searching for literal % or _                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF STRING FUNCTIONS GUIDE
-- ============================================================================