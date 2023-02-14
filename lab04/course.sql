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
    FOREIGN KEY (name) REFERENCES Course(name)
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