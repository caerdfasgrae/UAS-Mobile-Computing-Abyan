<?php
require_once("../cors.php");
require_once("../db.php");

$user_id = intval($_GET['user_id'] ?? 0);
if ($user_id <= 0) {
  http_response_code(400);
  echo json_encode(["success"=>false,"message"=>"user_id wajib"]);
  exit;
}

$stmt = $conn->prepare("
  SELECT p.lesson_id, p.points, p.last_seen, l.title
  FROM progress p
  JOIN lessons l ON l.id = p.lesson_id
  WHERE p.user_id=?
  ORDER BY p.last_seen DESC
");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$res = $stmt->get_result();

$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;

echo json_encode(["success"=>true,"data"=>$data]);
$stmt->close();
$conn->close();