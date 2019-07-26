CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_loc VARCHAR(40),
    branch_phone INT
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(40),
    emp_branch INT,
    FOREIGN KEY(emp_branch) REFERENCES branches(branch_id) ON DELETE SET NULL
);

CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(40),
    cust_birthday DATE
);

CREATE TABLE offers (
    branch INT,
    item VARCHAR(20),
    price NUMERIC(4,2),
    FOREIGN KEY(branch) REFERENCES branches(branch_id) ON DELETE CASCADE,
    PRIMARY KEY(branch, item)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    branch INT,
    customer INT,
    employee INT,
    time TIMESTAMP,
    FOREIGN KEY(branch) REFERENCES branches(branch_id) ON DELETE SET NULL,
    FOREIGN KEY(customer) REFERENCES customers(cust_id) ON DELETE SET NULL,
    FOREIGN KEY(employee) REFERENCES employees(emp_id) ON DELETE SET NULL
);

CREATE TABLE order_includes (
    order_id INT,
    item VARCHAR(20),
    quantity INT,
    PRIMARY KEY(order_id, item)
);

INSERT INTO branches VALUES(103, 'Tandon', 1234567890);
INSERT INTO employees VALUES(104, 'Easy E', 100);
INSERT INTO customers VALUES(104, 'Elizabeth', '1990-05-05');
INSERT INTO offers VALUES(103, 'Latte', 4.00);
INSERT INTO orders VALUES(101, 101, 101, 103, '2019-02-14 18:15:01.45');
INSERT INTO order_includes VALUES(103, 'Latte', 10);

----------------------------------------

SELECT *
FROM branches
JOIN offers
WHERE branches.branch_id = offers.branch;

SELECT *
FROM branches
JOIN employees
WHERE branches.branch_id = employees.emp_branch;

---1.c.1: WORKS
SELECT branch_id
FROM branches
JOIN offers
WHERE branches.branch_id = offers.branch AND item = 'Pumpkin Mocha';

---1.c.2:
SELECT results1.branch, results1.item
FROM (SELECT orders.branch, order_includes.item, SUM(quantity) AS total
    FROM orders
    JOIN order_includes
    ON orders.order_id
    WHERE orders.order_id = order_includes.order_id
    AND orders.time >= '2019-02-14 18:00:00.00'
    AND orders.time <= '2019-02-14 21:00:00.00'
    GROUP BY orders.branch, order_includes.item) AS results1
JOIN offers
WHERE results1.branch = offers.branch
AND results1.item = offers.item
AND offers.price*total IN (SELECT MAX(price * total) AS revenue
    FROM (SELECT orders.branch, order_includes.item, SUM(quantity) AS total
    FROM orders
    JOIN order_includes
    ON orders.order_id
    WHERE orders.order_id = order_includes.order_id
    AND orders.time >= '2019-02-14 18:00:00.00'
    AND orders.time <= '2019-02-14 21:00:00.00'
    GROUP BY orders.branch, order_includes.item) AS results2
JOIN offers
WHERE results2.branch = offers.branch
AND results2.item = offers.item
GROUP BY offers.branch);

results1.item, offers.price, total,



SELECT *
FROM offers;

SELECT orders.branch, order_includes.item, SUM(quantity) AS total
    FROM orders
    JOIN order_includes
    ON orders.order_id
    WHERE orders.order_id = order_includes.order_id
    GROUP BY orders.branch, order_includes.item;








----------------------------------------

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(40),
    major VARCHAR(40),
    gpa NUMERIC(3,2)
);

CREATE TABLE company (
    co_name VARCHAR(40) PRIMARY KEY,
    city VARCHAR(40)
);

CREATE TABLE job (
    job_id INT PRIMARY KEY,
    job_name VARCHAR(40),
    co_name VARCHAR(40),
    salary INT,
    FOREIGN KEY(co_name) REFERENCES company(co_name) ON DELETE SET NULL
);

