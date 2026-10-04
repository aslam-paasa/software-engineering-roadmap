/**
 * ======================================================================
 * MySQL — Privileges, Users, Roles & Access Control
 * ======================================================================
 *
 * TABLE OF CONTENTS:
 * 1.  What are Privileges? .............. Permissions to control DB access
 * 2.  Users in MySQL .................... Create users with host settings
 * 3.  Roles in MySQL .................... Reusable bundles of privileges
 * 4.  Users vs Roles .................... How to differentiate in mysql.user
 * 5.  GRANT — Give Permissions .......... SELECT, INSERT, UPDATE, etc.
 * 6.  Grant to a Role ................... Role-level permission management
 * 7.  Grant a Role to a User ............ Assign role → user inherits perms
 * 8.  GRANT ALL ......................... Shortcut for full access
 * 9.  WITH GRANT OPTION ................. Let user re-delegate permissions
 * 10. ALTER USER ........................ Password rotation, lock/unlock
 * 11. REVOKE ............................ Remove previously granted perms
 * 12. Golden Rules ...................... Key principles to remember
 * ======================================================================
 */


/**
 * ======================================================================
 * SAMPLE TABLE — students (used in all examples)
 * ======================================================================
 */

/**
 *   Ye students table hai jis pe sab GRANT/REVOKE examples chalenge.
 *
 * ┌────────────┬──────────────┬────────────┬──────┬────────┬─────────────────────┐
 * │ student_id │ email        │ full_name  │ city │ status │ created_at          │
 * ├────────────┼──────────────┼────────────┼──────┼────────┼─────────────────────┤
 * │ 1          │ raj@tuf.org  │ raj        │ blr  │ ACTIVE │ 2027-01-09 10:00:00 │
 * └────────────┴──────────────┴────────────┴──────┴────────┴─────────────────────┘
 */


CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    email      VARCHAR(120) NOT NULL UNIQUE,
    full_name  VARCHAR(80)  NOT NULL,
    city       VARCHAR(60)  NULL,
    status     ENUM('ACTIVE', 'BANNED') NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL
) ENGINE=InnoDB;



/**
 * ======================================================================
 * Part-1: WHAT ARE PRIVILEGES?
 * ======================================================================
 */

/**
 * DB Mein Kya Kar Sakte Ho — Ye Decide Karte Hain Privileges
 * ────────────────────────────────────────────────────────────
 *
 *   Privilege = permission hai jo control karta hai ki ek user DB mein kya kar sakta hai.
 *   Admin decide karta hai ki kaun kya access kare.
 *   Real life mein — har team member ko sensitive tables ka access dena theek nahi.
 *
 * DEFINITION:
 *   A privilege is a PERMISSION that controls what a user can do
 *   in a database:
 *   → READ data (SELECT)
 *   → INSERT new rows
 *   → UPDATE existing rows
 *   → DELETE rows
 *   → CREATE tables
 *   → DROP tables
 *   → And more...
 *
 * REAL-LIFE ANALOGY (Company):
 *   → Support team  → can view orders (SELECT only)
 *   → Backend devs  → can read + write data (SELECT, INSERT, UPDATE)
 *   → DB admins     → full access (ALL privileges)
 *   → Interns       → no access to revenue or user_login_history tables
 *
 * THE CORE PRINCIPLE:
 *   Give access only to the people who ACTUALLY NEED IT.
 *   Minimum necessary access = better security.
 */


/**
 * ======================================================================
 * Part-2: USERS IN MYSQL
 * ======================================================================
 */

/**
 * MySQL Mein Users — Host Ke Saath
 * ──────────────────────────────────
 *
 *   MySQL mein user sirf username se nahi banta — username + host se banta hai.
 *   Host decide karta hai ki user kahaan se login kar sakta hai.
 *   User create karna = access dena NAHI — pehle GRANT karna padta hai.
 *
 * WHERE ARE USERS STORED?
 *   MySQL stores all user accounts in the system table: mysql.user
 */


-- View all users and roles
SELECT * FROM mysql.user;

