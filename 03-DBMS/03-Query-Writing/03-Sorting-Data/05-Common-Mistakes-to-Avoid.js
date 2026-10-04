/**
 * COMMON MISTAKES TO AVOID
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — Putting LIMIT in the wrong place                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ LIMIT must always be the very last clause in your query.        │
 * │ Placing it before ORDER BY or WHERE causes a syntax error.      │
 * │                                                                 │
 * │   ❌ SELECT product_name FROM products LIMIT 2 ORDER BY price;  │
 * │      → Syntax error — LIMIT must come after ORDER BY            │
 * │                                                                 │
 * │   ✅ SELECT product_name FROM products ORDER BY price LIMIT 2;  │
 * │      → Correct clause order                                     │
 * │                                                                 │
 * │ Correct query clause order:                                     │
 * │   SELECT → FROM → WHERE → ORDER BY → LIMIT                      │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Forgetting how text sorting works                   │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ ASC on a text column sorts A → Z.                               │
 * │ DESC on a text column sorts Z → A.                              │
 * │ The same logic applies to product names, categories, cities —   │
 * │ any column that holds text.                                     │
 * │                                                                 │
 * │   ORDER BY category ASC   → Accessories, Cables, Electronics    │
 * │   ORDER BY category DESC  → Furniture, Electronics, Cables      │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Forgetting that ASC is the default                  │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ If you do not specify ASC or DESC, the database always defaults │
 * │ to ASC. This is fine for ascending results, but if you want     │
 * │ descending order and forget DESC, you will get the opposite of  │
 * │ what you intended — with no error to warn you.                  │
 * │                                                                 │
 * │   ORDER BY price        → same as ORDER BY price ASC            │
 * │   ORDER BY price DESC   → required explicitly for descending    │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 4 — Not knowing you can sort by an alias                │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ If you created a computed column with AS in SELECT, you can     │
 * │ reference that alias directly in ORDER BY.                      │
 * │                                                                 │
 * │   SELECT product_name,                                          │
 * │          price * stock_quantity AS total_value                  │
 * │   FROM products                                                 │
 * │   ORDER BY total_value DESC;   ← alias works here               │
 * │                                                                 │
 * │ This is one of the rare cases where ORDER BY can reference a    │
 * │ name defined in SELECT — because ORDER BY runs after SELECT in  │
 * │ the execution order.                                            │
 * └─────────────────────────────────────────────────────────────────┘
 */
