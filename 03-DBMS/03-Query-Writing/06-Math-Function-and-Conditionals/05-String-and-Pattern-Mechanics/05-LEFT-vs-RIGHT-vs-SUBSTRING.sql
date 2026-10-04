/**
 * ============================================================================
 * LEFT, RIGHT, SUBSTRING - COMPLETE REVISION GUIDE
 * (Extracting parts of strings, 1-based indexing)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE LEFT, RIGHT, SUBSTRING? ----------- (Extracting string parts)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 1-based indexing (important rule!)
 * 
 * 2. REAL-WORLD SCENARIOS ----------------------- (Practical examples)
 *    - 2.1 Extracting department codes (LEFT)
 *    - 2.2 Getting file extensions (RIGHT)
 *    - 2.3 Extracting years from a format (SUBSTRING)
 *    - 2.4 Extracting country codes (LEFT)
 *    - 2.5 Masking sensitive data (combining functions)
 * 
 * 3. LEFT() vs RIGHT() vs SUBSTRING() ----------- (Comparison)
 * 
 * 4. COMMON MISTAKES ---------------------------- (What to avoid)
 * 
 * 5. GOLDEN RULES ------------------------------- (Key principles)
 * 
 * 6. QUICK REFERENCE CARD ----------------------- (Cheat sheet)
 * 
 * 7. PRACTICE EXERCISES ------------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT ARE LEFT, RIGHT, SUBSTRING?
-- ============================================================================

/**
 * These functions extract parts of strings based on character positions.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LEFT, RIGHT, SUBSTRING - EXPLANATION                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ LEFT(string, n)      → first n characters (from left)           │   │
 * │   │ RIGHT(string, n)     → last n characters (from right)           │   │
 * │   │ SUBSTRING(string, start, length) → extract from position        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  IMPORTANT: SQL uses 1-based indexing!                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 *   │   │ Position:  1   2   3   4   5   6   7   8   9                  │   │
 * │   │ Character:  p   l   u   s   _   u   s   e   r                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ LEFT('plus_user', 3)           → 'plu'                          │   │
 * │   │ RIGHT('plus_user', 4)          → 'user'                         │   │
 * │   │ SUBSTRING('plus_user', 3)      → 'us_user' (position 3 to end)  │   │
 * │   │ SUBSTRING('plus_user', 3, 2)   → 'us'   (2 chars from pos 3)    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- LEFT example: first 3 characters
SELECT LEFT('plus_user', 3) AS left_3;

/**
 * OUTPUT:
 * ┌────────┐
 * │ left_3 │
 * ├────────┤
 * │ plu    │
 * └────────┘
 */

-- RIGHT example: last 4 characters
SELECT RIGHT('plus_user', 4) AS right_4;

/**
 * OUTPUT:
 * ┌────────┐
 * │ right_4│
 * ├────────┤
 * │ user   │
 * └────────┘
 */

-- SUBSTRING example: from position 3 to end
SELECT SUBSTRING('plus_user', 3) AS from_position_3;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ from_position_3 │
 * ├─────────────────┤
 * │ us_user         │
 * └─────────────────┘
 * 
 * EXPLANATION: Starts at position 3 ('u') and goes to end
 */

-- SUBSTRING example: from position 3, length 2
SELECT SUBSTRING('plus_user', 3, 2) AS from_3_len_2;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ from_3_len_2  │
 * ├───────────────┤
 * │ us            │
 * └───────────────┘
 * 
 * EXPLANATION: Takes 2 characters starting from position 3
 */

