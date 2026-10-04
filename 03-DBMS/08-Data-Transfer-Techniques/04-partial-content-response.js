/**
 * DATA TRANSFER — Partial Content Response
 * 1.  What is Partial Content Response? .. Server sends only requested part
 * 2.  Why It Is Needed ................... Large media files, seek, resume
 * 3.  How It Works ....................... Range header flow
 * 4.  Important HTTP Concepts ............ Headers, status codes
 * 5.  Important Jargons .................. Byte range, seek, content-range
 * 6.  Code Example ....................... Express.js full implementation
 * 7.  Code Explanation ................... Step by step breakdown
 * 8.  The Two Cases ...................... With range vs without range
 * 9.  Real-World Examples ................ YouTube seek, Spotify, resume download
 * 10. When to Use ........................ Decision guide
 * 11. Golden Rules ....................... Key principles to remember
 */


/**
 * Part-1: WHAT IS PARTIAL CONTENT RESPONSE?
 */

/**
 * Sirf Requested Part Bhejo — Pura File Nahi
 * ────────────────────────────────────────────
 * 
 *   Partial Content Response = server sirf us specific PART ka data bhejta hai
 *   jo client ne maanga — poori file nahi.
 *   Client Range header se specify karta hai ki use kaun sa byte range chahiye.
 *   Server sirf wahi bytes bhejta hai — bandwidth aur time dono bachte hain.
 *
 * DEFINITION:
 *   Partial Content Response is a data transfer technique where the server
 *   sends only a SPECIFIC PART of the data instead of sending the entire data.
 *
 * THE CORE IDEA:
 *   Client says: "Give me bytes 500 to 1023 of this file."
 *   Server sends: Only those specific bytes. Nothing more.
 *
 * SUPPORTED BY HTTP VIA:
 *   → Range request header (client → server)
 *   → Content-Range response header (server → client)
 *   → HTTP Status 206 Partial Content
 *
 * MAINLY USED FOR:
 *   → Large video files
 *   → Large audio files
 *   → Large file downloads that can be resumed
 */


/**
 * Part-2: WHY IT IS NEEDED
 */

/**
 * 1GB Video Ka Specific Part — Poora File Kyun Bhejein?
 * 
 * Hinglish:
 *   User YouTube pe video ka beech ka hissa skip karta hai.
 *   Usse poori video nahi chahiye — sirf woh part chahiye jahan wo skip kiya.
 *   Agar server poori 1GB video bheje → bandwidth waste, time waste, memory waste.
 *
 * THE PROBLEM WITHOUT PARTIAL CONTENT:
 *
 *   ┌──────────────────────────────────────────────────────────────┐
 *   │  Video file: 1GB                                             │
 *   │                                                              │
 *   │  [0MB ──────────────── 500MB ──────────────────── 1000MB]    │
 *   │                           ↑                                  │
 *   │              User skips to here (50% mark)                   │
 *   │                                                              │
 *   │  Without Partial Content:                                    │
 *   │  → Server sends ENTIRE 1GB file                              │
 *   │  → User only watches from 500MB onwards                      │
 *   │  → First 500MB = wasted bandwidth, wasted time               │
 *   └──────────────────────────────────────────────────────────────┘
 *
 * THE SOLUTION WITH PARTIAL CONTENT:
 *
 *   ┌──────────────────────────────────────────────────────────────┐
 *   │  Video file: 1GB                                             │
 *   │                                                              │
 *   │  [0MB ──────────────── 500MB ──────────────────── 1000MB]    │
 *   │                           ↑                                  │
 *   │              User skips to here (50% mark)                   │
 *   │                                                              │
 *   │  With Partial Content:                                       │
 *   │  → Browser sends Range: bytes=500000000-                     │
 *   │  → Server sends ONLY bytes from 500MB onwards                │
 *   │  → Saves: 500MB bandwidth + time + memory ✅                 │
 *   └──────────────────────────────────────────────────────────────┘
 *
 * WHAT IT SAVES:
 *   → Memory (server doesn't load full file)
 *   → Bandwidth (only relevant portion sent)
 *   → Time (less data to transfer)
 *   → Better user experience (seek is instant)
 */


/**
 * Part-3: HOW IT WORKS — The Range Request Flow
 */

