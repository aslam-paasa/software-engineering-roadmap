/**
 * DATA TRANSFER — Resumable Uploads
 * 1.  What is Resumable Upload? .......... File chunks mein upload hoti hai
 * 2.  Why It Is Needed ................... Internet disconnect = start over?
 * 3.  How It Works ....................... Step by step chunk flow
 * 4.  Important Concepts ................. uploadId, chunkIndex, merging
 * 5.  Folder Structure ................... uploads/ aur tempUploads/
 * 6.  Complete Flow Example .............. Real scenario with interruption
 * 7.  Code Example ....................... Simplified Express.js implementation
 * 8.  Code Explanation ................... Every step explained
 * 9.  Real-World Examples ................ Google Drive, YouTube, Dropbox
 * 10. When to Use ........................ Decision guide
 * 11. Golden Rules ....................... Key principles to remember
 * ======================================================================
 */


/**
 * Part-1: WHAT IS RESUMABLE UPLOAD?
 */

/**
 * File Ko Chunks Mein Upload Karo — Beech Mein Rok Sako
 * ────────────────────────────────────────────────────────
 * 
 *   Resumable Upload = badi file ko chhote chhote parts (chunks) mein upload karo.
 *   Agar beech mein internet cut ho jaaye — wahan se dobara shuru karo.
 *   Shuruaat se nahi karna padta — already uploaded chunks waste nahi hote.
 *
 * DEFINITION:
 *   Resumable Upload is a technique where a file is uploaded in small parts
 *   (CHUNKS), and if the upload stops in between, it can CONTINUE from where
 *   it stopped instead of starting from the beginning.
 *
 * THE CORE IDEA:
 *   → File is divided into multiple chunks (e.g., chunk-0, chunk-1, chunk-2...)
 *   → Each chunk is uploaded SEPARATELY
 *   → Server stores each chunk temporarily
 *   → When ALL chunks arrive, server COMBINES them into the final file
 *
 * SIMPLE ANALOGY:
 *   Jaise ek lambi book ke pages alag alag packet mein bhejte ho.
 *   Agar ek packet beech raaste mein kho jaaye — sirf woh packet dobara bhejo.
 *   Baaki sab packets waste nahi hote.
 */


/**
 * Part-2: WHY IT IS NEEDED
 */

/**
 * Bina Resume Ke Kya Problem Hai
 * ────────────────────────────────
 * 
 *   1GB file upload karo. 700MB ho gaya. Internet cut gaya.
 *   Bina resumable upload ke: 0 se dobara shuru karo — 700MB waste!
 *   Resumable ke saath: sirf baaki 300MB upload karo — time aur bandwidth bach gayi!
 *
 * THE PROBLEM WITHOUT RESUMABLE UPLOAD:
 *
 *   ┌────────────────────────────────────────────────────────────┐
 *   │  File size: 1GB                                            │
 *   │                                                            │
 *   │  Upload progress:                                          │
 *   │  [███████████████████████░░░░░░░░░░] 700MB uploaded        │
 *   │                           ↑                                │
 *   │                    Internet disconnects here               │
 *   │                                                            │
 *   │  WITHOUT RESUMABLE:                                        │
 *   │  →❌ Must restart from 0MB ❌                             │
 *   │  → 700MB wasted completely                                 │
 *   │  → User frustration                                        │
 *   └────────────────────────────────────────────────────────────┘
 *
 * THE SOLUTION WITH RESUMABLE UPLOAD:
 *
 *   ┌────────────────────────────────────────────────────────────┐
 *   │  WITH RESUMABLE:                                           │
 *   │  → ✅ Resume from 700MB ✅                                │
 *   │  → Only 300MB remaining                                    │
 *   │  → 700MB already saved on server                           │
 *   │  → Time saved, bandwidth saved, user happy                 │
 *   └────────────────────────────────────────────────────────────┘
 *
 * WHAT IT SAVES:
 *   → Time (no full re-upload)
 *   → Bandwidth (only missing chunks uploaded)
 *   → User effort (no manual restart needed)
 *   → Server resources (already uploaded parts not wasted)
 */


/**
 * Part-3: HOW IT WORKS
 */