-- View just user and host
SELECT user, host FROM mysql.user;


/**
 * HOST OPTIONS — Kahaan Se Login Kar Sakte Hain
 * ─────────────────────────────────────────────────
 *
 * 1. '%' (wildcard) → Any machine se login kar sakte hain
 *    (jab tak username + password sahi ho)
 */


CREATE USER 'raj'@'%' IDENTIFIED BY '123456';


/**
 * 2. 'localhost' → Sirf usi machine se login kar sakte hain jahan MySQL chal raha hai.
 *    ⚠️  Docker users dhyan dein:
 *    Agar MySQL Docker mein hai toh 'localhost' = Docker container, NOT host OS.
 */


CREATE USER 'raj_localhost'@'localhost' IDENTIFIED BY '123456';


/**
 * 3. Specific IP → Sirf us IP wali machine se login kar sakte hain.
 *    Companies mein tight security ke liye use hota hai.
 */


CREATE USER 'raj_ip'@'192.168.65.1' IDENTIFIED BY '123456';


/**
 * ⚠️  IMPORTANT NOTE:
 *   Creating a user does NOT automatically give access to any database or table.
 *   User banao alag, phir GRANT se permissions do alag.
 *
 * HOST SUMMARY TABLE:
 * ┌─────────────────────┬────────────────────────────────────────────────┐
 * │ Host Value          │ Meaning                                        │
 * ├─────────────────────┼────────────────────────────────────────────────┤
 * │ '%'                 │ Any machine (most permissive)                  │
 * │ 'localhost'         │ Only from the same server machine              │
 * │ '192.168.65.1'      │ Only from that specific IP                     │
 * └─────────────────────┴────────────────────────────────────────────────┘
 */


/**
 * ======================================================================
 * Part-3: ROLES IN MYSQL
 * ======================================================================
 */

/**
 * Role — Permissions Ka Reusable Bundle
 * ──────────────────────────────────────
 *
 *   Role = ek group of permissions ka bundle.
 *   Har user ko alag alag GRANT karne ki jagah — ek role banao.
 *   Role ko users mein assign karo — sab users woh permissions inherit karte hain.
 *   Scalable hai — ek jagah change karo, sab users pe effect hoga.
 *
 * DEFINITION:
 *   A role is a REUSABLE BUNDLE of privileges.
 *   Instead of granting permissions user-by-user,
 *   you grant permissions to a ROLE, then assign that role to users.
 *
 * WHY USE ROLES?
 *   Without roles:                        With roles:
 *   GRANT SELECT to raj                   GRANT SELECT to engineering
 *   GRANT SELECT to priya                 GRANT engineering to raj
 *   GRANT SELECT to amit                  GRANT engineering to priya
 *   GRANT SELECT to neha   ← repetitive   GRANT engineering to amit ← scalable
 *
 *   Change permissions for whole team? Update role ONCE → everyone updated.
 */


-- Create roles
CREATE ROLE 'engineering';
CREATE ROLE 'support';



/**
 * Part-4: USERS VS ROLES — How to Differentiate
 */

/**
 * Users aur Roles Mein Fark Kaise Karein
 * ─────────────────────────────────────────
 *
 *   MySQL mein users aur roles dono SAME TABLE mein store hote hain: mysql.user.
 *   Ye confusing lagta hai beginners ko.
 *   Fark ye hai: USERS ke paas password hota hai, ROLES ke paas nahi.
 *
 * STORED IN SAME TABLE: mysql.user
 *
 * KEY OBSERVATION:
 *   → Users have a PASSWORD (authentication string)
 *   → Roles do NOT have a password
 *
 * VISUAL:
 *   root, striver, raj      → have passwords → USERS
 *   engineering, support    → no password    → ROLES
 *
 * HOW TO LIST ONLY ROLES:
 */


-- Roles appear in mysql.user with:
-- account_locked = 'Y'  AND  no authentication string
SELECT user AS role_name, host
FROM mysql.user
WHERE account_locked = 'Y'
  AND (authentication_string IS NULL OR authentication_string = '')
