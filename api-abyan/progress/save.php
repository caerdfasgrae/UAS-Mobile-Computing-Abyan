<?php
require_once("../cors.php");
require_once("../db.php");

$user_id = intval($_POST['user_id'] ?? 0);
$lesson_id = intval($_POST['lesson_id'] ?? 0);
$points = intval($_POST['points'] ?? 0);

if ($user_id<=0 || $lesson_id<=0) {
  http_response_code(400);
  echo json_encode(["success"=>false,"message"=>"user_id & lesson_id wajib"]);
  exit;
}

$stmt = $conn->prepare("
  INSERT INTO progress (user_id, lesson_id, points, last_seen)
  VALUES (?, ?, ?, NOW())
  ON DUPLICATE KEY UPDATE points=VALUES(points), last_seen=NOW()
");
$stmt->bind_param("iii", $user_id, $lesson_id, $points);

if ($stmt->execute()) {
  echo json_encode(["success"=>true]);
} else {
  http_response_code(500);
  echo json_encode(["success"=>false,"message"=>"gagal simpan progress"]);
}
$stmt->close();
$conn->close();