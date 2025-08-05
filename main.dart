import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getRobotPose(int poseId) async {

final String baseUrl = 'http://192.168.0.189/robot_arm_api/get_run_pose.php';

final Uri url = Uri.parse('$baseUrl?pose_id=$poseId');

try {
final http.Response response = await http.get(url);

if (response.statusCode == 200) {
final Map<String, dynamic> responseData = json.decode(response.body);
if (responseData['success'] == true) {

if (responseData.containsKey('pose')) {
return responseData['pose'];
} else {
throw Exception('Server response is missing the "pose" data.');
}
} else {
throw Exception(responseData['error'] ?? 'Failed to get pose from server.');
}
} else {
throw Exception('Failed to load pose. Status code: ${response.statusCode}');
}
} catch (e) {
throw Exception('Error: $e');
}
}


void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Robot Arm Control Panel',
theme: ThemeData(
primarySwatch: Colors.blue,
visualDensity: VisualDensity.adaptivePlatformDensity,
),
home: const RobotArmControlScreen(),
);
}
}

class RobotArmControlScreen extends StatefulWidget {
const RobotArmControlScreen({Key? key}) : super(key: key);

@override
_RobotArmControlScreenState createState() => _RobotArmControlScreenState();
}

class _RobotArmControlScreenState extends State<RobotArmControlScreen> {

double _motor1 = 90.0;
double _motor2 = 90.0;
double _motor3 = 90.0;
double _motor4 = 90.0;

List<Map<String, dynamic>> _savedPoses = [
{'id': 1, 'motor1': 157, 'motor2': 55, 'motor3': 90, 'motor4': 26},
{'id': 2, 'motor1': 90, 'motor2': 115, 'motor3': 90, 'motor4': 59},
{'id': 3, 'motor1': 98, 'motor2': 77, 'motor3': 188, 'motor4': 79},
{'id': 4, 'motor1': 46, 'motor2': 75, 'motor3': 137, 'motor4': 82},
];

Future<void> _fetchPoses() async {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Fetching poses from dummy data...')),
);
}

Future<void> _saveCurrentPose() async {
final newPose = {
'id': _savedPoses.length + 1,
'motor1': _motor1.round(),
'motor2': _motor2.round(),
'motor3': _motor3.round(),
'motor4': _motor4.round(),
};
setState(() {
_savedPoses.add(newPose);
});
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Pose saved!')),
);
}

void _runPose(Map<String, dynamic> pose) {
setState(() {
_motor1 = pose['motor1'].toDouble();
_motor2 = pose['motor2'].toDouble();
_motor3 = pose['motor3'].toDouble();
_motor4 = pose['motor4'].toDouble();
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Running Pose ${pose['id']}...')),
);
}

void _resetSliders() {
setState(() {
_motor1 = 90.0;
_motor2 = 90.0;
_motor3 = 90.0;
_motor4 = 90.0;
});
}

void _deletePose(int id) {
setState(() {
_savedPoses.removeWhere((pose) => pose['id'] == id);
});
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('Pose $id deleted!')),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Robot Arm Control Panel'),
centerTitle: true,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: <Widget>[

_buildSlider('Motor 1', _motor1, (value) {
setState(() => _motor1 = value);
}),
_buildSlider('Motor 2', _motor2, (value) {
setState(() => _motor2 = value);
}),
_buildSlider('Motor 3', _motor3, (value) {
setState(() => _motor3 = value);
}),
_buildSlider('Motor 4', _motor4, (value) {
setState(() => _motor4 = value);
}),

const SizedBox(height: 20),

Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
ElevatedButton(
onPressed: _resetSliders,
child: const Text('Reset'),
),
ElevatedButton(
onPressed: _saveCurrentPose,
child: const Text('Save Pose'),
),
ElevatedButton(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Running current pose...')),
);

},
child: const Text('Run'),
),
],
),

const SizedBox(height: 30),

const Text(
'Saved Poses:',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),

_savedPoses.isEmpty
? const Center(child: Text('No poses saved yet.'))
: ListView.builder(
physics: const NeverScrollableScrollPhysics(),
shrinkWrap: true,
itemCount: _savedPoses.length,
itemBuilder: (context, index) {
final pose = _savedPoses[index];
return Card(
child: ListTile(
title: Text(
'Pose ${pose['id']}: ${pose['motor1']}, ${pose['motor2']}, ${pose['motor3']}, ${pose['motor4']}',
style: const TextStyle(fontSize: 16),
),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: const Icon(Icons.play_arrow, color: Colors.green),
onPressed: () => _runPose(pose),
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: () => _deletePose(pose['id']),
),
],
),
),
);
},
),
],
),
),
);
}

Widget _buildSlider(String label, double value, Function(double) onChanged) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'$label: ${value.round()}',
style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
),
Slider(
value: value,
min: 0,
max: 180,
divisions: 180,
label: value.round().toString(),
onChanged: onChanged,
),
],
),
);
}
}
