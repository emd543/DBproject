--Creates all of the relevent relations used in my Databases
--textbook. (Add textbook copyright info, etc)

CREATE DATABASE textbook;

--department
CREATE TABLE department(
  dept_name VARCHAR(20),
  building VARCHAR(15),
  budget NUMERIC(12,2),
  CHECK (budget > 0),
  PRIMARY KEY(dept_name)
);
--ALTER TABLE department ADD CHECK (budget > 0);
INSERT INTO department VALUES('Comp. Sci.', 'Taylor', 100000);
INSERT INTO department VALUES('Biology', 'Watson', 90000);
INSERT INTO department VALUES('Elec. Eng.', 'Taylor', 85000);
INSERT INTO department VALUES('Music', 'Packard', 80000);
INSERT INTO department VALUES('Finance', 'Painter', 120000);
INSERT INTO department VALUES('History', 'Painter', 50000);
INSERT INTO department VALUES('Physics', 'Watson', 70000);

--instructor
CREATE TABLE instructor(
  ID VARCHAR(5),
  name VARCHAR(20) NOT NULL,
  dept_name VARCHAR(20),
  salary NUMERIC(8,2),
  CHECK (salary > 29000),
  PRIMARY KEY(ID),
  FOREIGN KEY(dept_name)
  REFERENCES department(dept_name) ON DELETE SET NULL
);
--ALTER TABLE instructor ADD CHECK (salary > 29000);
INSERT INTO instructor VALUES(22222, 'Einstein', 'Physics', 95000);
INSERT INTO instructor VALUES(12121, 'Wu', 'Finance', 90000);
INSERT INTO instructor VALUES(32343, 'El Said', 'History', 60000);
INSERT INTO instructor VALUES(45565, 'Katz', 'Comp. Sci.', 75000);
INSERT INTO instructor VALUES(98345, 'Kim', 'Elec. Eng.', 80000);
INSERT INTO instructor VALUES(76766, 'Crick', 'Biology', 72000);
INSERT INTO instructor VALUES(10101, 'Srinivasan', 'Comp. Sci.', 65000);
INSERT INTO instructor VALUES(58583, 'Califieri', 'History', 62000);
INSERT INTO instructor VALUES(83821, 'Brandt', 'Comp. Sci.', 92000);
INSERT INTO instructor VALUES(15151, 'Mozart', 'Music', 40000);
INSERT INTO instructor VALUES(33456, 'Gold', 'Physics', 87000);
INSERT INTO instructor VALUES(76543, 'Singh', 'Finance', 80000);

