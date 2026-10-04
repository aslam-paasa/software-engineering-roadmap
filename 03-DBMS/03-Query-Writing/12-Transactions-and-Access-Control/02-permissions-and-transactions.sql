/**
 * MySQL — Connections, Connection Pools & Transactions (Deep Dive)
 * 1.  What is a Connection? ............. Single live channel to MySQL
 * 2.  What is a Connection Pool? ........ Reusing multiple open connections
 * 3.  Why Not Just One Connection? ...... Parallel requests need parallel channels
 * 4.  Transaction ...................... Multiple SQL ops as one atomic unit
 * 5.  COMMIT ........................... Permanently save transaction changes
 * 6.  ROLLBACK ......................... Undo all changes in transaction
 * 7.  SAVEPOINT ........................ Checkpoint inside a transaction
 * 8.  Internal Working — InnoDB ........ How transactions really work under the hood
 *     8.1 Connection + Transaction State
 *     8.2 When a Transaction Starts
 *     8.3 UPDATE/INSERT/DELETE Before COMMIT
 *     8.4 Undo Log
 *     8.5 Redo Log (Crash Safety)
 *     8.6 What COMMIT Actually Does
 *     8.7 What ROLLBACK and SAVEPOINT Do Internally
 * 9.  Timeout .......................... Lock wait too long → query fails
 * 10. Deadlock ......................... Two transactions blocking each other
 * 11. Golden Rules ..................... Key principles to remember
 */


/**
 * Part-1: WHAT IS A CONNECTION?
 */

/**
 * App aur MySQL Ke Beech Ka Live Channel
 * ─────────────────────────────────────────
 *
 *   Connection = app aur MySQL server ke beech ek live communication channel.
 *   Har connection ka apna unique ID hota hai.
 *   Connection "stateful" hai — session variables aur transaction state
 *   us connection ke andar hi rehte hain.
 *   Connection kill ho jaaye → sab session state chali jaati hai.
 *
 * DEFINITION:
 *   A connection is a single LIVE COMMUNICATION CHANNEL between your
 *   application and the MySQL server.
 *
 * KEY PROPERTIES:
 *   → Every connection has a unique CONNECTION_ID
 *   → A connection is STATEFUL:
 *       → Session variables live inside that connection
 *       → Transaction state lives inside that connection
 *   → If connection is disconnected/killed → session state is GONE
 *
 * CHECK YOUR CURRENT CONNECTION:
 */


SELECT CONNECTION_ID();
-- Returns the ID of your current connection
-- Example: 73


/**
 * WHY connection_id ALTERNATES (73, 74, 75, 76...)?
 *   Because the tool uses a CONNECTION POOL.
 *   The pool picks connections in round-robin.
 *   Each query may run on a DIFFERENT connection from the pool.
 *   This is normal and expected behavior.
 */


/**
 * Part-2: WHAT IS A CONNECTION POOL?
 */

/**
 * Multiple Connections Ka Manager
 * ──────────────────────────────────
 *
 *   Connection pool = ek manager jo multiple DB connections open rakhta hai aur unhe reuse karta hai.
 *   Naya connection banana slow aur expensive hota hai.
 *   Pool ek free connection deta hai, query chalti hai, phir connection wapas pool mein.
 *
 * DEFINITION:
 *   A connection pool is a MANAGER that keeps multiple DB connections open
 *   and REUSES them instead of creating new ones every time.
 *
 * WHY CONNECTION POOLS EXIST:
 *   → Opening a new DB connection EVERY request = slow + expensive
 *   → Apps handle MANY concurrent requests
 *   → One connection = others wait in queue
 *   → Pool keeps connections READY to use
 *
 * HOW IT WORKS:
 *
 *   App needs to query:
 *   ┌─────────────────────────────────────────────────────────────┐
 *   │                    CONNECTION POOL                          │
 *   │                                                             │
 *   │  [Connection 1] ──► Request A gets it → query runs          │
 *   │  [Connection 2] ──► Request B gets it → query runs          │
 *   │  [Connection 3] ──► Request C gets it → query runs          │
 *   │                                                             │
 *   │  After query done: connection returned back to pool         │
 *   └─────────────────────────────────────────────────────────────┘
 */


