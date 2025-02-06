import 'package:flutter/material.dart';
import 'package:project_hydros/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Root widget
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello, World!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Dashboard()),
                            );
                    },
                    child: const Text('Dashboard'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}