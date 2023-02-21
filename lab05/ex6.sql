SELECT *
FROM takes AS enrollment
WHERE enrollment.year = '2022'
    AND enrollment.semester = 'Fall'
   OR enrollment.semester = 'Autumn'

