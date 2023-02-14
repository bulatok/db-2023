-- Students
CREATE TABLE Students(
                         id int NOT NULL PRIMARY KEY,
                         name VARCHAR(100),
                         native_language VARCHAR(100)
);

INSERT INTO Students(id, name, native_language)
VALUES (1, 'name1', 'en');

INSERT INTO Students (id, name, native_language)
VALUES (2, 'name2', 'en');

INSERT INTO Students (id, name, native_language)
VALUES (3, 'name3', 'fr');

INSERT INTO Students (id, name, native_language)
VALUES (4, 'name4', 'bashkort');

INSERT INTO Students (id, name, native_language)
VALUES (5, 'name5', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (6, 'name6', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (7, 'name7', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (8, 'name8', 'afr');

INSERT INTO Students (id, name, native_language)
VALUES (9, 'name9', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (10, 'name10', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (11, 'name11', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (12, 'name12', 'ru');

INSERT INTO Students (id, name, native_language)
VALUES (13, 'name13', 'ru');

-- COURSE
CREATE TABLE Course(
                       name VARCHAR(100) NOT NULL PRIMARY KEY,
                       credits int
);
INSERT INTO Course (name, credits) VALUES ('databases', 1);
INSERT INTO Course (name, credits) VALUES ('intro to AI', 3);
INSERT INTO Course (name, credits) VALUES ('intro to ML', 4);
INSERT INTO Course (name, credits) VALUES ('intro to devops', 4);


CREATE TABLE Enroll(
                       student_id int,
                       course_name VARCHAR(50),
                       FOREIGN KEY (student_id) REFERENCES Students(id),
                       FOREIGN KEY (course_name) REFERENCES Course(name)
);
INSERT INTO Enroll (course_name, student_id) VALUES ('databases', 1);
INSERT INTO Enroll (course_name, student_id) VALUES ('databases', 2);
INSERT INTO Enroll (course_name, student_id) VALUES ('databases', 1);
INSERT INTO Enroll (course_name, student_id) VALUES ('intro to AI', 10);
INSERT INTO Enroll (course_name, student_id) VALUES ('intro to AI', 11);
INSERT INTO Enroll (course_name, student_id) VALUES ('english classes', 5);
INSERT INTO Enroll (course_name, student_id) VALUES ('english classes', 6);
INSERT INTO Enroll (course_name, student_id) VALUES ('english classes', 10);
INSERT INTO Enroll (course_name, student_id) VALUES ('english classes', 11);
INSERT INTO Enroll (course_name, student_id) VALUES ('intro to ML', 10);
INSERT INTO Enroll (course_name, student_id) VALUES ('intro to devops', 4);


-- Specialization
CREATE TABLE Specialization(
    name VARCHAR(100) NOT NULL PRIMARY KEY
);

INSERT INTO Specialization (name) VALUES ('medicine');
INSERT INTO Specialization (name) VALUES ('Robotics');
INSERT INTO Specialization (name) VALUES ('lawyer');

CREATE TABLE Takes(
                      student_id int,
                      specialization_name VARCHAR(50),
                      FOREIGN KEY (student_id) REFERENCES Students(id),
                      FOREIGN KEY (specialization_name) REFERENCES Specialization(name)
);
INSERT INTO Takes (specialization_name, student_id) VALUES ('medicine', 1);
INSERT INTO Takes (specialization_name, student_id) VALUES ('lawyer', 3);
INSERT INTO Takes (specialization_name, student_id) VALUES ('medicine', 2);
INSERT INTO Takes (specialization_name, student_id) VALUES ('medicine', 3);
INSERT INTO Takes (specialization_name, student_id) VALUES ('medicine', 4);
INSERT INTO Takes (specialization_name, student_id) VALUES ('Robotics', 2);
INSERT INTO Takes (specialization_name, student_id) VALUES ('Robotics', 3);

-- QUERIES
SELECT 'a';
SELECT name FROM Students LIMIT 10;

SELECT 'b';
SELECT s.name
FROM Students as s
WHERE s.native_language <> 'ru';

SELECT 'c';
SELECT s.name
FROM Students AS s JOIN Takes AS t ON t.student_id = s.id
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