/**
 * Chunk by Chunk Upload Ka Flow
 * ──────────────────────────────
 * 
 *   Client file ko chunks mein split karta hai.
 *   Har chunk alag alag upload hota hai apne index ke saath.
 *   Server chunks save karta hai. Jab sab aa jaayein — merge karta hai.
 *
 * THE UPLOAD FLOW:
 *
 *   CLIENT SIDE:
 *   ┌──────────────────────────────────────────────────────────────┐
 *   │  video.mp4 (100MB) ──► split into 5 chunks of 20MB each      │
 *   │                                                              │
 *   │  chunk-0 (0–20MB)                                            │
 *   │  chunk-1 (20–40MB)                                           │
 *   │  chunk-2 (40–60MB)                                           │
 *   │  chunk-3 (60–80MB)                                           │
 *   │  chunk-4 (80–100MB)                                          │
 *   └──────────────────────────────────────────────────────────────┘
 *         │
 *         │ (each chunk uploaded separately with metadata)
 *         ▼
 *   SERVER SIDE:
 *   ┌──────────────────────────────────────────────────────────────┐
 *   │  Receives chunk-0 → saves in uploads/abc123/chunk-0          │
 *   │  Receives chunk-1 → saves in uploads/abc123/chunk-1          │
 *   │  Receives chunk-2 → saves in uploads/abc123/chunk-2          │
 *   │                                                              │
 *   │  [INTERNET DISCONNECTS HERE]                                 │
 *   │                                                              │
 *   │  Receives chunk-3 → saves in uploads/abc123/chunk-3          │
 *   │  Receives chunk-4 → saves in uploads/abc123/chunk-4          │
 *   │                                                              │
 *   │  All 5 chunks received!                                      │
 *   │  ↓                                                           │
 *   │  MERGE: chunk-0 + 1 + 2 + 3 + 4 = video.mp4 ✅✅            │
 *   └──────────────────────────────────────────────────────────────┘
 *
 * METADATA SENT WITH EACH CHUNK:
 *   → uploadId   → unique ID for this upload session (e.g., "abc123")
 *   → chunkIndex → which chunk is this? (0, 1, 2, 3, 4...)
 *   → totalChunks → how many total chunks? (5)
 *   → fileName   → final file name ("video.mp4")
 */


/**
 * Part-4: IMPORTANT CONCEPTS
 */

/**
 * Resumable Upload Ke Key Terms
 * ──────────────────────────────
 * 
 *   Ye 6 concepts resumable upload ke core building blocks hain.
 *
 * ┌──────────────────────────┬──────────────────────────────────────────────┐
 * │ Concept                  │ Meaning                                      │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ uploadId                 │ Unique ID for each upload session.           │
 * │                          │ Server uses this to group chunks together.   │
 * │                          │ Example: "abc123"                            │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ chunkIndex               │ Position of current chunk (0, 1, 2...).      │
 * │                          │ Server uses this to name the chunk file.     │
 * │                          │ Example: chunk-0, chunk-1                    │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ totalChunks              │ Total number of chunks in this upload.       │
 * │                          │ Server knows when upload is complete.        │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ req.file                 │ The actual chunk file uploaded by multer.    │
 * │                          │ Contains path, size, original name.          │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ fs.renameSync()          │ Moves chunk from temp folder to upload dir.  │
 * │                          │ Gives it a proper name (chunk-0, chunk-1).   │
 * ├──────────────────────────┼──────────────────────────────────────────────┤
 * │ fs.createWriteStream()   │ Creates the final merged file.               │
 * │                          │ Chunks are written into this file one by one.│
 * └──────────────────────────┴──────────────────────────────────────────────┘
 *
 * THE RESUMABLE PART — How It Works:
 *   Client should track which chunks are already uploaded.
 *   When resuming, client sends ONLY missing chunks.
 *   Server already has chunk-0, chunk-1, chunk-2 saved.
 *   Client sends only chunk-3, chunk-4 to complete the upload.
 */


/**
 * Part-5: FOLDER STRUCTURE
 */

/**
 * Server Pe Folders Ka Structure
 * ────────────────────────────────
 * 
 *   Server do folders use karta hai — ek temporary chunks ke liye, ek final files ke liye.
 *
 * FOLDER STRUCTURE:
 *
 *   project/
 *   │
 *   ├── uploads/              ← Final merged files stored here
 *   │   ├── abc123/           ← Temporary folder per upload session
 *   │   │   ├── chunk-0       ← Individual chunks
 *   │   │   ├── chunk-1
 *   │   │   ├── chunk-2
 *   │   │   └── chunk-3
 *   │   └── video.mp4         ← Final merged file (after all chunks arrive)
 *   │
 *   ├── tempUploads/          ← Multer temporarily stores uploaded chunk here
 *   │   └── 1699999999-video.mp4  ← Temp file (moved immediately to uploads/)
 *   │
 *   └── server.js
 *
 * HOW FOLDERS ARE USED:
 *   1. Multer saves chunk → tempUploads/timestamp-filename
 *   2. Server moves it   → uploads/uploadId/chunk-N
 *   3. After all chunks  → merges into uploads/finalFileName.mp4
 *   4. Cleanup           → deletes uploads/uploadId/ folder
 */


