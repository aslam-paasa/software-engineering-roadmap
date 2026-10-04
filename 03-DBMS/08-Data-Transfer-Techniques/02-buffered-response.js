/**
 * Approach-1: Buffered Response
 * > Buffered response is a data transfer technique where the server first
 *   loads the entire data into memory, and only after the complete data is
 *   ready, it sends it to the client as a response.
 *
 * > How it works:
 *   - We have a client and a server.
 *   - Suppose we have a very large file or large data that needs to be sent
 *     from the server to the client.
 *   - First, the server loads the entire file/data into its memory.
 *   - After the complete data is loaded and ready, the server sends it as
 *     a response to the client.
 *
 * > Important point:
 *   - The entire data is stored (buffered) in memory before sending.
 *   - The response is sent only after all the data is ready.
 *
 * > Example:
 *   app.get('/buffered-json', async (req, res) => {
 *      const bigDataArray = await fetchSomeBigData();
 *      const jsonResponse = JSON.stringify(bigDataArray);
 *      res.setHeader('Content-Type', 'application/json');
 *      res.send(jsonResponse);
 *   })
 *
 * > Explanation of example:
 *   - fetchSomeBigData() loads the complete data into bigDataArray.
 *   - Until the entire data is fetched and stored, the response is not sent.
 *   - The data is first stored (buffered) in the variable.
 *   - Then it is processed (converted to JSON string).
 *   - After processing, the complete response is sent to the client.
 *
 * > Why buffered response is used:
 *   - When we need to process the complete data before sending it.
 *   - For example, formatting, modifying, or transforming the data.
 *
 * > Example scenario:
 *   - Suppose we fetch 5 records from the database.
 *   - And we want to change a field name in each record.
 *   - First, we store all records in memory.
 *   - Then we loop through them and modify the data.
 *   - After all modifications are done, we send the final response.
 *
 * > Key idea:
 *   - Data is fully stored and processed first,
 *   - Then sent to the client.
 *
 * > This is the most common technique used in normal APIs.
*/


/**
 * DATA TRANSFER — Buffered Response
 * 1. What is Buffered Response? ........ Full data in memory first, then send
 * 2. How It Works ...................... Step-by-step flow
 * 3. Why It Is Used .................... When full processing is needed
 * 4. The Problem with Buffered Response  Memory overflow risk
 * 5. Code Example ...................... Express.js implementation
 * 6. Code Explanation .................. Line by line breakdown
 * 7. When to Use / Not Use ............. Decision guide
 * 8. Golden Rules ...................... Key principles to remember
 */


/**
 * Part-1: WHAT IS BUFFERED RESPONSE?
 */

/**
 * Poora Data Pehle Memory Mein, Phir Bhejo
 * ──────────────────────────────────────────
 * 
 *   Buffered response mein server PEHLE poora data apni memory mein load karta hai.
 *   Jab saara data ready ho jaata hai — tab ek saath client ko bhejta hai.
 *   Ek baar mein saari cheez bhejni hoti hai — isliye "buffered" kehte hain.
 *
 * DEFINITION:
 *   Buffered response is a data transfer technique where the server first
 *   loads the ENTIRE data into memory, and only after the complete data is
 *   ready, sends it to the client as one response.
 *
 * HOW IT WORKS (Simple Flow):
 *   Client requests data
 *         │
 *         ▼
 *   Server fetches ALL data from DB / file
 *         │
 *         ▼
 *   Server LOADS it fully into memory (buffer)
 *         │
 *         ▼
 *   Server processes / transforms it if needed
 *         │
 *         ▼
 *   Server sends the COMPLETE response to client
 *         │
 *         ▼
 *   Client receives full response at once
 *
 * KEY CHARACTERISTIC:
 *   → The entire data is stored (buffered) in memory BEFORE sending
 *   → Response is sent ONLY AFTER all data is ready
 *   → Client waits until everything is ready
 */


/**
 * Part-2: HOW IT WORKS
 */