/**
 * Range Header Ka Kaam
 * ─────────────────────
 * 
 *   Client Range header bhejta hai — "mujhe bytes X se Y chahiye".
 *   Server Range check karta hai, sirf wahi bytes stream karta hai.
 *   Response ke saath Content-Range header aata hai — "bhej raha hoon X-Y/total".
 *
 * THE FULL FLOW:
 *
 *   1. User skips to middle of video / audio
 *         │
 *         ▼
 *   2. Browser sends HTTP request with Range header:
 *      GET /download-audio HTTP/1.1
 *      Range: bytes=500000-999999
 *         │
 *         ▼
 *   3. Server receives the request
 *   4. Server reads the Range header
 *   5. Server calculates: start=500000, end=999999
 *         │
 *         ▼
 *   6. Server creates stream ONLY for that byte range
 *      fs.createReadStream(file, { start: 500000, end: 999999 })
 *         │
 *         ▼
 *   7. Server sends response with:
 *      Status: 206 Partial Content
 *      Content-Range: bytes 500000-999999/5000000
 *      Content-Length: 500000
 *      Content-Type: audio/mpeg
 *         │
 *         ▼
 *   8. Server streams ONLY those bytes to client
 *         │
 *         ▼
 *   9. Client plays from the requested position
 *
 * RANGE HEADER FORMAT:
 *   Range: bytes=START-END
 *   Range: bytes=0-1023         → first 1024 bytes
 *   Range: bytes=500000-999999  → bytes 500000 to 999999
 *   Range: bytes=500000-        → from 500000 to end of file
 *
 * CONTENT-RANGE RESPONSE FORMAT:
 *   Content-Range: bytes START-END/TOTAL
 *   Content-Range: bytes 500000-999999/5000000
 *                  → sending 500000-999999 out of 5000000 total bytes
 */


/**
 * Part-4: IMPORTANT HTTP CONCEPTS
 */

/**
 * Important HTTP Headers aur Status Code
 * ─────────────────────────────────────────
 * 
 *   Partial Content Response 3 important HTTP concepts pe kaam karta hai.
 *   Range header (request), Content-Range header (response), 206 status code.
 *
 * 1. Range Header (Request Header — client se server ko)
 *    → Client specify karta hai ki kaun sa part chahiye.
 *    → Example: Range: bytes=0-1023
 *    → Meaning: "Send me bytes 0 through 1023"
 *    → When sent: when user seeks/skips, or resumes download
 *
 * 2. Content-Range Header (Response Header — server se client ko)
 *    → Server batata hai ki kaun sa part bheja ja raha hai.
 *    → Example: Content-Range: bytes 0-1023/5000000
 *    → Meaning: "Sending bytes 0-1023 out of 5000000 total"
 *    → Format: bytes START-END/TOTAL_FILE_SIZE
 *
 * 3. Accept-Ranges Header (Response Header)
 *    → Server batata hai ki wo range requests support karta hai.
 *    → Accept-Ranges: bytes
 *    → Without this header — client may not even try range requests.
 *
 * 4. HTTP Status 206 — Partial Content
 *    → Indicates that only PART of the resource is sent.
 *    → Different from 200 OK (which means full file sent).
 *    → Client uses this to know: "more data available, can request rest."
 *
 * 5. HTTP Status 200 — OK
 *    → Full file sent (no Range header in request).
 *    → Normal complete response.
 */


/**
 * Part-5: IMPORTANT JARGONS
 */

/**
 * Partial Content Ke Important Terms
 * ─────────────────────────────────────
 *
 * ┌──────────────────────┬────────────────────────────────────────────────┐
 * │ Term                 │ Meaning                                        │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Partial Content      │ Sending only PART of resource.                 │
 * │                      │ Not the full file.                             │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Range Header         │ REQUEST header to ask specific bytes from file.│
 * │                      │ Example: Range: bytes=0-1023                   │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Content-Range        │ RESPONSE header specifying sent byte range.    │
 * │                      │ Example: Content-Range: bytes 0-1023/5000000   │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Byte Range           │ Portion of file defined by start and end bytes.│
 * │                      │ Example: bytes 500000 to 999999                │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Seek                 │ Jump to specific part of media (video/audio).  │
 * │                      │ Example: Click 5:30 mark on YouTube            │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Chunk Size           │ How many bytes in one partial response.        │
 * ├──────────────────────┼────────────────────────────────────────────────┤
 * │ Resume Download      │ Continuing interrupted download from where     │
 * │                      │ it stopped, not from beginning.                │
 * └──────────────────────┴────────────────────────────────────────────────┘
 */


