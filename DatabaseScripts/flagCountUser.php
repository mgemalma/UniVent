<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

//get the values
$id = $_POST['id'];
$value = $_POST['value'];

//exicute a querry to get the flaggs of the user
$flags = mysqli_query($conn,"SELECT flags FROM User_Prod WHERE id = '$id'");
// create a temp array and then fetch the value of flags
$tempArray = Array();
$tempArray = $flags->fetch_object();

//create the querry string to update the number of flags with value of -- to increase by that value or - to decrease by the value
$sql = "UPDATE User_Prod set flags=$tempArray->flags $value WHERE id = '$id'";

if (mysqli_query($conn, $sql)) {
    echo "Event $id flags updated";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
