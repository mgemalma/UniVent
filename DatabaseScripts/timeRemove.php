<?php
// Create connection
$con = mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$time = time();
$sql = "SELECT * FROM Event_Prod where $time >= endT";


$result = mysqli_query($con, $sql);
  // If so, then create a results array and a temporary one
  // to hold the data
  $resultArray = array();
  $tempArray = array();

  // Loop through each row in the result set
  while($row = $result->fetch_object())
  {
    // Add each row into our results array
    $tempArray = $row;
      //print_r($row);
      array_push($resultArray, $tempArray);
  }
print_r($resultArray);
  // Finally, encode the array to JSON and output the results
  //echo json_encode($resultArray);


$sql = "SELECT * FROM User_Prod";
$result = mysqli_query($con, $sql);

  // If so, then create a results array and a temporary one
  // to hold the data
  $userArray = array();
  $tempArray = array();

  // Loop through each row in the result set
  while($row = $result->fetch_object())
  {
    // Add each row into our results array
    $tempArray = $row;
      //print_r($row);
      array_push($userArray, $tempArray);
  }
  print_r($userArray);

  for ($i = 0; $i < Count($resultArray); $i++) {
    $id = $resultArray[$i]->id;
    foreach($userArray as $item):
      echo "event ID : $id\n";
      echo "aEvents Before: $item->aEvents\n";
      $uid = $item->id;
      $item->aEvents = str_replace($id."^", "", $item->aEvents);
      $item->aEvents = str_replace("^".$id, "", $item->aEvents);
      $item->aEvents = str_replace($id, "", $item->aEvents);
      $item->pEvents = str_replace($id."^", "", $item->pEvents);
      $item->pEvents = str_replace("^".$id, "", $item->pEvents);
      $item->pEvents = str_replace($id, "", $item->pEvents);

      //str_replace("^^", "^", $aEvents);
      $sql = "UPDATE User_Prod set aEvents = '$item->aEvents',pEvents = '$item->pEvents' where id = '$uid'";
      //$sql = "UPDATE FROM User_Prod set aEvents = '$item->aEvents' where id = '$uid'";
      echo "$sql\n";
      echo "aEvents after:$item->aEvents \n";
      mysqli_query($con, $sql);
     endforeach;
  }

  // Finally, encode the array to JSON and output the results
  //echo json_encode($resultArray);

$sql = "DELETE FROM Event_Prod where $time >= endT";
if (mysqli_query($con, $sql)) {
    echo "Removed Events";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($con);
}

mysqli_close($con);
?>
