SELECT @@explain_format;

+------------------+
| @@explain_format |
+------------------+
| TRADITIONAL      |
+------------------+

----------------

explain select * from employees;
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra |
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-------+
|  1 | SIMPLE      | employees | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   23 |   100.00 | NULL  |
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-------+


----------------

SET @@explain_format=TREE;

+------------------+
| @@explain_format |
+------------------+
| TREE             |
+------------------+

EXPLAIN SELECT Name FROM country WHERE Code LIKE 'A%';
+--------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                      |
+--------------------------------------------------------------------------------------------------------------+
| -> Filter: (country.`Code` like 'A%')  (cost=3.67 rows=17)
    -> Index range scan on country using PRIMARY over ('A' <= Code <= 'A????????')  (cost=3.67 rows=17)  |
+--------------------------------------------------------------------------------------------------------------+

-----------------------------------------------------------------------

EXPLAIN FORMAT=JSON SELECT Name FROM country WHERE Code LIKE 'A%';

-------------------------

SET @@explain_format=DEFAULT;

SELECT @@explain_format;
+------------------+
| @@explain_format |
+------------------+
| TRADITIONAL      |
+------------------+

-----------------------------------------------------------------

-- Obtaining Information with EXPLAIN ANALYZE
-- MySQL 8.0.18 introduces EXPLAIN ANALYZE, which runs a statement and produces EXPLAIN output along with timing and additional, iterator-based, information about how the optimizer's expectations matched the actual execution. For each iterator, the following information is provided:

-- Estimated execution cost

-- (Some iterators are not accounted for by the cost model, and so are not included in the estimate.)

-- Estimated number of returned rows

-- Time to return first row

-- Time spent executing this iterator (including child iterators, but not parent iterators), in milliseconds.

-- (When there are multiple loops, this figure shows the average time per loop.)

-- Number of rows returned by the iterator

-- Number of loops

EXPLAIN ANALYZE SELECT * FROM t1 JOIN t2 ON (t1.c1 = t2.c2)\G
-- *************************** 1. row ***************************
-- EXPLAIN: -> Inner hash join (t2.c2 = t1.c1)  (cost=4.70 rows=6)
-- (actual time=0.032..0.035 rows=6 loops=1)
--     -> Table scan on t2  (cost=0.06 rows=6)
-- (actual time=0.003..0.005 rows=6 loops=1)
--     -> Hash
--         -> Table scan on t1  (cost=0.85 rows=6)
-- (actual time=0.018..0.022 rows=6 loops=1)
EXPLAIN ANALYZE SELECT * FROM t3 WHERE i > 8\G
-- *************************** 1. row ***************************
-- EXPLAIN: -> Filter: (t3.i > 8)  (cost=1.75 rows=5)
-- (actual time=0.019..0.021 rows=6 loops=1)
--     -> Table scan on t3  (cost=1.75 rows=15)
-- (actual time=0.017..0.019 rows=15 loops=1)

mysql> EXPLAIN ANALYZE SELECT * FROM t3 WHERE pk > 17\G
*************************** 1. row ***************************
-- EXPLAIN: -> Filter: (t3.pk > 17)  (cost=1.26 rows=5)
-- (actual time=0.013..0.016 rows=5 loops=1)
--     -> Index range scan on t3 using PRIMARY  (cost=1.26 rows=5)
-- (actual time=0.012..0.014 rows=5 loops=1)