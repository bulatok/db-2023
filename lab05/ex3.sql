-- a)
SELECT MAX(enrollement_max) AS max_enrollment,
       MIN(enrollement_max) AS min_enrollment
FROM (SELECT sect.course_id,
             sect.sec_id,
             sect.year,
             sect.semester,
             COALESCE((SELECT COALESCE(COUNT(*), 0) AS enrollment
                       FROM takes AS tak
                       WHERE tak.course_id = sect.course_id
                         AND tak.year = sect.year
                         AND tak.semester = sect.semester
                         AND tak.sec_id = sect.sec_id
                       GROUP BY tak.course_id, tak.sec_id, tak.semester, tak.year), 0) AS enrollement_max
      FROM section AS sect) AS enrollments;

-- b)
SELECT MAX(enrollment) AS max_enrollment,
       MIN(enrollment) AS min_enrollment
FROM (SELECT COALESCE(COUNT(*), 0) AS enrollment
      FROM section AS sect
               LEFT OUTER JOIN takes AS tak
                               ON tak.course_id = sect.course_id
                                   AND tak.year = sect.year
                                   AND tak.semester = sect.semester
                                   AND tak.sec_id = sect.sec_id
      GROUP BY tak.course_id, tak.sec_id, tak.semester, tak.year)
         AS enrollments