ORDER BY user;


/**
 * Expected output:
 * ┌──────────────┬──────┐
 * │ role_name    │ host │
 * ├──────────────┼──────┤
 * │ engineering  │ %    │
 * │ support      │ %    │
 * └──────────────┴──────┘
 */


/**
 * Part-5: GRANT — Give Permissions to User or Role
 */

/**
 * GRANT — Permissions Dene Ka Command
 * ──────────────────────────────────────
 *
 *   GRANT = admin ka command jo user ya role ko permissions deta hai.
 *   SELECT, INSERT, UPDATE, DELETE, CREATE, DROP — sab GRANT se milta hai.
 *   Ye HAMESHA root/admin ke level pe run hota hai.
 *
 * GRANT = Give permissions to a user or role.
 * Used to assign privileges: SELECT, INSERT, UPDATE, DELETE, etc.
 * Must be run by ROOT / ADMIN user.
 */

/**
 * Grant SELECT on a specific table to a user
 * ─────────────────────────────────────────────
 *
 *   raj ko sirf students table mein SELECT ki permission do.
 *   INSERT, UPDATE, DELETE nahi kar sakta — sirf padh sakta hai.
 */


GRANT SELECT
ON tuf_sql.students
TO 'raj'@'%';


/**
 * Verify what raj got (run as admin):
 */


SHOW GRANTS FOR 'raj'@'%';


/**
 * Cross-check: Login as raj and test:
 */


-- This will WORK (SELECT granted)
SELECT * FROM tuf_sql.students;

-- This will FAIL (INSERT not granted)
INSERT INTO tuf_sql.students (email, full_name, city, status, created_at)
VALUES ('test@tuf.org', 'Test', 'blr', 'ACTIVE', NOW());



/**
 * Grant Multiple Privileges to a User
 * ──────────────────────────────────────
 *
 *   Ek saath multiple permissions do — SELECT, INSERT, UPDATE.
 *   DELETE, ALTER, DROP nahi milega jab tak explicitly grant nahi karte.
 */


-- Run as root/admin
GRANT SELECT, INSERT, UPDATE
ON tuf_sql.students
TO 'raj'@'%';


/**
 * What raj can do now:
 *   → SELECT  → read rows          ✅
 *   → INSERT  → add new rows       ✅
 *   → UPDATE  → modify rows        ✅
 *   → DELETE  → remove rows        ❌ (not granted)
 *   → ALTER   → change table       ❌ (not granted)
 *   → DROP    → delete table       ❌ (not granted)
 *
 * Verify as admin:
 */


SHOW GRANTS FOR 'raj'@'%';


/**
 * Cross-check as raj — test all 3 operations:
 */


-- SELECT ✅
SELECT * FROM tuf_sql.students;

-- INSERT ✅
INSERT INTO tuf_sql.students (email, full_name, city, status, created_at)
VALUES ('new@tuf.org', 'new student', 'blr', 'ACTIVE', '2027-01-10 10:00:00');

-- UPDATE ✅
UPDATE tuf_sql.students
SET city = 'mumbai'
WHERE student_id = 1;



/**
 * ======================================================================
 * Part-6: GRANT TO A ROLE
 * ======================================================================
 */

/**
 * Role Ko Permissions Do
 * ────────────────────────
 *
 *   User ko directly permissions dene ki jagah — pehle role ko do.
 *   Phir role ko user mein assign karo.
 *   Scalable approach: ek role ke permissions change karo → sab users update.
 */


-- Run as root/admin
GRANT SELECT, INSERT, UPDATE
ON tuf_sql.students
TO 'engineering';


/**
 * What this means:
 *   → engineering role now HAS these privileges
 *   → Any user assigned this role INHERITS these permissions
 *   → To change team access: update role ONCE — not every user
 *
 * Verify role permissions:
 */


SHOW GRANTS FOR 'engineering'@'%';



/**
 * Part-7: GRANT A ROLE TO A USER
 */

