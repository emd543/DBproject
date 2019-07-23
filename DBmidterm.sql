company(cname, contactname, phone, address)
driver(driverid, dname, age)
delivery(did, sender, pickup, receiver, delivery, driverid)

create table company(
  cname VARCHAR(20),
  contactname VARCHAR(30),
  phone VARCHAR(10),
  address VARCHAR(40),
  PRIMARY KEY(cname)
);
INSERT INTO company VALUES('Apple', 'Steve Jobs', '4011234567', 'Cupertino');
INSERT INTO company VALUES('SupplyCo', 'Dan Smith', '4011111111', 'Dallas');
INSERT INTO company VALUES('OtherSupplier', 'John Doe', '4012222222', 'Chicago');
INSERT INTO company VALUES('HerringCo', 'Mad Max', '4013333333', 'Rhode Island');
INSERT INTO company VALUES('XYZ, Inc.', 'Xavier Y Zebra', '4014444444', 'Iceland');

create table driver(
  driverid INT,
  dname VARCHAR(30),
  age INT,
  PRIMARY KEY(driverid)
);
INSERT INTO driver VALUES(100, 'Driver One', 31);
INSERT INTO driver VALUES(101, 'Driver Two', 32);
INSERT INTO driver VALUES(102, 'Driver Three', 33);
INSERT INTO driver VALUES(103, 'Young Guy', 18);
INSERT INTO driver VALUES(104, 'Other Young Guy', 18);
INSERT INTO driver VALUES(105, 'Tom', 35);
INSERT INTO driver VALUES(106, 'Speedy', 30);


create table delivery(
  did INT,
  sender VARCHAR(20),
  pickup TIMESTAMP,
  receiver VARCHAR(20),
  delivery TIMESTAMP,
  driverid INT,
  PRIMARY KEY(did),
  FOREIGN KEY (sender) REFERENCES company(cname),
  FOREIGN KEY (receiver) REFERENCES company(cname),
  FOREIGN KEY (driverid) REFERENCES driver(driverid)
);
INSERT INTO delivery VALUES(100, 'SupplyCo', '2016-01-01 12:00:00', 'Apple', '2016-01-01 18:00:00', 100);
INSERT INTO delivery VALUES(101, 'SupplyCo', '2016-01-02 12:00:00', 'Apple', '2016-01-02 18:00:00', 100);
INSERT INTO delivery VALUES(102, 'OtherSupplier', '2016-01-03 12:00:00', 'Apple', '2016-01-03 13:00:00', 101);
INSERT INTO delivery VALUES(103, 'OtherSupplier', '2016-01-04 12:00:00', 'Apple', '2016-01-04 14:00:00', 102);
INSERT INTO delivery VALUES(104, 'HerringCo', '2018-01-04 12:00:00', 'Apple', '2018-01-04 14:00:00', 102);
INSERT INTO delivery VALUES(105, 'HerringCo', '12:00:00 2018-01-04', 'Apple', '14:00:00 2018-01-04', 102);
INSERT INTO delivery VALUES(106, 'SupplyCo', '2018-01-04 12:00:00', 'XYZ, Inc.', '2018-01-04 14:00:00', 105);
INSERT INTO delivery VALUES(107, 'SupplyCo', '2018-01-05 12:00:00', 'XYZ, Inc.', '2018-01-05 14:00:00', 105);
INSERT INTO delivery VALUES(108, 'SupplyCo', '2018-01-06 12:00:00', 'XYZ, Inc.', '2018-01-06 14:00:00', 105);
INSERT INTO delivery VALUES(109, 'SupplyCo', '2018-01-07 12:00:00', 'Apple', '2018-01-07 14:00:00', 105);
INSERT INTO delivery VALUES(110, 'SupplyCo', '2018-01-07 12:00:00', 'Apple', '2018-01-07 12:01:00', 106);

--1 Output senders of all packages sent to the company 'Apple' in 2016
SELECT sender
FROM delivery
WHERE receiver = 'Apple' AND pickup >= '2016-01-01 00:00:00' AND pickup < '2017-01-01 00:00:00';

--2 Output the name of any driver with avg delivery time longer than 3 hours:
SELECT dname
FROM driver natural join (SELECT driverid, avg(delivery - pickup) AS avg_delivery_time
FROM delivery
GROUP BY driverid
HAVING avg_delivery_time > 30000) AS avg_del_table;

--6 Output the driver name and age for youngest drivers
SELECT dname, age
FROM driver
WHERE age = (SELECT min(age)
FROM driver);

--7 Output the total number of packages delivered to XYZ Inc. by driver named Tom
SELECT COUNT(*)
FROM delivery NATURAL JOIN driver
WHERE dname = 'Tom' AND receiver = 'XYZ, Inc.';

--4 Output the name of any driver whose max delivery time ever was under 15 minutes
SELECT dname
FROM driver natural join (SELECT driverid, max(delivery - pickup) AS max_delivery_time
FROM delivery
GROUP BY driverid
HAVING max_delivery_time < 1500) AS max_del_table;

--5 Output the name of any company that has sent at least three packages in 2015
SELECT sender
FROM (SELECT sender, COUNT(*) AS sent_count
FROM delivery
WHERE pickup LIKE '2015%'
GROUP BY sender
HAVING sent_count >=3) AS count_table;

--3 Output the min delivery time of any driver who has made more than 50 deliveries
SELECT driverid, MIN(delivery - pickup) AS min_delivery_time
FROM delivery
GROUP BY driverid
HAVING driverid IN (SELECT driverid
  FROM (SELECT driverid, COUNT(*) AS delivery_count
FROM delivery
GROUP BY driverid
HAVING delivery_count >50) AS results_one);
