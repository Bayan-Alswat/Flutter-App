<?php
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "robot_arm_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
die(json_encode(['error' => 'Connection failed: ' . $conn->connect_error]));
}


if (!isset($_POST['id'])) {
die(json_encode(['error' => 'id parameter is missing']));
}

$id = $_POST['id'];

$sql = "UPDATE robot_status SET status_value = 0 WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
echo json_encode(['success' => true, 'message' => 'Status updated to 0']);
} else {
echo json_encode(['success' => false, 'error' => 'Error updating status']);
}

$stmt->close();
$conn->close();
?>
