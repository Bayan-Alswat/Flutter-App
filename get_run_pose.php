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

if (!isset($_GET['pose_id'])) {
die(json_encode(['error' => 'pose_id parameter is missing']));
}

$poseId = $_GET['pose_id'];


$sql = "SELECT motor1_angle, motor2_angle, motor3_angle, motor4_angle FROM poses WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $poseId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
$row = $result->fetch_assoc();
echo json_encode(['success' => true, 'pose' => $row]);
} else {
echo json_encode(['success' => false, 'error' => 'Pose not found']);
}

$stmt->close();
$conn->close();
?>
