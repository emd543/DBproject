<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Title</title>

  </head>
  <body>

    <?php
    $servername = "localhost";
    $username = "root";
    $password = "password";
    $dbname = "parking_lot_db";
    $loc_string = $_POST["location"];
    $license_string = $_POST["license_plate"];

    // Create connection
/*    $conn = new mysqli($servername, $username, $password);

    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }

    // Create database
    $sql = "CREATE DATABASE parking_lot_db;";
    if ($conn->query($sql) === TRUE) {
      echo "Database created successfully<br>";
    } else {
      echo "Error creating database: " . $conn->error "<br>";
    }

    // Close connection
    $conn->close();*/

    // Create new connection, using the new database
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }

    // SQL to create all 4 relations
/*    $sql = "create table users(
   	id int auto_increment,
   	name varchar(20) not null,
   	phone varchar(20) not null,
   	primary key(id)
   );";

    if ($conn->query($sql) === TRUE) {
      echo "Table users created successfully<br>";
    } else {
      echo "Error creating table: " . $conn->error;
    }

    $sql = "create table parking_lots(
    	id int auto_increment,
    	name varchar(40) not null,
    	location varchar(40) not null,
    	capacity int not null,
    	min_cost double not null,
    	max_cost double not null,
    	minutely_cost double not null,
    	primary key(id)
    );";

    if ($conn->query($sql) === TRUE) {
      echo "Table parking_lots created successfully<br>";
    } else {
      echo "Error creating table: " . $conn->error;
    }

    $sql = "create table valets(
    	id int auto_increment,
    	name varchar(20) not null,
    	parking_id int not null,
    	primary key(id),
    	foreign key(parking_id) references parking_lots(id)
    );";

    if ($conn->query($sql) === TRUE) {
      echo "Table valets created successfully<br>";
    } else {
      echo "Error creating table: " . $conn->error;
    }

    $sql = "create table records(
    	id int auto_increment,
    	user_id int not null,
    	parking_id int not null,
    	valet_id int not null,
    	license_plate varchar(20) not null,
    	enter_time datetime not null,
    	exit_time datetime,
    	total double,
    	primary key(id),
    	foreign key(user_id) references users(id),
    	foreign key(parking_id) references parking_lots(id),
    	foreign key(valet_id) references valets(id)
    );";

    if ($conn->query($sql) === TRUE) {
      echo "Table records created successfully<br>";
    } else {
      echo "Error creating table: " . $conn->error;
    }*/

    // Insert data into each of the relations