/**
 * Part-3: WHY NOT JUST ONE CONNECTION?
 */

/**
 * Ek Connection Se Kya Problem Hai
 * ──────────────────────────────────
 *
 *   3 users ek saath request bhejte hain.
 *   Ek connection hai toh sirf ek request chal sakti hai — baaki wait.
 *   Connection pool se teeno parallel chalti hain — fast aur efficient.
 *
 * SINGLE CONNECTION PROBLEM:
 *
 *   3 concurrent requests:
 *   Request A ─────────────┐
 *   Request B ─────────────┤ Only ONE connection available
 *   Request C ─────────────┘
 *
 *   Result:
 *   Request A runs     → done
 *   Request B WAITS    → runs after A
 *   Request C WAITS    → runs after B
 *   → Slow, delayed, poor user experience
 *
 * WITH CONNECTION POOL:
 *
 *   Request A => Connection 1 → runs in parallel
 *   Request B => Connection 2 → runs in parallel
 *   Request C => Connection 3 → runs in parallel
 *   → Fast, concurrent, efficient
 *
 * REAL-WORLD:
 *   Most production apps configure a pool of 5–20 connections.
 *   New requests wait only if ALL connections are busy.
 *   Pool size is tuned based on expected concurrent load.
 */


/**
 * Part-4: TRANSACTION
 */

/**
 * Multiple SQL Ops Ko Ek Atomic Unit Banao
 * ──────────────────────────────────────────
 *
 *   Transaction = multiple SQL operations ko ek single unit ki tarah treat karna.
 *   Atomic = All or Nothing. Ya sab succeed honge, ya kuch bhi nahi hoga.
 *   Beech mein kuch fail ho jaaye → sab kuch undo ho jaata hai.
 *
 * DEFINITION:
 *   A transaction makes multiple SQL operations behave as a SINGLE ATOMIC UNIT.
 *   ATOMIC = ALL or NOTHING.
 *   Either ALL statements succeed OR NONE of them apply.
 *
 * REAL-LIFE ANALOGY (Bank Transfer):
 *   Step 1: Deduct ₹500 from Account A
 *   Step 2: Add ₹500 to Account B
 *
 *   WITHOUT TRANSACTION:
 *   → Step 1 succeeds, then server crashes before Step 2
 *   → ₹500 gone from A, never added to B → money LOST!
 *
 *   WITH TRANSACTION:
 *   → Both steps are part of one unit
 *   → If Step 2 fails → Step 1 is also UNDONE automatically
 *   → Data stays consistent
 */


/**
 * Part-5: COMMIT
 */

/**
 * COMMIT — Changes Ko Permanently Save Karo
 * ────────────────────────────────────────────
 *
 *   COMMIT = transaction ke saare changes permanently database mein save karo.
 *   COMMIT se pehle changes sirf current session mein visible hote hain.
 *   COMMIT ke baad sab connections ko naya data dikhta hai.
 *
 * COMMIT permanently saves all changes made in the current transaction.
 * Changes are NOT finalized until COMMIT is explicitly run.
 */


-- ── INSIDE A TRANSACTION (Manual commit) ────────────────────────────

START TRANSACTION;

UPDATE students
SET status = 'ACTIVE'
WHERE student_id = 1;

UPDATE students
SET city = 'Delhi'
WHERE student_id = 1;

COMMIT;
-- Both updates are now PERMANENTLY saved
-- All other connections can now see the new values



-- ── OUTSIDE A TRANSACTION (Auto-commit) ─────────────────────────────

UPDATE students
SET status = 'ACTIVE'
WHERE student_id = 1;

