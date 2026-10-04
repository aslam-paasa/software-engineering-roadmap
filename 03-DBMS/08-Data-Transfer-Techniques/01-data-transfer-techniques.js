/**
 * DATA TRANSFER TECHNIQUES — Overview
 * 1. Client and Server ................. The two main components
 * 2. What is Data Transfer? ............ How data moves between them
 * 3. The 4 Techniques .................. Overview of all methods
 * 4. When to Use Which ................. Quick decision guide
 * 5. Golden Rules ...................... Key principles to remember
 */


/**
 * Part-1: CLIENT AND SERVER
 */

/**
 * Web Ka Foundation — Client aur Server
 * ────────────────────────────────────────
 * 
 *   Jab bhi hum website banate hain, do main parts hote hain.
 *   - Client = user ka browser. 
 *   - Server = wahan data stored hai.
 *   - Data transfer = in dono ke beech data ka aana-jaana.
 *
 * TWO MAIN COMPONENTS:
 *   1. CLIENT  → User's device (browser like Chrome, Edge, etc.)
 *   2. SERVER  → Machine where website files and data are stored
 *
 * HOW A WEBPAGE LOADS:
 *   1. User types a URL in the browser (client)
 *   2. Browser sends a request to the server
 *   3. Server finds the HTML file
 *   4. HTML file is TRANSFERRED from server → client
 *   5. Browser receives the file
 *   6. Browser RENDERS it and displays the webpage to the user
 *
 * THE CORE QUESTION:
 *   "How should data travel from server to client?"
 *   Answer depends on the TYPE and SIZE of data.
 */


/**
 * Part-2: WHAT IS DATA TRANSFER?
 */

/**
 * Server Se Client Tak Data Kaise Jaata Hai
 * ────────────────────────────────────────────
 * 
 *   Data transfer ka matlab hai — server pe stored data ko client ko bhejni.
 *   Simple JSON ke liye alag technique, 1GB video ke liye alag technique.
 *   Sahi technique choose karna performance aur memory ke liye zaroori hai.
 *
 * EXAMPLES OF DATA TRANSFER:
 *   → HTML page loading in browser
 *   → JSON data from an API response
 *   → Video file being streamed
 *   → Audio file being played
 *   → Large file being downloaded
 *   → File being uploaded
 *
 * WHY TECHNIQUE MATTERS:
 *   → Wrong technique → server crash (memory overflow)
 *   → Right technique → fast, efficient, memory-safe
 *
 *   Example: 1GB video file
 *   → BAD:  Load entire 1GB into server memory, then send
 *   → GOOD: Send in small chunks without loading everything
 *
 * UNDERLYING TECHNOLOGY:
 *   HTTP uses TCP underneath.
 *   TCP provides a continuous two-way connection (stream).
 *   This is what makes streaming possible.
 */


/**
 * Part-3: THE 4 TECHNIQUES
 */

/**
 * Data Transfer ke 4 Tarike
 * ───────────────────────────
 * 
 *   Client aur server ke beech data transfer karne ke 4 main tarike hain.
 *   Har ek alag use case ke liye hai — sab ko samajhna zaroori hai.
 *
 * ┌──────────────────────────────┬──────────────────────────────────────────┐
 * │ Technique                    │ Simple Meaning                           │
 * ├──────────────────────────────┼──────────────────────────────────────────┤
 * │ 1. Buffered Response         │ Poora data pehle memory mein load karo,  │
 * │                              │ phir ek saath bhejo                      │
 * ├──────────────────────────────┼──────────────────────────────────────────┤
 * │ 2. HTTP Streaming            │ Data ko chhote chunks mein bhejo —       │
 * │                              │ poora load karne ki zaroorat nahi        │
 * ├──────────────────────────────┼──────────────────────────────────────────┤
 * │ 3. Partial Content Response  │ Client jis specific PART ki zaroorat ho  │
 * │                              │ sirf wahi bhejo (byte range)             │
 * ├──────────────────────────────┼──────────────────────────────────────────┤
 * │ 4. Resumable Uploads         │ Upload beech mein rok ke dobara resume   │
 * │                              │ kar sako — start se nahi                 │
 * └──────────────────────────────┴──────────────────────────────────────────┘
 *
 * 1. BUFFERED RESPONSE:
 *    → Server loads ENTIRE data into memory first
 *    → Then sends it all at once
 *    → Good for: small data, data that needs full processing before sending
 *    → Bad for: large files (memory overflow risk)
 *    → Status code: 200 OK
 *
 * 2. HTTP STREAMING:
 *    → Data is divided into small CHUNKS
 *    → Each chunk is sent immediately as it's ready
 *    → Server memory stays low (no full file loading)
 *    → Good for: large files, videos, audio, live data
 *    → Node.js tool: fs.createReadStream() + pipe()
 *
 * 3. PARTIAL CONTENT RESPONSE:
 *    → Client requests only a SPECIFIC BYTE RANGE of a file
 *    → Server sends only that requested portion
 *    → Used with Range header in HTTP
 *    → Good for: video seek (jump to 10:00), resume downloads
 *    → Status code: 206 Partial Content
 *
 * 4. RESUMABLE UPLOADS:
 *    → Large files can be uploaded in parts
 *    → If upload is interrupted, resume from where it stopped
 *    → No need to restart the entire upload
 *    → Good for: large file uploads on slow/unreliable connections
 */