--course
CREATE TABLE course(
  course_id VARCHAR(7),
  title VARCHAR(50),
  dept_name VARCHAR(20),
  credits NUMERIC(2,0),
  CHECK (credits > 0),
  PRIMARY KEY(course_id),
  FOREIGN KEY(dept_name)
  REFERENCES department(dept_name) ON DELETE CASCADE
);
--ALTER TABLE course ADD CHECK (credits > 0);
INSERT INTO course VALUES('BIO-101', 'Intro. to Biology', 'Biology', 4);
INSERT INTO course VALUES('BIO-301', 'Genetics', 'Biology', 4);
INSERT INTO course VALUES('BIO-399', 'Computational Biology', 'Biology', 3);
INSERT INTO course VALUES('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4);
INSERT INTO course VALUES('CS-190', 'Game Design', 'Comp. Sci.', 4);
INSERT INTO course VALUES('CS-315', 'Robotics', 'Comp. Sci.', 3);
INSERT INTO course VALUES('CS-319', 'Image Processing', 'Comp. Sci.', 3);
INSERT INTO course VALUES('CS-347', 'Database System Concepts', 'Comp. Sci.', 3);
INSERT INTO course VALUES('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3);
INSERT INTO course VALUES('FIN-201', 'Investment Banking', 'Finance', 3);
INSERT INTO course VALUES('HIS-351', 'World History', 'History', 3);
INSERT INTO course VALUES('MU-199', 'Music Video Production', 'Music', 3);
INSERT INTO course VALUES('PHY-101', 'Physical Principles', 'Physics', 4);

--prereq
CREATE TABLE prereq(
  course_id VARCHAR(7),
  prereq_id VARCHAR(7),
  PRIMARY KEY (course_id, prereq_id),
  FOREIGN KEY(course_id)
  REFERENCES course(course_id) ON DELETE CASCADE,
  FOREIGN KEY(prereq_id)
  REFERENCES course(course_id) ON DELETE CASCADE
);
INSERT INTO prereq VALUES('BIO-301', 'BIO-101');
INSERT INTO prereq VALUES('BIO-399', 'BIO-101');
INSERT INTO prereq VALUES('CS-190', 'CS-101');
INSERT INTO prereq VALUES('CS-315', 'CS-101');
INSERT INTO prereq VALUES('CS-319', 'CS-101');
INSERT INTO prereq VALUES('CS-347', 'CS-101');
INSERT INTO prereq VALUES('EE-181', 'PHY-101');

--section
CREATE TABLE section(
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester  VARCHAR(6),
  CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')),
  year NUMERIC(4,0),
  CHECK (year > 1759 AND year <2100),
  building VARCHAR(15),
  room_number VARCHAR(7),
  time_slot_id VARCHAR(4),
  PRIMARY KEY(course_id, sec_id, semester, year),
  FOREIGN KEY (course_id) REFERENCES course(course_id),
  --FOREIGN KEY (building) REFERENCES classroom(building)
  --Not implemented yet because classroom relation isn't populated yet
);
--ALTER TABLE section ADD CHECK (year > 1759 AND year <2100);
--ALTER TABLE section ADD CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer'));
INSERT INTO section VALUES('BIO-101', '1', 'Summer', 2009, 'Painter', '514', 'B');
INSERT INTO section VALUES('BIO-301', '1', 'Summer', 2010, 'Painter', '514', 'A');
INSERT INTO section VALUES('CS-101', '1', 'Fall', 2009, 'Packard', '101', 'H');
INSERT INTO section VALUES('CS-101', '1', 'Spring', 2010, 'Packard', '101', 'F');
INSERT INTO section VALUES('CS-190', '1', 'Spring', 2009, 'Taylor', '3128', 'E');
INSERT INTO section VALUES('CS-190', '2', 'Spring', 2009, 'Taylor', '3128', 'A');
INSERT INTO section VALUES('CS-315', '1', 'Spring', 2010, 'Watson', '120', 'D');
INSERT INTO section VALUES('CS-319', '1', 'Spring', 2010, 'Watson', '100', 'B');
INSERT INTO section VALUES('CS-319', '2', 'Spring', 2010, 'Taylor', '3128', 'C');
INSERT INTO section VALUES('CS-347', '1', 'Fall', 2009, 'Taylor', '3128', 'A');
INSERT INTO section VALUES('EE-181', '1', 'Spring', 2009, 'Taylor', '3128', 'C');
INSERT INTO section VALUES('FIN-201', '1', 'Spring', 2010, 'Packard', '101', 'B');
INSERT INTO section VALUES('HIS-351', '1', 'Spring', 2010, 'Painter', '514', 'C');
INSERT INTO section VALUES('MU-199', '1', 'Spring', 2010, 'Packard', '101', 'D');
INSERT INTO section VALUES('PHY-101', '1', 'Fall', 2009, 'Watson', '100', 'A');

--teaches
CREATE TABLE teaches(
  ID VARCHAR(5),
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester VARCHAR(6),
  year NUMERIC(4,0),
  PRIMARY KEY(ID, course_id, sec_id, semester, year),
  FOREIGN KEY(course_id, sec_id, semester, year)
  REFERENCES section(course_id, sec_id, semester, year),
  FOREIGN KEY(ID) REFERENCES instructor(ID)
);
INSERT INTO teaches values('10101', 'CS-101', '1', 'Fall', 2009);
INSERT INTO teaches values('10101', 'CS-315', '1', 'Spring', 2010);
INSERT INTO teaches values('10101', 'CS-347', '1', 'Fall', 2009);
INSERT INTO teaches values('12121', 'FIN-201', '1', 'Spring', 2010);
INSERT INTO teaches values('15151', 'MU-199', '1', 'Spring', 2010);
INSERT INTO teaches values('22222', 'PHY-101', '1', 'Fall', 2009);
INSERT INTO teaches values('32343', 'HIS-351', '1', 'Spring', 2010);
INSERT INTO teaches values('45565', 'CS-101', '1', 'Spring', 2010);
INSERT INTO teaches values('45565', 'CS-319', '1', 'Spring', 2010);
INSERT INTO teaches values('76766', 'BIO-101', '1', 'Summer', 2009);
INSERT INTO teaches values('76766', 'BIO-301', '1', 'Summer', 2010);
INSERT INTO teaches values('83821', 'CS-190', '1', 'Spring', 2009);
INSERT INTO teaches values('83821', 'CS-190', '2', 'Spring', 2009);
INSERT INTO teaches values('83821', 'CS-319', '2', 'Spring', 2010);
INSERT INTO teaches values('98345', 'EE-181', '1', 'Spring', 2009);

--student
CREATE TABLE student(
  ID VARCHAR(5),
  name VARCHAR(20) NOT NULL,
  dept_name VARCHAR(20),
  total_cred NUMERIC(3,0) DEFAULT 0,
  PRIMARY KEY(ID),
  FOREIGN KEY(dept_name)
  REFERENCES department(dept_name) ON DELETE SET NULL
);
INSERT INTO student VALUES('00128', 'Zhang', 'Comp. Sci.', 102);
INSERT INTO student VALUES('12345', 'Shankar', 'Comp. Sci.', 32);
INSERT INTO student VALUES('19991', 'Brandt', 'History', 80);
INSERT INTO student VALUES('23121', 'Chavez', 'Finance', 110);
INSERT INTO student VALUES('44553', 'Peltier', 'Physics', 56);
INSERT INTO student VALUES('45678', 'Levy', 'Physics', 46);
INSERT INTO student VALUES('54321', 'Williams', 'Comp. Sci.', 54);
INSERT INTO student VALUES('55739', 'Sanchez', 'Music', 38);
INSERT INTO student VALUES('70557', 'Snow', 'Physics', 0);
INSERT INTO student VALUES('76543', 'Brown', 'Comp. Sci.', 58);
INSERT INTO student VALUES('76653', 'Aoi', 'Elec. Eng.', 60);
INSERT INTO student VALUES('98765', 'Bourikas', 'Elec. Eng.', 98);
INSERT INTO student VALUES('98988', 'Tanaka', 'Biology', 120);

--takes
CREATE TABLE takes(
  ID VARCHAR(5),
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester VARCHAR(6),
  year NUMERIC(4,0),
  grade VARCHAR(2),
  PRIMARY KEY(ID, course_id, sec_id, semester, year),
  FOREIGN KEY(course_id, sec_id, semester, year)
  REFERENCES section(course_id, sec_id, semester, year),
  FOREIGN KEY(ID) REFERENCES student(ID)
);
INSERT INTO takes values('00128', 'CS-101', '1', 'Fall', 2009, 'A');
INSERT INTO takes values('00128', 'CS-347', '1', 'Fall', 2009, 'A-');
INSERT INTO takes values('12345', 'CS-101', '1', 'Fall', 2009, 'C');
INSERT INTO takes values('12345', 'CS-190', '2', 'Spring', 2009, 'A');
INSERT INTO takes values('12345', 'CS-315', '1', 'Spring', 2010, 'A');
INSERT INTO takes values('12345', 'CS-347', '1', 'Fall', 2009, 'A');
INSERT INTO takes values('19991', 'HIS-351', '1', 'Spring', 2010, 'B');
INSERT INTO takes values('23121', 'FIN-201', '1', 'Spring', 2010, 'C+');
INSERT INTO takes values('44553', 'PHY-101', '1', 'Fall', 2009, 'B-');
INSERT INTO takes values('45678', 'CS-101', '1', 'Fall', 2009, 'F');
INSERT INTO takes values('45678', 'CS-101', '1', 'Spring', 2010, 'B+');
INSERT INTO takes values('45678', 'CS-319', '1', 'Spring', 2010, 'B');
INSERT INTO takes values('54321', 'CS-101', '1', 'Fall', 2009, 'A-');
INSERT INTO takes values('54321', 'CS-190', '2', 'Spring', 2009, 'B+');
INSERT INTO takes values('55739', 'MU-199', '1', 'Spring', 2010, 'A-');
INSERT INTO takes values('76543', 'CS-101', '1', 'Fall', 2009, 'A');
INSERT INTO takes values('76543', 'CS-319', '2', 'Spring', 2010, 'A');
INSERT INTO takes values('76653', 'EE-181', '1', 'Spring', 2009, 'C');
INSERT INTO takes values('98765', 'CS-101', '1', 'Fall', 2009, 'C-');
INSERT INTO takes values('98765', 'CS-315', '1', 'Spring', 2010, 'B');
INSERT INTO takes values('98988', 'BIO-101', '1', 'Summer', 2009, 'A');
INSERT INTO takes values('98988', 'BIO-301', '1', 'Summer', 2010, NULL);

--classroom
CREATE TABLE classroom(
  building VARCHAR(15),
  room_number VARCHAR(7),
  capacity NUMERIC(4,0),
  PRIMARY KEY (building, room_number)
);

--Views
CREATE VIEW physics_fall_2009 AS
  SELECT course.course_id, sec_id, building, room_number
  FROM course, section
  WHERE course.course_id = section.course_id
  AND course.dept_name = 'Physics'
  AND section.semester = 'Fall'
  AND section.year = '2009';
CREATE VIEW departments_total_salary(dept_name, total_salary) AS
  SELECT dept_name, SUM(salary)
  FROM instructor
  GROUP BY dept_name;
CREATE VIEW physics_fall_2009_watson AS
  SELECT course_id, room_number
  FROM physics_fall_2009
  WHERE building = 'Watson';
CREATE VIEW instructor_info AS
  SELECT ID, name, building
  FROM instructor, department
  WHERE instructor.dept_name = department.dept_name;
CREATE VIEW history_instructors AS
  SELECT *
  FROM instructor
  WHERE dept_name = 'History';

--Assertions, which apparently MySQL does not support
CREATE ASSERTION credits_earned_constraint
CHECK (NOT EXISTS (SELECT ID
FROM student
WHERE tot_cred <> (SELECT SUM(credits)
FROM takes NATURAL JOIN course
WHERE student.ID = takes.ID
AND grade IS NOT NULL AND grade <> 'F')));

--Indices
CREATE INDEX studentID_index ON student(ID);
