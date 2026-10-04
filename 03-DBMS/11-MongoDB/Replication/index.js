/**
 * Replication:
 * - Suppose your MongoDB server crashes. What happens?
 *   - Users cannot access data.
 *   - Application may go down.
 *   - New data cannot be written.
 * - What if we keep copies of the same database on multiple servers?
 *   - This idea is called Replication.
 * 
 * Definition:
 * - Replication is the process of maintaining multiple copies of the same data across
 *   multiple MongoDB servers to ensure high availability and fault tolerance.
 * 
 *                           +--------------------+
 *                           | Client Application |
 *                           +--------------------+
 *                                     |           
 *                                     | (Write)    
 *                                     |            
 *   +---------------------------------|--------------------------------------+
 *   |                                 V                                      | 
 *   |                       +--------------------+                           |
 *   |                       |      Primary       | (27018)                   |
 *   |                       +--------------------+                           | 
 *   |                                 |                                      |
 *   |                                 |                                      |
 *   |                +----------------+----------------+                     |
 *   |                |                                 |                     |
 *   |                | (Replication)                   | (Replication)       |
 *   |                |                                 |                     |
 *   |                V                                 V                     |
 *   |       +--------------------+            +--------------------+         |
 *   |       |    Secondary       |            |    Secondary       |         |
 *   |       +--------------------+            +--------------------+         |
 *   |             (27019)                            (27020)                 |
 *   |                                                                        |
 *   | # This group of servers are called Replica Set.                        |
 *   +------------------------------------------------------------------------+
 *    
 * - READ task hum primary m kr rhe honge (27017), aur poora operation log ek op_log naam
 *   k collection m save ho rha hoga jo humare local database m present hoga, aur yahi saare
 *   logs rkha hoga ki primary m kon kon se operations hue.
 * - Secondary inhi chijo ko monitor krte hue apne aap m data ko sync krta jaega.
 * 
 * 
 * Why do we need replication?
 * 1. High Availability: If one server fails, another server can take over.
 * 2. Fault Tolerance  : Hardware failures don't bring down the application.
 * 3. Disaster Recovery: Data can still be recovered from replicas.
 * 4. Read Scaling     : Some read operations can be served by secondary nodes.
*/

/**
 * What is a Replica Set?
 * - MongoDB replication is implemented using a Replica Set.
 * - A Replica Set is a group of MongoDB servers that maintain the same dataset.
 * - Example:
 *   - ReplicaSet
 *     |- Primary
 *     |- Secondary
 *     |- Secondary
 * 
 * How Replication works internally?
 * - MongoDB uses a special collection called oplog (Operation Log).
 * - Every write operation is recorded here. Example: Insert User, Update User, etc.
 * - All operations are stored in oplog.
 * 
 *       +--------+
 *       | Client |
 *       +--------+
 *           |
 *           V
 *      +---------+
 *      | Primary |
 *      +---------+
 *           |
 *           V
 *       +-------+
 *       | Oplog |
 *       +-------+
 *           |
 *           V
 *    +-----------------+
 *    | Secondary Nodes |
 *    +-----------------+
 * 
 * - Secondary servers continuously read the oplog and apply those changes.
 * - This process is called Replication Sync.
 * 
 * 
 * What happens if Primary Crashes?
 * - Primary X
 *   Secondary 1
 *   Secondary 2
 * 
 * - Now nobody can write data.
 * - MongoDB starts Election Process, One secondary becomes new primary.
 * 
 * - Old Primary X
 * - Secondary 1 => New Primary
 * - Secondary 2 => secondary
 * - This is called Automatic Failover.    
*/


/**
 * Replication Lag:
 * - Sometimes secondary isn't updated immediately.
 * - Example: Primary Updated Secondary Still Syncing.
 * - This delay is called Replication Lag. 
 * - Causes:
 *   - Slow network
 *   - Heavy work load
 *   - Large writes
*/


/**
 * Read from Secondary:
 * - Normally:
 *   - READ  -> Primary
 *   - WRITE -> Primary
 * - But MongoDB allows:
 *   - READ  -> Secondary
 * 
 * Benefits:
 * - Less load on Primary
 * - Better Performance
 * 
 * This leads to Read Preferences.
*/


/**
 * Replication vs Backup:
 * 
 * +-------------------+------------------------+
 * | Replication       | Backup                 |
 * +-------------------+------------------------+
 * | Live Copy         | Stored Copy            |
 * | Automatic         | Scheduled              |
 * | High Availability | Disaster Recovery      |
 * | Real-time Sync    | Point-in-time Snapshot |
 * +-------------------+------------------------+
 * 
 * - Replication is NOT a backup.
 * - If someone deletes data on Primary: Deleted everywhere
 * - PRIMARY DELETE -> SECONDARY DELETE
*/

/**
 * Commands:
 * - mongod --replSet rs0 --port 27017 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db1
 * - mongod --replSet rs0 --port 27018 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db2
 * - mongod --replSet rs0 --port 27019 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db3
 * 
 * - rs.initiate({
 *      _id: "rs0",
 *      members: [
 *         { _id: 0, host: "localhost:27017" },
 *         { _id: 1, host: "localhost:27018" },
 *         { _id: 2, host: "localhost:27019" },
 *      ]
 *   })
*/


/**
 * Steps:
 * 1. Open CMD as Administrator.
 * 2. Open 4 separate terminals:
 *    - Terminal-1: Start MongoDB server on port 27018      |
 *    - Terminal-2: Start MongoDB server on port 27019      |=======> Replica Members
 *    - Terminal-3: Start MongoDB server on port 27020      |
 *    - Terminal-4: Run Replica Set configuration commands
 * 3. Navigate to MongoDB bin folder in all 3 terminals to create server: 
 *    - cd C:\Program Files\MongoDB\Server\8.2\bin
 * 4. Start MongoDB servers:
 *    - Terminal-1: mongod --replSet rs0 --port 27018 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db1
 *    - Terminal-2: mongod --replSet rs0 --port 27019 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db2
 *    - Terminal-3: mongod --replSet rs0 --port 27020 --dbpath C:\Program Files\MongoDB\Server\8.2\data\db3
 *
 *    Note: --dbpath specifies where MongoDB will store the database files for each 
 *          server instance.
 *
 * 5. Initialize replication in Terminal-4:
 *    rs.initiate({
 *      _id: "rs0",
 *      members: [
 *        { _id: 0, host: "localhost:27018" },
 *        { _id: 1, host: "localhost:27019" },
 *        { _id: 2, host: "localhost:27020" }
 *      ]
 *    })
 *
 *    MongoDB will automatically:
 *    - Elect one node as PRIMARY
 *    - Mark the remaining nodes as SECONDARY
 *    - Replicate data from PRIMARY to all SECONDARY nodes
 * 
 * 6. Check on terminal-5: 
 *    - mongosh --port 27018
 *    - rs.status()
 *    - go to mongodb compass & click on new connection to see data:
 *      + mongodb://localhost:27018
 *      + mongodb://localhost:27019
 *      + mongodb://localhost:27020
 *    - Terminal-1 (Primary):
 *      - show db
 *      - use ecommerce
 *      - show collections
 *      - db.users.insertMany(
 *           { name: 'mkl', email: 'mkl@gmail.com' },
 *           { name: 'mkl2', email: 'mkl2@gmail.com' }
 *        )
 *      - Refresh and see data in 27018, 27019, 27020
 */