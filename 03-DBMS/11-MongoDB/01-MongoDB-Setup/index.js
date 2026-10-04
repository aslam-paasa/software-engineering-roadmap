/**
 * MongoDB Setup:
 * 1. Download:
 *    a. Mongod
 *       - Main Engine of MongoDB (MongoDB server that actually stores and manages the data)
 *       - It is a program that:
 *         - stores the data
 *         - handles queries
 *         - manages databases
 *         - runs on a machine/server
 * 
 *    b. MongoDB Shell (CLI TOOL):
 *       - MongoDB Shell is how developers communicate with the MongoDB server using commands.
 *       OR,
 *    c. MongoDB Compass (GUI Tool):
 *       - MongoDB Compass is a Graphical User Interface (GUI) tool.
 * 
 * 2. Default MongoDB address is:
 *    - mongodb://localhost:27017 or mongodb://127.0.0.1:27017
 *    - mongod (database server running)
 *        |
 *    +------+
 *    |      |
 * mongosh MongoDB Compass
 *   CLI    GUI
 * 
 *    - mongodb runs the database on localhost:27107, and both mongosh and Compass connect
 *      to it using a connection string.
 * 
*/