UPDATE students
SET city = 'Delhi'
WHERE student_id = 1;
-- MySQL AUTO-COMMITS each statement immediately
-- No explicit COMMIT needed


/**
 * AUTO-COMMIT BEHAVIOR:
 *   → OUTSIDE a transaction: MySQL auto-commits each statement
 *   → INSIDE a transaction: changes held until explicit COMMIT
 *
 * KEY DIFFERENCE:
 *   Inside transaction  → changes visible ONLY to current session until COMMIT
 *   After COMMIT        → changes visible to ALL connections globally
 */


/**
 * Part-6: ROLLBACK
 */

/**
 * ROLLBACK — Sab Changes Undo Karo
 * ──────────────────────────────────
 *
 *   ROLLBACK = transaction ke sab changes cancel karo.
 *   Database wapas last committed state mein aa jaata hai.
 *   START TRANSACTION ke baad kiye gaye SABHI changes chale jaate hain.
 *
 * ROLLBACK cancels the current transaction and REVERTS all changes
 * back to the last committed state.
 */


START TRANSACTION;

UPDATE students
SET status = 'BANNED'
WHERE student_id = 1;

UPDATE students
SET city = 'Blr'
WHERE student_id = 1;

ROLLBACK;
-- BOTH updates are undone completely
-- status and city return to what they were BEFORE START TRANSACTION


/**
 * WHAT HAPPENS STEP BY STEP:
 *   1. START TRANSACTION → MySQL starts holding changes temporarily
 *   2. UPDATE status = 'BANNED' → change exists ONLY inside this transaction
 *   3. UPDATE city = 'Blr' → change exists ONLY inside this transaction
 *   4. At this point:
 *      → Same session: sees BANNED and Blr
 *      → Other sessions: still see the OLD values (not committed yet)
 *   5. ROLLBACK →
 *      → status returns to original value
 *      → city returns to original value
 *      → Database exactly as it was BEFORE transaction began
 *
 * ┌───────────────────────────────────────────────────────────────────┐
 * │                    ROLLBACK VISUAL                                │
 * │                                                                   │
 * │  Before Transaction: status='ACTIVE', city='Mumbai'               │
 * │                                                                   │
 * │  START TRANSACTION;                                               │
 * │  UPDATE status → 'BANNED'    (held in transaction context)        │
 * │  UPDATE city   → 'Blr'       (held in transaction context)        │
 * │                                                                   │
 * │  ROLLBACK;                                                        │
 * │                                                                   │
 * │  After Rollback: status='ACTIVE', city='Mumbai'  ← unchanged!     │
 * └───────────────────────────────────────────────────────────────────┘
 */


/**
 * Part-7: SAVEPOINT
 */

/**
 * SAVEPOINT — Transaction Ke Andar Checkpoint
 * ──────────────────────────────────────────────
 *
 *   SAVEPOINT = transaction ke andar ek bookmark.
 *   Poori transaction rollback karne ki jagah — sirf kuch hissa rollback karo.
 *   Bookmark tak wapas aao, baaki ka kaam intact rehta hai.
 *   COMMIT se sirf jo bacha hai woh permanently save hota hai.
 *
 * SAVEPOINT creates a CHECKPOINT inside a transaction.
 * ROLLBACK TO SAVEPOINT undoes ONLY the work done AFTER that savepoint.
 * Everything BEFORE the savepoint remains intact.
 */


-- Syntax
START TRANSACTION;

-- some operations here

SAVEPOINT sp_name;         -- create a checkpoint

-- more operations here

ROLLBACK TO SAVEPOINT sp_name;  -- undo only work AFTER the savepoint

COMMIT;                    -- save everything that wasn't rolled back



-- Practical Example: Enrollment + Balance Transfer
START TRANSACTION;

