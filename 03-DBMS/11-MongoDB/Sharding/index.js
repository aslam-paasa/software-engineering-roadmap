/**
 * Sharding:
 * - Imagine Instagram has 500 million users. Can a single MongoDB Server handle
 *   all the users, photos, comment, and messages forever?
 * - No! Because a single server has limits:
 *   - Limited RAM
 *   - Limited CPU
 *   - Limited Storage
 *   - Limited Network Capacity
 * - This is called the Scaling problem.
*/


/**
 * Vertical Scaling vs Horizontal Scaling:
 * 
 * 1. Vertical Scaling:
 * - Increase the power of one machine.
 * - Server => More RAM, CPU, Storage
 * - Ex: 16GB => 64 GB RAM
 * - Problem: Eventually, even the biggest server has limits and becomes very expensive.
 * 
 * 2. Horizontal Scaling:
 *    - Add more servers
 *      - Server 1
 *      - Server 2
 *      - Server 3
 *    - Instead of making one machine bigger, increase use of multiple machines.
 *    - This idea leads to Sharding.
*/


/**
 * What is Sharding?
 * - Sharding is the process of distributing data across multiple servers so that no single
 *   server stores all the data.
 * - In simple words, Replication copies data and Sharding divides data.
*/


/**
 * Replication vs Sharding:
 * 1. Replication:
 *    - Server 1 => Copy
 *    - Server 2 => Copy
 *    - Server 3 => Copy
 *      [Same Data]
 * 
 *    - Purpose:
 *      - High Availability
 *      - Fault Tolerance
 * 
 * 2. Sharding:
 *    - Server 1 => User A-F
 *    - Server 2 => User G-M
 *    - Server 3 => User N-Z
 * 
 *    - Purpose:
 *      - Handle huge amount of data
 *      - Scale Horiontally
*/


/**
 * Sharded Cluster Architecture:
 * - MongoDB Sharding has three components:
 * 
 *   1. Component 1: Shards
 *      - Shards store the actual data.
 * 
 *   2. Component 2: Config Servers
 *      - Config Servers store metadata about the cluster.
 *      - Metadata means: Information about where data lives
 *      - Example:
 *        - User 123 -> Shard 2
 *        - User 987 -> Shard 1
 *      - Config Servers know this. They do NOT store actual application data.
 * 
 *   3. Component 3: mongos
 *      - mongos acts as a query router.
 *      - Application do NOT connect directly to shards 
 *      - Application connects to the mongos router and mongos router redirects them to
 *        their respective shard using the Config Server.
 * 
 *        +-------------+
 *        | Application |
 *        +-------------+
 *               |
 *               V
 *            mongos
 *               |
 *      +--------+--------+
 *      |        |        |
 *      V        V        V
 *      S1       S2       S3
 *               |
 *         Config Servers
*/


/**
 * How Query Routing Works?
 * 1. Application sends query to mongos.
 * 2. mongos asks Config Servers: Which shard contains userId 500?
 * 3. Config Servers respond: Shard 2
 * 4. mongos sends query to Shard 2
 * 5. Shard 2 returns result
 * 
 * Query Flow: Client > mongos > Config Server > Correct Shard > Result
*/


/**
 * What is a Shard Key?
 * - A Shard key is the field MongoDB uses to decide how to distribute data among shards. 
 *   (Jis key k basis pe data k distribution krnge usse shard key bolnge)
 *   {
 *      userId: 1001,
 *      name: "Manas"
 *   }
 * - If userId is the shard key, MongoDB uses it to decide where this document goes.
 * - A good shard key has high cardinality (many unique values).
 * - Ex: userId, email, orderId, etc.
*/

/**
 * Range-Based Sharding:
 * - Example:
 *   - Shard Key: UserId
 *   - Distribution:
 *     - 1-1000    => Shard 1
 *     - 1001-2000 => Shard 2
 *     - 2001-3000 => Shard 2
 * 
 * - Advantages: Efficient range queries
 * - Problem   : Can create hotspots (kisi ek shard pe jyda load ho jaega)
*/

/**
 * Hashed Sharding:
 * - MongoDB hashes the shard key (For Ex: userId - 1 => has value 10283)
 * - Distribution becomes random
 * - Advantage: Better distribution
 * - Problem  : Less efficient for range queries
*/

/**
 * Real-World Example:
 * - YouTube has millions of videos.
 * - Instead of storing everything on one database server:
 *   Shard 1 => Some videos
 *   Shard 2 => Some videos
 *   Shard 3 => Some videos
 *   ....
 * - This allows YouTube to keep growing.
*/



