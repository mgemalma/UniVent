<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
//fetch VALUES
$id = $_POST['id'];
$name = $_POST['name'];
$flags = $_POST['flags'];
$rad = $_POST['rad'];
$interests = $_POST['interests'];
$pEvents = $_POST['pEvents'];
$aEvents = $_POST['aEvents'];
$fEvents = $_POST['fEvents'];
$rEvents = $_POST['rEvents'];

//insert querry string including all the values to add a user.
$sql = "INSERT INTO User_Prod (id,name,flags,rad,interests,pEvents,aEvents,fEvents,rEvents)
VALUES('$id','$name',$flags,$rad,'$interests','$pEvents','$aEvents','$fEvents','$rEvents')";
if (mysqli_query($conn, $sql)){
  echo "User $id has been added to database successfully";
}
else{
  //the user exist therefore we will use update instead.

  //update querry string including all the values to change in the user.
  $sql = "UPDATE User_Prod set name = '$name',flags = $flags,rad = $rad, interests = '$interests',pEvents = '$pEvents',aEvents = '$aEvents',fEvents = '$fEvents',rEvents = '$rEvents' where id = '$id'" ;
  if (mysqli_query($conn, $sql)) {
    echo "User $id has been updated successfully";
  } else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
  }
}



mysqli_close($conn);
?>