-- Step 1: Insert new enrollment (this will be KEPT)
INSERT INTO enrollments (student_id, course_id, status, coupon_code, enrolled_at, refunded_at)
VALUES (4, 3, 'ACTIVE', NULL, '2026-01-10 12:20:00', NULL);

-- Step 2: Create a savepoint BEFORE balance changes
SAVEPOINT sp_before_balance_transfer;

-- Step 3: Try balance transfer (this will be UNDONE)
UPDATE accounts SET balance = balance - 200 WHERE id = 1;
UPDATE accounts SET balance = balance + 200 WHERE id = 2;

-- Step 4: Something went wrong with balance → undo ONLY balance changes
ROLLBACK TO SAVEPOINT sp_before_balance_transfer;
-- enrollment INSERT is still there
-- balance updates are gone

-- Step 5: Commit what remains
COMMIT;
-- Only the enrollment is permanently saved
-- Balance updates were discarded


/**
 * WHAT HAPPENED STEP BY STEP:
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ After START TRANSACTION:                                         │
 * │   Enrollment insert ✅ (in transaction, not yet committed)       │
 * │                                                                  │
 * │ SAVEPOINT sp_before_balance_transfer ← checkpoint created here   │
 * │                                                                  │
 * │ Balance updates done ✅ (in transaction, not yet committed)      │
 * │                                                                  │
 * │ ROLLBACK TO SAVEPOINT:                                           │
 * │   Balance updates ❌ UNDONE                                      │
 * │   Enrollment insert ✅ STILL THERE                               │
 * │   Transaction still ACTIVE                                       │
 * │                                                                  │
 * │ COMMIT:                                                          │
 * │   Enrollment permanently saved ✅                                │
 * │   Balance updates discarded ✅                                   │
 * └──────────────────────────────────────────────────────────────────┘
 *
 * SAVEPOINT vs FULL ROLLBACK:
 * ┌──────────────────────────┬─────────────────┬────────────────────────┐
 * │ Operation                │ ROLLBACK        │ ROLLBACK TO SAVEPOINT  │
 * ├──────────────────────────┼─────────────────┼────────────────────────┤
 * │ What gets undone         │ Everything      │ Only after savepoint   │
 * │ Transaction still active │ NO (ends)       │ YES (still active)     │
 * │ Can COMMIT after         │ NO              │ YES                    │
 * └──────────────────────────┴─────────────────┴────────────────────────┘
 */


/**
 * Part-8: INTERNAL WORKING — InnoDB Deep Dive
 */

/**
 * InnoDB Ke Andar Kya Hota Hai — Under the Hood
 * ────────────────────────────────────────────────
 *
 *   InnoDB MySQL ka default storage engine hai.
 *   Transactions ke andar kya hota hai — ye samajhna production mein bahut important hai.
 *   7 parts mein samjhenge — connection state, transaction start, updates, undo log,
 *   redo log, commit, aur rollback internals.
 */


/**
 * 8.1 Connection + Transaction State
 * ────────────────────────────────────
 *
 *   Transaction ki state usi connection se tied hoti hai jisne use start kiya.
 *   Production warning: pool mein alag connection pe COMMIT mat karo.
 *
 * KEY POINTS:
 *   → Every query runs on a DB connection
 *   → In real apps: connection pool used (round-robin selection)
 *   → A transaction's in-progress work is tied to the SAME CONNECTION that started it
 *
 * DEMO SCENARIO:
 *   Connection 78: START TRANSACTION → UPDATE student name to 'RajVikram'
 *   Connection 79/80 (other windows): still see 'Raj'
 *
 *   WHY?
 *   → Change NOT committed yet → NOT globally visible
 *   → Updated version lives INSIDE that transaction/connection's context
 *
 * ⚠️  PRODUCTION WARNING:
 *   If you run START TRANSACTION on Connection 1 (pooled)
 *   and later run COMMIT on Connection 2 (different pooled connection):
 *   → COMMIT does NOTHING useful for that transaction!
 *   → Transaction state is NOT on Connection 2
 *
 *   ALWAYS run the whole transaction as ONE UNIT on the SAME connection:
 *   START TRANSACTION → queries → COMMIT/ROLLBACK (all on same connection)
 */


