/**
 * # Normalization:
 *   - The process of removing redundancy in your database.
 * 
 * # Redundancy:
 *   - Redundant data means that already exist elsewhere and we're duplicating it in
 *     two places.
 *   - For example, if you have two tables:
 *     1. users
 *     2. user_metadata
 *     where you do the following:
 *   
 *      Users                                                   Orders
 *     +---------+----------+----------+----------+            +----------+----------+----------+----------+
 *     | user_id | username | password | name     |            | order_id | user_id  | name     | name     |
 *     +---------+----------+----------+----------+            +----------+----------+----------+----------+
 *     | 1.      | kirat1   | 123456   | harkirat |--------+-->| 1.       | 1.       | harkirat | 300      |
 *     | 2.      | raman    | 123456   | raman    |--+     +-->| 2.       | 1.       | harkirat | 20       |
 *     +---------+----------+----------+----------+  +-------->| 3.       | 2.       | raman    | 400      |
 *                                                             +----------+----------+----------+----------+
 *   
 *     - If you notice, we've stored the name on the order in the Orders table, when it is 
 *       already present in the Users table. This is redundant data.
 *     - Notice this schema is still full proof. We can get all the orders given a user id.
 *       We can tell users details (username, name) given an order id.
 * 
 * # No full proof data:
 * 
 *     Users                                            Orders
 *    +---------+----------+----------+----------+     +----------+----------+----------+
 *    | user_id | username | password | name     |     | order_id | name     | name     |
 *    +---------+----------+----------+----------+     +----------+----------+----------+
 *    | 1.      | kirat1   | 123456   | harkirat |     | 1.       | harkirat | 300      |
 *    | 2.      | raman    | 123456   | raman    |     | 2.       | harkirat | 20       |
 *    +---------+----------+----------+----------+     | 3.       | raman    | 400      |
 *                                                     +----------+----------+----------+
 * 
 *   - This data doesn't have any relationship b/w Orders and Users.
 *   - This is just plain wrong.
 *   - You can never tell the orders for a user (esp if 2 users can have the same name)
 *   - Normalization is done on tables that are full proof to remove redundancy.
 *     [ Before we jump into normalization, let's understand relationships ]
*/

/**
 * # Types of relationships:
 *   1. One-to-One
 *   2. One-to-Many
 *   3. Many-to-One
 *   4. Many-to-Many
 * 
 * # Example
 *   - Use case - Library Management System
 *     1. User table
 *     2. Library Card Table
 *     3. Books table
 *     4. Genre Table
 * 
 * # One-to-One: Each user has a single 'library card'.
 * # One-to-Many
 * # Many-to-One
 * # Many-to-Many
 *    
*/


