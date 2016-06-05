<?php
include '../mysql.php';
$json = $_SERVER['HTTP_DATA'];
$credentials = json_decode($json, true);
$db = new DbConnect();
$query = "select * from appliances";
if($credentials["playground_id"] != NULL)
{
	$query = "select * from appliances where playground_id = :playground_id";
}

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