/**
 * 8.2 When a Transaction Starts
 * ───────────────────────────────
 *
 *   START TRANSACTION chalate hi InnoDB ek transaction context banata hai.
 *   Koi table copy nahi hoti — sirf tracking setup hoti hai.
 *
 * WHEN YOU RUN: START TRANSACTION;
 *
 *   InnoDB creates a transaction context with mainly:
 *
 *   1. TRANSACTION ID
 *      → Unique number to track this unit of work
 *
 *   2. READ VIEW (for MVCC)
 *      → So other sessions can read CONSISTENT "older versions"
 *      → Other sessions don't see your uncommitted changes
 *
 *   AT THIS STAGE:
 *   → No table copy is created
 *   → No row changes are written yet
 *   → Just a SETUP so InnoDB can later COMMIT or ROLLBACK correctly
 */


/**
 * 8.3 When You Run UPDATE/INSERT/DELETE (Before COMMIT)
 * ────────────────────────────────────────────────────────
 *
 *   Real records CHANGE karte hain — lekin safely.
 *   Data disk pe pages mein rehta hai → page RAM (Buffer Pool) mein load hoti hai
 *   → change RAM mein hota hai → woh page "Dirty Page" ban jaata hai.
 *   Locks bhi acquire hote hain — doosra transaction same row update nahi kar sakta.
 *
 * THIS IS THE CORE PART: InnoDB DOES change real records, but SAFELY.
 *
 * (A) Data lives on disk in PAGES:
 *     Records stored in pages on disk.
 *     B-Tree/B+Tree index structures help LOCATE which page has the row.
 *
 * (B) Page is loaded into RAM (Buffer Pool):
 *
 *     ┌──────────────────────────────────────────────────────────────┐
 *     │  DISK                          RAM (Buffer Pool)             │
 *     │                                                              │
 *     │  [page with row] ──load──► [page in RAM] ← change applied    │
 *     │                                                              │
 *     │  This in-memory modified page = DIRTY PAGE                   │
 *     │  (changed in RAM, NOT flushed to disk yet)                   │
 *     └──────────────────────────────────────────────────────────────┘
 *
 * (C) Locks are acquired for writes:
 *     → Your transaction takes a LOCK on the row(s) being updated
 *     → Another transaction trying to update the SAME row = WAITS
 *     → Reads may still happen (MVCC serves older version)
 *
 * UNTIL YOU COMMIT OR ROLLBACK:
 *   → The LOCK remains on those rows
 *   → Other writers must wait
 */


/**
 * 8.4 Undo Log
 * ─────────────
 *
 *   Row modify karne se PEHLE InnoDB purana version Undo Log mein likhta hai.
 *   Do kaam karta hai: ROLLBACK support + MVCC consistent reads.
 *   Writer ne change kiya → doosra connection purana version Undo Log se padh leta hai.
 *
 * UNDO LOG: Before modifying a row, InnoDB writes UNDO LOG entries.
 *
 * UNDO LOG HELPS IN TWO WAYS:
 *
 * 1. ROLLBACK SUPPORT:
 *    If you run ROLLBACK:
 *    → InnoDB uses the undo log to REVERSE what you did
 *    → Restores previous state
 *
 * 2. MVCC CONSISTENT READS (Multi-Version Concurrency Control):
 *
 *    ┌──────────────────────────────────────────────────────────────┐
 *    │  Transaction A: UPDATE name → 'RajVikram' (not committed)    │
 *    │                                                              │
 *    │  Transaction B: SELECT name → gets 'Raj' ← from UNDO LOG!    │
 *    │                                                              │
 *    │  Undo log keeps a POINTER to the previous row version.       │
 *    │  Transaction B's "read view" decides which version to show.  │
 *    └──────────────────────────────────────────────────────────────┘
 *
 * THAT'S WHY IN THE DEMO:
 *   Writer connection:          saw 'RajVikram' (current dirty page)
 *   Other connections:          saw 'Raj'       (from undo log — old version)
 *   After COMMIT:               everyone sees 'RajVikram'
 */