/**
 * User Ko Role Assign Karo
 * ──────────────────────────
 *
 *   Role banaya, permissions diye — ab user ko role assign karo.
 *   User role inherit karta hai — alag se permissions dene ki zaroorat nahi.
 *   Ek important step: DEFAULT ROLE set karo — warna user ko har session mein
 *   manually SET ROLE karna padega.
 *
 * STEP 1: Assign role to user
 */


GRANT 'engineering' TO 'raj_ip'@'192.168.65.1';


/**
 * User raj_ip is now LINKED to the role engineering.
 * But role may NOT be active by default after login!
 *
 * STEP 2: Set default role (so it activates automatically after login)
 */


-- Run as admin
SET DEFAULT ROLE 'engineering' TO 'raj_ip'@'192.168.65.1';


/**
 * Without SET DEFAULT ROLE:
 *   User logs in → role NOT active → must manually run: SET ROLE 'engineering';
 *
 * With SET DEFAULT ROLE:
 *   User logs in → role AUTOMATICALLY active → ready to use
 *
 * Verify:
 */


SHOW GRANTS FOR 'raj_ip'@'192.168.65.1';



/**
 * Part-8: GRANT ALL — Shortcut for Full Access
 */

/**
 * GRANT ALL — Ek Command Mein Sab Permissions
 * ──────────────────────────────────────────────
 *
 *   GRANT ALL ek shortcut hai — ek ek karke permissions list karne ki zaroorat nahi.
 *   Lekin SCOPE bahut important hai — table level, database level, ya server level.
 *   Server level GRANT ALL = superuser = bahut risky!
 *
 * GRANT ALL = Give ALL available privileges at the specified scope.
 * Scope controls HOW WIDE the access is.
 *
 * General Syntax:
 *   GRANT ALL
 *   ON <scope>
 *   TO 'user'@'host';
 */

/**
 * Option 1: All Privileges on One Specific Table
 * ─────────────────────────────────────────────────
 *
 *   Sirf students table pe sab kuch kar sakta hai raj.
 *   Doosri tables pe koi access nahi.
 *   Use karo jab: user sirf ek table ka owner ho.
 */


-- Run as root/admin
GRANT ALL
ON tuf_sql.students
TO 'raj'@'%';


/**
 * What raj can do:
 *   → SELECT, INSERT, UPDATE, DELETE on students ✅
 *   → TRUNCATE on students ✅
 *   → NO access to any other table ❌
 *
 * Use when: User fully owns/manages a single table but should not touch others.
 */


/**
 * Option 2: All Privileges on All Tables of One Database
 * ─────────────────────────────────────────────────────────
 *
 *   tuf_sql ke andar saari tables pe striver ko full access.
 *   Baad mein create hone wali nayi tables bhi automatically accessible hongi.
 *   Doosre databases pe access nahi.
 *   Use karo jab: backend developer ek poore application database ka owner ho.
 */


-- Run as root/admin
GRANT ALL
ON tuf_sql.*
TO 'striver'@'%';


/**
 * What striver can do:
 *   → Access EVERY table inside tuf_sql ✅
 *   → NEW tables added to tuf_sql later → automatically accessible ✅
 *   → NO access to any other database ❌
 *
 * Use when: Someone is responsible for an entire application database.
 */


/**
 * Option 3: All Privileges on ALL Databases (Server Level)
 * ───────────────────────────────────────────────────────────
 *
 *   Ye BAHUT POWERFUL aur RISKY hai.
 *   Poore MySQL server pe full control — sab databases, sab tables.
 *   Sirf trusted admins ko dena chahiye — kabhi application users ko nahi.
 */


-- Only root or super-admin should EVER run this
GRANT ALL
ON *.*
TO 'admin_user'@'%';


