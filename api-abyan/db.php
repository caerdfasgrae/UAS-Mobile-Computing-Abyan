<?php
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost","tify9948_abyan","abyanpacarhani","tify9948_db_abyan");
if ($conn->connect_error) {
  http_response_code(500);
  echo json_encode(["success"=>false,"message"=>"DB Error"]);
  exit;
}
$conn->set_charset("utf8mb4");
?>