CREATE TABLE Specialization(
  name VARCHAR(100) NOT NULL PRIMARY KEY,
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
INSERT INTO Takes (name, student_id) VALUES ('medicine', 1);
INSERT INTO Takes (name, student_id) VALUES ('lawyer', 3);
INSERT INTO Takes (name, student_id) VALUES ('medicine', 2);
INSERT INTO Takes (name, student_id) VALUES ('medicine', 3);
INSERT INTO Takes (name, student_id) VALUES ('medicine', 4);
INSERT INTO Takes (name, student_id) VALUES ('Robotics', 2);
INSERT INTO Takes (name, student_id) VALUES ('Robotics', 3);