SELECT MAX(COALESCE(enrollment, 0)) AS max_enrollment,
       MIN(COALESCE(enrollment, 0)) AS min_enrollment
FROM (SELECT COUNT(*) AS enrollment
      FROM takes
      WHERE year = '2022'
          AND semester = 'Fall'
         OR semester = 'Autumn'
      GROUP BY course_id, sec_id, semester, year) AS enrollments