/**
 * 8.5 Redo Log (Crash Safety)
 * ─────────────────────────────
 *
 *   Redo Log ROLLBACK ke liye nahi hai — ye DURABILITY ke liye hai.
 *   Agar MySQL crash ho jaaye before dirty pages disk pe flush honge —
 *   Redo Log restart pe committed changes replay kar deta hai.
 *
 * REDO LOG = for DURABILITY, NOT for rollback.
 *
 * HOW IT WORKS:
 *   → When you modify pages in RAM → InnoDB also writes REDO information
 *   → If MySQL CRASHES before flushing dirty pages to disk:
 *     → Redo log can REPLAY committed changes during recovery
 *     → Data is NOT lost
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │                       REDO LOG PURPOSE                           │
 * │                                                                  │
 * │  Modified page in RAM (Dirty Page)                               │
 * │          │                                                       │
 * │          ├──► Redo Log written (on disk, fast sequential write)  │
 * │          │                                                       │
 * │          ├──► COMMIT happens                                     │
 * │          │                                                       │
 * │          └──► MySQL CRASHES before dirty page flushed to disk    │
 * │                                                                  │
 * │  On restart: Redo log REPLAYS the change → data recovered ✅✅  │
 * └──────────────────────────────────────────────────────────────────┘
 *
 * UNDO vs REDO LOG:
 * ┌────────────────────┬──────────────────────────────────────────────┐
 * │ Log Type           │ Purpose                                      │
 * ├────────────────────┼──────────────────────────────────────────────┤
 * │ UNDO LOG           │ Rollback support + MVCC consistent reads     │
 * │ REDO LOG           │ Crash recovery + Durability (D in ACID)      │
 * └────────────────────┴──────────────────────────────────────────────┘
 */


/**
 * 8.6 What COMMIT Actually Does
 * ──────────────────────────────
 *
 *   COMMIT chalte hi InnoDB 3 main kaam karta hai.
 *   Transaction ID finalize, locks release, changes globally visible.
 *
 * WHEN YOU RUN: COMMIT;
 *
 *   InnoDB does mainly these things:
 *
 *   1. MARKS TRANSACTION AS COMMITTED
 *      → Transaction ID is finalized
 *      → Change is now "official"
 *
 *   2. RELEASES LOCKS
 *      → Row locks held by this transaction are released
 *      → Other waiting transactions can now proceed
 *
 *   3. MAKES CHANGES VISIBLE TO ALL CONNECTIONS
 *      → Before commit: only current session saw the new value
 *      → After commit: ALL connections see the updated data
 *
 * DIRTY PAGE:
 *   The actual disk write (flushing dirty pages) happens
 *   in the background — not necessarily at COMMIT time.
 *   Redo log ensures durability even if crash happens before disk flush.
 */


