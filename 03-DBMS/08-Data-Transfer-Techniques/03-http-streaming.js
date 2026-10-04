/**
 * DATA TRANSFER — HTTP Streaming
 * 1.  What is HTTP Streaming? ........... Data sent in small chunks
 * 2.  The Problem it Solves ............. Buffered response's memory problem
 * 3.  How Streaming Works ............... Chunk by chunk flow
 * 4.  Why Streaming Works — TCP ......... The underlying connection
 * 5.  Node.js Streaming APIs ............ fs.createReadStream + pipe
 * 6.  Important Jargons ................. Stream, Chunk, Pipe, Buffer, etc.
 * 7.  Code Example ...................... Express.js implementation
 * 8.  Code Explanation .................. Line by line breakdown
 * 9.  Real-World Examples ............... YouTube, Spotify, etc.
 * 10. When to Use Streaming ............. Decision guide
 * 11. Golden Rules ...................... Key principles to remember
 */


/**
 * Part-1: WHAT IS HTTP STREAMING?
 */

/**
 * Data Ko Chhote Chunks Mein Bhejo
 * ──────────────────────────────────
 * 
 *   HTTP Streaming = data ko ek saath bhejne ki jagah chhote chhote
 *   pieces (chunks) mein bhejte hain.
 *   Server poora data memory mein load nahi karta — seedha network pe bhejta hai.
 *
 * DEFINITION:
 *   HTTP Streaming is a data transfer technique where data is sent from
 *   the server to the client in smaller CHUNKS, instead of loading the
 *   entire data into memory first.
 *
 * SIMPLE MENTAL MODEL:
 *
 *   BUFFERED RESPONSE (Old way):
 *   ┌────────────────────────────────────────────────────────────┐
 *   │ Load ALL → Process ALL → Send ALL                          │
 *   │ [Wait wait wait... then send everything at once]           │
 *   └────────────────────────────────────────────────────────────┘
 *
 *   HTTP STREAMING (Better way):
 *   ┌────────────────────────────────────────────────────────────┐
 *   │ Read chunk → Send chunk → Read chunk → Send chunk → ...    │
 *   │ [Send immediately as available — no waiting]               │
 *   └────────────────────────────────────────────────────────────┘
 *
 * KEY DIFFERENCE:
 *   → Buffered: WAIT until everything is ready, then send
 *   → Streaming: Send IMMEDIATELY as each piece is ready
 */


/**
 * Part-2: THE PROBLEM IT SOLVES
 */

/**
 * Buffered Response Ka Problem — Memory Overflow
 * ─────────────────────────────────────────────────
 * 
 *   1GB file ko 10 users request karein → 10GB RAM chahiye → server crash.
 *   Streaming mein sirf ek chunk ka memory chahiye — baaki directly network pe.
 *
 * THE PROBLEM WITH BUFFERED RESPONSE FOR LARGE FILES:
 *   File size: 1GB
 *   If 10 users request at the same time:
 *   → 10 × 1GB = 10GB RAM required
 *   → Most servers have only 2GB–4GB RAM
 *   → Server CRASHES
 *
 * HOW STREAMING FIXES THIS:
 *
 *   ┌────────────────────────────────────────────────────────────┐
 *   │                   BUFFERED (BAD)                           │
 *   │                                                            │
 *   │  [█████████████████████████] ← 1GB in RAM                  │
 *   │  Then send ─────────────────────────────────────►          │
 *   │  × 10 users = 10GB RAM → CRASH                             │
 *   └────────────────────────────────────────────────────────────┘
 *
 *   ┌────────────────────────────────────────────────────────────┐
 *   │                   STREAMING (GOOD)                         │
 *   │                                                            │
 *   │  [█] read → send                                           │
 *   │  [█] read → send                                           │
 *   │  [█] read → send    (only 1 chunk at a time in RAM)        │
 *   │  × 10 users = still only ~1KB per user in RAM ✅✅        │
 *   └────────────────────────────────────────────────────────────┘
 *
 * RESULT:
 *   → Memory stays LOW no matter how many users
 *   → Server stays stable
 *   → Client starts receiving data FASTER (no waiting for full load)
 */


/**
 * Part-3: HOW STREAMING WORKS 
 */

