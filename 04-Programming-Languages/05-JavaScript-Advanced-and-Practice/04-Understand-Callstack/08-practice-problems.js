/**
 * PROBLEM 1: Basic async function
 * - Input:  async function returning a value
 * - Output: "Hello"
*/

async function hello() {
  return "Hello";
}
hello().then((val) => console.log(val));

// Output: "Hello"


/**
 * PROBLEM 2: Await a resolved promise
 * - Input:  await Promise.resolve(42)
 * - Output: 42
*/

async function getVal() {
  const val = await Promise.resolve(42);
  console.log(val);
}
getVal();

// Output: 42


/**
 * PROBLEM 3: Await a delayed promise
 * - Input:  await sleep(1000)
 * - Output: "Done" (after 1 second)
*/

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
async function delayed() {
  await sleep(100);
  console.log("Done");
}
delayed();

// Output: "Done" (after 100ms)


/**
 * PROBLEM 4: Sequential awaits — one after another
 * - Input:  await step1(), await step2()
 * - Output: "Step 1", "Step 2" (100ms apart)
*/

async function sequential() {
  await sleep(100);
  console.log("Step 1");
  await sleep(100);
  console.log("Step 2");
}
sequential();

// Output: "Step 1", "Step 2" (200ms total)


/**
 * PROBLEM 5: Parallel execution with Promise.all + await
 * - Input:  await Promise.all([p1, p2, p3])
 * - Output: ["A", "B", "C"] (all run at the same time)
*/

async function parallel() {
  const results = await Promise.all([
    Promise.resolve("A"),
    Promise.resolve("B"),
    Promise.resolve("C"),
  ]);
  console.log(results);
}
parallel();

// Output: ["A", "B", "C"]


/**
 * PROBLEM 6: Basic error handling with try/catch
 * - Input:  await Promise.reject("Error!")
 * - Output: "Caught: Error!"
*/

async function risky() {
  try {
    await Promise.reject("Error!");
  } catch (err) {
    console.log(`Caught: ${err}`);
  }
}
risky();

// Output: "Caught: Error!"


/**
 * PROBLEM 7: Async function always returns a promise
 * - Input:  async function returning non-promise value
 * - Output: true (it's a Promise)
*/

async function returnNum() {
  return 42;
}
const result7 = returnNum();
console.log(result7 instanceof Promise);

// Output: true


/**
 * PROBLEM 8: Fetch data simulation with async/await
 * - Input:  await mockFetch("/users/1")
 * - Output: { id: 1, name: "John" }
*/

// function mockFetch(url) {
//   return new Promise((resolve, reject) => {
//     setTimeout(() => {
//       if (url === "/users/1") resolve({ id: 1, name: "John" });
//       else reject("404 Not Found");
//     }, 100);
//   });
// }
// async function getUser() {
//   const user = await mockFetch("/users/1");
//   console.log(user);
// }
// getUser();

// Output: { id: 1, name: "John" }


/**
 * PROBLEM 9: Chained async calls — fetch user then posts
 * - Input:  await getUser() → await getPosts(user.id)
 * - Output: 3 (number of posts)
*/

function getUser9() {
  return Promise.resolve({ id: 1, name: "John" });
}
function getPosts(userId) {
  return Promise.resolve([
    { id: 1, userId: 1 },
    { id: 2, userId: 1 },
    { id: 3, userId: 1 },
  ]);
}
async function getUserData() {
  const user = await getUser9();
  const posts = await getPosts(user.id);
  console.log(posts.length);
}
getUserData();

// Output: 3


/**
 * PROBLEM 10: Error in one step breaks the chain
 * - Input:  await step1() throws → step2() never runs
 * - Output: "Step 1 failed", "Step 2 skipped"
*/

async function brokenChain() {
  try {
    await Promise.reject("Step 1 failed");
    console.log("Step 2");
  } catch (err) {
    console.log(err);
    console.log("Step 2 skipped");
  }
}
brokenChain();

// Output: "Step 1 failed", "Step 2 skipped"


