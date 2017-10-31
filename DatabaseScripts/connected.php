<?php
require '../vendor/autoload.php';
use \Firebase\JWT\JWT;

// Create connection
$con=mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}else {
echo "Connected successfully.";
}

mysqli_close($con);
?>