/**
 * # Normalizing data:
 *   - Normalization in databases is a systematic approach of decomposing tables to eliminate
 *     data redundancy and improve data integrity.
 *   - The process typically progresses through several normal forms, each building on the last.
 *   - When you look at a schema, you can identify if it lies in one of the following 
 *     categories of normalization:
 *     1. 1NF    |
 *     2. 2NF    |
 *     3. 3NF    |  The lower, the better
 *     4. BCNF   |
 *     5. 4NF    |
 *     6. 5NF    V
 * 
 *   - You aim to reach 3NF/BCNF usually. The lower you go, the more normalized your table is.
 *     But over normalizaation can lead to excessive JOINS.
 * 
 * 1. 1NF: A single cell must not hold more than one value (integrity):
 *    - This rule ensures that each column of a database table holds only atomicity (indivisible)
 *      values, and multi-valued attributes are split into separate columns.
 *    - For example, if a column is meant to store phone numbers, and a person has multiple
 *      phone numbers, each number should be in a separate row, not as a list or set in a
 *      single cell.
 * 
 *      +-----------+-------------+--------------------------------+
 *      | StudentID | Name        | Activities                     |
 *      +-----------+-------------+--------------------------------+
 *      | 1.        | John Doe    | Basketball, Soccer, Chess Club |
 *      | 2.        | Emily White | Drama Club, Yearbook           |
 *      +-----------+-------------+--------------------------------+
 * 
 * 
 *      +-----------+-------------+--------------------------------+
 *      | StudentID | Name        | Activities                     |
 *      +-----------+-------------+--------------------------------+
 *      | 1.        | John Doe    | Basketball                     |
 *      | 1.        | John Doe    | Soccer                         |
 *      | 1.        | John Doe    | Chess Club                     |
 *      | 2.        | Emily White | Drama Club                     |
 *      | 2.        | Emily White | Yearbook                       |
 *      +-----------+-------------+--------------------------------+
 * 
 *    Rules:
 *    a. There must be a primary key for identification: Each table should have a primary key,
 *       which is a column (or a set of columns) that uniquely identifies each row in a table.
 * 
 *    b. No duplicated rows: To ensure that the data in the table is organized properly and
 *       to uphold the integrity of the data, each row in the table should be unique. This rule
 *       works hand-in-hand with the presence of a primary key to prevent duplicate entries
 *       which can lead to data anomalies.
 * 
 *    c. Each column must have only one value for each row in the table:
 *       This rule emphasizes that every column must hold only one value per row, and that
 *       value should be same kind for that column across all rows.
 * 
 *      +-----------+-------------+--------------------------------------+
 *      | StudentID | Name        | ContactInfo                          |
 *      +-----------+-------------+--------------------------------------+
 *      | 1.        | John Doe    | johndoe@gmail.com, (555) 123-4567    |
 *      | 2.        | Emily White | emilywhite@gmail.com, (555) 765-4321 |
 *      +-----------+-------------+--------------------------------------+
 * 
 *      +-----------+-------------+----------------------------------------+
 *      | StudentID | Name        | Email                 | Phone Number   |
 *      +-----------+-------------+----------------------------------------+
 *      | 1.        | John Doe    | johndoe@gmail.com     | (555) 123-4567 |
 *      | 2.        | Emily White | emilywhite@gmail.com  | (555) 765-4321 |
 *      +-----------+-------------+-----------------------+----------------+
 * 
 * 2. 2NF:
 *    - 1NF gets rid of repeating rows. 2NF gets rid of redundancy
 *    - A table is said to be in 2NF if it meets the following criteria:
 *      - is already in 1NF
 *      - has 0 partial dependency
 *    - Partial dependency - 
 *      - This occurs when a non-primary key attribute is dependent on part of a 
 *        composite primary key, rather than on the whole primary key. 
 *      - In simpler terms, if your table has a primary key made up of multiple columns, 
 *        a partial dependency exists if an attribute in the table is dependent only on a
 *        subset of those columns that form the primary key.
 *      - Example: Consider a table with the composite primary key (StudentID, CourseID) and 
 *        other attributes like InstructorName and CourseName. If CourseName is dependent only
 *        on CourseID and not on the complete composite key (StudentID, CourseID), then 
 *        CourseName has a partial dependency on the primary key. This violates 2NF.
 * 
 *    # Before Normalization:
 * 
 *       Enrollments Table
 *      +-----------+----------+-----------------+----------------+-------+
 *      | StudentId | CourseId | CourseName      | InstructorName | Grade |
 *      +-----------+----------+-----------------+----------------+-------+
 *      | 001       | CS101    | Computer Sciene | Dr.Smith       | A     |
 *      | 002       | CS101    | Computer Sciene | Dr.Smith       | B     |
 *      | 001       | MA202    | Mathematics     | Dr.Johnson     | A     |
 *      | 003       | CS101    | Computer Sciene | Dr.Smith       | C     |
 *      | 002       | MA202    | Mathematics     | Dr.Johnson     | B     |
 *      +-----------+----------+-----------------+----------------+-------+
 * 
 *      Can you spot the redundancy over here? 
 *      - The instructor name and course name are repeated in rows, even though the name
 *        of an instructor should be the same for a given courseID
 *      - Primary Key of this table is (student_id, course_id)
 *      - CourseName and InstructorName have a 'partial dependency' on 'CourseID'
 * 
 *    # After Normalization 
 * 
 *      +----------+-----------------+----------------+
 *      | CourseId | CourseName      | InstructorName |
 *      +----------+-----------------+----------------+
 *      | CS101    | Computer Sciene | Dr.Smith       |
 *      | MA202    | Mathematics     | Dr.Johnson     |
 *      +----------+-----------------+----------------+
 * 
 *      +-----------+----------+-------+
 *      | StudentId | CourseId | Grade |
 *      +-----------+----------+-------+
 *      | 001       | CS101    | A     |
 *      | 002       | CS101    | B     |
 *      | 001       | MA202    | A     |
 *      | 003       | CS101    | C     |
 *      | 002       | MA202    | B     |
 *      +-----------+----------+-------+
 * 
 * 3. 3NF:
 *    - When a table is in 2NF, it eliminates repeating groups and redundancy, but it does
 *      not eliminate transitive partial dependency.
 *    - So, for a table to be in 3NF, it must:
 *      - be in 2NF
 *      - have no transitive partial dependency
 *    - A transitive dependency in a relational database occurs when one non-key attribute 
 *      indirectly depends on the primary key through another non-key attribute.
 * 
 *    # Example:
 *      +-----------------+--------------+--------------+----------------+-------------------+
 *      | EmployeeID (PK) | EmployeeName | DepartmentID | DepartmentName | DepartmentManager |
 *      +-----------------+--------------+--------------+----------------+-------------------+
 *      | 1.              | Alice        | D1           | Sales          | John              |
 *      | 2.              | Bob          | D2           | Marketing      | Sarah             |
 *      | 3.              | Charlie      | D1           | Sales          | John              |
 *      | 4.              | Diana        | D3           | Finance        | Mary              |
 *      +-----------------+--------------+--------------+----------------+-------------------+
 *      
 *      - DepartmentName has a transitive dependency on the Primary Key (EmployeeID)
 *      - To normalize to 3NF, we need to do the following:
 *        +-----------------+--------------+--------------+
 *        | EmployeeID (PK) | EmployeeName | DepartmentID |
 *        +-----------------+--------------+--------------+
 *        | 1.              | Alice        | D1           |
 *        | 2.              | Bob          | D2           |
 *        | 3.              | Charlie      | D1           |
 *        | 4.              | Diana        | D3           |
 *        +-----------------+--------------+--------------+
 * 
 *        +-----------------+--------------+--------------+----------------+-------------------+
 *        | EmployeeID (PK) | EmployeeName | DepartmentID | DepartmentName | DepartmentLocation |
 *        +-----------------+--------------+--------------+----------------+-------------------+
 *        | 1.              | Alice        | D1           | Sales          | New York          |
 *        | 2.              | Bob          | D2           | Marketing      | LA                |
 *        | 4.              | Diana        | D3           | Finance        | Chicago           |
 *        +-----------------+--------------+--------------+----------------+-------------------+
 *        
*/