/**
 * Part-4: WHEN TO USE WHICH
 */

/**
 * Kab Kaun Si Technique Use Karo
 * ────────────────────────────────
 * 
 *   Real scenarios mein kaunsi technique choose karni chahiye — ye guide hai.
 *
 * ┌──────────────────────────────────────┬──────────────────────────────────────┐
 * │ Situation                            │ Use This Technique                   │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Small JSON API response              │ Buffered Response                    │
 * │ (5-6 records from DB)                │                                      │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Need to process data before sending  │ Buffered Response                    │
 * │ (modify fields, format data)         │                                      │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Large file download (100MB+)         │ HTTP Streaming                       │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Video/Audio streaming                │ HTTP Streaming + Partial Content     │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ User skips to middle of video        │ Partial Content Response (Range)     │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Resume interrupted download          │ Partial Content Response             │
 * ├──────────────────────────────────────┼──────────────────────────────────────┤
 * │ Large file upload (slow connection)  │ Resumable Uploads                    │
 * └──────────────────────────────────────┴──────────────────────────────────────┘
 *
 * REAL-WORLD EXAMPLES:
 *   → YouTube seek to 10:00      → Partial Content Response
 *   → Netflix video streaming    → HTTP Streaming + Partial Content
 *   → Spotify audio play         → HTTP Streaming + Partial Content
 *   → Normal REST API response   → Buffered Response
 *   → Google Drive upload        → Resumable Uploads
 *   → Large text file read       → HTTP Streaming
 */


/**
 * Part-5: GOLDEN RULES
 */

/**
 * Data Transfer Techniques ke Core Principles
 * ──────────────────────────────────────────────
 *
 *  1. ✅ NEVER LOAD LARGE FILES INTO MEMORY AT ONCE
 *        10 users × 1GB file = 10GB RAM needed → server crash.
 *        Use streaming or partial responses for large files.
 *
 *  2. ✅ BUFFERED RESPONSE IS FINE FOR SMALL DATA
 *        Normal JSON APIs with small responses — buffered is perfect.
 *        Zyada sochne ki zaroorat nahi.
 *
 *  3. ✅ STREAMING = CHUNK BY CHUNK
 *        File memory mein load nahi hoti — directly network pe bhejti hai.
 *        Node.js mein: fs.createReadStream() + pipe(res)
 *
 *  4. ✅ PARTIAL CONTENT = CLIENT CONTROLS WHAT IT WANTS
 *        Range header se client specify karta hai kaun sa hissa chahiye.
 *        Server sirf wahi bhejta hai — bandwidth save hoti hai.
 *
 *  5. ✅ STATUS CODES MATTER
 *        200 = Full file sent (Buffered or full stream)
 *        206 = Partial content sent (Range request)
 *        416 = Requested range not satisfiable (invalid range)
 *
 *  6. ✅ pipe() IS YOUR FRIEND IN NODE.JS
 *        readStream.pipe(res) → automatically transfers data chunk by chunk.
 *        Memory efficient. No manual chunk management needed.
 *
 *  7. ✅ USE THE RIGHT TECHNIQUE FOR THE RIGHT JOB
 *        Small JSON → Buffered
 *        Large file → Stream
 *        Media seek → Partial Content
 *        Large upload → Resumable
 */