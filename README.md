# Flutter-App
Robot Arm Control Panel
This project is a robot arm control application developed using Flutter for the frontend and PHP for the backend. The application allows the user to control the angles of the robot arm's joints, save poses, and run them.

## Project Contents
The project consists of two main parts:

    1. flutter_app: A Flutter application that serves as the control interface.

    2. php_backend: A set of PHP files that function as an API to communicate with the database.

### Flutter Application
The Flutter application is the frontend of the project. It allows the user to:

   * Control the Arm: Use 4 sliders to adjust the angles of the robot arm's joints (from Motor 1 to Motor 4).

   * Save Poses: Press the "Save Pose" button to save the current angle values to the database.

   * Run Poses: Press the "Run" button to execute the current pose, or select and run a saved pose from the list.

   * Manage Poses: View a list of saved poses with the ability to delete any of them.