/**
 * ⚠️  WARNING: This is EXTREMELY POWERFUL and RISKY.
 *   → Full control over the ENTIRE MySQL server
 *   → Can read, modify, drop ANY database or table
 *   → Effectively equivalent to a superuser
 *   → NEVER grant this to application users
 *
 * SCOPE COMPARISON:
 * ┌──────────────────────────┬────────────────────────────────────────────┐
 * │ Scope                    │ Access Level                               │
 * ├──────────────────────────┼────────────────────────────────────────────┤
 * │ ON tuf_sql.students      │ Only the students table                    │
 * │ ON tuf_sql.*             │ All tables in tuf_sql database             │
 * │ ON *.*                   │ ALL databases + ALL tables (server level)  │
 * └──────────────────────────┴────────────────────────────────────────────┘
 */


/**
 * Part-9: WITH GRANT OPTION
 */

/**
 * WITH GRANT OPTION — Permission Re-delegate Karne Ki Power
 * ────────────────────────────────────────────────────────────
 *
 *   Normal GRANT mein user sirf khud use kar sakta hai permissions.
 *   WITH GRANT OPTION dene se user in permissions ko DOOSRON ko bhi de sakta hai.
 *   Dangerous: is option ka misuse "privilege explosion" create kar sakta hai.
 *   Agar nahi chahte ki user permissions share kare — ye keyword mat likhna.
 */

/**
 * Syntax:
 *   GRANT <privileges>
 *   ON <scope>
 *   TO 'user'@'host'
 *   WITH GRANT OPTION;
 */


GRANT SELECT, INSERT
ON tuf_sql.students
TO 'raj'@'%'
WITH GRANT OPTION;


/**
 * What raj can do now:
 *   → SELECT and INSERT on students ✅
 *   → Run GRANT SELECT/INSERT on students TO other_user ✅
 *   → raj CANNOT grant privileges he doesn't have ❌
 *
 * REAL RISK — Privilege Explosion:
 *   raj grants to priya → priya grants to amit → amit grants to neha
 *   → Many users gain access indirectly without admin knowing
 *
 * ⚠️  IMPORTANT:
 *   If you DON'T want a user to re-share privileges:
 *   Simply OMIT WITH GRANT OPTION.
 *   That single keyword makes a MASSIVE difference in control.
 */


/**
 * Part-10: ALTER USER
 */

/**
 * ALTER USER — Existing User Account Modify Karo
 * ─────────────────────────────────────────────────
 *
 *   ALTER USER se existing user ka password change karo ya account lock/unlock karo.
 *   Root/admin ke level pe chalata hai — normal user doosre ka password change nahi kar sakta.
 *   Password rotation aur emergency lock — ye do sabse common use cases hain.
 *
 * ALTER USER = Administrative command to MODIFY an existing user account.
 * Must be run by ROOT/ADMIN user.
 *
 * Common uses:
 *   → Password rotation (security policy)
 *   → Account locking (incident response)
 *   → Account unlocking (restore access)
 */

/**
 * Use 1: Password Rotation — Password Change Karo
 * ─────────────────────────────────────────────────
 *
 *   Security ke liye passwords periodically change karne chahiye.
 *   Purana password turant invalid ho jaata hai.
 *   Naye connections ke liye naya password zaroori.
 */


ALTER USER 'tuf_support'@'localhost'
IDENTIFIED BY 'Temp#5678';


/**
 * What happens:
 *   → Old password becomes INVALID immediately
 *   → New login attempts MUST use the new password
 *   → Existing open sessions may continue (depends on client)
 *   → New connections require new password
 */


/**
 * Use 2: Emergency Lock — Account Turant Band Karo
 * ──────────────────────────────────────────────────
 *
 *   Suspicious activity, employee offboarding, ya compromised credentials —
 *   user ko turant block karo bina account delete kiye.
 *   Account rehta hai — roles, grants, history sab intact rehte hain.
 *   Baad mein restore kar sakte hain agar zaroorat pade.
 */


ALTER USER 'tuf_support'@'localhost' ACCOUNT LOCK;


/**
 * What happens:
 *   → User CANNOT create new sessions (login will FAIL)
 *   → Account still EXISTS (roles, grants, history intact)
 *   → Safer than DROP USER when you might need to restore later
 *
 * Use when:
 *   → Suspicious activity detected
 *   → Employee offboarding
 *   → Compromised credentials suspected
 */


