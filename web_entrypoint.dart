import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:edtech_app/main.dart'; // Replace with your app's main file path.

void main() {
  // Set up web-specific URL strategy
  setUrlStrategy(PathUrlStrategy());

  // Run the app
  runApp(MyApp());
}