/**
 * Part-6: COMPLETE FLOW EXAMPLE
 */

/**
 * Real Scenario — Internet Disconnect Ke Saath
 * ──────────────────────────────────────────────
 * 
 *   Ye poora real-world example hai — internet cut hone ke saath.
 *
 * SCENARIO:
 *   File: video.mp4 (100MB)
 *   uploadId: "abc123"
 *   Split into 5 chunks of 20MB each
 *
 * UPLOAD SEQUENCE:
 *
 *   chunk-0 uploaded → server saves: uploads/abc123/chunk-0  ✅
 *   chunk-1 uploaded → server saves: uploads/abc123/chunk-1  ✅
 *   chunk-2 uploaded → server saves: uploads/abc123/chunk-2  ✅
 *
 *   ❌ INTERNET DISCONNECTS HERE ❌
 *   (chunks 3 and 4 not yet uploaded)
 *
 *   ✅ USER COMES BACK ONLINE ✅
 *   (client knows chunk-3 and chunk-4 are missing)
 *
 *   chunk-3 uploaded → server saves: uploads/abc123/chunk-3  ✅
 *   chunk-4 uploaded → server saves: uploads/abc123/chunk-4  ✅
 *
 * SERVER DETECTS ALL CHUNKS RECEIVED (chunkIndex + 1 === totalChunks)
 *
 * MERGE PROCESS:
 *   chunk-0 → write to final file
 *   chunk-1 → write to final file (appended)
 *   chunk-2 → write to final file (appended)
 *   chunk-3 → write to final file (appended)
 *   chunk-4 → write to final file (appended)
 *   → uploads/video.mp4 created ✅
 *
 * CLEANUP:
 *   uploads/abc123/ folder deleted (no longer needed)
 */


/**
 * Part-7: CODE EXAMPLE — Simplified Resumable Upload Server
 */


/**
 * Complete Code Explanation:
 * > This server allows uploading large files in small parts (chunks).
 *   - Each chunk is uploaded separately.
 *   - The server stores chunks temporarily.
 *   - When all chunks are uploaded, the server combines them into the
 *     final file.
 * > This allows resumable uploads.
 *
 * Important Concepts:
 * 1. uploadId              : Unique ID for each upload session
 * 2. chunkIndex            : Position of chunk
 * 3. totalChunks           : Total number of chunks
 * 4. req.file              : Uploaded chunk file
 * 5. fs.renameSync()       : Moves file to new location
 * 6. fs.createWriteStream(): Creates final file
 * 7. Resumable Upload      : Upload can continue from last chunk
 */

/**
 * Resumable Uploads:
 * > This server allows uploading large files in small parts called chunks.
 * > Instead of uploading the full file at once, the client uploads:
 *   - chunk-0, chunk-1, chunk-2, ...
 * > The server stores each chunk temporarily.
 * > When all chunks are uploaded, the server combines them into the final file.
 * > This allows resumable uploads.
 */

/**
 * 1. Import required modules
 *    a. express       → used to create server and APIs
 *    b. cors          → allows frontend (React, browser, Postman) to access server
 *    c. fs            → used to read, write, delete files
 *    d. path          → used to safely create file paths
 *    e. multer        → middleware used to handle file uploads
 *    f. fileURLToPath → used to create __dirname in ES Modules
 */

import express from "express";
import cors from "cors";
import fs from "fs";
import path from "path";
import multer from "multer";
import { fileURLToPath } from "url";

/**
 * 2. Create __filename and __dirname (ES Module Fix)
 *    a. In CommonJS  : __dirname is available by default
 *    b. In ES Modules: __dirname is NOT available, So we create it manually.
 *       __filename → full path of this file
 *       __dirname  → folder path of this file
 */

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * 3. Create Express server
 */

const app = express();
const port = 3000;

