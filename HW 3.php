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
    $dbname = "database_from_php";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }

    // Create database (already done)
/*    $sql = "CREATE DATABASE database_from_php;";
    if ($conn->query($sql) === TRUE) {
      echo "Database created successfully";
    } else {
      echo "Error creating database: " . $conn->error;
    }*/

    // SQL to create table (already done)
/*    $sql = "CREATE TABLE MyGuests (
      id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      firstname VARCHAR(30) NOT NULL,
      lastname VARCHAR(30) NOT NULL,
      email VARCHAR(50),
      reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )";

    if ($conn->query($sql) === TRUE) {
      echo "Table MyGuests created successfully";
    } else {
      echo "Error creating table: " . $conn->error;
    }*/

    // Insert data into table
/*    $sql = "INSERT INTO MyGuests (firstname, lastname, email)
    VALUES ('John', 'Doe', 'john@example.com');";
    $sql .= "INSERT INTO MyGuests (firstname, lastname, email)
    VALUES ('Mary', 'Moe', 'mary@example.com');";
    $sql .= "INSERT INTO MyGuests (firstname, lastname, email)
    VALUES ('Julie', 'Dooley', 'julie@example.com')";

    if ($conn->multi_query($sql) === TRUE) {
      echo "New records created successfully";
    } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
    }*/

    // Select records from relation
    $sql = "SELECT id, firstname, lastname FROM MyGuests WHERE firstname='John'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // output data of each row
        while($row = $result->fetch_assoc()) {
            echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
        }
    } else {
        echo "0 results";
    }

    $conn->close();
     ?>

  </body>
</html>