/*    $sql = "insert into users(name,phone) value
	('Theresa Greer','436-910-3977'),
	('Kirsten Alexander','284-704-0877'),
	('Edward Turner','715-537-3288'),
	('Vanessa Anderson','347-928-6192');";

    if ($conn->multi_query($sql) === TRUE) {
      echo "New records created successfully<br>";
    } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $sql = "insert into parking_lots(name,location,capacity,min_cost,max_cost,minutely_cost) value
    ('Seaport Plaza Garage','145 John St. New York, NY',200,30,150,0.5),
    ('Brooklyn Bridge Garage','360 Furman St. Brooklyn, NY',150,24,120,0.4),
    ('Rockefeller Center Garage','55 W 48th St. New York, NY',300,60,300,1),
    ('The Bergen Valet Garage','312 Bergen St. New York, NY',20,36,180,0.6);";

    if ($conn->multi_query($sql) === TRUE) {
      echo "New records created successfully<br>";
    } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $sql = "insert into valets(name,parking_id) value
    ('Jody Williams',1),
    ('Jennifer Moore',2),
    ('Stephen Hahn',3),
    ('Joel Shaffer',4),
    ('Patricia Garrison',1),
    ('Rebecca Daniels',2),
    ('Ashley Sanders',3),
    ('Joy Clarke',4);";

    if ($conn->multi_query($sql) === TRUE) {
      echo "New records created successfully<br>";
    } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $sql = "insert into records(user_id,parking_id,valet_id,license_plate,enter_time,exit_time,total) value
    (1,1,1,'GZH7304','2019-03-15 21:29:04','2019-03-15 21:56:38',30.0),
    (2,1,2,'EXZ9820','2019-03-16 22:36:16','2019-03-17 17:51:31',300),
    (1,2,4,'GZH7304','2019-03-18 05:43:00','2019-03-18 06:50:07',26.8),
    (3,2,2,'HDM2727','2019-03-18 10:34:17','2019-03-18 18:30:20',180.0),
    (1,3,3,'GZH7304','2019-03-18 19:47:02','2019-03-19 10:46:07',300),
    (4,3,6,'FYP7892','2019-03-19 16:03:54','2019-03-19 17:44:47',100),
    (1,3,3,'GZH7304','2019-03-19 20:48:38','2019-03-20 13:18:23',300),
    (4,4,8,'FYP7892','2019-03-20 15:18:24','2019-03-21 01:46:37',180.0),
    (3,2,4,'HDM2727','2019-03-21 11:09:13','2019-03-21 12:02:55',36.0),
    (2,2,2,'EXZ9820','2019-03-21 12:41:18','2019-03-21 14:41:09',47.6),
    (1,3,6,'GZH7304','2019-03-22 19:28:52','2019-03-22 21:42:13',66.5),
    (2,2,2,'EXZ9820','2019-03-23 00:23:45','2019-03-23 01:35:29',35.5),
    (3,1,1,'HDM2727','2019-03-23 08:25:22','2019-03-23 17:03:24',150.0),
    (1,1,2,'GZH7304','2019-03-23 21:31:11','2019-03-24 03:53:33',180.0),
    (1,4,8,'KKG4708','2019-03-24 21:10:38','2019-03-25 12:22:24',180.0),
    (3,3,3,'HDM2727','2019-03-25 20:54:46','2019-03-26 02:27:30',180.0),
    (2,4,4,'EXZ9820','2019-03-26 02:43:00','2019-03-26 06:49:15',98.4),
    (2,2,4,'EXZ9820','2019-03-26 20:17:07','2019-03-27 02:06:09',180.0),
    (3,1,2,'HDM2727','2019-03-27 06:34:03','2019-03-27 15:30:30',300),
    (1,2,2,'KKG4708','2019-03-27 21:17:00','2019-03-28 01:36:48',259),
    (2,1,1,'EXZ9820','2019-03-28 06:14:48','2019-03-28 08:41:52',73.5),
    (4,1,1,'KKG4708','2019-03-29 05:22:28','2019-03-29 09:48:50',159.6),
    (3,3,3,'HDM2727','2019-03-29 17:41:31','2019-03-30 06:10:47',300),
    (1,3,6,'GZH7304','2019-03-30 09:07:00','2019-03-30 16:04:25',300),
    (3,1,1,'HDM2727','2019-03-30 19:02:44','2019-03-30 21:39:06',78.0),
    (2,2,4,'EXZ9820','2019-03-31 06:46:20','2019-03-31 13:11:16',120.0),
    (1,3,3,'GZH7304','2019-03-31 18:08:32','2019-03-31 20:31:58',57.2),
    (4,3,6,'FYP7892','2019-04-01 04:13:34','2019-04-01 11:05:54',300),
    (1,1,1,'GZH7304','2019-04-01 11:50:00','2019-04-01 13:14:19',50.4),
    (2,2,4,'EXZ9820','2019-04-01 18:32:59','2019-04-01 23:42:53',180.0)";

    if ($conn->multi_query($sql) === TRUE) {
      echo "New records created successfully<br>";
    } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
    }*/

    // Select tuples from the relations
    //$loc_string = "Brooklyn";
    ?>
    <form action="site.php" method="post">
      Search parking lots by location: <br><input type="text" name="location"><br>

      <input type="submit">
    </form>
    <?php

    $sql = "SELECT id, name, location FROM parking_lots WHERE location LIKE '%$loc_string%'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
      // output data of each row
      while($row = $result->fetch_assoc()) {
          echo "id: " . $row["id"]. " - Name: " . $row["name"]. " - Location: " . $row["location"]. "<br>";
        }
      } else {
        echo "0 results";
      }

      ?>
      <br>
      <form action="site.php" method="post">
        Search records by license plate: <br><input type="text" name="license_plate"><br>

        <input type="submit">
      </form>
      <?php

      $sql = "SELECT id, user_id, parking_id, valet_id, license_plate FROM records WHERE license_plate LIKE '%$license_string%'";
      $result = $conn->query($sql);

      if ($result->num_rows > 0) {
        // output data of each row
        while($row = $result->fetch_assoc()) {
            echo "id: " . $row["id"]. " - User id: " . $row["user_id"]. " - Parking lot id: " . $row["parking_id"]. " - Valet id: " . $row["valet_id"]. " - License plate: " . $row["license_plate"]. "<br>";
          }
        } else {
          echo "0 results";
        }

    $conn->close();
     ?>

  </body>
</html>
