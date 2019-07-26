<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Title</title>

  </head>
  <body>

    <form action="site.php" method="post">
      Noun: <input type="text" name="noun"><br>
      Person in room: <input type="text" name="personInRoom"><br>
      Verb: <input type="text" name="verb"><br>
      Part of the body (plural): <input type="text" name="bodyPart"><br>
      Adjective: <input type="text" name="adjective"><br>

      <input type="submit">
    </form>

    <?php
    $noun = $_POST["noun"];
    $personInRoom = $_POST["personInRoom"];
    $verb = $_POST["verb"];
    $bodyPart = $_POST["bodyPart"];
    $adjective = $_POST["adjective"];
    echo "It was Thanksgiving, and the scent of succulent roast $noun wafted through my house. '$personInRoom, it's time to $verb!' my mother called. I couldn't wait to get my $bodyPart on that $adjective Thanksgiving meal.";
     ?>

  </body>
</html>
