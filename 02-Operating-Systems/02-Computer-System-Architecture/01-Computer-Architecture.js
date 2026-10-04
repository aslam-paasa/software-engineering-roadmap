/**
 * Computer System Architecture:
 * > Computer System Architecture explains how multiple parts are
 *   connected and how they work together in an organized way.
 * > It tells:
 *   - How input is taken
 *   - How instructions are stored
 *   - How processing happens
 *   - How output is produced
 *   - How different components work together
 * > It gives the basic structure of how most computers are designed
 *   (structure of the computer & how data flow inside it).
*/

/**
 * Von Neumann Architecture:
 * > Von Neumann Architecture is a computer design model where:
 *   - data and instructions are stored in the same memory, and 
 *   - the CPU processes one by one (sequentially) to produce output.
 * > It explains how a computer takes input, stores instructions,
 *   processes them, and gives output in a step-by-step manner.
 *   1. Input is given
 *   2. Program and data are stored in main memory,
 *   3. CPU fetches instructions from memory.
 *   4. CPU decodes and executes them.
 *   5. Output is produced.
 *   6. This process continues step-by-step. 
 *   This is called sequential execution.
*/

/**
 * Main Components of Von Neumann:
 * > A Computer mainly has 4 parts:
 *   1. Input Unit:
 *      - The input unit sends data to the computer.
 *      - It allows the user to give instructions or data to the program
 *      - Ex: Keyboard, mouse, etc.
 * 
 *   2. Memory Unit:
 *      - The memory unit stores:
 *        a. Data
 *        b. Program Instructions
 *      - In Von Neumann Architecture, both data and instructions are
 *        stored in the same main memory.
 *      - This is the key idea of this architecture.
 * 
 *   3. CPU (Central Processing Unit):
 *      - The CPU is the brain of the computer.
 *      - It fetches instructions from memory, executes them, and 
 *        performs calculations.
 *      - CPU has three important parts:
 *        a. ALU (Arithmetic Logic Unit)
 *           > Performs arithmetic operations
 *           > Performs logical operations
 *           > All operations are handled by electronic circuits
 *        b. Control Unit:
 *           > Controls the execution of instructions
 *           > Tells the memory, ALU and input/output what to do
 *           > Manages the flow of data inside the system
 *        c. Registers:
 *           > Small storage areas inside the CPU
 *           > Store intermediate results temporarily
 *           > Help in fast processing.
 * 
 *   4. Output Unit:
 *      - The output unit shows the final result.
 *      - Ex: Monitor, Printer, etc.
*/

/**
 * Example:
 * 1. Input: 
 *    int a = 5;
 *    int b = 6;
 *    int c = a + b;
 * 
 * Step-1: Input
 * > The program is written and given to the system.
 * 
 * Step-2: Memory
 * > The program instructions and values (5 and 6) are stored in main 
 *   memory.
 * 
 * Step-3: CPU Processing
 * > Control Unit fetches the instruction.
 * > Registers store values temporarily.
 * > ALU performs the addition (5 + 6).
 * > Result is stored back in memory or register.
 * 
 * Step-4: Output
 * > The result (11) is produced.
*/