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
$start = $_POST['start'];
$end = $_POST['end'];
$add = $_POST['add'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$rat = $_POST['rat'];
$ratC = $_POST['ratC'];
$flags = $_POST['flags'];
$heads = $_POST['heads'];
$host = $_POST['host'];
$title = $_POST['title'];
$type = $_POST['type'];
$desc = $_POST['desc'];
$interests = $_POST['interests'];


$sql = "INSERT INTO Event_Prod (id,startT,endT,addr,latitude,longitude,rat,ratC,flags,heads,host,title,type,descr,interests)
VALUES('$id',$start,$end,'$add',$latitude,$longitude,$rat,$ratC,$flags,'$heads','$host','$title','$type','$desc','$interests')";
if (mysqli_query($conn, $sql)){
  echo "New record created successfully";
}
else{
  $sql = "UPDATE Event_Prod set startT='$start',endT=$end,addr='$add',latitude=$latitude,longitude=$longitude,rat=$rat,ratC=$ratC,flags=$flags,heads='$heads', host='$host',title='$title',type='$type', descr ='$desc', interests ='$interests' where id = $id";

  if (mysqli_query($conn, $sql)) {
  echo "Updated successfully";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
  }
}




mysqli_close($conn);
?>
