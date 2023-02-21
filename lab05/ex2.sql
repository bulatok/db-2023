SELECT enrollments.sec_id, enrollments.year, enrollments.course_id, enrollment
FROM (
         SELECT COUNT(*) AS enrollment, course_id, sec_id, year
         FROM takes
         GROUP BY course_id, sec_id, semester, year
     ) AS enrollments
WHERE enrollment IN (
    SELECT MAX(COALESCE(e, 0)) AS max_enrollment
    FROM (
             SELECT COUNT(*) AS e
             FROM takes
             GROUP BY course_id, sec_id, semester, year
         ) AS enrollments
    )