/**
 * Chunk by Chunk Ka Flow
 * ──────────────────────
 * 
 *   Streaming mein connection open rehta hai jab tak saara data nahi jaata.
 *   Har ek chunk seedha read hota hai aur client ko bheja jaata hai.
 *   Memory mein sirf ek chunk ka data hota hai ek waqt mein.
 *
 * THE FLOW:
 *   Client sends request
 *         │
 *         ▼
 *   Server OPENS connection (stays open)
 *         │
 *         ▼
 *   Server reads CHUNK 1 from file
 *         │
 *         ▼
 *   Server IMMEDIATELY sends CHUNK 1 to client
 *         │
 *         ▼
 *   Client starts receiving data (fast!)
 *         │
 *         ▼
 *   Server reads CHUNK 2 → sends CHUNK 2
 *   Server reads CHUNK 3 → sends CHUNK 3
 *   ...continues...
 *         │
 *         ▼
 *   All chunks sent → connection CLOSES
 *         │
 *         ▼
 *   Client has received full data
 *
 * AT ANY POINT IN TIME:
 *   → Server RAM holds only 1 chunk (e.g., 1KB)
 *   → NOT the entire file
 *   → Connection remains open throughout
 */


/**
 * Part-4: WHY STREAMING WORKS — TCP underneath
 */

/**
 * TCP Connection Ka Jadoo
 * ─────────────────────────
 * 
 *   HTTP ke neeche TCP hota hai jo ek continuous two-way connection provide karta hai.
 *   TCP ke upar hi streaming possible hai — connection open rehta hai.
 *   Ye channel open rehta hai aur hum baar baar data bhej sakte hain.
 *
 * THE UNDERLYING TECHNOLOGY:
 *   HTTP uses TCP underneath.
 *   TCP provides a continuous two-way CONNECTION called a STREAM.
 *
 *   ┌────────────────────────────────────────────────────────────┐
 *   │               TCP STREAM (Persistent Connection)           │
 *   │                                                            │
 *   │   CLIENT ◄═══════════════════════════════► SERVER          │
 *   │            (connection stays open)                         │
 *   │                                                            │
 *   │   Chunk 1 ─────────────────────────────────────►           │
 *   │   Chunk 2 ─────────────────────────────────────►           │
 *   │   Chunk 3 ─────────────────────────────────────►           │
 *   │   ...                                                      │
 *   │   Done → CONNECTION CLOSED                                 │
 *   └────────────────────────────────────────────────────────────┘
 *
 * WHY THIS MATTERS:
 *   → Streams allow READING and WRITING data gradually
 *   → We do NOT need to load the entire file into memory
 *   → The connection acts as a pipe between file and network
 */


/**
 * Part-5: NODE.JS STREAMING APIS
 */

/**
 * Node.js Mein Streaming Ke Tools
 * ──────────────────────────────────
 * 
 *   Node.js mein built-in streaming APIs hain.
 *   fs.createReadStream() file ko chunks mein read karta hai.
 *   pipe() un chunks ko directly response mein bhejta hai.
 *
 * KEY APIS:
 *
 *   1. fs.createReadStream(filePath, options)
 *      → File ko chhote chunks mein read karta hai
 *      → Poora file memory mein load NAHI hota
 *      → Options:
 *          encoding: 'utf8'    → binary data ko readable text mein convert
 *          highWaterMark: 1024 → chunk size (1024 bytes = 1KB)
 *
 *   2. readStream.pipe(res)
 *      → res (HTTP response) ek WRITABLE STREAM hai
 *      → pipe() readable stream ko writable stream se connect karta hai
 *      → Automatically chunks transfer karta hai
 *      → Memory efficient and fast
 *
 * THE PIPE CONCEPT:
 *
 *   FILE ─── [READ STREAM]─── pipe() ─── [HTTP RESPONSE]─── CLIENT
 *  (disk)     (readable)                   (writable)
 *
 *   Jaise paani ka pipe — ek end se paani aata hai, doosre end se jaata hai.
 *   Server ko beech mein kuch karna nahi padta.
 */


/**
 * Part-6: IMPORTANT JARGONS
 */

