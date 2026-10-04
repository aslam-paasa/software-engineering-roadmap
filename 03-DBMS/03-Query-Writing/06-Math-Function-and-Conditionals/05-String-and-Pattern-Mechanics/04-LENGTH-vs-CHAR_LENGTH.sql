/**
 * ============================================================================
 * LENGTH() vs CHAR_LENGTH() - COMPLETE REVISION GUIDE
 * (Bytes vs Characters, UTF-8 Encoding)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE LENGTH() and CHAR_LENGTH()? -------- (Bytes vs Characters)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 Why the difference matters (UTF-8 encoding)
 * 
 * 2. BYTES vs CHARACTERS - EXPLANATION ---------- (How computers store text)
 * 
 * 3. REAL-WORLD SCENARIOS ----------------------- (Practical examples)
 *    - 3.1 User-visible character counts
 *    - 3.2 Checking storage usage (bytes)
 *    - 3.3 Validating minimum character length
 *    - 3.4 Identifying "Special Character" rows
 *    - 3.5 Enforcing data limits (hard drive safety)
 * 
 * 4. LENGTH() vs CHAR_LENGTH() - COMPARISON ----- (When to use which)
 * 
 * 5. COMMON MISTAKES ---------------------------- (What to avoid)
 * 
 * 6. GOLDEN RULES ------------------------------- (Key principles)
 * 
 * 7. QUICK REFERENCE CARD ----------------------- (Cheat sheet)
 * 
 * 8. PRACTICE EXERCISES ------------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT ARE LENGTH() and CHAR_LENGTH()?
-- ============================================================================

/**
 * CHAR_LENGTH() counts the number of CHARACTERS (what humans see).
 * LENGTH() counts the number of BYTES (what computers store).
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LENGTH() vs CHAR_LENGTH() - EXPLANATION                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CHAR_LENGTH(string)  → number of CHARACTERS                     │   │
 * │   │ LENGTH(string)       → number of BYTES                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CHAR_LENGTH('RAJ') = 3    LENGTH('RAJ') = 3                      │   │
 * │   │ CHAR_LENGTH('é')   = 1    LENGTH('é')   = 2   (accented letter)  │   │
 * │   │ CHAR_LENGTH('😀')  = 1    LENGTH('😀')  = 4   (emoji)             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- English letters (1 byte per character)
SELECT 
    CHAR_LENGTH('RAJ') AS characters,
    LENGTH('RAJ') AS bytes;

/**
 * OUTPUT:
 * ┌────────────┬───────┐
 * │ characters │ bytes │
 * ├────────────┼───────┤
 * │ 3          │ 3     │
 * └────────────┴───────┘
 * 
 * EXPLANATION: 'R','A','J' each take 1 byte = total 3 bytes
 */

-- Accented character (2 bytes)
SELECT 
    CHAR_LENGTH('é') AS characters,
    LENGTH('é') AS bytes;

/**
 * OUTPUT:
 * ┌────────────┬───────┐
 * │ characters │ bytes │
 * ├────────────┼───────┤
 * │ 1          │ 2     │
 * └────────────┴───────┘
 * 
 * EXPLANATION: 'é' is 1 character but takes 2 bytes in UTF-8
 */

-- Emoji (4 bytes)
SELECT 
    CHAR_LENGTH('😀') AS characters,
    LENGTH('😀') AS bytes;

/**
 * OUTPUT:
 * ┌────────────┬───────┐
 * │ characters │ bytes │
 * ├────────────┼───────┤
 * │ 1          │ 4     │
 * └────────────┴───────┘
 * 
 * EXPLANATION: Emoji is 1 character but takes 4 bytes!
 */

-- Word with accent
SELECT 
    CHAR_LENGTH('café') AS characters,
    LENGTH('café') AS bytes;

/**
 * OUTPUT:
 * ┌────────────┬───────┐
 * │ characters │ bytes │
 * ├────────────┼───────┤
 * │ 4          │ 5     │
 * └────────────┴───────┘
 * 
 * EXPLANATION: 'c','a','f' (3 bytes) + 'é' (2 bytes) = 5 bytes
 */

