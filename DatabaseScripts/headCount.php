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

//get the heads count through exicuting the sql querry and fetching the specific value into an array
$heads = mysqli_query($conn,"SELECT heads FROM Event_Prod WHERE id = '$id'");
$tempArray = Array();
$tempArray = $heads->fetch_object();

//create the querry string to update the number of heads with value of -- to increase by that value or - to decrease by the value
$sql = "UPDATE Event_Prod set heads=$tempArray->heads $value WHERE id = '$id'";


if (mysqli_query($conn, $sql)) {
    echo "Event $id heads updated";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>
