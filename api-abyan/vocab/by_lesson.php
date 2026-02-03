<?php
require_once("../cors.php");
require_once("../db.php");

$lesson_id = intval($_GET['lesson_id'] ?? 0);
if ($lesson_id <= 0) {
  http_response_code(400);
  echo json_encode(["success"=>false,"message"=>"lesson_id wajib"]);
  exit;
}

$stmt = $conn->prepare("SELECT id, jp, romaji, idn, example FROM vocab WHERE lesson_id=? ORDER BY id ASC");
$stmt->bind_param("i", $lesson_id);
$stmt->execute();
$res = $stmt->get_result();

$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;

echo json_encode(["success"=>true,"data"=>$data]);
$stmt->close();
$conn->close();