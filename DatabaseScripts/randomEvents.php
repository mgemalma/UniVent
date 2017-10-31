<?php
// Create connection
$conn = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
for ($i=0; $i < 100; $i++) {
  $id = uniqid();
  $start = time()+(20*60);
  $end = time()+(20*60);
  $add = "address$i";
  $rat = rand(0,5);
  $ratC = rand(0,25);
  $flags = rand(0,13);
  $heads = rand(0,13);
  $latitude = rand(40440000,40449999)/1000000;
  $longitude = rand(-86950000,-86959999)/1000000;
  $host = rand();
  $title = "title$i";
  $type = "type$i";
  $desc = "description$i";
  $interests = "interests$i";


  $sql = "INSERT INTO Event_Prod (id,startT,endT,addr,latitude,longitude,rat,ratC,flags,heads,host,title,type,descr,interests)
  VALUES('$id',$start,$end,'$add',$latitude,$longitude,$rat,$ratC,$flags,'$heads','$host','$title','$type','$desc','$interests')";
  if (mysqli_query($conn, $sql)) {
      echo "New record created successfully";
  } else {
      echo "Error: " . $sql . "<br>" . mysqli_error($conn);
  }
}


mysqli_close($conn);
?>