/**
 * Streaming Ke Important Terms
 * ──────────────────────────────
 * Hinglish:
 *   Ye 7 terms hain jo streaming ke baare mein baat karte waqt use hote hain.
 *
 * ┌──────────────────┬────────────────────────────────────────────────────┐
 * │ Term             │ Meaning                                            │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Stream           │ Continuous flow of data over time.                 │
 * │                  │ Example: video streaming                           │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Chunk            │ Small piece of data.                               │
 * │                  │ Large file divided into chunks.                    │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Readable Stream  │ Used to READ stream data chunk-by-chunk.           │
 * │                  │ Example: fs.createReadStream()                     │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Writable Stream  │ Used to WRITE stream data chunk-by-chunk.          │
 * │                  │ Example: HTTP response (res)                       │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Pipe             │ Connects readable stream to writable stream.       │
 * │                  │ Automatically transfers data between them.         │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ Buffer           │ Temporary memory storage for data in transit.      │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ highWaterMark    │ Defines chunk size.                                │
 * │                  │ Default: 64KB. Can be customized.                  │
 * ├──────────────────┼────────────────────────────────────────────────────┤
 * │ TCP Stream       │ Continuous connection for sending/receiving data.  │
 * │                  │ HTTP uses TCP underneath.                          │
 * └──────────────────┴────────────────────────────────────────────────────┘
 */


/**
 * Part-7: CODE EXAMPLE — HTTP Streaming in Express.js
 */



/**
 * Route for streaming text file
 * 1. Set response header:
 *    - Content-Type tells browser what type of data is coming
 * 2. Create readable stream from file
 *    a. fs.createReadStream()
 *       - Reads 'largeTextFile.txt' file in small chunks instead of loading
 *         full file into memory (create stream)
 *    b. Options:
 *       - encoding: "utf8"
 *       - Converts binary data into readable text
 *    c. highWaterMark: 1024
 *       - Defines chunk size (1024 bytes = 1KB)
 *       - File will be read in 1KB chunks
 * 3. Pipe stream to response:
 *    > readStream.pipe(res)
 *      - res object is a writeable stream
 *      - Sends file chunk by chunk directly to client (readStream <--> res)
 *      - No full file loading into memory
 *      - Efficient and fast
 */


import express from 'express';
import cors from 'cors';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';


/**
 * ─── ES MODULE __dirname ──────────────────────────────────────────
 * a. fileURLToPath(import.meta.url)  → converts module URL to file path
 * b. path.dirname(__filename)        → gets directory of current file
*/

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


const app = express();
const port = 3000;
app.use(cors());

/* For parsing JSON and form data */
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

/**
 * ─── HTTP STREAMING ROUTE ─────────────────────────────────────────────
*/

app.get('/stream-text', (req, res) => {

    /**
     * Step 1: Set Content-Type header:
     * Tells browser: "I'm sending plain text data"
    */
    res.setHeader('Content-Type', 'text/plain');

    /**
     * Step 2: Create a READABLE STREAM from the file
     * fs.createReadStream() reads 'largeTextFile.txt' in small chunks
     * instead of loading full file into memory
     */
    const readStream = fs.createReadStream(
        path.join(__dirname, 'largeTextFile.txt'),
        {
            encoding: 'utf8',    /* Convert binary bytes to readable text */
            highWaterMark: 1024, /* Each chunk = 1024 bytes = 1KB         */
        }
    );

    /**
     * Step 3: PIPE the readable stream to the HTTP response
     * res is a WRITABLE stream
     * pipe() connects them: file chunks → network → client
     * No manual chunk handling needed
     * Memory efficient: only 1KB in RAM at any time
    */
    readStream.pipe(res);

});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});



/**
 * Part-8: CODE EXPLANATION — Line by Line
 */

/**
 * Har Line Ka Matlab
 * ────────────────────
 * 
 *   Code ke important parts ka detailed explanation.
 *
 * 1. fileURLToPath(import.meta.url)
 *    → ES modules mein __filename automatically available nahi hota.
 *    → Ye function module URL ko file path mein convert karta hai.
 *    → Result: "/home/user/project/server.js"
 *
 * 2. path.dirname(__filename)
 *    → Current file ki directory path nikalta hai.
 *    → Result: "/home/user/project"
 *    → CommonJS mein ye __dirname se milta tha — ES modules mein manually karo.
 *
 * 3. res.setHeader('Content-Type', 'text/plain')
 *    → Browser ko batata hai: "aane wala data plain text hai"
 *    → Browser isi hisaab se data handle karega.
 *
 * 4. fs.createReadStream(filePath, options)
 *    → File ko chunks mein read karta hai.
 *    → Poora file MEMORY MEIN LOAD NAHI HOTA.
 *    → encoding: 'utf8' → binary data (bytes) ko text mein convert karo.
 *    → highWaterMark: 1024 → ek baar mein 1KB read karo.
 *    → Return: ek Readable Stream object.
 *
 * 5. readStream.pipe(res)
 *    → res object ek Writable Stream hai (HTTP response).
 *    → pipe() dono ko connect karta hai.
 *    → Har chunk jo read hota hai, seedha res mein jaata hai (client ko).
 *    → Automatic flow control — fast client fast read, slow client slow read.
 *    → Koi manual chunk management nahi chahiye.
 *    → Memory: ek chunk (1KB) ek waqt mein RAM mein.
 *
 * MEMORY COMPARISON:
 *   Buffered (100MB file):   100MB in RAM
 *   Streaming (100MB file):  1KB in RAM (just current chunk)
 */


