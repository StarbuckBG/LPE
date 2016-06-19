<?php
include '../mysql.php';
//$json = $_SERVER['HTTP_DATA'];
$json = file_get_contents('php://input');
$credentials = json_decode($json, true);
if($credentials['user_id'] != NULL && $credentials['points'] != NULL)
{
	$db = new DbConnect();
	$query = "Insert into logs(user_id, appliance_id, points, intensity, start_time, end_time) values(:user_id, :appliance_id, :points, :intensity, :start_time, :end_time)";
	try
	{
		if($db->execute_query($query, $credentials))
		{
			http_response_code(200);
		}
		else
		{
		http_response_code(400);
		}
	}
	catch(PDOException $e)
	{
		http_response_code(406);
	}
	
}
else
{
	http_response_code(400);
}


?>