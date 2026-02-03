<?php
require_once("../cors.php");
require_once("../db.php");

$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($email === '' || $password === '') {
  http_response_code(400);
  echo json_encode(["success"=>false,"message"=>"email/password wajib"]);
  exit;
}

$stmt = $conn->prepare("SELECT id, name, email, password_hash FROM users WHERE email=? LIMIT 1");
$stmt->bind_param("s", $email);
$stmt->execute();
$res = $stmt->get_result();

if ($row = $res->fetch_assoc()) {
  if (password_verify($password, $row['password_hash'])) {
    unset($row['password_hash']);
    echo json_encode(["success"=>true,"user"=>$row]);
    exit;
  }
}

http_response_code(401);
echo json_encode(["success"=>false,"message"=>"Login gagal"]);
$stmt->close();
$conn->close();