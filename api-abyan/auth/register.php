<?php
require_once("../cors.php");
require_once("../db.php");

$name = trim($_POST['name'] ?? '');
$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($name === '' || $email === '' || $password === '') {
  http_response_code(400);
  echo json_encode(["success"=>false,"message"=>"name/email/password wajib"]);
  exit;
}

$hash = password_hash($password, PASSWORD_BCRYPT);

$stmt = $conn->prepare("INSERT INTO users (name, email, password_hash) VALUES (?,?,?)");
$stmt->bind_param("sss", $name, $email, $hash);

if ($stmt->execute()) {
  echo json_encode(["success"=>true,"user_id"=>$conn->insert_id]);
} else {
  http_response_code(409);
  echo json_encode(["success"=>false,"message"=>"email sudah terdaftar"]);
}
$stmt->close();
$conn->close();