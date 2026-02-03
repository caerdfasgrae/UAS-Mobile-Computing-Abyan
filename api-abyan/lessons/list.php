<?php
require_once("../cors.php");
require_once("../db.php");

$q = $conn->query("SELECT id, title, level, image_asset FROM lessons ORDER BY id DESC");
$data = [];
while($row = $q->fetch_assoc()) $data[] = $row;

echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>