-- ============================================================================
-- 1.2 1-based indexing (Important Rule!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              1-BASED INDEXING - VISUAL GUIDE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   String: "plus_user"                                                   │
 * │                                                                          │
 * │   ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐              │
 * │   │  p  │  l  │  u  │  s  │  _  │  u  │  s  │  e  │  r  │              │
 * │   └─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘              │
 * │   ↑     ↑     ↑     ↑     ↑     ↑     ↑     ↑     ↑                     │
 * │   1     2     3     4     5     6     7     8     9                     │
 * │                                                                          │
 * │   ⚠️  NOT zero-based! First character is position 1, not 0!            │
 * │                                                                          │
 * │   SUBSTRING('plus_user', 0, 2) → May return empty or error!            │
 * │   SUBSTRING('plus_user', 1, 2) → 'pl' (correct)                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate 1-based indexing
SELECT 
    SUBSTRING('plus_user', 1, 2) AS positions_1_2,
    SUBSTRING('plus_user', 2, 2) AS positions_2_3,
    SUBSTRING('plus_user', 3, 2) AS positions_3_4;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬─────────────┐
 * │ positions_1_2│ positions_2_3│ positions_3_4│
 * ├─────────────┼─────────────┼─────────────┤
 * │ pl          │ lu          │ us          │
 * └─────────────┴─────────────┴─────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: USER_ACCOUNTS
-- ============================================================================

CREATE TABLE user_accounts (
    id INT PRIMARY KEY,
    account_code VARCHAR(50),
    phone_number VARCHAR(50),
    filename VARCHAR(100)
);

INSERT INTO user_accounts (id, account_code, phone_number, filename) VALUES
(1, 'MKT-2023-001', '+91-9876543210', 'invoice_001.pdf'),
(2, 'ENG-2024-045', '+1-555019922', 'schema_final.sql'),
(3, 'FIN-2022-112', '+44-20794601', 'budget_report.xlsx');

-- Display data
SELECT id, account_code, phone_number, filename FROM user_accounts ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬───────────────┬─────────────────┬─────────────────────┐
 * │ id │ account_code  │ phone_number    │ filename            │
 * ├────┼───────────────┼─────────────────┼─────────────────────┤
 * │ 1  │ MKT-2023-001  │ +91-9876543210  │ invoice_001.pdf     │
 * │ 2  │ ENG-2024-045  │ +1-555019922    │ schema_final.sql    │
 * │ 3  │ FIN-2022-112  │ +44-20794601    │ budget_report.xlsx  │
 * └────┴───────────────┴─────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 2: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Extracting Department Codes (LEFT)
 * 
 * Every account code starts with a 3-letter department code.
 * Extract the department from the account_code.
 */

SELECT 
    account_code, 
    LEFT(account_code, 3) AS dept_code
FROM user_accounts;

/**
 * OUTPUT:
 * ┌───────────────┬───────────┐
 * │ account_code  │ dept_code │
 * ├───────────────┼───────────┤
 * │ MKT-2023-001  │ MKT       │
 * │ ENG-2024-045  │ ENG       │
 * │ FIN-2022-112  │ FIN       │
 * └───────────────┴───────────┘
 * 
 * EXPLANATION: Department is the first 3 characters of account_code
 */

/**
 * SCENARIO 2: Getting File Extensions (RIGHT)
 * 
 * Identify the file type by extracting the extension from filename
 */

SELECT 
    filename, 
    RIGHT(filename, 3) AS extension_short,
    RIGHT(filename, 4) AS extension_long
FROM user_accounts;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────┬────────────────┐
 * │ filename            │ extension_short │ extension_long │
 * ├─────────────────────┼─────────────────┼────────────────┤
 * │ invoice_001.pdf     │ pdf             │ .pdf           │
 * │ schema_final.sql    │ sql             │ .sql           │
 * │ budget_report.xlsx  │ lsx             │ .xlsx          │
 * └─────────────────────┴─────────────────┴────────────────┘
 * 
 * EXPLANATION: 
 * - .pdf: last 3 chars = 'pdf', last 4 chars = '.pdf'
 * - .sql: last 3 chars = 'sql', last 4 chars = '.sql'
 * - .xlsx: last 3 chars = 'lsx', last 4 chars = 'xlsx' (no dot)
 *   (xlsx extension is 4 characters, so last 4 gives 'xlsx')
 */

/**
 * SCENARIO 3: Extracting Years from a Format (SUBSTRING)
 * 
 * The year is stored in the middle of account_code
 * Format: DEPT-YYYY-NNN (e.g., MKT-2023-001)
 * Year starts at position 5, length 4
 */

SELECT 
    account_code, 
    SUBSTRING(account_code, 5, 4) AS creation_year
FROM user_accounts;

/**
 * OUTPUT:
 * ┌───────────────┬───────────────┐
 * │ account_code  │ creation_year │
 * ├───────────────┼───────────────┤
 * │ MKT-2023-001  │ 2023          │
 * │ ENG-2024-045  │ 2024          │
 * │ FIN-2022-112  │ 2022          │
 * └───────────────┴───────────────┘
 * 
 * EXPLANATION: 
 * Position: 1=M, 2=K, 3=T, 4=-, 5=2, 6=0, 7=2, 8=3, ...
 * SUBSTRING from position 5, length 4 gives '2023'
 */

/**
 * SCENARIO 4: Extracting Country Codes (LEFT)
 * 
 * Country codes in phone numbers are at the beginning
 * Extract first 3 characters (including the + sign)
 */

SELECT 
    phone_number, 
    LEFT(phone_number, 3) AS country_prefix
FROM user_accounts;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┐
 * │ phone_number    │ country_prefix  │
 * ├─────────────────┼─────────────────┤
 * │ +91-9876543210  │ +91             │
 * │ +1-555019922    │ +1-             │
 * │ +44-20794601    │ +44             │
 * └─────────────────┴─────────────────┘
 * 
 * EXPLANATION: 
 * - +91: first 3 chars = '+91'
 * - +1-: first 3 chars = '+1-' (includes the hyphen)
 * - +44: first 3 chars = '+44'
 */

/**
 * SCENARIO 5: Masking Sensitive Data (Combining functions)
 * 
 * Show only last 4 digits of phone numbers for security
 * Use RIGHT to get last digits, CONCAT to add stars
 */

SELECT 
    phone_number, 
    CONCAT('******', RIGHT(phone_number, 4)) AS masked_phone
FROM user_accounts;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┐
 * │ phone_number    │ masked_phone    │
 * ├─────────────────┼─────────────────┤
 * │ +91-9876543210  │ ******3210      │
 * │ +1-555019922    │ ******9922      │
 * │ +44-20794601    │ ******4601      │
 * └─────────────────┴─────────────────┘
 * 
 * EXPLANATION: 
 * - RIGHT(phone_number, 4) extracts last 4 digits
 * - CONCAT adds 6 stars in front
 */

-- More masking examples
SELECT 
    filename,
    CONCAT(LEFT(filename, 5), '...', RIGHT(filename, 4)) AS masked_filename
FROM user_accounts;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────────┐
 * │ filename            │ masked_filename     │
 * ├─────────────────────┼─────────────────────┤
 * │ invoice_001.pdf     │ invoi....pdf        │
 * │ schema_final.sql    │ schem....sql        │
 * │ budget_report.xlsx  │ budge....xlsx       │
 * └─────────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 3: LEFT() vs RIGHT() vs SUBSTRING() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LEFT() vs RIGHT() vs SUBSTRING()                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Function           │ Extracts               │ Best for              │ │
 * │ ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ LEFT(string, n)    │ First n characters     │ Prefixes, codes,      │ │
 * │ │                    │ (from beginning)       │ department IDs        │ │
 * │ ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ RIGHT(string, n)   │ Last n characters      │ Suffixes, extensions, │ │
 * │ │                    │ (from end)             │ last digits           │ │
 * │ ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ SUBSTRING(s, p, l) │ From position p,       │ Middle parts,         │ │
 * │ │                    │ length l               │ fixed formats         │ │
 * │ └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   VISUAL EXAMPLE ON "ABCDEFGH":                                          │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ LEFT('ABCDEFGH', 3)  → 'ABC'                                       ││
 *   │ RIGHT('ABCDEFGH', 3) → 'FGH'                                       ││
 *   │ SUBSTRING('ABCDEFGH', 3, 2) → 'CD'                                 ││
 *   │                                                                     ││
 *   │   String:  A  B  C  D  E  F  G  H                                  ││
 *   │            ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑                                  ││
 *   │ Position:  1  2  3  4  5  6  7  8                                  ││
 *   │                                                                     ││
 *   │ LEFT(3)   →  A  B  C                                                ││
 *   │ RIGHT(3)  →              F  G  H                                    ││
 *   │ SUBSTRING(3,2) →  C  D                                              ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Side-by-side comparison
SELECT 
    'ABCDEFGH' AS original,
    LEFT('ABCDEFGH', 3) AS left_3,
    RIGHT('ABCDEFGH', 3) AS right_3,
    SUBSTRING('ABCDEFGH', 3, 2) AS substring_3_2;

/**
 * OUTPUT:
 * ┌──────────┬────────┬────────┬───────────────┐
 * │ original │ left_3 │ right_3 │ substring_3_2 │
 * ├──────────┼────────┼────────┼───────────────┤
 * │ ABCDEFGH │ ABC    │ FGH    │ CD            │
 * └──────────┴────────┴────────┴───────────────┘
 */

-- ============================================================================
-- PART 4: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using position 0 instead of 1 (zero-based indexing)        │
 * │                                                                          │
 * │   ❌ SUBSTRING('plus_user', 0, 2) → empty or error                     │
 * │   ✅ SUBSTRING('plus_user', 1, 2) → 'pl'                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong - position 0
SELECT SUBSTRING('plus_user', 0, 2) AS position_zero;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ position_zero│
 * ├──────────────┤
 * │ (empty)      │
 * └──────────────┘
 */

-- ✅ Correct - position 1
SELECT SUBSTRING('plus_user', 1, 2) AS position_one;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ position_one│
 * ├─────────────┤
 * │ pl          │
 * └─────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Asking for more characters than exist                      │
 * │                                                                          │
 * │   LEFT('abc', 100) → 'abc' (returns all, no error)                     │
 * │   RIGHT('abc', 100) → 'abc' (returns all, no error)                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    LEFT('abc', 100) AS left_100,
    RIGHT('abc', 100) AS right_100;

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ left_100│ right_100│
 * ├─────────┼──────────┤
 * │ abc     │ abc      │
 * └─────────┴──────────┘
 * 
 * EXPLANATION: SQL safely returns all characters without error
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting that spaces, hyphens, dots are characters       │
 * │                                                                          │
 * │   'MKT-2023-001' has 11 characters (including the hyphens)             │
 * │   Hyphens are at positions 4 and 9                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Show all character positions including hyphens
SELECT 
    account_code,
    SUBSTRING(account_code, 1, 1) AS pos1,
    SUBSTRING(account_code, 2, 1) AS pos2,
    SUBSTRING(account_code, 3, 1) AS pos3,
    SUBSTRING(account_code, 4, 1) AS pos4,
    SUBSTRING(account_code, 5, 1) AS pos5
FROM user_accounts
WHERE id = 1;

/**
 * OUTPUT:
 * ┌──────────────┬──────┬──────┬──────┬──────┬──────┐
 * │ account_code │ pos1 │ pos2 │ pos3 │ pos4 │ pos5 │
 * ├──────────────┼──────┼──────┼──────┼──────┼──────┤
 * │ MKT-2023-001 │ M    │ K    │ T    │ -    │ 2    │
 * └──────────────┴──────┴──────┴──────┴──────┴──────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Negative indexing (not supported in all databases)         │
 * │                                                                          │
 * │   Some databases allow SUBSTRING(str, -3) for last 3 characters        │
 * │   But for compatibility, use RIGHT(str, 3) instead                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Recommended: Use RIGHT for end-of-string extraction
SELECT RIGHT('plus_user', 4) AS safe_way;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ safe_way │
 * ├──────────┤
 * │ user     │
 * └──────────┘
 */

-- ============================================================================
-- PART 5: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: SQL uses 1-based indexing                                      │
 * │         → First character is position 1, NOT 0                         │
 * │         → SUBSTRING(str, 1, n) = LEFT(str, n)                          │
 * │                                                                          │
 * │ RULE 2: Use LEFT() for prefixes                                        │
 * │         → Department codes, country codes, prefixes                    │
 * │                                                                          │
 * │ RULE 3: Use RIGHT() for suffixes                                       │
 * │         → File extensions, last digits, suffixes                       │
 * │                                                                          │
 * │ RULE 4: Use SUBSTRING() for middle parts                               │
 * │         → Fixed-position data, like YYYY-MM-DD                         │
 * │                                                                          │
 * │ RULE 5: Always count separators (spaces, hyphens, dots)                │
 * │         → They are characters too!                                     │
 * │                                                                          │
 * │ RULE 6: Safe to ask for more characters than exist                     │
 * │         → Returns all characters without error                         │
 * │                                                                          │
 * │ RULE 7: Combine functions for complex extraction                       │
 * │         → CONCAT(LEFT(...), RIGHT(...)) for masking                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 6: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ LEFT():                                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LEFT('Hello World', 5)   → 'Hello'                                 ││
 * │ │ LEFT('ABCDEF', 3)        → 'ABC'                                   ││
 * │ │ LEFT('123456', 2)        → '12'                                    ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ RIGHT():                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ RIGHT('Hello World', 5)  → 'World'                                 ││
 * │ │ RIGHT('ABCDEF', 3)       → 'DEF'                                   ││
 * │ │ RIGHT('123456', 2)       → '56'                                    ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ SUBSTRING():                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ SUBSTRING('Hello World', 7, 5) → 'World'                           ││
 * │ │ SUBSTRING('ABCDEF', 3, 2)      → 'CD'                               ││
 * │ │ SUBSTRING('123456', 2, 3)      → '234'                              ││
 * │ │ SUBSTRING('plus_user', 3)      → 'us_user' (to end)                 ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Extract first 3 characters (dept code)                          ││
 * │ │ LEFT(account_code, 3)                                              ││
 * │ │                                                                     ││
 * │ │ -- Extract last 4 digits (masked phone)                            ││
 * │ │ CONCAT('****', RIGHT(phone, 4))                                    ││
 * │ │                                                                     ││
 * │ │ -- Extract middle (year from YYYY-MM-DD)                           ││
 * │ │ SUBSTRING(date_string, 1, 4)                                       ││
 * │ │                                                                     ││
 * │ │ -- Get file extension                                               ││
 * │ │ RIGHT(filename, 3)                                                 ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ INDEXING RULE:                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ Position:  1   2   3   4   5   6   7   8   9                       ││
 * │ │ Character:  p   l   u   s   _   u   s   e   r                       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Extract first 3 characters of 'Database'
 * 
 * Answer:
 *   SELECT LEFT('Database', 3);
 */

/**
 * EXERCISE 2: Extract last 4 characters of 'report_2024.pdf'
 * 
 * Answer:
 *   SELECT RIGHT('report_2024.pdf', 4);
 */

/**
 * EXERCISE 3: Extract characters 4-6 from 'ABCDEFGHIJ'
 * 
 * Answer:
 *   SELECT SUBSTRING('ABCDEFGHIJ', 4, 3);
 */

/**
 * EXERCISE 4: Get the file extension from 'document.xlsx'
 * 
 * Answer:
 *   SELECT RIGHT('document.xlsx', 4);
 */

/**
 * EXERCISE 5: Mask credit card '1234567890123456' to show only last 4 digits
 * 
 * Answer:
 *   SELECT CONCAT('************', RIGHT('1234567890123456', 4));
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS user_accounts;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. LEFT(string, n) = First n characters (prefix)                       │
 * │    → Use for: department codes, country codes, prefixes                │
 * │                                                                          │
 * │ 2. RIGHT(string, n) = Last n characters (suffix)                       │
 * │    → Use for: file extensions, last digits, suffixes                   │
 * │                                                                          │
 * │ 3. SUBSTRING(string, start, length) = Extract from position            │
 * │    → Use for: fixed-position data, middle parts                        │
 * │    → If length omitted, goes to end                                    │
 * │                                                                          │
 * │ 4. ⚠️  CRITICAL: 1-based indexing                                     │
 * │    → First character is position 1 (not 0)                             │
 * │                                                                          │
 * │ 5. Safe to request more characters than exist                          │
 * │    → Returns all available characters (no error)                       │
 * │                                                                          │
 * │ 6. Spaces, hyphens, dots ARE characters                                │
 * │    → Count them in position calculations                               │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - LEFT for beginning                                                 │
 * │   - RIGHT for end                                                      │
 * │   - SUBSTRING for middle                                               │
 * │   - Position starts at 1                                               │
 * │   - Combine functions for complex extractions                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF LEFT, RIGHT, SUBSTRING REVISION GUIDE
-- ============================================================================