/**
 * PROBLEM 11: Await with Promise.race
 * - Input:  await Promise.race([slow, fast])
 * - Output: "Fast"
*/

async function raceTest() {
  const slow = new Promise((r) => setTimeout(() => r("Slow"), 200));
  const fast = new Promise((r) => setTimeout(() => r("Fast"), 50));
  const winner = await Promise.race([slow, fast]);
  console.log(winner);
}
raceTest();

// Output: "Fast"


/**
 * PROBLEM 12: Await with Promise.allSettled
 * - Input:  await Promise.allSettled([resolve, reject, resolve])
 * - Output: [{status: "fulfilled", value: 1}, {status: "rejected", reason: "Err"}, ...]
*/

async function allSettledTest() {
  const results = await Promise.allSettled([
    Promise.resolve(1),
    Promise.reject("Err"),
    Promise.resolve(3),
  ]);
  console.log(results);
}
allSettledTest();

// Output: [{status: "fulfilled", value: 1}, {status: "rejected", reason: "Err"}, {status: "fulfilled", value: 3}]


/**
 * PROBLEM 13: Await with Promise.any
 * - Input:  await Promise.any([reject, resolve, reject])
 * - Output: "Success"
*/

async function anyTest() {
  const result = await Promise.any([
    Promise.reject("Err1"),
    Promise.resolve("Success"),
    Promise.reject("Err2"),
  ]);
  console.log(result);
}
anyTest();

// Output: "Success"


/**
 * PROBLEM 14: Convert .then() chain to async/await
 * - Input:  fetchUser().then(getPosts).then(count)
 * - Output: 3
*/

function fetchUser14() {
  return Promise.resolve({ id: 1 });
}
function fetchPosts14(userId) {
  return Promise.resolve([1, 2, 3]);
}
async function convertChain() {
  const user = await fetchUser14();
  const posts = await fetchPosts14(user.id);
  console.log(posts.length);
}
convertChain();

// Output: 3


/**
 * PROBLEM 15: Loop with await — sequential processing
 * - Input:  [1, 2, 3] — await each one
 * - Output: "1", "2", "3" (100ms apart)
*/

async function sequentialLoop() {
  const items = [1, 2, 3];
  for (const item of items) {
    await sleep(100);
    console.log(item);
  }
}
sequentialLoop();

// Output: 1, 2, 3 (each 100ms apart)


/**
 * PROBLEM 16: Parallel processing with map + Promise.all
 * - Input:  [1, 2, 3] — all processed at once
 * - Output: [1, 2, 3] (all resolve at ~same time)
*/

async function parallelMap() {
  const items = [1, 2, 3];
  const results = await Promise.all(
    items.map(async (item) => {
      await sleep(100);
      return item;
    })
  );
  console.log(results);
}
parallelMap();

// Output: [1, 2,  3] (all after ~100ms)


/**
 * PROBLEM 17: Process array in batches (concurrency control)
 * - Input:  [1,2,3,4,5], batchSize = 2
 * - Output: [1, 2, 3, 4, 5] (2 at a time)
*/

async function processInBatches(items, batchSize) {
  const results = [];
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    const batchResults = await Promise.all(
      batch.map(async (item) => {
        await sleep(50);
        return item;
      })
    );
    results.push(...batchResults);
  }
  console.log(results);
}
processInBatches([1, 2, 3, 4, 5], 2);

// Output: [1, 2, 3, 4, 5]


/**
 * PROBLEM 18: Retry with async/await
 * - Input:  retryAsync(unstableFn, 3)
 * - Output: "Success on attempt 3"
*/

async function retryAsync(fn, maxRetries) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (err) {
      if (i === maxRetries - 1) throw err;
      console.log(`Attempt ${i + 1} failed, retrying...`);
    }
  }
}
let count18 = 0;
const unstableFn18 = async () => {
  count18++;
  if (count18 < 3) throw new Error("Not yet");
  return "Success on attempt 3";
};
retryAsync(unstableFn18, 5)
  .then((val) => console.log(val))
  .catch((err) => console.log(err));

