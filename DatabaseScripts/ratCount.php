<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
//get the value
$id = $_POST['id'];
$rat = $_POST['rat'];
$value = $_POST['value'];

//get the ratC count through exicuting the sql querry and fetching the specific value into an array
$ratC = mysqli_query($conn,"SELECT ratC FROM Event_Prod WHERE id = '$id'");
$tempArray = Array();
$tempArray = $ratC->fetch_object();

//create the querry string to update the number of ratC with value of -- to increase by that value or - to decrease by the value
$sql = "UPDATE Event_Prod set rat = $rat, ratC=$tempArray->ratC $value WHERE id = '$id'";
//echo $sql;
if (mysqli_query($conn, $sql)) {
      echo "Event $id ratC updated";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