/**
 * Part-6: CODE EXAMPLE — Full Partial Content Implementation
 */

/**
 * Code Explanation:
 * > This API sends an audio file to the client.
 * > If the client asks for a specific part of the audio, the server sends
 *   only that part (Partial Content).
 * > Otherwise, the server sends the full audio file.
 */

import express from "express";
import cors from "cors";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = 3000;
app.use(cors());

app.use(express.static("public"));

/* For parsing JSON and form data */
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/download-audio", (req, res) => {
  /**
   * Step 1: Get full path of audio file
   * > path.join(__dirname, "public/music.mp3")
   *   - __dirname          → current folder path
   *   - "public/music.mp3" → audio file location
   * > This creates the complete path of the audio file.
   */
  const filePath = path.join(__dirname, "public/music.mp3");

  /**
   * Step 2: Get file information
   * > fs.statSync(filePath)
   *   - This gives details about the file.
   *   - We use it to get file size.
   * > Example: fileSize = 5000000 bytes (5MB)
   */
  const stat = fs.statSync(filePath);
  const fileSize = stat.size;

  /**
   * Step 3: Check if client requested specific part of file
   * > req.headers.range
   *   - Browser sends Range header when:
   *     - User skips audio
   *     - User resumes audio
   * > Example Range header:
   *   - Range: bytes=0-1023
   * > This means client wants bytes from 0 to 1023
   */
  const range = req.headers.range;

  /**
   * CASE-I If Range exists → send only requested part (step-4)
   */
  if (range) {
    /**
     * > Remove "bytes=" and split start and end
     * > Example: "bytes=0-1023"
     *   - becomes:
     *     a. start = 0
     *     b. end = 1023
     */
    const parts = range.replace(/bytes=/, "").split("-");

    const start = parseInt(parts[0], 10);

    /* If end is not provided, send till end of file */
    const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;

    /* Calculate size of data to send */
    const chunkSize = end - start + 1;

    /**
     * Step 5: Create stream for only requested part
     * > fs.createReadStream(filePath, { start, end })
     *   - Reads only selected portion
     *   - Does NOT read full file
     * > This saves memory
     */
    const file = fs.createReadStream(filePath, { start, end });

    /**
     * Step 6: Set response headers
     * > These headers tell browser:
     *   - which part is sent
     *   - total file size
     *   - file type
     */
    const head = {
      /**
       * Example: bytes 0-1023/5000000
       * - sending bytes 0 to 1023
       * - total file size is 5000000
       */
      "Content-Range": `bytes ${start}-${end}/${fileSize}`,
      /* Tells browser that server supports partial content */
      "Accept-Ranges": "bytes",
      /* Size of current chunk */
      "Content-Length": chunkSize,
      /* File type (audio) */
      "Content-Type": "audio/mpeg",
    };

    /**
     * Step 7: Send status code 206
     * > 206 means Partial Content
     */
    res.writeHead(206, head);

    /**
     * Step 8: Send file part to client
     * - pipe() sends data directly without loading full file into memory
     */
    file.pipe(res);
  } 
  
  /**
   * CASE-II: If Range does NOT exist → send full file (step-9)
   * > This happens when user plays audio from start
  */
  else {

    const head = {
      /* Full file size */
      "Content-Length": fileSize,
      /* File type */
      "Content-Type": "audio/mpeg",
    };

    /**
     * Send status 200 (OK): Means full file is sent
     */
    res.writeHead(200, head);

    /**
     * Send full file using stream, Still uses stream to save memory
     */
    fs.createReadStream(filePath).pipe(res);
  }
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});



/**
 * Part-7: CODE EXPLANATION
 */