/**
 * Use 3: Unlock Account — Access Wapas Do
 * ──────────────────────────────────────────
 *
 *   Lock ke baad agar user ko dobara access dena ho — UNLOCK karo.
 *   Sab pehle wali permissions aur roles intact rehte hain.
 */


ALTER USER 'tuf_support'@'localhost' ACCOUNT UNLOCK;


/**
 * What happens:
 *   → User can log in again (with correct password) ✅
 *   → All previously granted privileges/roles remain UNCHANGED ✅
 *
 * ALTER USER SUMMARY:
 * ┌──────────────────────────────────┬──────────────────────────────────────┐
 * │ Command                          │ Effect                               │
 * ├──────────────────────────────────┼──────────────────────────────────────┤
 * │ IDENTIFIED BY 'new_password'     │ Changes password immediately         │
 * │ ACCOUNT LOCK                     │ Blocks all new login attempts        │
 * │ ACCOUNT UNLOCK                   │ Restores login ability               │
 * └──────────────────────────────────┴──────────────────────────────────────┘
 */


/**
 * Part-11: REVOKE — Remove Permissions
 */

/**
 * REVOKE — GRANT Ka Ulta
 * ──────────────────────
 *
 *   REVOKE = GRANT ka opposite.
 *   Pehle diye gaye permissions hata do.
 *   Main change: GRANT mein TO → REVOKE mein FROM.
 *   Root/admin ke level pe chalata hai.
 *
 * REVOKE = Remove permissions or roles previously granted.
 * It is the OPPOSITE of GRANT.
 *
 * KEY DIFFERENCE: TO becomes FROM
 *   GRANT SELECT ... TO 'raj'@'%';
 *   REVOKE SELECT ... FROM 'raj'@'%';
 *
 * Must be run by ROOT/ADMIN user.
 */

/**
 * Use 1: Revoke a Role from a User
 * ──────────────────────────────────
 *
 *   User se poora role hata do — role ke through milne wali sab permissions chali jaayengi.
 */


REVOKE 'role_support_ops'
FROM 'tuf_support'@'localhost';


/**
 * What happens:
 *   → User no longer has that ROLE assigned
 *   → ALL privileges coming from that role are REMOVED for that user
 *   → User's other directly-granted privileges remain unchanged
 */


/**
 * Use 2: Revoke Specific Privileges from a User
 * ───────────────────────────────────────────────
 *
 *   User se kuch specific permissions hata do — baaki permissions rehti hain.
 *   raj ke paas pehle SELECT + INSERT + UPDATE tha — ab sirf INSERT aur UPDATE haata hain.
 *   Sirf SELECT bachega.
 */


REVOKE INSERT, UPDATE
ON tuf_sql.students
FROM 'raj'@'%';


/**
 * What happens:
 *   → raj LOSES INSERT and UPDATE privileges ❌
 *   → raj KEEPS any other privileges they still have (e.g., SELECT) ✅
 *
 * Cross-check as raj after REVOKE:
 */


-- This will STILL WORK (SELECT was kept)
SELECT * FROM tuf_sql.students;

-- This will FAIL (INSERT revoked)
INSERT INTO tuf_sql.students (email, full_name, city, status, created_at)
VALUES ('fail@tuf.org', 'Fail User', 'blr', 'ACTIVE', NOW());

-- This will FAIL (UPDATE revoked)
UPDATE tuf_sql.students SET city = 'pune' WHERE student_id = 1;


/**
 * GRANT vs REVOKE QUICK REFERENCE:
 * ┌────────────────────────────────┬──────────────────────────────────────────┐
 * │ GRANT                          │ REVOKE                                   │
 * ├────────────────────────────────┼──────────────────────────────────────────┤
 * │ Gives permissions              │ Removes permissions                      │
 * │ Uses TO keyword                │ Uses FROM keyword                        │
 * │ GRANT SELECT ... TO 'raj'      │ REVOKE SELECT ... FROM 'raj'             │
 * │ GRANT 'role' TO 'user'         │ REVOKE 'role' FROM 'user'                │
 * └────────────────────────────────┴──────────────────────────────────────────┘
 */


