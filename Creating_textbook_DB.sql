--Creates all of the relevent relations used in my Databases
--textbook. (Add textbook copyright info, etc)

CREATE DATABASE textbook;

--Department
create table department(
  dept_name VARCHAR(20),
  building VARCHAR(15),
  budget NUMERIC(12,2),
  PRIMARY KEY(dept_name)
);
insert into department VALUES('Comp. Sci.', 'Taylor', 100000);
insert into department VALUES('Biology', 'Watson', 90000);
insert into department VALUES('Elec. Eng.', 'Taylor', 85000);
insert into department VALUES('Music', 'Packard', 80000);
insert into department VALUES('Finance', 'Painter', 120000);
insert into department VALUES('History', 'Painter', 50000);
insert into department VALUES('Physics', 'Watson', 70000);

--Instructor
create table instructor(
  ID VARCHAR(5),
  name VARCHAR(20) NOT NULL,
  dept_name VARCHAR(20),
  salary NUMERIC(8,2),
  PRIMARY KEY(ID),
  FOREIGN KEY(dept_name)
  REFERENCES department(dept_name) ON DELETE SET NULL
);
insert into instructor VALUES(22222, 'Einstein', 'Physics', 95000);
insert into instructor VALUES(12121, 'Wu', 'Finance', 90000);
insert into instructor VALUES(32343, 'El Said', 'History', 60000);
insert into instructor VALUES(45565, 'Katz', 'Comp. Sci.', 75000);
insert into instructor VALUES(98345, 'Kim', 'Elec. Eng.', 80000);
insert into instructor VALUES(76766, 'Crick', 'Biology', 72000);
insert into instructor VALUES(10101, 'Srinivasan', 'Comp. Sci.', 65000);
insert into instructor VALUES(58583, 'Califieri', 'History', 62000);
insert into instructor VALUES(83821, 'Brandt', 'Comp. Sci.', 92000);
insert into instructor VALUES(15151, 'Mozart', 'Music', 40000);
insert into instructor VALUES(33456, 'Gold', 'Physics', 87000);
insert into instructor VALUES(76543, 'Singh', 'Finance', 80000);

--Course
create table course(
  course_id VARCHAR(7),
  title VARCHAR(50),
  dept_name VARCHAR(20),
  credits NUMERIC(2,0),
  PRIMARY KEY(course_id),
  FOREIGN KEY(dept_name)
  REFERENCES department(dept_name) ON DELETE CASCADE
);
insert into course VALUES('BIO-101', 'Intro. to Biology', 'Biology', 4);
insert into course VALUES('BIO-301', 'Genetics', 'Biology', 4);
insert into course VALUES('BIO-399', 'Computational Biology', 'Biology', 3);
insert into course VALUES('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4);
insert into course VALUES('CS-190', 'Game Design', 'Comp. Sci.', 4);
insert into course VALUES('CS-315', 'Robotics', 'Comp. Sci.', 3);
insert into course VALUES('CS-319', 'Image Processing', 'Comp. Sci.', 3);
insert into course VALUES('CS-347', 'Database System Concepts', 'Comp. Sci.', 3);
insert into course VALUES('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3);
insert into course VALUES('FIN-201', 'Investment Banking', 'Finance', 3);
insert into course VALUES('HIS-351', 'World History', 'History', 3);
insert into course VALUES('MU-199', 'Music Video Production', 'Music', 3);
insert into course VALUES('PHY-101', 'Physical Principles', 'Physics', 4);

--Prereq
create table prereq(
  course_id VARCHAR(7),
  prereq_id VARCHAR(7),
  PRIMARY KEY (course_id, prereq_id),
  FOREIGN KEY(course_id)
  REFERENCES course(course_id) ON DELETE CASCADE,
  FOREIGN KEY(prereq_id)
  REFERENCES course(course_id) ON DELETE CASCADE
);
insert into prereq VALUES('BIO-301', 'BIO-101');
insert into prereq VALUES('BIO-399', 'BIO-101');
insert into prereq VALUES('CS-190', 'CS-101');
insert into prereq VALUES('CS-315', 'CS-101');
insert into prereq VALUES('CS-319', 'CS-101');
insert into prereq VALUES('CS-347', 'CS-101');
insert into prereq VALUES('EE-181', 'PHY-101');

--Section
create table section(
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester  VARCHAR(6),
  year NUMERIC(4,0),
  building VARCHAR(15),
  room_number VARCHAR(7),
  time_slot_id VARCHAR(4),
  PRIMARY KEY(course_id, sec_id, semester, year),
  FOREIGN KEY (course_id) REFERENCES course(course_id)
);
insert into section VALUES('BIO-101', '1', 'Summer', 2009, 'Painter', '514', 'B');
insert into section VALUES('BIO-301', '1', 'Summer', 2010, 'Painter', '514', 'A');
insert into section VALUES('CS-101', '1', 'Fall', 2009, 'Packard', '101', 'H');
insert into section VALUES('CS-101', '1', 'Spring', 2010, 'Packard', '101', 'F');
insert into section VALUES('CS-190', '1', 'Spring', 2009, 'Taylor', '3128', 'E');
insert into section VALUES('CS-190', '2', 'Spring', 2009, 'Taylor', '3128', 'A');
insert into section VALUES('CS-315', '1', 'Spring', 2010, 'Watson', '120', 'D');
insert into section VALUES('CS-319', '1', 'Spring', 2010, 'Watson', '100', 'B');
insert into section VALUES('CS-319', '2', 'Spring', 2010, 'Taylor', '3128', 'C');
insert into section VALUES('CS-347', '1', 'Fall', 2009, 'Taylor', '3128', 'A');
insert into section VALUES('EE-181', '1', 'Spring', 2009, 'Taylor', '3128', 'C');
insert into section VALUES('FIN-201', '1', 'Spring', 2010, 'Packard', '101', 'B');
insert into section VALUES('HIS-351', '1', 'Spring', 2010, 'Painter', '514', 'C');
insert into section VALUES('MU-199', '1', 'Spring', 2010, 'Packard', '101', 'D');
insert into section VALUES('PHY-101', '1', 'Fall', 2009, 'Watson', '100', 'A');

--Teaches
create table teaches(
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
insert into teaches values('10101', 'CS-101', '1', 'Fall', 2009);
insert into teaches values('10101', 'CS-315', '1', 'Spring', 2010);
insert into teaches values('10101', 'CS-347', '1', 'Fall', 2009);
insert into teaches values('12121', 'FIN-201', '1', 'Spring', 2010);
insert into teaches values('15151', 'MU-199', '1', 'Spring', 2010);
insert into teaches values('22222', 'PHY-101', '1', 'Fall', 2009);
insert into teaches values('32343', 'HIS-351', '1', 'Spring', 2010);
insert into teaches values('45565', 'CS-101', '1', 'Spring', 2010);
insert into teaches values('45565', 'CS-319', '1', 'Spring', 2010);
insert into teaches values('76766', 'BIO-101', '1', 'Summer', 2009);
insert into teaches values('76766', 'BIO-301', '1', 'Summer', 2010);
insert into teaches values('83821', 'CS-190', '1', 'Spring', 2009);
insert into teaches values('83821', 'CS-190', '2', 'Spring', 2009);
insert into teaches values('83821', 'CS-319', '2', 'Spring', 2010);
insert into teaches values('98345', 'EE-181', '1', 'Spring', 2009);

--Student
CREATE TABLE student(
  ID VARCHAR(5),
  name VARCHAR(20) NOT NULL,
  dept_name VARCHAR(20),
  total_cred NUMERIC(3,0),
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

--Takes
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
  
