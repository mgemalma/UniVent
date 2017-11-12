<?php
// This script is sent a user ID and a device ID, save both as an entry in the table
// Create connection
$con=mysqli_connect("localhost", "gymbudd1_UVAdmin", "Bo56H!m&", "gymbudd1_UniVentDB");

// Check Connection
if (mysqli_connect_errno()) {
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$uID = $_POST['userID'];
$dID = $_POST['deviceID'];

// Select an entry from the table with the given userID
$sql = "INSERT INTO Device_IDs (userID,deviceID)
VALUES('$uID', '$dID')";
if (mysqli_query($con, $sql)) {
	echo "New device ID registered successfully";
} else {
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
}
mysqli_close($con);
?>