/**
 * Steps:
 * 1. Open CMD as Administrator.
 *
 * 2. Open 5 separate terminals:
 *    - Terminal-1: Start Shard-1 (27018)
 *    - Terminal-2: Start Shard-2 (27019)
 *    - Terminal-3: Start Shard-3 (27020)
 *    - Terminal-4: Start mongos Router
 *    - Terminal-5: Run Sharding Commands
 *
 * 3. Navigate to MongoDB bin folder in all terminals:
 *    cd mongodb/server/.../bin
 *
 * 4. Start Shard Servers
 *    Terminal-1: mongod --shardsvr --port 27018 --dbpath C:\MongoDB\shard1
 *    Terminal-2: mongod --shardsvr --port 27019 --dbpath C:\MongoDB\shard2
 *    Terminal-3: mongod --shardsvr --port 27020 --dbpath C:\MongoDB\shard3
 *
 *
 * 5. Start mongos Router
 *    Terminal-4: mongos --port 27017
 *
 *    Note:
 *    - mongos acts as a Router.
 *    - Applications connect to mongos instead of shards.
 *    - mongos decides which shard should handle the request.
 *
 *
 * 6. Connect to mongos
 *    Terminal-5: mongosh --port 27017
 *
 *
 * 7. Add Shards to Cluster
 *    sh.addShard("localhost:27018")
 *    sh.addShard("localhost:27019")
 *    sh.addShard("localhost:27020")
 *
 *
 * 8. Verify Added Shards
 *    sh.status()
 *
 *
 * 9. Enable Sharding for Database
 *    sh.enableSharding("school")
 *
 *
 * 10. Shard the Collection
 *
 *    sh.shardCollection(
 *      "school.users",
 *      { userId: "hashed" }
 *    )
 *
 *    Breakdown:
 *    - school <== Database Name
 *    - users  <== Collection Name
 *    - userId <== Shard Key
 *    - hashed <== MongoDB creates a hash value of userId
 *
 *
 * 11. Insert Sample Data
 *
 *    use school
 *
 *    db.users.insertMany([
 *      { userId: 1, name: "John" },
 *      { userId: 2, name: "Sam" },
 *      { userId: 3, name: "Alex" },
 *      { userId: 4, name: "Bob" },
 *      { userId: 5, name: "David" },
 *      { userId: 6, name: "Mike" }
 *    ])
 *
 * 12. How Data Gets Distributed
 *
 *    MongoDB hashes userId and automatically decides
 *    which shard should store the document.
 *
 *    Example:
 *
 *    userId=1 ---> Hash ---> Shard-2
 *    userId=2 ---> Hash ---> Shard-1
 *    userId=3 ---> Hash ---> Shard-3
 *    userId=4 ---> Hash ---> Shard-2
 *    userId=5 ---> Hash ---> Shard-1
 *    userId=6 ---> Hash ---> Shard-3
 *
 *    Final Distribution:
 *
 *    Shard-1            Shard-2            Shard-3
 *    -------            -------            -------
 *    User-2             User-1             User-3
 *    User-5             User-4             User-6
 *
 *
 * 13. Query Data
 *
 *    db.users.find()
 *
 *    Note:
 *    Even though data is stored across multiple shards,
 *    mongos combines the results and returns them as
 *    if they came from a single database.
 *
 *
 * 14. Check Sharding Status
 *    sh.status()
 *
 * 15. Understand Helper Objects
 *
 *    MongoDB automatically provides:
 *
 *    - db <== Current Database Helper
 *    - rs <== Replica Set Helper
 *    - sh <== Sharding Helper
 *
 *    Examples:
 *
 *    db.users.find()
 *    rs.status()
 *    sh.status()
 */




