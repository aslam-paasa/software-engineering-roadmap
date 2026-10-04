/**
 * ============================================================================
 * REPLACE() - COMPLETE REVISION GUIDE
 * (Find and replace substrings, case sensitivity)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS REPLACE()? ------------------------------ (Find and replace text)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 Case sensitivity (important!)
 * 
 * 2. REAL-WORLD SCENARIOS ---------------------------- (Practical examples)
 *    - 2.1 Updating domain names
 *    - 2.2 Reformatting category tags (underscore to hyphen)
 *    - 2.3 Removing specific words from text
 *    - 2.4 Swapping multiple characters (nested REPLACE)
 *    - 2.5 Masking sensitive parts of text
 * 
 * 3. SELECT vs UPDATE with REPLACE() ----------------- (Temporary vs Permanent)
 * 
 * 4. COMMON MISTAKES --------------------------------- (What to avoid)
 * 
 * 5. GOLDEN RULES ------------------------------------ (Key principles)
 * 
 * 6. QUICK REFERENCE CARD ---------------------------- (Cheat sheet)
 * 
 * 7. PRACTICE EXERCISES ------------------------------ (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT IS REPLACE()?
-- ============================================================================

/**
 * REPLACE() searches a string and replaces all occurrences of a substring.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    REPLACE() - EXPLANATION                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ REPLACE(string, string_to_replace, replacement_string)          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ REPLACE('a_b_c', '_', '-')     → 'a-b-c'                        │   │
 * │   │ REPLACE('Hello World', 'World', 'SQL') → 'Hello SQL'            │   │
 * │   │ REPLACE('apple apple', 'apple', 'orange') → 'orange orange'     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  IMPORTANT: REPLACE() is CASE-SENSITIVE in most databases!       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ REPLACE('Apple', 'apple', 'Orange') → 'Apple' (no change)       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic REPLACE example
SELECT REPLACE('a_b_c', '_', '-') AS replaced;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ replaced │
 * ├──────────┤
 * │ a-b-c    │
 * └──────────┘
 */

-- Replace multiple occurrences
SELECT REPLACE('apple apple apple', 'apple', 'orange') AS all_replaced;

/**
 * OUTPUT:
 * ┌─────────────────────────┐
 * │ all_replaced            │
 * ├─────────────────────────┤
 * │ orange orange orange    │
 * └─────────────────────────┘
 */

-- Replace word in sentence
SELECT REPLACE('Hello World', 'World', 'SQL') AS greeting;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ greeting    │
 * ├─────────────┤
 * │ Hello SQL   │
 * └─────────────┘
 */

