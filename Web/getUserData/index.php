<?php
include '../mysql.php';
$json = getallheaders();
$credentials = json_decode($json["Data"], true);
$db = new DbConnect();


if($credentials["username"] != NULL)
{
	$query = "SELECT * from users
	where username like :username";
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