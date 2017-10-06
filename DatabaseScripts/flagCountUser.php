<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$userID = $_GET['userID'];
$operator = $_GET['operator'];

$flagCount = mysqli_query($conn,"SELECT flagCount FROM User_Prod WHERE userID = $userID");
$tempArray = Array();
$tempArray = $flagCount->fetch_object();
if ($operator == 'I'){
$sql = "UPDATE User_Prod set flagCount=$tempArray->flagCount+1 WHERE eventID = $userID";
}
elseif ($operator == 'D'){
$sql = "UPDATE User_Prod set flagCount=$tempArray->flagCount-1 WHERE eventID = $userID";
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