/**
 * Buffered Response Ka Flow
 * ──────────────────────────
 * 
 *   Step 1: fetchSomeBigData() poora data array mein load karta hai.
 *   Step 2: Jab tak sab kuch fetch nahi hota — koi response nahi jaata.
 *   Step 3: Data pehle variable mein store (buffer) hota hai.
 *   Step 4: Phir process hota hai (JSON string mein convert).
 *   Step 5: Phir poora response ek saath client ko jaata hai.
 *
 * STEP BY STEP:
 *   1. Client sends GET /buffered-json request
 *   2. Server calls fetchSomeBigData()
 *   3. WAITS until all data is fetched
 *   4. Data stored in bigDataArray (in memory)
 *   5. Data is converted to JSON string
 *   6. Complete JSON sent to client via res.send()
 *   7. Client gets full response at once
 *
 * IMPORTANT POINTS:
 *   → No partial sending — everything or nothing
 *   → Client doesn't receive anything until all data is ready
 *   → All data lives in server memory during processing
 */


/**
 * Part-3: WHY BUFFERED RESPONSE IS USED
 */

/**
 * Jab Poora Data Process Karna Ho
 * ──────────────────────────────────
 * 
 *   Buffered response tab use karte hain jab data bhejne se PEHLE
 *   poora process karna ho — jaise field names change karna, sort karna, etc.
 *
 * USE BUFFERED RESPONSE WHEN:
 *   → You need to process the COMPLETE data before sending
 *   → Formatting, modifying, or transforming data
 *   → Sorting or filtering the full dataset
 *   → Computing aggregates (totals, averages)
 *   → Combining data from multiple sources before responding
 *
 * EXAMPLE SCENARIO:
 *   1. Fetch 5 records from database
 *   2. Change a field name in each record (e.g., rename 'usr_id' to 'userId')
 *   3. Add a computed field to each record
 *   4. Sort by date
 *   5. Then send the final processed response
 *
 *   This is only possible after having ALL records in memory first.
 *
 * MOST COMMON USE CASE:
 *   → Normal REST APIs with small-medium data
 *   → This is the DEFAULT technique used in most APIs
 *   → Most everyday Express routes use buffered responses
 */


/**
 * Part-4: THE PROBLEM WITH BUFFERED RESPONSE
 */

/**
 * Bade Files Ka Problem — Memory Overflow
 * ──────────────────────────────────────────
 * 
 *   Chhote data ke liye buffered response perfect hai.
 *   Lekin bade files ke liye — jaise 1GB video — ye dangerous hai.
 *   10 users ek saath request karein toh 10GB RAM chahiye hogi — crash!
 *
 * THE PROBLEM:
 *   Suppose we have a file of size 1GB.
 *   If we use buffered response:
 *   → The entire 1GB file loads into server memory first
 *   → Then it sends to client
 *
 *   If 10 users request the same file at the same time:
 *   → 10 × 1GB = 10GB RAM required
 *   → Most servers have only 2GB–4GB RAM
 *   → Server CRASHES
 *
 * VISUAL:
 *
 *   ┌─────────────────────────────────────────────────────────────┐
 *   │                    SERVER MEMORY                            │
 *   │                                                             │
 *   │  User 1 request: [████████████████] 1GB loaded              │
 *   │  User 2 request: [████████████████] 1GB loaded              │
 *   │  User 3 request: [████████████████] 1GB loaded              │
 *   │  ...                                                        │
 *   │  User 10 request: [████████████████] 1GB loaded             │
 *   │                                                             │
 *   │  Total: 10GB RAM used → SERVER CRASH! 💥💥                 │
 *   └─────────────────────────────────────────────────────────────┘
 *
 * SOLUTION FOR LARGE FILES:
 *   → Use HTTP Streaming instead
 *   → Use Partial Content Response for media
 *   → See: 02_http_streaming.js and 03_partial_content.js
 */


/**
 * Part-5: CODE EXAMPLE — Buffered Response in Express.js
 */


import express from 'express';
import cors from 'cors';

const app = express();
const port = 3000;
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/**
 *  ─── BUFFERED RESPONSE ROUTE ──────────────────────────────────────────
*/

app.get('/buffered-json', async (req, res) => {

    /* Step 1: Fetch ALL data at once → loads fully into memory */
    const bigDataArray = await fetchSomeBigData();

    /* Step 2: Process the data (convert to JSON string) */
    const jsonResponse = JSON.stringify(bigDataArray);

    /* Step 3: Set response content type header */
    res.setHeader('Content-Type', 'application/json');

    /* Step 4: Send COMPLETE response to client */
    res.send(jsonResponse);

    // Nothing is sent until ALL of the above is done!
});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});



