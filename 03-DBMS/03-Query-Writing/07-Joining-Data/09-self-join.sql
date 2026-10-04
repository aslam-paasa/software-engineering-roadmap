-- ============================================================================
-- PART 9: SELF JOIN (Table joins itself)
-- ============================================================================

/**
 * SELF JOIN is when a table is joined with itself.
 * Used for hierarchical data (employee-manager, category-subcategory)
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                            SELF JOIN                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - employees table:                                              │
 * │   ┌────────┬───────────┬────────────┐                                   │
 * │   │ emp_id │ emp_name  │ manager_id │                                   │
 * │   ├────────┼───────────┼────────────┤                                   │
 * │   │   1    │ Kriti     │    NULL    │  ← CEO (no manager)               │
 * │   │   2    │ Siddhant  │    1       │  ← Reports to Kriti               │
 * │   │   3    │ Anamika   │    1       │  ← Reports to Kriti               │
 * │   │   4    │ Utkarsh   │    2       │  ← Reports to Siddhant            │
 * │   │   5    │ Ronit     │    2       │  ← Reports to Siddhant            │
 * │   │   6    │ Shivi     │    3       │  ← Reports to Anamika             │
 * │   └────────┴───────────┴────────────┘                                   │
 * │                                                                         │
 * │   SELF JOIN: e JOIN m ON e.manager_id = m.emp_id                        │
 * │                                                                         │
 * │   OUTPUT - Each employee with manager name:                             │
 * │   ┌───────────┬───────────┐                                             │
 * │   │ employee  │ manager   │                                             │
 * │   ├───────────┼───────────┤                                             │
 * │   │ Siddhant  │ Kriti     │                                             │
 * │   │ Anamika   │ Kriti     │                                             │
 * │   │ Utkarsh   │ Siddhant  │                                             │
 * │   │ Ronit     │ Siddhant  │                                             │
 * │   │ Shivi     │ Anamika   │                                             │
 * │   └───────────┴───────────┘                                             │
 * │                                                                         │
 * │   NOTE: Kriti (CEO) has no manager, so she is excluded                  │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Create employees table for SELF JOIN example
CREATE TEMP TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'Kriti',    NULL),
(2, 'Siddhant', 1),
(3, 'Anamika',  1),
(4, 'Utkarsh',  2),
(5, 'Ronit',    2),
(6, 'Shivi',    3);

/**
 * SCENARIO 1: Show each employee with their manager name
 */

-- Using table aliases: e for employee, m for manager
SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees e
JOIN employees m
    ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

/**
 * OUTPUT:
 * ┌───────────┬───────────┐
 * │ employee  │ manager   │
 * ├───────────┼───────────┤
 * │ Siddhant  │ Kriti     │
 * │ Anamika   │ Kriti     │
 * │ Utkarsh   │ Siddhant  │
 * │ Ronit     │ Siddhant  │
 * │ Shivi     │ Anamika   │
 * └───────────┴───────────┘
 * 
 * EXPLANATION:
 * - e is the employee (child)
 * - m is the manager (parent)
 * - JOIN on e.manager_id = m.emp_id
 * - Kriti (emp_id=1) has manager_id=NULL → not included
 */

/**
 * SCENARIO 2: Count direct reports per manager
 */

SELECT
    m.emp_name AS manager,
    COUNT(*) AS direct_reports
FROM employees e
JOIN employees m
    ON e.manager_id = m.emp_id
GROUP BY m.emp_name
ORDER BY m.emp_name;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────┐
 * │ manager   │ direct_reports  │
 * ├───────────┼─────────────────┤
 * │ Anamika   │       1         │
 * │ Kriti     │       2         │
 * │ Siddhant  │       2         │
 * └───────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Kriti manages Siddhant + Anamika = 2
 * - Siddhant manages Utkarsh + Ronit = 2
 * - Anamika manages Shivi = 1
 */

-- Clean up
DROP TABLE employees;