/**
 * Sharding + Replication Together:
 * - In production:
 *   - Shard 1 => Replica Set
 *   - Shard 2 => Replica Set
 *   - Shard 3 => Replica Set
 * - So each shard is usually replicated.
 * - This provides:
 *   - Sharding => Scalability
 *   - Replication => High Availability
 *
 * Steps-to-follow:
 * 1. Open CMD as Administrator.
 *
 * 2. Open 8 separate terminals:
 *
 *    Shard-1 Replica Set Members
 *    - Terminal-1: Shard-1 Member-1 (27018)
 *    - Terminal-2: Shard-1 Member-2 (27019)
 *    - Terminal-3: Shard-1 Member-3 (27020)
 *
 *    Config Server Replica Set Members
 *    - Terminal-4: Config-1 (27021)
 *    - Terminal-5: Config-2 (27022)
 *    - Terminal-6: Config-3 (27023)
 *
 *    Router
 *    - Terminal-7: Start mongos Router
 *    - Terminal-8: Run Replica Set + Sharding Commands
 *
 *
 * 3. Navigate to MongoDB bin folder in all terminals:
 *    cd C:\Program Files\MongoDB\Server\8.2\bin
 *
 *
 * 4. Start Shard Replica Set Members
 *    Terminal-1: mongod --shardsvr --replSet shardRS --port 27018 --dbpath C:\MongoDB\shard1
 *    Terminal-2: mongod --shardsvr --replSet shardRS --port 27019 --dbpath C:\MongoDB\shard2
 *    Terminal-3: mongod --shardsvr --replSet shardRS --port 27020 --dbpath C:\MongoDB\shard3
 *
 *    Note: These 3 servers store the same data because they belong to the same Replica Set.
 *
 *
 * 5. Initialize Shard Replica Set
 *    - mongosh --port 27018
 *    - rs.initiate({
 *        _id: "shardRS",
 *        members: [
 *          { _id: 0, host: "localhost:27018" },
 *          { _id: 1, host: "localhost:27019" },
 *          { _id: 2, host: "localhost:27020" }
 *        ]
 *      })
 *
 *    MongoDB will automatically:
 *    - Elect one PRIMARY node
 *    - Mark remaining nodes as SECONDARY
 *    - Replicate data from PRIMARY to SECONDARIES
 *
 *
 * 6. Start Config Server Replica Set Members
 *    Terminal-4: mongod --configsvr --replSet configRS --port 27021 --dbpath C:\MongoDB\config1
 *    Terminal-5: mongod --configsvr --replSet configRS --port 27022 --dbpath C:\MongoDB\config2
 *    Terminal-6: mongod --configsvr --replSet configRS --port 27023 --dbpath C:\MongoDB\config3
 *
 *    Note: Config Servers store metadata such as:
 *    - Available Shards
 *    - Chunks
 *    - Data Distribution
 *
 *
 * 7. Initialize Config Server Replica Set
 *    - mongosh --port 27021
 *    - rs.initiate({
 *        _id: "configRS",
 *        configsvr: true,
 *        members: [
 *          { _id: 0, host: "localhost:27021" },
 *          { _id: 1, host: "localhost:27022" },
 *          { _id: 2, host: "localhost:27023" }
 *        ]
 *      })
 *
 *
 * 8. Start mongos Router
 *    Terminal-7: mongos --configdb configRS/localhost:27021,localhost:27022,localhost:27023 --port 27017
 *    Note:
 *    - mongos acts as a Router.
 *    - Applications connect to mongos.
 *    - mongos decides which shard should handle requests.
 *
 *
 * 9. Connect to mongos
 *    Terminal-8: mongosh --port 27017
 *
 *
 * 10. Add Replica Set as a Shard
 *     - sh.addShard(
 *         "shardRS/localhost:27018,localhost:27019,localhost:27020"
 *       )
 *    - Note: Here the entire Replica Set becomes a single Shard.
 *
 *
 * 11. Enable Sharding for Database
 *     - sh.enableSharding("school")
 *
 *
 * 12. Shard the Collection
 *
 *     sh.shardCollection(
 *       "school.users",
 *       { userId: "hashed" }
 *     )
 *
 *
 * 13. Insert Sample Data
 *     - use school
 *     - db.users.insertMany([
 *         { userId: 1, name: "John" },
 *         { userId: 2, name: "Sam" },
 *         { userId: 3, name: "Alex" },
 *         { userId: 4, name: "Bob" },
 *         { userId: 5, name: "David" },
 *         { userId: 6, name: "Mike" }
 *       ])
 *
 *
 * 14. How Data Flows
 *
 *         Application
 *              |
 *              v
 *           mongos
 *              |
 *              v
 *           Shard-1 (Replica Set)
 *              |
 *         -------------------
 *         |        |        |
 *      Primary  Secondary Secondary
 *      27018      27019     27020
 *
 *    - Data is written to PRIMARY.
 *    - PRIMARY replicates data to SECONDARY nodes.
 *    - If PRIMARY goes down, MongoDB elects a new PRIMARY.
 *
 *
 * 15. Verify Replica Set
 *     - rs.status()
 *
 *
 * 16. Verify Sharding
 *     - sh.status()
 *
 *
 * 17. Why Use Sharding + Replication Together?
 *
 *     Replication:
 *     - Provides High Availability
 *     - Provides Failover
 *     - Prevents Data Loss
 * 
 *     Sharding:
 *     - Distributes Data Across Servers
 *     - Handles Large Datasets
 *     - Improves Scalability
 * 
 *     Together:
 *     - Sharding => Scale Horizontally
 *     - Replication => High Availability
 *
 *    This is the architecture used in large-scale production systems.
 */