/**
 * Part-6: CODE EXPLANATION — Line by Line
 */

/**
 * Har Line Ka Matlab
 * ────────────────────
 * Hinglish:
 *   Code ke har important part ka explanation — kya ho raha hai aur kyun.
 *
 * 1. fetchSomeBigData()
 *    → Ye function DB ya kisi source se POORA data fetch karta hai.
 *    → await matlab: jab tak data nahi aata — wait karo.
 *    → Sab kuch memory mein bigDataArray mein aa jaata hai.
 *    → ABHI TAK CLIENT KO KUCH NAHI BHEJA.
 *
 * 2. JSON.stringify(bigDataArray)
 *    → Array / object ko JSON string mein convert karta hai.
 *    → Ye processed data hai jo bhejni hai.
 *    → Ye bhi memory mein store hoti hai.
 *
 * 3. res.setHeader('Content-Type', 'application/json')
 *    → Browser ko batata hai ki aane wala data JSON format mein hai.
 *    → Browser usi hisaab se parse karega.
 *
 * 4. res.send(jsonResponse)
 *    → Ab POORI JSON string ek saath client ko bheji jaati hai.
 *    → Ek hi baar mein — no chunks, no streaming.
 *
 * IMPORTANT NOTE:
 *   Steps 1, 2, 3 sab complete hone ke baad hi Step 4 hota hai.
 *   Client ko response milta hi step 4 pe — baaki steps pe nahi.
 */


/**
 * Part-7: WHEN TO USE / NOT USE
 */

/**
 * Buffered Response Ka Decision Guide
 * ──────────────────────────────────────
 * 
 *   Ye table decide karne mein help karega — buffered use karein ya nahi.
 *
 * ✅ USE BUFFERED RESPONSE WHEN:
 *   → Small data (few KB to few MB)
 *   → Normal REST API responses (user info, list of items, etc.)
 *   → Data needs full processing before sending
 *   → Sorting, filtering, aggregating the full dataset
 *   → Combining data from multiple DB queries
 *   → Short response time acceptable
 *
 * ❌ DO NOT USE BUFFERED RESPONSE WHEN:
 *   → Large files (100MB, 1GB, etc.)
 *   → Video or audio streaming
 *   → File downloads
 *   → Many concurrent users requesting large data
 *   → Real-time / live data feeds
 *
 * COMPARISON:
 * ┌──────────────────────────────┬────────────────┬──────────────────────┐
 * │ Scenario                     │ Use Buffered?  │ Use Instead          │
 * ├──────────────────────────────┼────────────────┼──────────────────────┤
 * │ Get 5 users from DB          │ YES ✅✅      │ —                    │
 * │ API returning JSON list      │ YES ✅✅      │ —                    │
 * │ Stream 1GB video file        │ NO  ❌❌      │ HTTP Streaming       │
 * │ Audio player seek            │ NO  ❌❌      │ Partial Content      │
 * │ Large CSV download           │ NO  ❌❌      │ HTTP Streaming       │
 * └──────────────────────────────┴────────────────┴──────────────────────┘
 */


/**
 * Part-8: GOLDEN RULES
 */

/**
 * Buffered Response ke Core Principles
 * ──────────────────────────────────────
 *
 *  1. ✅ BUFFERED RESPONSE IS PERFECT FOR SMALL DATA
 *        Normal JSON APIs, DB queries, form responses — use buffered.
 *        It's the simplest and most common technique.
 *
 *  2. ✅ DATA IS FULLY PROCESSED BEFORE SENDING
 *        This is the main advantage — you can modify, sort, filter,
 *        and transform before the client receives anything.
 *
 *  3. ❌ NEVER USE BUFFERED FOR LARGE FILES
 *        1GB file × 10 concurrent users = 10GB RAM = server crash.
 *        Use streaming instead.
 *
 *  4. ✅ CLIENT GETS EVERYTHING AT ONCE
 *        No partial data, no chunks — one complete response.
 *        Simple for the client to handle.
 *
 *  5. ✅ STATUS CODE = 200 OK
 *        Full data is always sent with 200.
 *        No range headers, no partial content.
 *
 *  6. ✅ MOST COMMON TECHNIQUE IN EVERYDAY APIS
 *        Most express routes you write daily use this by default.
 *        res.json(), res.send() — both are buffered.
 */
