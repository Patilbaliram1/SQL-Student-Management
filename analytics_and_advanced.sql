/* =====================================================
   BASIC ANALYTICS
   ===================================================== */

-- 1. Total number of students
SELECT COUNT(*) AS total_students
FROM students;

-- 2. Average score of all students
SELECT ROUND(AVG(score), 2) AS average_score
FROM marks;

-- 3. Highest score
SELECT MAX(score) AS highest_score
FROM marks;

-- 4. Lowest score
SELECT MIN(score) AS lowest_score
FROM marks;

-- 5. Subject-wise average score
SELECT sub.subject_name,
       ROUND(AVG(m.score), 2) AS average_score
FROM marks m
JOIN subjects sub ON m.subject_id = sub.subject_id
GROUP BY sub.subject_name;


/* =====================================================
   STUDENT PERFORMANCE ANALYTICS
   ===================================================== */

-- 6. Average score per student
SELECT s.student_id,
       s.name,
       ROUND(AVG(m.score), 2) AS avg_score
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.name;

-- 7. Top 5 students (by average score)
SELECT s.name,
       ROUND(AVG(m.score), 2) AS avg_score
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.name
ORDER BY avg_score DESC
LIMIT 5;

-- 8. Bottom 5 students (by average score)
SELECT s.name,
       ROUND(AVG(m.score), 2) AS avg_score
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.name
ORDER BY avg_score ASC
LIMIT 5;

-- 9. Students who scored above overall average
SELECT DISTINCT s.name
FROM students s
JOIN marks m ON s.student_id = m.student_id
WHERE m.score > (SELECT AVG(score) FROM marks);


/* =====================================================
   DEPARTMENT ANALYTICS
   ===================================================== */

-- 10. Department-wise average score
SELECT s.department,
       ROUND(AVG(m.score), 2) AS department_avg
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.department;

-- 11. Best performing department
SELECT department,
       department_avg
FROM (
    SELECT s.department,
           ROUND(AVG(m.score), 2) AS department_avg
    FROM students s
    JOIN marks m ON s.student_id = m.student_id
    GROUP BY s.department
) dept
ORDER BY department_avg DESC
LIMIT 1;


/* =====================================================
   ADVANCED SQL (WINDOW FUNCTIONS)
   ===================================================== */

-- 12. Rank students based on average score
SELECT name,
       avg_score,
       RANK() OVER (ORDER BY avg_score DESC) AS student_rank
FROM (
    SELECT s.name,
           ROUND(AVG(m.score), 2) AS avg_score
    FROM students s
    JOIN marks m ON s.student_id = m.student_id
    GROUP BY s.name
) ranked_students;

-- 13. Dense rank (no gaps in ranking)
SELECT name,
       avg_score,
       DENSE_RANK() OVER (ORDER BY avg_score DESC) AS dense_rank
FROM (
    SELECT s.name,
           ROUND(AVG(m.score), 2) AS avg_score
    FROM students s
    JOIN marks m ON s.student_id = m.student_id
    GROUP BY s.name
) ranked_students;

-- 14. Subject toppers
SELECT sub.subject_name,
       s.name,
       m.score
FROM marks m
JOIN students s ON m.student_id = s.student_id
JOIN subjects sub ON m.subject_id = sub.subject_id
WHERE (m.subject_id, m.score) IN (
    SELECT subject_id, MAX(score)
    FROM marks
    GROUP BY subject_id
);


/* =====================================================
   PASS / FAIL ANALYTICS
   ===================================================== */

-- 15. Pass / Fail count (pass >= 40)
SELECT
    CASE
        WHEN score >= 40 THEN 'PASS'
        ELSE 'FAIL'
    END AS result,
    COUNT(*) AS count
FROM marks
GROUP BY result;

-- 16. Pass percentage
SELECT
    ROUND(
        SUM(CASE WHEN score >= 40 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS pass_percentage
FROM marks;


/* =====================================================
   ADVANCED FILTERING & INSIGHTS
   ===================================================== */

-- 17. Students who failed in at least one subject
SELECT DISTINCT s.name
FROM students s
JOIN marks m ON s.student_id = m.student_id
WHERE m.score < 40;

-- 18. Students who passed all subjects
SELECT s.name
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.name
HAVING MIN(m.score) >= 40;

-- 19. Students scoring above 75 in any subject
SELECT DISTINCT s.name
FROM students s
JOIN marks m ON s.student_id = m.student_id
WHERE m.score > 75;

-- 20. Overall performance summary
SELECT
    COUNT(DISTINCT s.student_id) AS total_students,
    ROUND(AVG(m.score), 2) AS overall_avg,
    MAX(m.score) AS max_score,
    MIN(m.score) AS min_score
FROM students s
JOIN marks m ON s.student_id = m.student_id;