/**
 * Part-12: GOLDEN RULES
 */

/**
 * MySQL Access Control ke Core Principles
 * ──────────────────────────────────────────
 *
 *  1. ✅ MINIMUM NECESSARY ACCESS
 *        Sirf utna hi access do jitna zaroori ho.
 *        Support team = SELECT only. Devs = SELECT + INSERT + UPDATE. Admins = ALL.
 *
 *  2. ✅ USER CREATION ≠ ACCESS
 *        CREATE USER se sirf account banta hai — koi DB access nahi milta.
 *        Access ke liye separately GRANT karna padta hai.
 *
 *  3. ✅ USERNAME + HOST = UNIQUE IDENTITY
 *        'raj'@'%' aur 'raj'@'localhost' MySQL mein alag alag users hain.
 *        Same username, alag host = alag account.
 *
 *  4. ✅ USERS HAVE PASSWORDS, ROLES DO NOT
 *        Roles aur users dono mysql.user mein store hote hain.
 *        Differentiation: role ka koi password/auth string nahi hota.
 *
 *  5. ✅ ROLES = SCALABLE PERMISSIONS
 *        100 developers hain? Ek 'engineering' role banao, sab ko assign karo.
 *        Permissions change karni ho → sirf role update karo, sab users update.
 *
 *  6. ✅ ALWAYS SET DEFAULT ROLE
 *        Role assign karne ke baad SET DEFAULT ROLE bhi karo.
 *        Warna user login ke baad manually SET ROLE karna padega.
 *
 *  7. ✅ GRANT ALL ON *.* = EXTREME RISK
 *        Server-level GRANT ALL = complete superuser.
 *        Kabhi bhi application users ko ye access mat do.
 *
 *  8. ✅ WITH GRANT OPTION = DELEGATE WITH CAUTION
 *        Ye keyword user ko powers re-share karne deta hai.
 *        Galat haath mein gaya toh "privilege explosion" ho sakta hai.
 *        Agar re-sharing nahi chahiye — ye keyword mat likho.
 *
 *  9. ✅ LOCK BEFORE DROP
 *        Suspicious user ko turant ACCOUNT LOCK karo.
 *        DROP USER se pehle lock karo — agar baad mein restore karna pade toh easy hoga.
 *
 * 10. ✅ REVOKE = GRANT KA ULTA
 *        GRANT mein TO → REVOKE mein FROM.
 *        Revoke sirf un permissions ko hatata hai jo explicitly revoke ki hain.
 *        Baaki permissions intact rehti hain.
 *
 * QUICK COMMANDS REFERENCE:
 *
 *   CREATE USER 'raj'@'%' IDENTIFIED BY 'password';
 *   CREATE ROLE 'engineering';
 *
 *   GRANT SELECT ON db.table TO 'user'@'host';
 *   GRANT SELECT, INSERT ON db.table TO 'user'@'host';
 *   GRANT ALL ON db.table TO 'user'@'host';
 *   GRANT ALL ON db.* TO 'user'@'host';
 *   GRANT ALL ON *.* TO 'user'@'host';
 *   GRANT 'role' TO 'user'@'host';
 *   GRANT SELECT ON db.table TO 'user'@'host' WITH GRANT OPTION;
 *
 *   SET DEFAULT ROLE 'role' TO 'user'@'host';
 *
 *   SHOW GRANTS;
 *   SHOW GRANTS FOR 'user'@'host';
 *
 *   ALTER USER 'user'@'host' IDENTIFIED BY 'new_password';
 *   ALTER USER 'user'@'host' ACCOUNT LOCK;
 *   ALTER USER 'user'@'host' ACCOUNT UNLOCK;
 *
 *   REVOKE INSERT, UPDATE ON db.table FROM 'user'@'host';
 *   REVOKE 'role' FROM 'user'@'host';
 *
 */