/**
 * Part-9: REAL-WORLD EXAMPLES
 */

/**
 * Streaming Real Life Mein Kahan Hoti Hai
 * ─────────────────────────────────────────
 * 
 *   Ye platforms streaming use karti hain — isliye itni fast aur smooth hain.
 *
 *   → YouTube, Netflix   → Video streaming (video file chunks)
 *   → Spotify, JioSaavn  → Audio streaming (audio file chunks)
 *   → Large file download → File streaming (chunked download)
 *   → Large file upload   → Streaming upload
 *   → Live webcam feed    → Real-time data streaming
 *   → ChatGPT responses   → Text streaming (tokens sent one by one)
 *
 * HOW YOUTUBE VIDEO STREAMING WORKS:
 *   1. You click play on a video
 *   2. Browser sends HTTP request to YouTube server
 *   3. Server opens TCP connection
 *   4. Server reads video file in chunks (e.g., 64KB each)
 *   5. Sends each chunk to browser immediately
 *   6. Browser starts playing as first chunks arrive
 *   7. Server keeps sending more chunks
 *   8. You see smooth video without waiting for full download!
 *
 *   This is why YouTube can play 4K videos without downloading them fully.
 */


/**
 * Part-10: WHEN TO USE HTTP STREAMING
 */

/**
 * Streaming Ka Decision Guide
 * ────────────────────────────
 * 
 *   Streaming kab use karein, kab nahi — ye table batata hai.
 *
 * ✅ USE HTTP STREAMING WHEN:
 *   → Large files (100MB, 1GB, etc.)
 *   → Video streaming
 *   → Audio streaming
 *   → Large CSV / data exports
 *   → File downloads
 *   → Many concurrent users requesting large data
 *   → Real-time / live data feeds
 *   → Logs being streamed to client
 *
 * ❌ DO NOT USE HTTP STREAMING WHEN:
 *   → Small data (few KB — normal API responses)
 *   → Data needs full processing before sending
 *   → Simple JSON API with 5-10 records
 *
 * BENEFITS OF STREAMING:
 *   ✅ Uses much less memory (server stays stable)
 *   ✅ Faster response START time (client sees data sooner)
 *   ✅ Prevents server crashes from memory overload
 *   ✅ Efficient for large files
 *   ✅ Node.js pipe() makes it very simple to implement
 */


/**
 * Part-11: GOLDEN RULES
 */

/**
 * HTTP Streaming ke Core Principles
 * ────────────────────────────────────
 *
 *  1. ✅ STREAMING = CHUNK BY CHUNK, NOT ALL AT ONCE
 *        Server reads one chunk → sends it → reads next → sends it.
 *        Memory holds only one chunk at a time.
 *
 *  2. ✅ USE STREAMING FOR LARGE FILES
 *        Any file > few MB should be streamed, not buffered.
 *        Video, audio, large downloads → always stream.
 *
 *  3. ✅ pipe() IS THE CORE TOOL IN NODE.JS
 *        readStream.pipe(res) — that's all you need.
 *        No manual chunk handling, no memory management.
 *
 *  4. ✅ CONNECTION STAYS OPEN DURING STREAMING
 *        TCP connection remains active until all chunks are sent.
 *        Then it closes automatically.
 *
 *  5. ✅ CLIENT STARTS RECEIVING DATA IMMEDIATELY
 *        No waiting for full file to load.
 *        First chunk reaches client very quickly.
 *
 *  6. ✅ highWaterMark CONTROLS CHUNK SIZE
 *        Default: 64KB. Can be tuned.
 *        Smaller chunks = less memory but more overhead.
 *        Larger chunks = more memory but fewer operations.
 *
 *  7. ✅ HTTP USES TCP — THAT'S WHY STREAMING WORKS
 *        TCP provides a persistent, continuous connection.
 *        Without TCP's stream model, HTTP streaming wouldn't exist.
 */