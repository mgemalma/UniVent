<?php
require '../vendor/autoload.php';
use \Firebase\JWT\JWT;

// Create connection
$con=mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$id = $_POST['id'];
// This SQL statement selects ALL from the table Event_Prod
$sql = "DELETE FROM Event_Prod where id  = '$id'";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
	echo "Event $id removed successfully";
}else {
  echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}


//Close connections
mysqli_close($con);
?>
