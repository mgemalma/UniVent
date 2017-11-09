<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$eventID = $_POST['id'];
$rat = $_POST['rat'];
$value = $_POST['value'];

$ratC = mysqli_query($conn,"SELECT ratC FROM Event_Prod WHERE id = '$eventID'");
$tempArray = Array();
$tempArray = $ratC->fetch_object();
$sql = "UPDATE Event_Prod set rat = $rat, ratC=$tempArray->ratC $value WHERE id = '$eventID'";
//echo $sql;
if (mysqli_query($conn, $sql)) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