/**
 * Har Step Ka Matlab
 * ────────────────────
 * 
 *   Code ke har important step ka detailed explanation.
 *
 * STEP 1: path.join(__dirname, 'public/music.mp3')
 *    → __dirname = current folder (e.g., /home/user/project)
 *    → Result: /home/user/project/public/music.mp3
 *    → Complete file path banata hai.
 *
 * STEP 2: fs.statSync(filePath)
 *    → File ki information milti hai synchronously.
 *    → stat.size = file ka total size in bytes.
 *    → Example: 5000000 = 5MB file.
 *    → Zaroori hai kyunki Content-Range header mein total size chahiye.
 *
 * STEP 3: req.headers.range
 *    → Browser ye header tab bhejta hai jab:
 *        User audio/video skip karta hai.
 *        User download resume karta hai.
 *    → Example value: "bytes=1000000-2000000"
 *    → Agar ye header nahi hai → poora file bhejo.
 *
 * STEP 4: range.replace(/bytes=/, '').split('-')
 *    → "bytes=0-1023" → "0-1023" → ["0", "1023"]
 *    → parts[0] = "0" → start byte
 *    → parts[1] = "1023" → end byte (ya undefined agar nahi diya)
 *
 * STEP 5: parseInt(parts[0], 10)
 *    → String "0" ko number 0 mein convert karo.
 *    → 10 = base 10 (decimal) — normal number.
 *
 * STEP 6: end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1
 *    → Agar end diya gaya hai → use karo.
 *    → Agar end nahi diya → file ke aakhir tak jao (fileSize - 1).
 *    → Example: Range: bytes=500000- → end = 4999999 (5MB file mein)
 *
 * STEP 7: fs.createReadStream(filePath, { start, end })
 *    → Sirf start se end bytes padho — poori file nahi.
 *    → Memory efficient: sirf us chunk ka data RAM mein.
 *
 * STEP 8: Content-Range: bytes ${start}-${end}/${fileSize}
 *    → Client ko batata hai: "ye bytes bhej raha hoon, total itni hai"
 *    → Example: Content-Range: bytes 0-1023/5000000
 *
 * STEP 9: Accept-Ranges: bytes
 *    → Client ko batata hai: "ye server range requests support karta hai"
 *    → Client future mein bhi range request bhej sakta hai.
 *
 * STEP 10: res.writeHead(206, head)
 *    → 206 = Partial Content status code.
 *    → Headers ke saath response start karo.
 *
 * STEP 11: file.pipe(res)
 *    → Sirf requested bytes stream karo client ko.
 *    → Fast, memory efficient.
 */


/**
 * Part-8: THE TWO CASES — With Range vs Without Range
 */

/**
 * Do Cases Ka Summary
 * ─────────────────────
 * 
 *   Request mein Range header hai ya nahi — iske hisaab se response alag hota hai.
 *
 * CASE 1: Range header EXISTS (User seeks / resumes)
 *   → Client sends: Range: bytes=500000-999999
 *   → Server reads ONLY those bytes from file
 *   → Server responds:
 *       Status: 206 Partial Content
 *       Content-Range: bytes 500000-999999/5000000
 *       Content-Length: 500000
 *   → Only 500000 bytes sent (not full 5000000)
 *
 * CASE 2: NO Range header (User starts from beginning)
 *   → Client sends: GET /download-audio (no Range header)
 *   → Server streams FULL file
 *   → Server responds:
 *       Status: 200 OK
 *       Content-Length: 5000000
 *   → Full 5000000 bytes sent
 *
 * ┌──────────────────────┬──────────────┬────────────────────────────┐
 * │ Request              │ Status Code  │ What is Sent               │
 * ├──────────────────────┼──────────────┼────────────────────────────┤
 * │ With Range header    │ 206          │ Only requested bytes       │
 * │ Without Range header │ 200          │ Full file                  │
 * └──────────────────────┴──────────────┴────────────────────────────┘
 */

/**
 * Simple Summary:
 * 1. Case 1: Client requests specific part
 *    → Server sends only that part
 *    → Status code = 206
 * 2. Case 2: Client requests full file
 *    → Server sends full file
 *    → Status code = 200
 *
 * 3. Real Example:
 *    - When you skip YouTube video to 10:00, browser requests only that part,
 *      not full video.
 *    - This is Partial Content Response.
*/


/**
 * Part-9: REAL-WORLD EXAMPLES
 */