/**
 * 8.7 What ROLLBACK and SAVEPOINT Do Internally
 * ────────────────────────────────────────────────
 *
 *   ROLLBACK: Undo Log use karta hai — saari changes reverse karta hai.
 *   SAVEPOINT: ek bookmark hai Undo Log entries mein.
 *   ROLLBACK TO SAVEPOINT: sirf savepoint ke baad ki entries undo karta hai.
 *
 * ROLLBACK INTERNALLY:
 *   → Uses Undo Log to REVERSE all changes of the transaction
 *   → Back to the state at last commit
 *   → Locks released
 *   → Transaction ends
 *
 * SAVEPOINT INTERNALLY:
 *   → A SAVEPOINT is like a BOOKMARK inside the transaction
 *   → InnoDB keeps UNDO ENTRIES as you do operations
 *   → The savepoint marks a position in the undo log chain
 *
 * ROLLBACK TO SAVEPOINT INTERNALLY:
 *   → Undo only the part AFTER that savepoint bookmark
 *   → Keep everything BEFORE that savepoint intact
 *   → Transaction is still ACTIVE after this
 *
 * VISUAL:
 *
 *   Transaction timeline:
 *   [START] → [op1] → [op2] → [SAVEPOINT] → [op3] → [op4] → [ROLLBACK TO SP]
 *
 *   After ROLLBACK TO SAVEPOINT:
 *   [op1] ✅ kept      [op2] ✅ kept
 *   [op3] ❌ undone    [op4] ❌ undone
 *   Transaction still active → can do more operations or COMMIT
 */


/**
 * Part-9: TIMEOUT
 */

/**
 * Lock Wait Timeout — Zyada Der Tak Wait Kiya Toh Fail
 * ────────────────────────────────────────────────────────
 * Hinglish:
 *   Agar Transaction A kisi row pe lock hold kare bahut der tak —
 *   Transaction B ka update indefinitely wait karega.
 *   MySQL/app mein timeout hota hai — ek time ke baad query fail ho jaati hai.
 *
 * SCENARIO:
 *
 *   Transaction A: Locks row 1 (doing updates, not yet committed)
 *         │
 *         │  [Transaction B tries to update row 1]
 *         │         │
 *         │         ▼
 *         │   Transaction B WAITS...
 *         │   WAITS...
 *         │   WAITS...
 *         │         │
 *         │         ▼
 *         │   TIMEOUT → Transaction B's query FAILS with error:
 *         │   "Lock wait timeout exceeded; try restarting transaction"
 *         │
 *   Transaction A still running...
 *
 * WHY TIMEOUT EXISTS:
 *   → Without timeout: Transaction B would wait FOREVER
 *   → With timeout: After configured time, query fails gracefully
 *   → Application can retry or handle the error
 *
 * DEFAULT TIMEOUT IN MYSQL:
 *   innodb_lock_wait_timeout = 50 seconds (default)
 */


/**
 * Part-10: DEADLOCK
 */

/**
 * Deadlock — Do Transactions Ek Doosre Ka Wait Kar Rahe Hain
 * ────────────────────────────────────────────────────────────
 *
 *   Transaction 1 ne row A lock kiya, ab row B chahiye.
 *   Transaction 2 ne row B lock kiya, ab row A chahiye.
 *   Dono ek doosre ka wait karte hain — koi aage nahi badh sakta.
 *   MySQL deadlock detect karta hai aur ek transaction ko automatically rollback karta hai.
 *
 * DEADLOCK SCENARIO:
 *
 *   Transaction 1:                  Transaction 2:
 *   LOCK row A ✅                   LOCK row B ✅
 *   (wants row B) ─────────► WAIT  (wants row A) ─────────► WAIT
 *         ▲                                                    │
 *         └────────────────────────────────────────────────────┘
 *                         CIRCULAR WAIT!
 *
 *   Transaction 1 waiting for T2 to release row B.
 *   Transaction 2 waiting for T1 to release row A.
 *   Neither can proceed = DEADLOCK!
 *
 * HOW MYSQL HANDLES DEADLOCK:
 *   → MySQL DETECTS deadlock automatically
 *   → MySQL ABORTS (rolls back) ONE transaction
 *   → The other transaction can now PROCEED
 *   → Aborted transaction gets: "Deadlock found when trying to get lock"
 *
 * HOW TO AVOID DEADLOCKS:
 *   → Always access tables/rows in the SAME ORDER across transactions
 *   → Keep transactions SHORT (hold locks for minimal time)
 *   → Use lower isolation levels where possible
 *   → Index properly (full table scans cause more locking)
 *
 * TIMEOUT vs DEADLOCK:
 * ┌────────────────────┬────────────────────────────────────────────────┐
 * │                    │ TIMEOUT                  │ DEADLOCK             │
 * ├────────────────────┼──────────────────────────┼──────────────────────┤
 * │ What happens       │ One txn waits too long   │ Two txns wait for    │
 * │                    │ for a lock               │ each other           │
 * ├────────────────────┼──────────────────────────┼──────────────────────┤
 * │ Detection          │ After time limit         │ Immediately detected │
 * ├────────────────────┼──────────────────────────┼──────────────────────┤
 * │ Resolution         │ Waiting query fails      │ MySQL rolls back one │
 * └────────────────────┴──────────────────────────┴──────────────────────┘
 */


