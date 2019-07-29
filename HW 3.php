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

    // Create connection
    $conn = new mysqli($servername, $username, $password);

    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }
    echo "Connected successfully";

    //$conn->close();
     ?>

  </body>
</html>
