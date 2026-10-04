/**
 * View in OS:
 * > A view means the way of looking at something.
 * > In Operating System:
 *   - A view means how we see or understand the OS.
 *   - Different people see the OS in different ways.
 *   - So, we say OS has different "views". 
 * 
 * Think of it like this:
 * > The same building can look different:
 *   - For a visitor, it's just a place to enter and use.
 *   - For an engineer, it's structure, wiring, pipes, etc.
 * > Same building. Different views.
 *
 * 
 * Now connect it to OS:
 * In an Operating Sytem, there are two main types of views:
 * 1. System View: How the system (hardware + internal parts) sees the OS
 * 2. User View  : How the user sees and uses the OS.
*/

/**
 * User View in Operating System (OS):
 * 
 * From the user's perspective, an Operating System can be of two types:
 * 1. Single User View (Personal Use)
 *    - Designed for one user at a time
 *    - Used in personal computers
 *    - OS focuses on making work easy for that one user.
 *    - Ex: A personal computer used for one person.
 * 
 * 2. Multi User View (Mainframe, File Sharing System, etc.)
 *    - Multiple users can use the system at the same time.
 *    - Common in mainframe systems or file sharing systems.
 *    - OS manages resources so all the users can work smoothly.
 * 
 * 3. GUI & CLI:
 *    - GUI & CLI comes under User View.
 *    - Because they define how a user interacts with the OS
 *      a. GUI (Graphical User Interface):
 *         - User icons, windows, buttons, mouse.
 *         - Easy and visual
 *         - Mostly used in personal systems.
 *      b. CLI (Command Line Interface):
 *         - Uses text-based commands.
 *         - User types commands to interact with OS
 *         - No graphical elements.
*/

/**
 * System View:
 * > In System View, the OS is seen as a manager of the entire system.
 * > Here, we do not focus on the user.
 * > From this perspective, the OS works as a resource manager and
 *   controller.
 * 
 * Under System View, the OS mainly handles:
 * 1. Resource Allocation:
 *    - The OS distributes system resources.
 *    - It decides which process gets access to resources and for how
 *      long.
 *    - So basically, OS acts like a resource manager.
 * 
 * 2. Process Management:
 *    - A process is a program that is running.
 *    - The OS manages multiple running processes.
 *    - It controls how processes are created and handled.
 *    - It controls their execution and keeps them organized without 
 *      interfering with each other.
 * 
 * 3. Thread Management:
 *    - Threads are smaller part of the process.
 *    - A single process can have multiple threads.
 *    - The OS manages how these threads run and share resources.
 *    - So here, OS controls the execution of threads inside processes.
 * 
 * 4. Process Allocation:
 *    - The OS decides how system resources are given to processes.
 *    - It manages the allocation of CPU and other required resources.
 *    - This ensures processes get what they need to execute.
*/