// Output: "Attempt 1 failed...", "Attempt 2 failed...", "Success on attempt 3"


/**
 * PROBLEM 19: Timeout with async/await using Promise.race
 * - Input:  await withTimeout(slowPromise, 100)
 * - Output: "Timeout"
*/

function withTimeout(promise, ms) {
  const timeout = new Promise((_, reject) =>
    setTimeout(() => reject("Timeout"), ms)
  );
  return Promise.race([promise, timeout]);
}
async function timeoutTest() {
  try {
    await withTimeout(sleep(500), 100);
    console.log("Done");
  } catch (err) {
    console.log(err);
  }
}
timeoutTest();

// Output: "Timeout"


/**
 * PROBLEM 20: Fetch multiple URLs in parallel
 * - Input:  ["/users/1", "/users/2", "/users/3"]
 * - Output: [{id: 1}, {id: 2}, {id: 3}]
*/

function mockFetch20(url) {
  const id = url.split("/")[2];
  return Promise.resolve({ id: Number(id) });
}
async function fetchAllUrls(urls) {
  const data = await Promise.all(urls.map((url) => mockFetch20(url)));
  console.log(data);
}
fetchAllUrls(["/users/1", "/users/2", "/users/3"]);

// Output: [{id: 1}, {id: 2}, {id: 3}]


/**
 * PROBLEM 21: Sequential vs Parallel timing comparison
 * - Input:  3 tasks, each takes 100ms
 * - Output: Sequential: 300ms, Parallel: ~100ms
*/

async function timingComparison() {
  // Sequential
  const seqStart = Date.now();
  await sleep(100);
  await sleep(100);
  await sleep(100);
  const seqTime = Date.now() - seqStart;

  // Parallel
  const parStart = Date.now();
  await Promise.all([sleep(100), sleep(100), sleep(100)]);
  const parTime = Date.now() - parStart;

  console.log(`Sequential: ${seqTime}ms, Parallel: ${parTime}ms`);
}
timingComparison();

// Output: "Sequential: ~300ms, Parallel: ~100ms"


/**
 * PROBLEM 22: Fetch with error recovery (fallback)
 * - Input:  primary fails → try fallback
 * - Output: "From fallback"
*/

async function fetchWithFallback22() {
  function mockFetch22(url) {
    if (url === "/primary") return Promise.reject("Primary failed");
    return Promise.resolve("From fallback");
  }
  try {
    return await mockFetch22("/primary");
  } catch {
    return await mockFetch22("/fallback");
  }
}
fetchWithFallback22().then((val) => console.log(val));

// Output: "From fallback"


/**
 * PROBLEM 23: Async reduce — process items sequentially and accumulate
 * - Input:  [1, 2, 3, 4] — sum with async delay
 * - Output: 10
*/

async function asyncReduce(arr) {
  let total = 0;
  for (const num of arr) {
    const val = await new Promise((resolve) => resolve(num));
    total += val;
  }
  return total;
}
asyncReduce([1, 2, 3, 4]).then((result) => console.log(result));

// Output: 10


/**
 * PROBLEM 24: Top-level await simulation (IIFE)
 * - Input:  (async () => { await sleep(100); console.log("Done") })()
 * - Output: "Done"
*/

(async () => {
  await sleep(100);
  console.log("Done");
})();

// Output: "Done" (after 100ms)


/**
 * PROBLEM 25: Async filter — filter using async predicate
 * - Input:  [1, 2, 3, 4, 5] — keep odd numbers (checked asynchronously)
 * - Output: [1, 3, 5]
*/

async function asyncFilter(arr, predicate) {
  const results = await Promise.all(arr.map(predicate));
  return arr.filter((_, i) => results[i]);
}
async function isOdd(n) {
  await sleep(10);
  return n % 2 !== 0;
}
asyncFilter([1, 2, 11, 4, 5], isOdd).then((result) => console.log(result));