-- ============================================================================
-- 1.2 Why the Difference Matters (UTF-8 Encoding)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHY THE DIFFERENCE MATTERS                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   Most modern databases use UTF-8 encoding. In UTF-8:                   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 *   │   │ • English letters (A-Z, a-z) → 1 byte each                    │   │
 * │   │ • Numbers (0-9) → 1 byte each                                   │   │
 * │   │ • Common symbols (!,@,#,$) → 1 byte each                        │   │
 * │   │ • Accented letters (é, ñ, ü) → 2 bytes each                     │   │
 * │   │ • Emojis (😀, ❤️, 🚀) → 4 bytes each                           │   │
 * │   │ • Some Asian characters → 3 bytes each                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY THIS MATTERS:                                                     │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • CHAR_LENGTH() = What USER sees (display limits)               │   │
 * │   │ • LENGTH() = What DATABASE stores (storage limits)              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: USER_PROFILES
-- ============================================================================

CREATE TABLE user_profiles (
    id INT PRIMARY KEY,
    display_name VARCHAR(50),
    bio_snippet VARCHAR(100)
);

INSERT INTO user_profiles (id, display_name, bio_snippet) VALUES
(1, 'Raj', 'Hello'),
(2, 'Renée', 'Café'),
(3, 'User123', 'Happy 😀');

-- Display data
SELECT id, display_name, bio_snippet FROM user_profiles ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────────┬─────────────┐
 * │ id │ display_name │ bio_snippet │
 * ├────┼──────────────┼─────────────┤
 * │ 1  │ Raj          │ Hello       │
 * │ 2  │ Renée        │ Café        │
 * │ 3  │ User123      │ Happy 😀    │
 * └────┴──────────────┴─────────────┘
 */

-- ============================================================================
-- PART 2: BYTES vs CHARACTERS - DETAILED EXPLANATION
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              BYTES vs CHARACTERS - VISUAL GUIDE                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   String: "café"                                                        │
 * │                                                                          │
 * │   Characters (what you see):                                           │
 * │   ┌─────┬─────┬─────┬─────┐                                            │
 * │   │  c  │  a  │  f  │  é  │                                            │
 * │   └─────┴─────┴─────┴─────┘                                            │
 * │     1    2    3    4      ← CHAR_LENGTH = 4                            │
 * │                                                                          │
 *   │   Bytes (how computer stores):                                         │
 * │   ┌─────┬─────┬─────┬─────┬─────┐                                      │
 * │   │  c  │  a  │  f  │  é  │  é  │                                      │
 * │   │(1b) │(1b) │(1b) │(2b) │     │                                      │
 * │   └─────┴─────┴─────┴─────┴─────┘                                      │
 * │     1    2    3    4    5      ← LENGTH = 5 (é takes 2 bytes)          │
 * │                                                                          │
 * │   String: "😀" (emoji)                                                  │
 * │                                                                          │
 * │   Characters: 1 (😀)                                                    │
 * │   Bytes: 4 (emojis take 4 bytes in UTF-8)                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate with a function to show both
SELECT 
    display_name,
    CHAR_LENGTH(display_name) AS characters,
    LENGTH(display_name) AS bytes,
    LENGTH(display_name) - CHAR_LENGTH(display_name) AS extra_bytes
FROM user_profiles;

/**
 * OUTPUT:
 * ┌──────────────┬────────────┬───────┬─────────────┐
 * │ display_name │ characters │ bytes │ extra_bytes │
 * ├──────────────┼────────────┼───────┼─────────────┤
 * │ Raj          │ 3          │ 3     │ 0           │
 * │ Renée        │ 5          │ 6     │ 1           │
 * │ User123      │ 7          │ 7     │ 0           │
 * └──────────────┴────────────┴───────┴─────────────┘
 * 
 * EXPLANATION: Renée has 1 extra byte (the 'é' takes 2 bytes instead of 1)
 */

-- ============================================================================
-- PART 3: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: User-Visible Character Counts
 * 
 * For a social media dashboard, show character count of display names
 * (what users expect to see)
 */

SELECT 
    id, 
    display_name, 
    CHAR_LENGTH(display_name) AS char_count
FROM user_profiles;

/**
 * OUTPUT:
 * ┌────┬──────────────┬────────────┐
 * │ id │ display_name │ char_count │
 * ├────┼──────────────┼────────────┤
 * │ 1  │ Raj          │ 3          │
 * │ 2  │ Renée        │ 5          │
 * │ 3  │ User123      │ 7          │
 * └────┴──────────────┴────────────┘
 * 
 * EXPLANATION: Users see "Renée" as 5 characters, not 6
 */

/**
 * SCENARIO 2: Checking Storage Usage (Bytes)
 * 
 * DBA wants to know how many bytes each bio snippet takes on disk
 */

SELECT 
    id, 
    bio_snippet, 
    LENGTH(bio_snippet) AS byte_size
FROM user_profiles;

/**
 * OUTPUT:
 * ┌────┬─────────────┬───────────┐
 * │ id │ bio_snippet │ byte_size │
 * ├────┼─────────────┼───────────┤
 * │ 1  │ Hello       │ 5         │
 * │ 2  │ Café        │ 5         │
 * │ 3  │ Happy 😀    │ 10        │
 * └────┴─────────────┴───────────┘
 * 
 * EXPLANATION: 
 * - 'Hello' = 5 bytes (H,e,l,l,o → 1 byte each)
 * - 'Café' = 5 bytes (C,a,f → 3 bytes + é → 2 bytes = 5)
 * - 'Happy 😀' = 10 bytes (H,a,p,p,y, space → 6 bytes + emoji 4 bytes = 10)
 */

/**
 * SCENARIO 3: Validating Minimum Character Length
 * 
 * Find users whose display name is too short (less than 4 characters)
 * Use CHAR_LENGTH because we care about the name, not disk space
 */

SELECT display_name
FROM user_profiles
WHERE CHAR_LENGTH(display_name) < 4;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ display_name │
 * ├──────────────┤
 * │ Raj          │
 * └──────────────┘
 * 
 * EXPLANATION: 'Raj' has 3 characters (< 4), so it's flagged
 * 'Renée' has 5 characters, not flagged
 * 'User123' has 7 characters, not flagged
 */

/**
 * SCENARIO 4: Identifying "Special Character" Rows
 * 
 * Find users who used special characters or emojis
 * A row has special characters if bytes > characters
 */

SELECT 
    display_name, 
    CHAR_LENGTH(display_name) AS chars, 
    LENGTH(display_name) AS bytes,
    LENGTH(display_name) - CHAR_LENGTH(display_name) AS extra_bytes
FROM user_profiles
WHERE LENGTH(display_name) > CHAR_LENGTH(display_name);

/**
 * OUTPUT:
 * ┌──────────────┬───────┬───────┬─────────────┐
 * │ display_name │ chars │ bytes │ extra_bytes │
 * ├──────────────┼───────┼───────┼─────────────┤
 * │ Renée        │ 5     │ 6     │ 1           │
 * └──────────────┴───────┴───────┴─────────────┘
 * 
 * EXPLANATION: Only Renée has special character (é)
 * Raj and User123 have only standard characters
 */

/**
 * SCENARIO 5: Enforcing Data Limits (Hard Drive Safety)
 * 
 * Legacy system only allows exactly 8 bytes per field
 * Which users are safe and which will be cut off?
 */

SELECT 
    display_name, 
    LENGTH(display_name) AS bytes,
    CASE 
        WHEN LENGTH(display_name) <= 8 THEN 'Safe'
        ELSE 'Too Large for Disk'
    END AS storage_status
FROM user_profiles;

/**
 * OUTPUT:
 * ┌──────────────┬───────┬─────────────────────┐
 * │ display_name │ bytes │ storage_status      │
 * ├──────────────┼───────┼─────────────────────┤
 * │ Raj          │ 3     │ Safe                │
 * │ Renée        │ 6     │ Safe                │
 * │ User123      │ 7     │ Safe                │
 * └──────────────┴───────┴─────────────────────┘
 * 
 * EXPLANATION: All fit within 8 bytes
 * If a name had more bytes, it would show 'Too Large for Disk'
 */

-- More examples with different strings
CREATE TEMP TABLE test_strings (
    sample_text VARCHAR(100)
);

INSERT INTO test_strings VALUES
('Hello'),           -- 5 bytes
('Café'),            -- 5 bytes (é = 2 bytes)
('Müller'),          -- 7 bytes (ü = 2 bytes)
('नमस्ते'),          -- 18 bytes? (Hindi characters)
('😀😀😀');          -- 12 bytes (3 emojis × 4 bytes)

SELECT 
    sample_text,
    CHAR_LENGTH(sample_text) AS characters,
    LENGTH(sample_text) AS bytes,
    CASE 
        WHEN LENGTH(sample_text) > CHAR_LENGTH(sample_text) THEN 'Has special chars'
        ELSE 'ASCII only'
    END AS char_type
FROM test_strings;

/**
 * OUTPUT:
 * ┌─────────────┬────────────┬───────┬──────────────────┐
 * │ sample_text │ characters │ bytes │ char_type        │
 * ├─────────────┼────────────┼───────┼──────────────────┤
 * │ Hello       │ 5          │ 5     │ ASCII only       │
 * │ Café        │ 4          │ 5     │ Has special chars│
 * │ Müller      │ 6          │ 7     │ Has special chars│
 * │ नमस्ते      │ 5          │ 18    │ Has special chars│
 * │ 😀😀😀       │ 3          │ 12    │ Has special chars│
 * └─────────────┴────────────┴───────┴──────────────────┘
 */

DROP TABLE test_strings;

-- ============================================================================
-- PART 4: LENGTH() vs CHAR_LENGTH() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LENGTH() vs CHAR_LENGTH() - WHEN TO USE                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Use Case           │ Use CHAR_LENGTH()      │ Use LENGTH()          │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Display limits    │ ✓ (what user sees)     │ ✗                      │ │
 * │ │ (e.g., max 50 chars)│                        │                       │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Storage limits    │ ✗                      │ ✓ (actual disk space) │ │
 * │ │ (e.g., VARCHAR(100)│                        │                       │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Password length   │ ✓ (user counts chars)  │ ✗ (misleading)        │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Detecting special │ ✗ (all chars are 1)    │ ✓ (bytes > chars)     │ │
 * │ │ characters       │                        │                       │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Database storage  │ ✗                      │ ✓ (actual bytes)      │ │
 * │ │ monitoring       │                        │                       │ │
 * └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   QUICK DECISION GUIDE:                                                  │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ Ask yourself: "Am I counting for a HUMAN or for a COMPUTER?"       ││
 *   │                                                                     ││
 *   │ • HUMAN sees characters → use CHAR_LENGTH()                        ││
 *   │ • COMPUTER stores bytes → use LENGTH()                             ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example: Validating username length for display
-- Users expect "Renée" to count as 5 characters, not 6
SELECT 
    display_name,
    CHAR_LENGTH(display_name) AS user_visible_length,
    CASE 
        WHEN CHAR_LENGTH(display_name) <= 5 THEN 'Valid'
        ELSE 'Too Long'
    END AS validation
FROM user_profiles;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────────────┬────────────┐
 * │ display_name │ user_visible_length  │ validation │
 * ├──────────────┼──────────────────────┼────────────┤
 * │ Raj          │ 3                    │ Valid      │
 * │ Renée        │ 5                    │ Valid      │
 * │ User123      │ 7                    │ Too Long   │
 * └──────────────┴──────────────────────┴────────────┘
 */

-- ============================================================================
-- PART 5: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using LENGTH() for password validation                     │
 * │                                                                          │
 * │   ❌ WHERE LENGTH(password) >= 8                                       │
 * │      → User types "😀😀😀😀" (4 emojis)                                │
 * │      → LENGTH = 16 bytes, but only 4 characters!                      │
 * │                                                                          │
 * │   ✅ WHERE CHAR_LENGTH(password) >= 8                                  │
 * │      → Counts actual characters user typed                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong for password validation
SELECT 
    '😀😀😀😀' AS password,
    LENGTH('😀😀😀😀') AS bytes,
    CHAR_LENGTH('😀😀😀😀') AS actual_chars;

/**
 * OUTPUT:
 * ┌──────────┬───────┬──────────────┐
 * │ password │ bytes │ actual_chars │
 * ├──────────┼───────┼──────────────┤
 * │ 😀😀😀😀  │ 16    │ 4            │
 * └──────────┴───────┴──────────────┘
 * 
 * EXPLANATION: 16 bytes but only 4 characters!
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Assuming 1 character always = 1 byte                      │
 * │                                                                          │
 * │   ❌ Assuming VARCHAR(10) means 10 bytes                               │
 * │   ✅ VARCHAR(10) means 10 CHARACTERS (PostgreSQL)                      │
 * │      But actual storage may be more bytes                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting that spaces are counted                        │
 * │                                                                          │
 * │   CHAR_LENGTH('Raj ') = 4 (includes space)                             │
 * │   CHAR_LENGTH(TRIM('Raj ')) = 3 (without space)                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    'Raj ' AS with_space,
    CHAR_LENGTH('Raj ') AS length_with_space,
    CHAR_LENGTH(TRIM('Raj ')) AS length_without_space;

/**
 * OUTPUT:
 * ┌────────────┬───────────────────┬─────────────────────┐
 * │ with_space │ length_with_space │ length_without_space│
 * ├────────────┼───────────────────┼─────────────────────┤
 * │ Raj        │ 4                 │ 3                   │
 * └────────────┴───────────────────┴─────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Using LENGTH for display character limits                  │
 * │                                                                          │
 * │   Twitter: 280 CHARACTER limit (not bytes)                             │
 * │   Use CHAR_LENGTH(tweet) <= 280                                        │
 * │   NOT LENGTH(tweet) <= 280 (would reject valid tweets with emojis)     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 6: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Use CHAR_LENGTH() for HUMAN-visible counts                     │
 * │         → Display names, tweets, comments, passwords                   │
 * │         → What users expect to see                                     │
 * │                                                                          │
 * │ RULE 2: Use LENGTH() for STORAGE/technical counts                      │
 * │         → Disk space, database limits, network transfer                │
 * │         → What the computer actually stores                            │
 * │                                                                          │
 * │ RULE 3: English letters (A-Z) = 1 byte each                            │
 * │         → CHAR_LENGTH = LENGTH for English-only text                   │
 * │                                                                          │
 * │ RULE 4: Special characters and emojis take MORE bytes                  │
 * │         → Accents: 2 bytes                                             │
 * │         → Emojis: 4 bytes                                              │
 * │         → Some Asian characters: 3 bytes                               │
 * │                                                                          │
 * │ RULE 5: Always TRIM before counting if spaces shouldn't count          │
 * │         → CHAR_LENGTH(TRIM(name))                                      │
 * │                                                                          │
 * │ RULE 6: Test with international characters before deployment           │
 * │         → Don't assume your app only handles English                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ CHAR_LENGTH() - Character count (what humans see):                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CHAR_LENGTH('Raj')    → 3                                          ││
 * │ │ CHAR_LENGTH('Renée')  → 5                                          ││
 * │ │ CHAR_LENGTH('😀')     → 1                                          ││
 * │ │ CHAR_LENGTH('café')   → 4                                          ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ LENGTH() - Byte count (what computer stores):                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LENGTH('Raj')    → 3                                               ││
 * │ │ LENGTH('Renée')  → 6  ('é' = 2 bytes)                              ││
 * │ │ LENGTH('😀')     → 4  (emoji = 4 bytes)                            ││
 * │ │ LENGTH('café')   → 5  ('é' = 2 bytes)                              ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Common Character Byte Sizes (UTF-8):                                    │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ English letters (A-Z, a-z)  → 1 byte                               ││
 * │ │ Numbers (0-9)               → 1 byte                               ││
 * │ │ Common symbols (!,@,#)      → 1 byte                               ││
 * │ │ Accented letters (é, ñ, ü)  → 2 bytes                              ││
 * │ │ Emojis (😀, ❤️, 🚀)         → 4 bytes                              ││
 * │ │ Some Asian characters       → 3 bytes                              ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Detecting Special Characters:                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ WHERE LENGTH(column) > CHAR_LENGTH(column)                         ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 8: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Count characters in 'Müller' (what users see)
 * 
 * Answer:
 *   SELECT CHAR_LENGTH('Müller');
 */

/**
 * EXERCISE 2: Count bytes in 'Müller' (storage space)
 * 
 * Answer:
 *   SELECT LENGTH('Müller');
 */

/**
 * EXERCISE 3: Find all usernames that contain special characters
 * 
 * Answer:
 *   SELECT username FROM users WHERE LENGTH(username) > CHAR_LENGTH(username);
 */

/**
 * EXERCISE 4: Validate that tweet is within 280 characters
 * 
 * Answer:
 *   SELECT * FROM tweets WHERE CHAR_LENGTH(tweet_text) <= 280;
 */

/**
 * EXERCISE 5: Calculate storage needed for a VARCHAR column
 * 
 * Answer:
 *   SELECT SUM(LENGTH(column_name)) FROM table_name;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS user_profiles;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. CHAR_LENGTH() = Number of CHARACTERS (what humans see)              │
 * │    → Use for display limits, password validation, user input           │
 * │                                                                          │
 * │ 2. LENGTH() = Number of BYTES (what computer stores)                   │
 * │    → Use for storage monitoring, disk space calculation                │
 * │                                                                          │
 * │ 3. In UTF-8 encoding:                                                  │
 * │    → English letters: 1 byte per character                             │
 * │    → Accented letters: 2 bytes per character                           │
 * │    → Emojis: 4 bytes per character                                     │
 * │                                                                          │
 * │ 4. When bytes > characters = special characters present                │
 * │    → WHERE LENGTH(col) > CHAR_LENGTH(col)                              │
 * │                                                                          │
 * │ 5. Never assume 1 character = 1 byte                                   │
 * │    → Your app may go global!                                           │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - CHAR_LENGTH = for HUMANS (what they see)                           │
 * │   - LENGTH = for COMPUTERS (what they store)                           │
 *   │   - Test with international characters                               │
 * │   - Trim spaces before counting if needed                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF LENGTH vs CHAR_LENGTH REVISION GUIDE
-- ============================================================================