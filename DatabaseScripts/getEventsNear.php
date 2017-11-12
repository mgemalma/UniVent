<?php

// Create connection
$con=mysqli_connect("localhost","gymbudd1_UVAdmin","Bo56H!m&","gymbudd1_UniVentDB");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
// get the lat and longitude add a deviation of 1 degree to both of them
$lat = $_POST['latitude'];
$long = $_POST['longitude'];
$upperlat = $lat + 1;
$lowerlat = $lat - 1;
$upperlong = $long + 1;
$lowerlong = $long - 1;

// This SQL statement selects ALL from the table Event_Prod that are the within the bounds given by the box of lat long.
$sql = "SELECT * FROM Event_Prod where latitude < $upperlat && latitude > $lowerlat && longitude < $upperlong && longitude > $lowerlong";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
	// If so, then create a results array and a temporary one
	// to hold the data
	$resultArray = array();
	$tempArray = array();

	// Loop through each row in the result set
	while($row = $result->fetch_object())
	{
		// Add each row into our results array
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	}
// Finally, encode the array to JSON and output the results
 echo json_encode($resultArray);

}else {
  echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}


//Close connections
mysqli_close($con);
?>