/**
 * Part-11: GOLDEN RULES
 */

/**
 * Connections, Pools aur Transactions ke Core Principles
 * ────────────────────────────────────────────────────────
 *
 *  1. ✅ TRANSACTION KA KAAM EK HI CONNECTION PE KARO
 *        START TRANSACTION aur COMMIT/ROLLBACK dono same connection handle pe hone chahiye.
 *        Connection pool mein alag connection pe COMMIT = koi effect nahi.
 *
 *  2. ✅ CONNECTION POOL = PERFORMANCE FOUNDATION
 *        Har request pe naya connection banana slow hai.
 *        Pool connections ready rakhta hai — parallel requests serve karta hai.
 *
 *  3. ✅ TRANSACTIONS SHORT RAKHO
 *        Jitni der transaction khuli — utni der locks held.
 *        Lambi transactions = zyada waiting = timeout risk.
 *
 *  4. ✅ COMMIT = GLOBALLY VISIBLE
 *        COMMIT se pehle: sirf current session mein changes dikhte hain.
 *        COMMIT ke baad: sab connections ko naya data milta hai.
 *
 *  5. ✅ ROLLBACK = UNDO LOG SE KAAM HOTA HAI
 *        InnoDB Undo Log use karke saari changes reverse karta hai.
 *        Row ka purana version Undo Log mein stored hota hai.
 *
 *  6. ✅ SAVEPOINT = PARTIAL UNDO
 *        Poori transaction rollback karne ki zaroorat nahi.
 *        SAVEPOINT se sirf kuch hissa undo karo, baaki COMMIT karo.
 *
 *  7. ✅ DIRTY PAGE = RAM MEIN CHANGE, DISK PE NAHI
 *        UPDATE/INSERT ke baad change RAM (Buffer Pool) mein hota hai.
 *        Disk flush baad mein hota hai — Redo Log durability ensure karta hai.
 *
 *  8. ✅ UNDO LOG = ROLLBACK + MVCC
 *        Undo Log do kaam karta hai:
 *          → ROLLBACK support
 *          → MVCC: doosre transactions purana version padh sakte hain
 *
 *  9. ✅ REDO LOG = CRASH SAFETY
 *        Redo Log ROLLBACK ke liye nahi — crash recovery ke liye.
 *        MySQL restart pe committed changes replay kar deta hai.
 *
 * 10. ✅ DEADLOCK SE BACHNE KA TARIKA
 *        Tables/rows hamesha SAME ORDER mein access karo sab transactions mein.
 *        Transactions chhote rakho — locks jaldi release ho.
 *
 * QUICK REFERENCE — Transaction Commands:
 *
 *   START TRANSACTION;          -- Start a transaction
 *   COMMIT;                     -- Save all changes permanently
 *   ROLLBACK;                   -- Undo all changes in transaction
 *   SAVEPOINT sp_name;          -- Create a checkpoint
 *   ROLLBACK TO SAVEPOINT sp_name;   -- Undo only after the savepoint
 *   RELEASE SAVEPOINT sp_name;  -- Remove a savepoint
 *   SELECT CONNECTION_ID();     -- See current connection ID
 */