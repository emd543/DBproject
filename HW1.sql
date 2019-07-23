--Evan DiPetrillo - emd543 - N13515282
--Database Systems - CS-6083 - Summer 2019
--Homework #1

--a. Record has three attributes (sid, uid, date) in its primary key because that is the minimal possible superkey (candidate key) for that relation. It is almost certain that some users will play the same song more than once, which would mean that sid and uid together are not sufficient to be a superkey, and thus the tuple (sid, uid) cannot be the primary key. Similarly, because a user could play multiple songs on the same day, or different users could play the same song on the same day, both (uid, date) and (sid, date) are also insufficient.

--b. Within table song, FOREIGN KEY(aid) REFERENCES artist(aid). On delete, this should be set NULL.
--Within table record, FOREIGN KEY(sid) REFERENCES song(sid) and FOREIGN KEY(uid) REFERENCES user(uid). Because these are in the primary key, on delete they should cascade.

--c.
--1
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

--2
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

--3
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

--4
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

--d
-- Please see attached LaTeX PDF for relational algebra.

--2
--a
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
--Assumptions: I create a student_id attribute, under the assumption that multiple students could have the same name. The prompt says "The companies from different cities...", so I included a city attribute, in case that info becomes relevant at some point. I created a job_id attribute, under the assumption that the same company could have multiple job openings with the same job name (e.g., "Software Engineer"). I assume that a student can only interview for the same job once, so the primary key of the interview table is the 2-tuple (student_id, job_id). I encoded interview results as 2 bits - one for an offer, and one for accepting the offer - to make summing them easier. Obviously it is impossible for an offer to be accepted if it is not made, but there is currently nothing that prevents that from being entered as data.

--b
--1
SELECT student.student_name
FROM student
JOIN (
    SELECT student_id, SUM(offer) AS offers
    FROM interview
    GROUP BY student_id
) AS results
ON student.student_id
WHERE student.student_id = results.student_id AND results.offers >= 2;

--2
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

--3
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

--4
SELECT co_name, SUM(accepted) AS hires
FROM (SELECT interview.job_id, interview.accepted, job.co_name
FROM interview
JOIN job
ON interview.job_id
WHERE interview.job_id = job.job_id) AS results_one
GROUP BY co_name
ORDER BY hires DESC
LIMIT 5;
