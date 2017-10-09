-- Q2.1

SELECT d.deptNum, count(a.acnum) as NumAcademics
FROM department d
LEFT JOIN academic a ON d.deptnum = a.deptnum
WHERE postcode between 3000 and 3999
GROUP BY d.deptNum
ORDER BY count(a.acnum) DESC;

-- Q2.2

SELECT a.acnum, a.givename, a.famname 
FROM academic a
WHERE a.acnum NOT IN
(
  SELECT acnum
  FROM author
);

-- Q2.3

SELECT d.deptNum, d.instname, d.deptname
FROM department d
LEFT JOIN academic a ON d.deptnum = a.deptnum
GROUP BY d.deptNum, d.instname, d.deptname
HAVING count(a.acnum) > 10;

-- Q2.4
SELECT * FROM
(
  SELECT d.deptnum, d.deptname, d.instname
  FROM department d
  JOIN academic a ON d.deptnum = a.deptnum
  JOIN interest i ON a.acnum = i.acnum
  JOIN field f ON i.fieldnum = f.fieldnum
  WHERE f.title = 'Software Engineering'
  GROUP BY d.deptnum, d.deptname, d.instname
  ORDER BY count(a.acnum) DESC
)
WHERE ROWNUM <= 1;

-- Q2.5

SELECT count(a.acnum)
FROM academic a
WHERE a.acnum NOT IN
(
  SELECT acnum
  FROM interest
);

-- Q2.6

SELECT f.fieldnum, f.id, count(a.acnum)
FROM field f
LEFT JOIN interest i ON i.fieldnum = f.fieldnum
LEFT JOIN academic a ON a.acnum = i.acnum
GROUP BY f.fieldnum, f.id
HAVING count(a.acnum) < 10;

-- Q2.7

SELECT *
FROM paper p
WHERE EXISTS
(
  SELECT *
  FROM author
  NATURAL JOIN academic a
  NATURAL JOIN department d
  WHERE author.panum = p.panum
    AND UPPER(d.state) LIKE 'VIC%'
);

-- Q2.8

CREATE VIEW PAPER_VIEW AS
SELECT p.panum, count(a.acnum) as n_author, p.title
FROM paper p
LEFT JOIN author a ON p.panum = a.panum
GROUP BY p.panum, p.title;

-- Q2.9
-- The original query searches for 'B' and '1' and a single digit,
-- not 'D' and '2' and a single digit as required.
-- Additionally, the ID field is a fixed width CHAR, padded with spaces
-- which means 'D.2.3      ' is not LIKE 'D.2._'

SELECT *
FROM field
WHERE TRIM(id) LIKE 'D.2._';

-- Q2.10
-- Use of cross product with WHERE instead of a JOIN is bad practise but
-- not technically a syntax error.

-- Group by must include all non aggegrate fields

-- Having clause must be a boolean expression

-- To fix this, we could sort by the count and then extract the top row
-- but this might miss any ties in first place. Instead we can subselect 
-- the highest count and select all rows matching that count.

SELECT d.deptnum, d.deptname, d.instname, COUNT(a.acnum)
FROM department d
JOIN academic a ON a.deptnum = d.deptnum
GROUP BY d.deptnum, d.deptname, d.instname
HAVING COUNT(a.acnum) =
(
  SELECT MAX(COUNT(a.acnum))
  FROM department d
  JOIN academic a ON a.deptnum = d.deptnum
  GROUP BY d.deptnum
);