/**
 * Partial Content Real Life Mein
 * ────────────────────────────────
 * 
 *   Ye sab examples daily life mein Partial Content Response use karte hain.
 *
 * YOUTUBE VIDEO SEEK:
 *   → You're watching a 1 hour video
 *   → You click on the 45:00 mark
 *   → Browser sends: Range: bytes=2700000000- (approx 45 min position)
 *   → YouTube server sends only from that byte position
 *   → You see video from 45:00 — without downloading first 45 min!
 *
 * SPOTIFY / MUSIC PLAYER:
 *   → Song is 10MB
 *   → You drag the progress bar to 80%
 *   → Browser sends: Range: bytes=8000000-
 *   → Server sends last 2MB only
 *   → Music plays from that position
 *
 * RESUME DOWNLOAD (e.g., Chrome download):
 *   → Downloading a 500MB file
 *   → Internet disconnects at 200MB
 *   → Chrome resumes: Range: bytes=200000000-
 *   → Server sends remaining 300MB
 *   → No need to start over!
 *
 * PDF VIEWER (Browser):
 *   → Large PDF (100 pages)
 *   → Browser requests only first few pages initially
 *   → As you scroll, more pages requested via Range
 *   → No need to download all 100 pages upfront
 */


/**
 * Part-10: WHEN TO USE PARTIAL CONTENT RESPONSE
 */

/**
 * Partial Content Ka Decision Guide
 * ────────────────────────────────────
 * 
 *   Kab Partial Content use karein — ye decision guide hai.
 *
 * ✅ USE PARTIAL CONTENT RESPONSE WHEN:
 *   → Video streaming (YouTube, Netflix-style)
 *   → Audio streaming (music players)
 *   → Large file downloads that should be resumable
 *   → PDF or document viewers that load progressively
 *   → Any media where users might seek/skip
 *   → When bandwidth efficiency is important
 *
 * ❌ DO NOT NEED PARTIAL CONTENT WHEN:
 *   → Small files (images, small JSON, small text)
 *   → Files that are always needed in full
 *   → API responses (use buffered response)
 *   → When files are small enough to always send completely
 *
 * COMPARISON WITH STREAMING:
 * ┌────────────────────────────┬─────────────────┬──────────────────────┐
 * │ Aspect                     │ HTTP Streaming  │ Partial Content      │
 * ├────────────────────────────┼─────────────────┼──────────────────────┤
 * │ Who controls what to send  │ Server          │ Client (via Range)   │
 * │ Status code                │ 200             │ 206                  │
 * │ Use case                   │ Large downloads │ Media seek, resume   │
 * │ Range header               │ Not needed      │ Required             │
 * └────────────────────────────┴─────────────────┴──────────────────────┘
 *
 * NOTE: Both streaming and partial content are often COMBINED.
 *   Video players use both together for optimal media delivery.
 */


/**
 * Part-11: GOLDEN RULES
 */

/**
 * Partial Content Response ke Core Principles
 * ──────────────────────────────────────────────
 *
 *  1. ✅ PARTIAL CONTENT = CLIENT CONTROLS WHAT IT WANTS
 *        Unlike streaming where server sends everything,
 *        here the CLIENT specifies the exact byte range needed.
 *
 *  2. ✅ RANGE HEADER IS THE KEY
 *        Range: bytes=START-END
 *        Check req.headers.range for every media request.
 *
 *  3. ✅ STATUS 206 = PARTIAL CONTENT
 *        Always use 206 when sending partial data.
 *        Use 200 only when sending the full file.
 *
 *  4. ✅ ALWAYS INCLUDE CONTENT-RANGE HEADER
 *        Content-Range: bytes START-END/TOTAL
 *        Client needs this to know position in file.
 *
 *  5. ✅ ALWAYS INCLUDE ACCEPT-RANGES: bytes
 *        This tells the client that your server supports range requests.
 *        Without this, clients may not even send Range headers.
 *
 *  6. ✅ USE fs.createReadStream({ start, end }) FOR EFFICIENCY
 *        Only reads the requested bytes from disk.
 *        No full file loading into memory.
 *
 *  7. ✅ HANDLE BOTH CASES
 *        → Range header present → 206 + partial stream
 *        → Range header absent  → 200 + full stream
 *        Both should still use streams for memory efficiency.
 *
 *  8. ✅ PARTIAL CONTENT + STREAMING WORK TOGETHER
 *        For media files, combine both:
 *        Use Range for seeking + use streaming for efficient delivery.
 */