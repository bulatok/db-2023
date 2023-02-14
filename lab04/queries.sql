SELECT 'a';
SELECT name FROM Students LIMIT 10;

SELECT 'b';
SELECT s.name
	FROM Students as s
	WHERE s.native_language <> 'ru'

SELECT 'c';
SELECT s.name
	FROM Students AS s JOIN Takes AS t ON е.student_id = s.id
	WHERE t.specialization_name = 'Robotics';

SELECT 'd';
SELECT c.name, s.name
	FROM Students AS s 
		JOIN Enroll AS e ON e.student_id = s.id
		JOIN Course AS c ON c.name = e.course_name
	WHERE c.credits < 3;

SELECT 'e';
SELECT DISTINCT e.course_name
	FROM Enroll AS e JOIN Students AS s 
      		ON s.id = e.student_id	
	WHERE s.native_language = 'en'