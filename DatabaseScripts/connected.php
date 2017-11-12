<?php
require '../vendor/autoload.php';
use \Firebase\JWT\JWT;

// Create connection
$con=mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  //http_response_code();
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}else {
//http_response_code(201);
echo "true";
}

mysqli_close($con);
?>
