<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$eventID = $_GET['eventID'];
$startTime = $_GET['startTime'];
$createdTime = $_GET['createdTime'];
$endTime = $_GET['endTime'];
$address = $_GET['address'];
$rating = $_GET['rating'];
$ratingCount = $_GET['ratingCount'];
$flag = $_GET['flag'];
$attendanceCount = $_GET['attendanceCount'];
$latitude = $_GET['latitude'];
$longitude = $_GET['longitude'];

$title = $_GET['title'];
$type = $_GET['type'];
$description = $_GET['description'];
$creatorID = $_GET['creatorID'];


$sql = "INSERT INTO Event_Prod (eventID,cTimeStamp,sTimeStamp,eTimeStamp,address,latitude,longitude,rating,ratingCount,flag,headCount,hostID,title,description,type)
VALUES('$eventID','$createdTime','$startTime','$endTime','$address','$latitude','$longitude','$rating','$ratingCount','$flag','$attendanceCount','$creatorID','$title','$description','$type')";
if (mysqli_query($conn, $sql)) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>