/**
 * 4. Enable middleware
 *    a. cors(): Allows frontend from different origin to access server
 *    b. express.json()      : Allows reading JSON data from req.body
 *    c. express.urlencoded(): Allows reading form-data
 */

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/**
 * 5. Create required folders
 *    > uploads/     : Final merged files stored here
 *    > tempUploads/ : Temporary storage for uploaded chunks
 */

const uploadsRoot = path.join(__dirname, "uploads");
const tempUploadsRoot = path.join(__dirname, "tempUploads");

/* Create uploads folder if not exists */
if (!fs.existsSync(uploadsRoot)) {
  fs.mkdirSync(uploadsRoot, { recursive: true });
}

/* Create tempUploads folder if not exists */
if (!fs.existsSync(tempUploadsRoot)) {
  fs.mkdirSync(tempUploadsRoot, { recursive: true });
}

/**
 * 6. Configure multer (file upload middleware)
 *    > multer handles file upload automatically
 *    > destination → where temporary chunk is stored
 *    > filename    → unique file name for temporary storage
 */

const storage = multer.diskStorage({
  /* Store chunk in tempUploads folder */
  destination: (req, file, cb) => {
    cb(null, tempUploadsRoot);
  },

  /* Create unique name using timestamp ( Ex: 1699999999-video.mp4) */
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

/* upload middleware used in API */
const upload = multer({ storage });

/**
 * 7. Upload chunk API
 *    a. upload.single("chunk") : receives one chunk file
 *    b. req.file               : uploaded file
 *    c. req.body contains:
 *       - chunkIndex
 *       - totalChunks
 *       - fileName
 *       - uploadId
 */

app.post("/upload-chunk", upload.single("chunk"), async (req, res) => {
  try {
    /* 8. Read chunk information from request */
    const chunkIndex = Number(req.body.chunkIndex);
    const totalChunks = Number(req.body.totalChunks);
    const fileName = req.body.fileName;
    const uploadId = req.body.uploadId;

    /**
     * 9. Create upload session folder
     *    > uploads/uploadId/
     *      - Example: uploads/abc123/
     *      - This folder stores all chunks of this upload session
     */

    const uploadDir = path.join(uploadsRoot, uploadId);

    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }

    /**
     * 10. Move chunk from tempUploads → uploadDir
     *     > tempUploads/file-temp: uploads/abc123/chunk-0
     */

    const chunkPath = path.join(uploadDir, `chunk-${chunkIndex}`);
    fs.renameSync(req.file.path, chunkPath);
    console.log(`Chunk ${chunkIndex} saved`);

    /* 11. If not last chunk, stop here */
    if (chunkIndex + 1 !== totalChunks) {
      return res.json({
        success: true,
        message: `Chunk ${chunkIndex} uploaded`,
      });
    }

    /* 12. All chunks received → start merging */
    console.log("All chunks received. Merging...");
    const finalFilePath = path.join(uploadsRoot, fileName);
    const writeStream = fs.createWriteStream(finalFilePath);

    /**
     * 13. Merge chunks sequentially using streams
     *     - chunk-0 → write
     *     - chunk-1 → write
     *     - chunk-2 → write
     *       ...
     */
    async function mergeChunks() {
      for (let i = 0; i < totalChunks; i++) {
        const chunkFile = path.join(uploadDir, `chunk-${i}`);

        await new Promise((resolve, reject) => {
          const readStream = fs.createReadStream(chunkFile);

          /* Pipe chunk into final file */
          readStream.pipe(writeStream, { end: false });

          /* After writing chunk → delete it */
          readStream.on("end", () => {
            fs.unlinkSync(chunkFile);
            resolve();
          });

          readStream.on("error", reject);
        });
      }
    }

    await mergeChunks();

    /* 14. Close final file stream */
    writeStream.end();

    writeStream.on("finish", () => {
      console.log("Merge complete");

      /* Delete temporary upload session folder */
      fs.rmSync(uploadDir, { recursive: true, force: true });
      console.log("Temporary chunks cleaned");
    });

    /* 15. Send success response */
    return res.json({
      success: true,
      message: "File uploaded and merged successfully",
    });
  } catch (err) {
    console.error(err);

    res.status(500).json({
      success: false,
      message: "Upload failed",
    });
  }
});

/**
 * 16. Start server
 */
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

/**
 * Complete Flow Example
 * > File = video.mp4 (100MB)
 * > Client splits into:
 *   - chunk-0
 *   - chunk-1
 *   - chunk-2
 *   - chunk-3
 *   - chunk-4
 *
 * > Upload process:
 *   - upload chunk-0 → saved
 *   - upload chunk-1 → saved
 *   - upload chunk-2 → saved
 *
 * internet disconnects
 *
 * resume upload:
 * - upload chunk-3 → saved
 * - upload chunk-4 → saved
 *
 *
 * Server merges:
 * > chunk-0 + chunk-1 + chunk-2 + chunk-3 + chunk-4 = video.mp4
 * > Final file ready inside uploads folder
 */


/**
 * Part-8: CODE EXPLANATION — Every Step Explained
 */

/**
 * Har Step Ka Detailed Explanation
 * ──────────────────────────────────
 * 
 *   Code ke har important part ka simple explanation — beginners ke liye.
 *
 * STEP 1: Imports
 *   → express   : server banane ke liye
 *   → cors      : frontend ko access dene ke liye
 *   → fs        : file system operations (read/write/delete)
 *   → path      : safe file paths banane ke liye
 *   → multer    : file upload handle karne ke liye automatically
 *   → fileURLToPath: ES Module mein __dirname banana ke liye
 *
 * STEP 2: __filename aur __dirname fix
 *   → ES Modules mein ye built-in available nahi hote.
 *   → fileURLToPath(import.meta.url) → current file ka path deta hai.
 *   → path.dirname(__filename) → current file ka folder path deta hai.
 *
 * STEP 3: Folder creation
 *   → uploads/     → final merged file yahan aayegi.
 *   → tempUploads/ → multer yahan temporarily chunk save karta hai.
 *   → fs.existsSync() → check karo folder exist karta hai ya nahi.
 *   → fs.mkdirSync() → folder banao agar nahi hai.
 *
 * STEP 4: multer configuration
 *   → multer.diskStorage() → bata do kahan save karo aur kya naam do.
 *   → destination → tempUploadsFolder mein save karo.
 *   → filename → Date.now() + originalname → unique name (timestamp).
 *   → upload = multer({ storage }) → ye middleware use hoga route mein.
 *
 * STEP 5: upload-chunk route
 *   → upload.single('chunk') → ek baar mein ek chunk file receive karo.
 *   → req.body.chunkIndex  → konsa chunk hai ye? (0, 1, 2...)
 *   → req.body.totalChunks → total kitne chunks expect kar rahe hain?
 *   → req.body.fileName    → final file ka naam kya hoga?
 *   → req.body.uploadId    → ye session ka unique ID kya hai?
 *
 * STEP 6: Session folder
 *   → uploads/abc123/ → sab chunks ek jagah store honge.
 *   → uploadId se folder naam banate hain → ek upload = ek folder.
 *
 * STEP 7: fs.renameSync()
 *   → Chunk ko temp folder se session folder mein move karo.
 *   → Before: tempUploads/1699999999999-video.mp4
 *   → After:  uploads/abc123/chunk-0
 *   → Proper naam milta hai (chunk-0, chunk-1, etc.).
 *
 * STEP 8: Last chunk check
 *   → chunkIndex + 1 === totalChunks matlab ye LAST chunk hai.
 *   → Agar last nahi hai → sirf success reply karo, merge mat karo.
 *   → Agar last hai → merging shuru karo.
 *
 * STEP 9: Merging chunks
 *   → fs.createWriteStream(finalFilePath, { flags: 'a' })
 *     → Final file kholo (append mode).
 *     → flags: 'a' = append — har chunk add hota jaayega end mein.
 *   → for loop → chunk-0 se chunk-N tak ek ek karke likhte hain.
 *   → readStream.pipe(writeStream, { end: false })
 *     → Chunk read karo aur final file mein likhte jao.
 *     → end: false = final file band mat karo (aur chunks aayenge).
 *   → readStream.on('end') → chunk likhna khatam → delete karo, next jao.
 *
 * STEP 10: Cleanup
 *   → writeStream.end() → sab kuch likhne ke baad final file close karo.
 *   → fs.rmSync(sessionFolder) → session folder delete karo (chunks gone).
 */


/**
 * Part-9: REAL-WORLD EXAMPLES
 */

/**
 * Resumable Upload Real Life Mein
 * ──────────────────────────────────
 * 
 *   Ye platforms daily resumable uploads use karti hain.
 *
 *   → Google Drive    → Large file upload (pause + resume button)
 *   → YouTube         → Video upload (handles interruptions automatically)
 *   → Dropbox         → File sync across devices
 *   → OneDrive        → Microsoft cloud storage upload
 *   → AWS S3          → Multipart upload API
 *   → Any large file  → Upload system on slow/unreliable connections
 *
 * HOW GOOGLE DRIVE DOES IT:
 *   1. You select a 2GB file to upload
 *   2. Google Drive splits it into chunks
 *   3. Each chunk uploaded to Google's servers
 *   4. Internet disconnects at 40% → Google saves chunks already uploaded
 *   5. You reconnect → Drive resumes from chunk where it stopped
 *   6. Upload completes → Drive merges chunks into final file
 *   7. File visible in your Drive
 */


/**
 * Part-10: WHEN TO USE RESUMABLE UPLOADS
 */

/**
 * Resumable Upload Ka Decision Guide
 * ─────────────────────────────────────
 * 
 *   Kab resumable upload zaroori hai aur kab simple upload kaafi hai.
 *
 * ✅ USE RESUMABLE UPLOAD WHEN:
 *   → Large files (50MB, 100MB, 1GB, etc.)
 *   → Slow or unreliable internet connection
 *   → Mobile uploads (network can switch or drop)
 *   → Video/audio file uploads
 *   → Document sharing platforms
 *   → User might close browser and come back later
 *
 * ❌ NOT NEEDED WHEN:
 *   → Small files (profile picture, small PDFs, small images)
 *   → Files under 5-10MB
 *   → Fast stable internet guaranteed
 *   → Simple form file uploads
 *
 * COMPARISON TABLE:
 * ┌────────────────────────────┬──────────────────┬──────────────────────┐
 * │ Aspect                     │ Normal Upload    │ Resumable Upload     │
 * ├────────────────────────────┼──────────────────┼──────────────────────┤
 * │ Upload method              │ One request      │ Multiple requests    │
 * │ Interrupt handling         │ Start over ❌   │ Resume ✅            │
 * │ Bandwidth on failure       │ Wasted           │ Only missing chunks  │
 * │ Complexity                 │ Simple           │ More setup needed    │
 * │ Best for                   │ Small files      │ Large files          │
 * └────────────────────────────┴──────────────────┴──────────────────────┘
 */


/**
 * Part-11: GOLDEN RULES
 */

/**
 * Resumable Upload ke Core Principles
 * ──────────────────────────────────────
 *
 *  1. ✅ SPLIT LARGE FILES INTO CHUNKS BEFORE UPLOADING
 *        Never try to upload a 1GB file in one request.
 *        Split into 1MB–10MB chunks depending on file size.
 *
 *  2. ✅ uploadId GROUPS ALL CHUNKS TOGETHER
 *        Every chunk from the same upload session must have the same uploadId.
 *        Server uses this to create one folder per session.
 *
 *  3. ✅ chunkIndex PRESERVES ORDER DURING MERGE
 *        Chunks may arrive out of order. Index ensures correct merge order.
 *        Always merge: chunk-0, chunk-1, chunk-2... in that sequence.
 *
 *  4. ✅ SERVER DETECTS COMPLETION VIA chunkIndex + 1 === totalChunks
 *        Last chunk triggers the merge process.
 *        Simple and effective completion detection.
 *
 *  5. ✅ ALWAYS USE APPEND MODE WHEN MERGING
 *        fs.createWriteStream(filePath, { flags: 'a' })
 *        Each chunk appended to end of final file — not overwritten.
 *
 *  6. ✅ DELETE CHUNKS AFTER MERGING
 *        Once chunks are merged into final file, delete the temp chunks.
 *        Saves disk space. fs.unlinkSync() for each chunk, fs.rmSync() for folder.
 *
 *  7. ✅ pipe() WITH { end: false } IS IMPORTANT
 *        Without end: false, the file stream closes after first chunk.
 *        Remaining chunks would fail to write.
 *
 *  8. ✅ CLIENT MUST TRACK WHICH CHUNKS ARE UPLOADED
 *        For true resumability, client must know which chunks already succeeded.
 *        On reconnect, send ONLY missing chunks — not already-uploaded ones.
 *
 *  9. ✅ CLEANUP TEMP FOLDER AFTER MERGE
 *        Session folder (uploads/abc123/) is no longer needed after merge.
 *        Always clean up to avoid disk space waste.
 *
 * 10. ✅ RESUMABLE UPLOADS = BEST FOR UNRELIABLE NETWORKS
 *        Mobile users, slow connections, large video uploads —
 *        always use resumable uploads here. Normal upload = frustration.
 *
 * ======================================================================
 */