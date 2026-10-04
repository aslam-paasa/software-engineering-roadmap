/**
 * Multiprocessor System:
 * 1. Understand CPU:
 *    - CPU is the main processor of the computer.
 *    - It performs calculations and executes instructions.
 *    - Earlier, one CPU has one processing unit inside it.
 *    - That means:
 *      > One instruction at a time
 *      > One flow of execution
 * 
 * 2. The Problem:
 *    - In early computer systems:
 *      > There was only one CPU.
 *      > If many programs needed processing, they had to wait.
 *      > If the CPU failed, the whole system stopped.
 *      > Performance was limited because only one processor was doing
 *        all the work.
 *    - So the main problem was:
 *      "One CPU was not enough for heavy workloads and reliability."
 * 
 * 3. Solution: Multiprocessor System
 *    - To solve this, systems were designed with more than one CPU.
 *    - This is called a Multiprocessor System.
 *    - In this system:
 *      > Multiple CPUs are connected in one computer.
 *      > They share memory.
 *      > They work together to execute tasks.
 * 
 * 4. How it works?
 *    a. The OS assigned tasks to different processors.
 *    b. Processors execute tasks in parallel.
 *    c. Work gets completed faster.
 *    d. If one processor fails, others can continue working.
 * 
 * 5. Simple words:
 *    - Imagine a group project
 *    - Instead of one student doing all the work, four students work
 *      together.
 *    - The work finishes faster.
 *    - That is multiprocessor system.
 * 
 * 6. Advantage:
 *    a. Faster processing
 *    b. Better performance
 *    c. Improved reliability
 *    d. More tasks can run at the same time
*/

/**
 * Types of Multiprocessor System:
 * > It is a system that has more than one CPU, and all CPUs share memory
 *   and work together.
 *   a. Symmetric Multiprocessing (SMP)
 *   b. Asymmetric Multiprocessing (AMP)
 * 
 * Symmetric Multiprocessing:
 * a. Idea:
 *    - In this system:
 *      > All processors are equal.
 *      > Each CPU can perform any task.
 *      > All processors share the same memory.
 *      > The Operating System controls all processors equally.
 * 
 * b. How it works?
 *    - There are multiple CPUs.
 *    - The OS scheduled tasks.
 *    - Any processor can execute any process.
 *    - If one processor is free, it picks up a task.
 *      (No processor is special, all are treated the same)
 * 
 * Asymmetric Multiprocessing (AMP)
 * a. The Idea:
 *    - In this system:
 *      > Processors are not equal.
 *      > One processor is the main processor (master)
 *      > Other processors are worker processors (slaves)
 *      > The master assigns tasks to other processors.
 * 
 * b. How it works?
 *    - The master processor controls the system.
 *    - It assigns specific tasks to worker processors.
 *    - Workers execute assigned tasks only.
 *    - Control remains with the master.     
*/

/**
 * Multicore System:
 * 
 * 1. The Problem:
 *    - Multiprocessor systems used multiple separate CPUs, but:
 *      > They required more space.
 *      > They consumed more power.
 *      > It caused overheating
 *      > Performance improvement was limited.
 *      > They increased hardware cost.
 *    - So engineers needed a better solution.
 * 
 * 2. The Solution: Multicore System
 *    - Instead of adding multiple separate CPUs, multiple processing
 *      units (cores) were placed inside a single CPU chip.
 *    - This is called Multicore System, which allowed parallel execution.
 * 
 * 3. Understanding Core:
 *    - A core is an independent processing unit inside the CPU.
 *    - You can think of a core as mini-CPU inside the main CPU.
 *    - Each core can:
 *      > Fetch instuctions
 *      > Execute instructions
 *      > Performs calculations
 *      independently
 * 
 * 3. How it works?
 *    - One physical CPU
 *    - Inside it, multiple cores
 *    - Each core can execute tasks independently at the same time.
 *      > Core 1 can execute Task A
 *      > Core 2 can execute Task B
 *      > Core 3 can execute Task C
 *      > Core 4 can execute Task D
 *    - OS distributes tasks among cores, and this improves performance.
 * 
 *    Remember: Even though there is one physical CPU chip, inside it:
 *    > Each core has its own ALU.
 *    > Each core has its own control unit.
 *    > Each core can process instructions independently.
 *    But they may share some resources like memory.
 * 
 *    Performance Metrics:
 *    - Throughput: Ek given time period me kitne processes/tasks 
 *      successfully complete hue.
 *    - Formula: Throughput = No. of completed processes/Time 
 * 
 * 4. Simple words:
 *    - Imagine one person with four hands working at the same time
 *    - That is a multicore system
 *    - One CPU, Multiple cores inside it
 * 
 * 5. Advantages:
 *    a. Faster performance
 *    b. Lower power consumption compared to multiple separate CPUs.
 *    c. More efficient design
 *    d. Smaller physical size
*/


/**
 * Difference:
 * 1. Multiprocessor System:
 *    - Multiple separate CPUs
 *    - Shared memory
 * 2. Multicore System:
 *    - One CPU chip
 *    - Multiple cores inside it
*/

/**
 * Summary:
 * a. Problem: Single CPU limited speed and performance.
 * b. Solution 1: 
 *    - Add multiple CPUs: Multiprocessor System.
 * c. Better Solution: 
 *    - Add multiple cores inside one CPU: Multicore System.
 * 
 * Both systems improve performance by allowing parallel execution of
 * tasks.
*/