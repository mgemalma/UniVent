<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$eventID = $_GET['eventID'];
$operator = $_GET['operator'];

$flag = mysqli_query($conn,"SELECT flag FROM Event_Prod WHERE eventID = $eventID");
$tempArray = Array();
$tempArray = $flag->fetch_object();
if ($operator == 'I'){
$sql = "UPDATE Event_Prod set flag=$tempArray->flag+1 WHERE eventID = $eventID";
}
elseif ($operator == 'D'){
$sql = "UPDATE Event_Prod set flag=$tempArray->flag-1 WHERE eventID = $eventID";
}else {
  echo "Invalid operator";
}
if (mysqli_query($conn, $sql)) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
