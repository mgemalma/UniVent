<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$time = time();


$sql = "DELETE FROM Event_Prod
       where $time >= eTimeStamp";
if (mysqli_query($conn, $sql)) {
    echo "Removed Events";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}
$sql = "DELETE FROM Event_Prod
       where 15 < flag";
if (mysqli_query($conn, $sql)) {
    echo "Removed Events";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