CREATE TABLE interview (
    student_id INT,
    job_id INT,
    int_date DATE,
    offer BIT,
    accepted BIT,
    PRIMARY KEY(student_id, job_id),
    FOREIGN KEY(student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY(job_id) REFERENCES job(job_id) ON DELETE CASCADE
);

INSERT INTO student VALUES(103, 'Carl', 'Computer Science', 3.22);
INSERT INTO company VALUES('Google', 'Mountain View');
INSERT INTO job VALUES(108, 'Barista', 'Starbucks', 30000);
INSERT INTO interview VALUES(103, 100, '2019-01-05', 1, 1);

SELECT *
FROM interview;

--Number of companies; will need later
SELECT COUNT(*)
FROM company;

--Useful: total results for each student
SELECT student_id, COUNT(*) AS interviews, SUM(offer) AS offers, SUM(accepted) AS acceptances
FROM interview
GROUP BY student_id;

SELECT student.student_name, results.offers
FROM student
JOIN (
    SELECT student_id, COUNT(*) AS interviews, SUM(offer) AS offers, SUM(accepted) AS acceptances
    FROM interview
    GROUP BY student_id
) AS results
ON student.student_id
WHERE student.student_id = results.student_id AND results.offers >= 2;

SELECT *
FROM (SELECT student_id, COUNT(*) AS interviews, COUNT (DISTINCT co_name) AS co_count, SUM(offer) AS offers, SUM(accepted) AS acceptances
    FROM interview
    JOIN job
    ON interview.job_id
    WHERE interview.job_id = job.job_id
    GROUP BY student_id)
AS results
WHERE results.co_count = (SELECT COUNT(*)
FROM company);

SELECT student.student_id, student.student_name
FROM (
    SELECT *
    FROM (SELECT student_id, COUNT(*) AS interviews, COUNT (DISTINCT co_name) AS co_count, SUM(offer) AS offers, SUM(accepted) AS acceptances
        FROM interview
        JOIN job
        ON interview.job_id
        WHERE interview.job_id = job.job_id
        GROUP BY student_id)
    AS results_one
    WHERE results_one.co_count = (SELECT COUNT(*)
    FROM company)
) AS results_two
JOIN student
ON student.student_id
WHERE student.student_id = results_two.student_id;

--Outputs ALL students who were hired by Amazon
SELECT student.student_name
FROM student
JOIN (
    SELECT interview.student_id, interview.int_date, interview.offer, interview.accepted, job.job_id, job.co_name, job.salary
    FROM interview
    JOIN job
    ON interview.job_id
    WHERE interview.job_id = job.job_id
) AS results_one
ON results_one.student_id
WHERE student.student_id = results_one.student_id
AND results_one.co_name = 'Amazon'
AND results_one.offer = 1
AND results_one.accepted = 1
AND student.gpa = (SELECT MAX(gpa)
    FROM student
    JOIN (
        SELECT interview.student_id, interview.int_date, interview.offer, interview.accepted, job.job_id, job.co_name, job.salary
        FROM interview
        JOIN job
        ON interview.job_id
        WHERE interview.job_id = job.job_id
    ) AS results_one
    ON results_one.student_id
    WHERE student.student_id = results_one.student_id
    AND results_one.co_name = 'Amazon'
    AND results_one.offer = 1
    AND results_one.accepted = 1
);


SELECT co_name, SUM(accepted) AS hires
FROM (SELECT interview.job_id, interview.accepted, job.co_name
FROM interview
JOIN job
ON interview.job_id
WHERE interview.job_id = job.job_id) AS results_one
GROUP BY co_name
ORDER BY hires DESC
LIMIT 5;

--1 DONE
SELECT student.student_name
FROM student
JOIN (
    SELECT student_id, SUM(offer) AS offers
    FROM interview
    GROUP BY student_id
) AS results
ON student.student_id
WHERE student.student_id = results.student_id AND results.offers >= 2;

--2 DONE
SELECT student.student_id, student.student_name
FROM (
    SELECT *
    FROM (SELECT student_id, COUNT (DISTINCT co_name) AS co_count
        FROM interview
        JOIN job
        ON interview.job_id
        WHERE interview.job_id = job.job_id
        GROUP BY student_id)
    AS results_one
    WHERE results_one.co_count = (SELECT COUNT(*)
    FROM company)
) AS results_two
JOIN student
ON student.student_id
WHERE student.student_id = results_two.student_id;

--3 DONE
SELECT student.student_name
FROM student
JOIN (
    SELECT interview.student_id, interview.int_date, interview.offer, interview.accepted, job.job_id, job.co_name, job.salary
    FROM interview
    JOIN job
    ON interview.job_id
    WHERE interview.job_id = job.job_id
) AS results_one
ON results_one.student_id
WHERE student.student_id = results_one.student_id
AND results_one.co_name = 'Amazon'
AND results_one.offer = 1
AND results_one.accepted = 1
AND student.gpa = (SELECT MAX(gpa)
    FROM student
    JOIN (
        SELECT interview.student_id, interview.int_date, interview.offer, interview.accepted, job.job_id, job.co_name, job.salary
        FROM interview
        JOIN job
        ON interview.job_id
        WHERE interview.job_id = job.job_id
    ) AS results_one
    ON results_one.student_id
    WHERE student.student_id = results_one.student_id
    AND results_one.co_name = 'Amazon'
    AND results_one.offer = 1
    AND results_one.accepted = 1
);

--4 DONE
SELECT co_name, SUM(accepted) AS hires
FROM (SELECT interview.job_id, interview.accepted, job.co_name
FROM interview
JOIN job
ON interview.job_id
WHERE interview.job_id = job.job_id) AS results_one
GROUP BY co_name
ORDER BY hires DESC
LIMIT 5;

-------------------------------------------------------------------
--Problem 1
-------------------------------------------------------------------
CREATE TABLE user (
    uid INT PRIMARY KEY,
    uname VARCHAR(40),
    state VARCHAR(40)
);

CREATE TABLE artist (
    aid INT PRIMARY KEY,
    aname VARCHAR(40),
    description VARCHAR(80)
);

CREATE TABLE song (
    sid INT PRIMARY KEY,
    aid INT,
    sname VARCHAR(40),
    release_date DATE,
    FOREIGN KEY(aid) REFERENCES artist(aid) ON DELETE SET NULL
);

CREATE TABLE record (
    sid INT,
    uid INT,
    date DATE,
    PRIMARY KEY(sid, uid, date),
    FOREIGN KEY(sid) REFERENCES song(sid) ON DELETE CASCADE,
    FOREIGN KEY(uid) REFERENCES user(uid) ON DELETE CASCADE
);

SELECT *
FROM user;

INSERT INTO artist VALUES(102, 'The Beatles', 'John, Paul, George, and Ringo');
INSERT INTO user VALUES(103, 'NY Jimmy', 'New York');
INSERT INTO song VALUES(108, 102, 'Revolution', '1966-09-09');
INSERT INTO record VALUES(108, 102, '2017-03-05');

---------------------------------------------------------------
--Scratch work
----------------------------------------------------------------

SELECT *
FROM record;

SELECT uid, uname
FROM user;

SELECT COUNT(UNIQUE sid)
FROM record
GROUP BY uid;

SELECT *
FROM user
JOIN record
ON user.uid
WHERE user.uid = record.uid
ORDER BY user.uid;

--2

--USEFUL: plays per person-song combo
SELECT record.sid, record.uid, COUNT(date)
FROM record
GROUP BY record.sid, record.uid;

--USEFUL: plays per song in 2017
SELECT record.sid, COUNT(date)
FROM record
WHERE record.date LIKE '2017%'
GROUP BY record.sid;

--USEFUL: song table joined with total plays for that song
SELECT song.sid, aid, plays
FROM song
JOIN (SELECT record.sid, COUNT(date) AS plays
FROM record
GROUP BY record.sid)
AS total_plays
ON song.sid
WHERE song.sid = total_plays.sid
ORDER BY song.sid;

--USEFUL: total number of plays for each artist in 2017
SELECT aid, SUM(plays) AS total_plays
FROM (
    SELECT song.sid, aid, plays
    FROM song
    JOIN (
        SELECT record.sid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2017%'
        GROUP BY record.sid)
    AS total_plays
    ON song.sid
    WHERE song.sid = total_plays.sid) AS results
GROUP BY aid;

SELECT record.sid, COUNT(date)
FROM record
GROUP BY record.sid;

--Plays per person-song combo in 2017
SELECT record.sid, record.uid, COUNT(date) AS plays
FROM record
WHERE record.date LIKE '2017%'
GROUP BY record.sid, record.uid;

--For each user, gives the largest number of plays for a single song in 2017
SELECT uid, MAX(plays) AS max_plays
FROM (
    SELECT record.sid, record.uid, COUNT(date) AS plays
    FROM record
    WHERE record.date LIKE '2017%'
    GROUP BY record.sid, record.uid
    ) AS results
GROUP BY uid;

--Maybe not useful or efficient
SELECT step_two.uid, MAX(step_two.plays) AS max_plays
FROM (
SELECT results.uid, results.sid, results.plays, song.sname
    FROM (
        SELECT record.sid, record.uid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2017%'
        GROUP BY record.sid, record.uid
        ) AS results
    JOIN song
    ON song.sid
    WHERE song.sid = results.sid
    ORDER BY uid
    ) AS step_two
GROUP BY step_two.uid;

--Finds largest number of total plays for each user
SELECT uid, MAX(plays) AS max_plays
FROM (
    SELECT record.sid, record.uid, COUNT(date) AS plays
    FROM record
    WHERE record.date LIKE '2017%'
    GROUP BY record.sid, record.uid
    ) AS results
GROUP BY uid;

--counts total plays per user-song combo
SELECT record.sid, record.uid, COUNT(date) AS plays
FROM record
WHERE record.date LIKE '2017%'
GROUP BY record.sid, record.uid;

--works
SELECT results_three.uid, song.sname
FROM song
JOIN
(
    SELECT results_one.uid, sid
    FROM (
        SELECT results_zero.uid, MAX(plays) AS max_plays
        FROM (
            SELECT record.sid, record.uid, COUNT(date) AS plays
            FROM record
            WHERE record.date LIKE '2017%'
            GROUP BY record.sid, record.uid
            ) AS results_zero
        GROUP BY results_zero.uid
    ) AS results_one
    JOIN (
        SELECT record.sid, record.uid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2017%'
        GROUP BY record.sid, record.uid
    ) AS results_two
    ON results_one.uid
    WHERE results_one.uid = results_two.uid AND results_one.max_plays = results_two.plays
) AS results_three
ON song.sid
WHERE song.sid = results_three.sid;

-- works: Gives the most popular song (sid) for each uid
SELECT results_one.uid, sid
FROM (
    SELECT results_zero.uid, MAX(plays) AS max_plays
    FROM (
        SELECT record.sid, record.uid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2017%'
        GROUP BY record.sid, record.uid
        ) AS results_zero
    GROUP BY results_zero.uid
) AS results_one
JOIN (
    SELECT record.sid, record.uid, COUNT(date) AS plays
    FROM record
    WHERE record.date LIKE '2017%'
    GROUP BY record.sid, record.uid
) AS results_two
ON results_one.uid
WHERE results_one.uid = results_two.uid AND results_one.max_plays = results_two.plays;

-------------------------------

--1 DONE
SELECT user.uid, user.uname
FROM user
JOIN (
    SELECT record.uid, COUNT(DISTINCT record.sid) AS song_count
    FROM record
    GROUP BY record.uid
    HAVING song_count > 50
) AS results
ON user.uid
WHERE user.uid = results.uid;

--2 DONE
SELECT aid, SUM(plays) AS total_plays
FROM (
    SELECT song.sid, aid, plays
    FROM song
    JOIN (
        SELECT record.sid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2017%'
        GROUP BY record.sid)
    AS total_plays
    ON song.sid
    WHERE song.sid = total_plays.sid) AS results
GROUP BY aid;

--3 DONE
SELECT results_three.uid, song.sname
FROM song
JOIN
(
    SELECT results_one.uid, sid
    FROM (
        SELECT results_zero.uid, MAX(plays) AS max_plays
        FROM (
            SELECT record.sid, record.uid, COUNT(date) AS plays
            FROM record
            WHERE record.date LIKE '2018%'
            GROUP BY record.sid, record.uid
            ) AS results_zero
        GROUP BY results_zero.uid
    ) AS results_one
    JOIN (
        SELECT record.sid, record.uid, COUNT(date) AS plays
        FROM record
        WHERE record.date LIKE '2018%'
        GROUP BY record.sid, record.uid
    ) AS results_two
    ON results_one.uid
    WHERE results_one.uid = results_two.uid AND results_one.max_plays = results_two.plays
) AS results_three
ON song.sid
WHERE song.sid = results_three.sid;

--4 DONE
SELECT user.uname
FROM user
WHERE user.state = 'New York' AND user.uid IN (
    SELECT DISTINCT record.uid
    FROM record
    WHERE record.date LIKE '2016%' AND record.sid IN (
        SELECT song.sid
        FROM song
        WHERE song.aid = (
            SELECT artist.aid
            FROM artist
            WHERE artist.aname = 'Queen'
            LIMIT 1
        )
    )
);

--------------------------------------------
--OLD, don't care anymore
--------------------------------------------

SELECT employee.emp_id, employee.first_name, employee.last_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);

SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
);

SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id = 102;

SELECT COUNT(super_id)
FROM employee
WHERE super_id UNIQUE;

SELECT *
FROM employee;

SELECT SUM(salary)
FROM employee
GROUP BY sex;

DROP TABLE branch;
DESCRIBE client;

SELECT *
FROM employee;

ALTER TABLE employee DROP first_name;

ALTER TABLE branch
DROP FOREIGN KEY(mgr_id) REFERENCES employee(emp_id);

----------------------------------------------

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);

CREATE TABLE branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SELECT *
FROM branch;

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

----------------------------------------------------

select uid, sname
from (select uid, max(plays) as plays
  from (select uid, sid, count(*) as plays
    from record group by uid, sid) as temp3
  group by uid) as temp2
natural join (select uid, sid, count(*) as plays
from record group by uid, sid) as temp1 natural join song;