-- ============================================================================
-- 1.2 Case Sensitivity (Important!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CASE SENSITIVITY - IMPORTANT TRAP                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   REPLACE() is CASE-SENSITIVE in most databases:                       │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ REPLACE('Apple', 'apple', 'Orange') → 'Apple' (no change)       │   │
 * │   │ REPLACE('Apple', 'Apple', 'Orange') → 'Orange' (matches case)   │   │
 * │   │                                                                  │   │
 * │   │ Solution: Use LOWER() or UPPER() to normalize case              │   │
 * │   │ REPLACE(LOWER(text), LOWER('apple'), 'orange')                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Case-sensitive example
SELECT 
    REPLACE('Apple', 'apple', 'Orange') AS case_sensitive,
    REPLACE('Apple', 'Apple', 'Orange') AS exact_case_match;

/**
 * OUTPUT:
 * ┌───────────────┬──────────────────┐
 * │ case_sensitive│ exact_case_match │
 * ├───────────────┼──────────────────┤
 * │ Apple         │ Orange           │
 * └───────────────┴──────────────────┘
 * 
 * EXPLANATION: 'apple' (lowercase) does not match 'Apple' (capital A)
 */

-- Case-insensitive using LOWER
SELECT REPLACE(LOWER('Apple'), LOWER('apple'), 'orange') AS case_insensitive;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ case_insensitive │
 * ├──────────────────┤
 * │ orange           │
 * └──────────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: SITE_CONTENT
-- ============================================================================

CREATE TABLE site_content (
    id INT PRIMARY KEY,
    page_url VARCHAR(200),
    category_tag VARCHAR(50),
    description TEXT
);

INSERT INTO site_content (id, page_url, category_tag, description) VALUES
(1, 'tuf.com/blog/sql-basics', 'Lvl_1', 'Learn SQL basics here.'),
(2, 'tuf.com/blog/joins-sql', 'Lvl_2', 'Master SQL joins.'),
(3, 'tuf.com/tools/sql-editor', 'Lvl_1', 'Try our SQL editor.'),
(4, 'oldbrand.com/home', 'Legacy', 'Visit oldbrand.');

-- Display data
SELECT id, page_url, category_tag, description FROM site_content ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────────┬─────────────┬─────────────────────────┐
 * │ id │ page_url                │ category_tag│ description             │
 * ├────┼─────────────────────────┼─────────────┼─────────────────────────┤
 * │ 1  │ tuf.com/blog/sql-basics │ Lvl_1       │ Learn SQL basics here.  │
 * │ 2  │ tuf.com/blog/joins-sql  │ Lvl_2       │ Master SQL joins.       │
 * │ 3  │ tuf.com/tools/sql-editor│ Lvl_1       │ Try our SQL editor.     │
 * │ 4  │ oldbrand.com/home       │ Legacy      │ Visit oldbrand.         │
 * └────┴─────────────────────────┴─────────────┴─────────────────────────┘
 */

-- ============================================================================
-- PART 2: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Updating Domain Names
 * 
 * Company moved from 'oldbrand.com' to 'newbrand.com'
 * Update the URL to show the new domain
 */

SELECT 
    page_url, 
    REPLACE(page_url, 'oldbrand.com', 'newbrand.com') AS updated_url
FROM site_content
WHERE id = 4;

/**
 * OUTPUT:
 * ┌─────────────────────┬───────────────────────┐
 * │ page_url            │ updated_url           │
 * ├─────────────────────┼───────────────────────┤
 * │ oldbrand.com/home   │ newbrand.com/home     │
 * └─────────────────────┴───────────────────────┘
 */

-- Update all URLs (temporary - SELECT only)
SELECT 
    page_url,
    REPLACE(page_url, 'tuf.com', 'takeuforward.org') AS new_domain
FROM site_content;

/**
 * OUTPUT:
 * ┌─────────────────────────┬─────────────────────────────────┐
 * │ page_url                │ new_domain                      │
 * ├─────────────────────────┼─────────────────────────────────┤
 * │ tuf.com/blog/sql-basics │ takeuforward.org/blog/sql-basics│
 * │ tuf.com/blog/joins-sql  │ takeuforward.org/blog/joins-sql │
 * │ tuf.com/tools/sql-editor│ takeuforward.org/tools/sql-editor│
 * │ oldbrand.com/home       │ oldbrand.com/home               │
 * └─────────────────────────┴─────────────────────────────────┘
 */

/**
 * SCENARIO 2: Reformatting Category Tags
 * 
 * Change underscores to hyphens for new naming convention
 */

SELECT 
    category_tag, 
    REPLACE(category_tag, '_', '-') AS new_tag
FROM site_content;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┐
 * │ category_tag│ new_tag │
 * ├─────────────┼─────────┤
 * │ Lvl_1       │ Lvl-1   │
 * │ Lvl_2       │ Lvl-2   │
 * │ Lvl_1       │ Lvl-1   │
 * │ Legacy      │ Legacy  │
 * └─────────────┴─────────┘
 * 
 * EXPLANATION: Underscore replaced with hyphen; 'Legacy' unchanged
 */

/**
 * SCENARIO 3: Removing Specific Words from Text
 * 
 * Remove the word "SQL" from descriptions to make them more general
 * Note: Include space to avoid breaking words like "SQLite"
 */

SELECT 
    description, 
    REPLACE(description, 'SQL ', '') AS short_description
FROM site_content;

/**
 * OUTPUT:
 * ┌─────────────────────────┬─────────────────────┐
 * │ description             │ short_description   │
 * ├─────────────────────────┼─────────────────────┤
 * │ Learn SQL basics here.  │ Learn basics here.  │
 * │ Master SQL joins.       │ Master joins.       │
 * │ Try our SQL editor.     │ Try our editor.     │
 * │ Visit oldbrand.         │ Visit oldbrand.     │
 * └─────────────────────────┴─────────────────────┘
 * 
 * EXPLANATION: 'SQL ' (with space) removed from descriptions
 */

-- Alternative: Remove just the word (without space)
SELECT 
    description,
    REPLACE(description, 'SQL', '') AS without_space_removal
FROM site_content
WHERE id = 1;

/**
 * OUTPUT:
 * ┌────────────────────────┬──────────────────────┐
 * │ description            │ without_space_removal│
 * ├────────────────────────┼──────────────────────┤
 * │ Learn SQL basics here. │ Learn  basics here.  │
 * └────────────────────────┴──────────────────────┘
 * 
 * NOTE: Double space appears where 'SQL' was removed
 */

/**
 * SCENARIO 4: Swapping Multiple Characters (Nested REPLACE)
 * 
 * Replace domain AND replace slashes with arrows
 */

SELECT 
    page_url,
    REPLACE(REPLACE(page_url, 'tuf.com', 'takeuforward.org'), '/', ' > ') AS breadcrumb
FROM site_content
WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────────┬─────────────────────────────────────┐
 * │ page_url                │ breadcrumb                          │
 * ├─────────────────────────┼─────────────────────────────────────┤
 * │ tuf.com/blog/sql-basics │ takeuforward.org > blog > sql-basics│
 * └─────────────────────────┴─────────────────────────────────────┘
 * 
 * EXPLANATION: 
 * - First REPLACE: 'tuf.com' → 'takeuforward.org'
 * - Second REPLACE: '/' → ' > '
 */

-- Multiple nested replacements example
SELECT 
    page_url,
    REPLACE(REPLACE(REPLACE(page_url, '.', ' DOT '), '/', ' SLASH '), '-', ' DASH ') AS encoded_url
FROM site_content
WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────────┬────────────────────────────────────────────────────────────┐
 * │ page_url                │ encoded_url                                                │
 * ├─────────────────────────┼────────────────────────────────────────────────────────────┤
 * │ tuf.com/blog/sql-basics │ tuf DOT com SLASH blog SLASH sql DASH basics              │
 * └─────────────────────────┴────────────────────────────────────────────────────────────┘
 */

/**
 * SCENARIO 5: Masking Sensitive Parts of Text
 * 
 * Hide middle part of a code for security
 */

SELECT 
    'SECURE-123-KEY' AS original,
    REPLACE('SECURE-123-KEY', '123', '***') AS masked;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┐
 * │ original        │ masked          │
 * ├─────────────────┼─────────────────┤
 * │ SECURE-123-KEY  │ SECURE-***-KEY  │
 * └─────────────────┴─────────────────┘
 */

-- Mask credit card numbers (show last 4 digits)
SELECT 
    '1234-5678-9012-3456' AS card_number,
    REPLACE('1234-5678-9012-3456', '1234-5678-9012', '****-****-****') AS masked_card;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────────────┐
 * │ card_number         │ masked_card             │
 * ├─────────────────────┼─────────────────────────┤
 * │ 1234-5678-9012-3456 │ ****-****-****-3456     │
 * └─────────────────────┴─────────────────────────┘
 */

-- ============================================================================
-- PART 3: SELECT vs UPDATE with REPLACE() - Temporary vs Permanent
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              SELECT vs UPDATE - IMPORTANT DISTINCTION                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SELECT with REPLACE():                                               │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Changes data ONLY in the query output                         │   │
 * │   │ • Does NOT modify the actual table                               │   │
 * │   │ • Temporary change for reporting                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   UPDATE with REPLACE():                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Permanently changes data in the table                         │   │
 *   │   │ • Cannot be undone (unless in transaction)                      │   │
 * │   │ • Permanent change to database                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- SELECT (temporary - does not change table)
SELECT 
    id,
    page_url,
    REPLACE(page_url, 'tuf.com', 'newdomain.com') AS temp_url
FROM site_content
WHERE id = 1;

-- Check original - still unchanged
SELECT page_url FROM site_content WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────────┐
 * │ page_url                │
 * ├─────────────────────────┤
 * │ tuf.com/blog/sql-basics │
 * └─────────────────────────┘
 * 
 * EXPLANATION: Original data remains unchanged
 */

-- UPDATE (permanent - changes table)
-- ⚠️  Be careful! This permanently changes data
-- UPDATE site_content 
-- SET page_url = REPLACE(page_url, 'oldbrand.com', 'newbrand.com')
-- WHERE id = 4;

-- After UPDATE, check the change
-- SELECT page_url FROM site_content WHERE id = 4;

-- To revert (if needed)
-- UPDATE site_content 
-- SET page_url = REPLACE(page_url, 'newbrand.com', 'oldbrand.com')
-- WHERE id = 4;

-- ============================================================================
-- PART 4: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Expecting REPLACE to modify the table                      │
 * │                                                                          │
 * │   ❌ SELECT REPLACE(column, 'old', 'new') FROM table                   │
 * │      → This does NOT change the table!                                 │
 * │                                                                          │
 * │   ✅ UPDATE table SET column = REPLACE(column, 'old', 'new')           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ This does NOT change the table
SELECT REPLACE(page_url, 'tuf.com', 'new.com') FROM site_content;

-- ✅ This changes the table (be careful!)
-- UPDATE site_content SET page_url = REPLACE(page_url, 'tuf.com', 'new.com');

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Case sensitivity issues                                    │
 * │                                                                          │
 * │   ❌ REPLACE('Apple', 'apple', 'Orange') → 'Apple' (no change)         │
 * │                                                                          │
 * │   ✅ REPLACE(LOWER('Apple'), LOWER('apple'), 'orange')                 │
 * │   ✅ REPLACE('Apple', 'Apple', 'Orange')                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ No change due to case mismatch
SELECT REPLACE('Apple', 'apple', 'Orange') AS no_change;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ no_change│
 * ├──────────┤
 * │ Apple    │
 * └──────────┘
 */

-- ✅ Case-insensitive approach
SELECT REPLACE(LOWER('Apple'), LOWER('apple'), 'orange') AS case_insensitive;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ case_insensitive │
 * ├──────────────────┤
 * │ orange           │
 * └──────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Unintended replacements (partial word matches)            │
 * │                                                                          │
 * │   ❌ REPLACE('category', 'cat', 'dog') → 'dogegory' (unintended!)      │
 * │                                                                          │
 * │   ✅ Be specific: REPLACE('category', 'cat ', 'dog ')                  │
 * │   ✅ Or use word boundaries if available                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Unintended replacement
SELECT REPLACE('category', 'cat', 'dog') AS unintended;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ unintended│
 * ├───────────┤
 * │ dogegory  │
 * └───────────┘
 * 
 * EXPLANATION: 'cat' inside 'category' was replaced
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: REPLACE with NULL values                                   │
 * │                                                                          │
 * │   REPLACE(NULL, 'a', 'b') → NULL                                       │
 * │   Always handle NULLs with COALESCE                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    REPLACE(NULL, 'a', 'b') AS null_returns_null,
    COALESCE(REPLACE(NULL, 'a', 'b'), 'Original is NULL') AS null_handled;

/**
 * OUTPUT:
 * ┌───────────────────┬────────────────────┐
 * │ null_returns_null │ null_handled       │
 * ├───────────────────┼────────────────────┤
 * │ NULL              │ Original is NULL   │
 * └───────────────────┴────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5: Forgetting that REPLACE replaces ALL occurrences          │
 * │                                                                          │
 * │   REPLACE('cat cat cat', 'cat', 'dog') → 'dog dog dog' (all 3)        │
 * │   If you want only first occurrence, use other methods                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- All occurrences are replaced
SELECT REPLACE('cat cat cat', 'cat', 'dog') AS all_replaced;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ all_replaced│
 * ├─────────────┤
 * │ dog dog dog │
 * └─────────────┘
 */

-- ============================================================================
-- PART 5: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: SELECT REPLACE() = Temporary change (display only)             │
 * │         → Does NOT modify the actual table                             │
 * │                                                                          │
 * │ RULE 2: UPDATE with REPLACE() = Permanent change                       │
 * │         → Use with WHERE to avoid updating all rows                    │
 * │         → Consider using transaction for safety                        │
 * │                                                                          │
 * │ RULE 3: REPLACE() is CASE-SENSITIVE                                    │
 * │         → Use LOWER() or UPPER() for case-insensitive replacement      │
 * │                                                                          │
 * │ RULE 4: REPLACE replaces ALL occurrences                               │
 * │         → No option for "replace first only"                           │
 * │                                                                          │
 * │ RULE 5: Be careful with partial word matches                           │
 * │         → 'cat' in 'category' will be replaced                         │
 * │         → Include spaces or use word boundaries                        │
 * │                                                                          │
 * │ RULE 6: NULL input → NULL output                                       │
 * │         → Use COALESCE to handle NULLs                                 │
 * │                                                                          │
 * │ RULE 7: Nest REPLACE for multiple replacements                         │
 * │         → REPLACE(REPLACE(text, 'a', 'b'), 'c', 'd')                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example: Safe UPDATE with WHERE clause
-- UPDATE site_content 
-- SET category_tag = REPLACE(category_tag, '_', '-')
-- WHERE category_tag LIKE '%\_%';

-- Example: Multiple replacements with nesting
SELECT 
    'Hello_World-SQL' AS original,
    REPLACE(REPLACE('Hello_World-SQL', '_', ' '), '-', ' ') AS cleaned;

/**
 * OUTPUT:
 * ┌─────────────────┬───────────────┐
 * │ original        │ cleaned       │
 * ├─────────────────┼───────────────┤
 * │ Hello_World-SQL │ Hello World SQL│
 * └─────────────────┴───────────────┘
 */

-- ============================================================================
-- PART 6: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ REPLACE() - Basic Usage:                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ REPLACE('a_b_c', '_', '-')       → 'a-b-c'                         ││
 * │ │ REPLACE('Hello World', 'World', 'SQL') → 'Hello SQL'               ││
 * │ │ REPLACE('apple apple', 'apple', 'orange') → 'orange orange'        ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Common Patterns:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Change domain in URL (temporary)                                ││
 * │ │ SELECT REPLACE(page_url, 'old.com', 'new.com') FROM pages;         ││
 * │ │                                                                     ││
 * │ │ -- Update domain permanently                                        ││
 * │ │ UPDATE pages SET page_url = REPLACE(page_url, 'old.com', 'new.com');││
 * │ │                                                                     ││
 * │ │ -- Replace multiple characters (nested)                            ││
 * │ │ REPLACE(REPLACE(text, '_', '-'), '/', '>')                         ││
 * │ │                                                                     ││
 * │ │ -- Case-insensitive replacement                                     ││
 * │ │ REPLACE(LOWER(text), LOWER('old'), 'new')                          ││
 * │ │                                                                     ││
 * │ │ -- Remove a word                                                    ││
 * │ │ REPLACE(description, 'unwanted ', '')                              ││
 * │ │                                                                     ││
 * │ │ -- Mask sensitive data                                              ││
 * │ │ REPLACE(credit_card, SUBSTRING(credit_card, 1, 12), '****-****-****')││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Important Notes:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ • CASE-SENSITIVE (use LOWER/UPPER for case-insensitive)           ││
 * │ │ • Replaces ALL occurrences                                         ││
 * │ │ • SELECT = temporary, UPDATE = permanent                           ││
 * │ │ • NULL input = NULL output                                         ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Replace all underscores with hyphens in 'first_name_last_name'
 * 
 * Answer:
 *   SELECT REPLACE('first_name_last_name', '_', '-');
 */

/**
 * EXERCISE 2: Change domain from 'example.com' to 'test.com' in URL
 * 
 * Answer:
 *   SELECT REPLACE('https://example.com/page', 'example.com', 'test.com');
 */

/**
 * EXERCISE 3: Remove the word 'unwanted' from 'This is unwanted text'
 * 
 * Answer:
 *   SELECT REPLACE('This is unwanted text', 'unwanted ', '');
 */

/**
 * EXERCISE 4: Replace both spaces and hyphens with underscores (nested)
 * 
 * Answer:
 *   SELECT REPLACE(REPLACE('Hello World-SQL', ' ', '_'), '-', '_');
 */

/**
 * EXERCISE 5: Permanently update all 'oldbrand.com' to 'newbrand.com' in URLs
 * 
 * Answer:
 *   UPDATE site_content SET page_url = REPLACE(page_url, 'oldbrand.com', 'newbrand.com');
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS site_content;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. REPLACE() = Find and replace text in strings                        │
 * │    → REPLACE(string, find, replace)                                    │
 * │                                                                          │
 * │ 2. SELECT with REPLACE() = Temporary (display only)                    │
 * │    → Does NOT change the actual table                                  │
 * │                                                                          │
 * │ 3. UPDATE with REPLACE() = Permanent (changes table)                   │
 * │    → Use WITH WHERE to avoid updating all rows                         │
 * │                                                                          │
 * │ 4. CASE-SENSITIVE: 'Apple' ≠ 'apple'                                   │
 * │    → Use LOWER() or UPPER() for case-insensitive                       │
 * │                                                                          │
 * │ 5. Replaces ALL occurrences (not just first)                           │
 * │                                                                          │
 * │ 6. Nest REPLACE() for multiple replacements                            │
 * │    → REPLACE(REPLACE(text, 'a', 'b'), 'c', 'd')                        │
 * │                                                                          │
 * │ 7. NULL input = NULL output                                            │
 * │    → Use COALESCE to handle NULLs                                      │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - SELECT = temporary (view only)                                     │
 * │   - UPDATE = permanent (changes data)                                  │
 * │   - Case matters                                                       │
 * │   - All occurrences replaced                                           │
 * │   - Be careful with partial word matches                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF REPLACE REVISION GUIDE
-- ============================================================================