<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
//fetch VALUES
$userID = $_GET['userID'];
$userName = $_GET['userName'];
$flagCount = $_GET['flagCount'];
$postedEvents = $_GET['postedEvents'];
$attendingEvents = $_GET['attendingEvents'];
$interests = $_GET['interests'];
$schedule = $_GET['schedule'];
$deviceID = $_GET['deviceID'];


$sql = "INSERT INTO User_Prod (userID,userName,flagCount,postedEvents,attendingEvents,interests,schedule,deviceID)
VALUES('$userID','$userName','$flagCount','$postedEvents','$attendingEvents','$interests','$schedule','$deviceID')";
if (mysqli_query($conn, $sql)) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
