<?php
include '../mysql.php';
$json = getallheaders();
$credentials = json_decode($json["Data"], true);
$db = new DbConnect();
$query = "SELECT user_id, users.username as user, SUM(points) as points_sum, AVG(intensity) as average_intensity
FROM logs 
LEFT JOIN appliances ON appliances.id = logs.appliance_id
LEFT JOIN playgrounds ON playgrounds.id = appliances.playground_id
LEFT JOIN users on users.id = logs.user_id
group by user_id
order by points_sum DESC";

$result = $db->execute_query($query, $credentials, true);
if($result)
	{
		http_response_code(200);
		echo $result;
	}
else
	{
		http_response_code(400);
	}
	
	
?>