// Output: [1, 2, 11, 4, 5].filter → wait, [1, 11, 5]

// Output: [1, 11, 5]


/**
 * PROBLEM 26: Promise pool with async/await (concurrency limit)
 * - Input:  5 tasks, concurrency = 2
 * - Output: [1, 2, 3, 4, 5]
*/

async function promisePool26(tasks, concurrency) {
  let index = 0;
  const results = [];
  async function worker() {
    while (index < tasks.length) {
      const i = index++;
      results[i] = await tasks[i]();
    }
  }
  await Promise.all(Array.from({ length: concurrency }, () => worker()));
  return results;
}
async function poolTest() {
  const tasks = [1, 2, 3, 4, 5].map((n) => async () => {
    await sleep(50);
    return n;
  });
  const results = await promisePool26(tasks, 2);
  console.log(results);
}
poolTest();

// Output: [1, 2, 3, 4, 5]


/**
 * PROBLEM 27: Async memoize — cache async results
 * - Input:  memoAsync("/users/1") called twice
 * - Output: "Fetching...", { id: 1 }, "From cache", { id: 1 }
*/

function memoAsync27(fn) {
  const cache = {};
  return async function (...args) {
    const key = JSON.stringify(args);
    if (key in cache) {
      console.log("From cache");
      return cache[key];
    }
    console.log("Fetching...");
    cache[key] = await fn(...args);
    return cache[key];
  };
}
const getUser27 = memoAsync27(async (url) => {
  await sleep(50);
  return { id: 1 };
});
(async () => {
  console.log(await getUser27("/users/1"));
  console.log(await getUser27("/users/1"));
})();

// Output: "Fetching...", { id: 1 }, "From cache", { id: 1 }


/**
 * PROBLEM 28: Queue async tasks — execute one by one
 * - Input:  queue.add(task1), queue.add(task2)
 * - Output: "Task 1", "Task 2" (in order)
*/

function createAsyncQueue() {
  let chain = Promise.resolve();
  return {
    add(fn) {
      chain = chain.then(fn);
      return chain;
    },
  };
}
const queue28 = createAsyncQueue();
queue28.add(async () => {
  await sleep(50);
  console.log("Task 1");
});
queue28.add(async () => {
  await sleep(50);
  console.log("Task 2");
});

// Output: "Task 1", "Task 2" (100ms apart)


/**
 * PROBLEM 29: Execute with delay between calls
 * - Input:  [fn1, fn2, fn3] with 100ms gap between each
 * - Output: "A", "B", "C" (100ms apart)
*/

async function executeWithDelay(tasks, delayMs) {
  for (let i = 0; i < tasks.length; i++) {
    if (i > 0) await sleep(delayMs);
    await tasks[i]();
  }
}
const tasks29 = [
  async () => console.log("A"),
  async () => console.log("B"),
  async () => console.log("C"),
];
executeWithDelay(tasks29, 100);

// Output: "A", "B", "C" (100ms apart)


/**
 * PROBLEM 30: Full pipeline — fetch, transform, filter, sort, display
 * - Input:  [{name: 'A', score: 45}, {name: 'B', score: 85}, {name: 'C', score: 70}, {name: 'D', score: 30}]
 * - Steps:  Fetch data → filter score >= 50 → sort descending → extract names
 * - Output: ['B', 'C']
*/

function mockFetch30() {
  return Promise.resolve([
    { name: "A", score: 45 },
    { name: "B", score: 85 },
    { name: "C", score: 70 },
    { name: "D", score: 30 },
  ]);
}
async function fullPipeline() {
  try {
    // 1. Fetch
    const data = await mockFetch30();

    // 2. Filter passing scores
    const passing = data.filter((s) => s.score >= 50);

    // 3. Sort descending
    const sorted = passing.sort((a, b) => b.score - a.score);

    // 4. Extract names
    const names = sorted.map((s) => s.name);

    console.log(names);
  } catch (err) {
    console.log(`Error: ${err}`);
  }
}
fullPipeline();

// Output: ['B', 'C']
