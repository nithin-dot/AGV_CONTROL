import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

Future<List<Robot>> fetchrobot(http.Client client) async {
  final response = await client.get(Uri.parse('http://192.168.43.192:8200/'));

  // Use the compute function to run parserobot in a separate isolate.
  return compute(parserobot, response.body);
}

// A function that converts a response body into a List<Robot>.
List<Robot> parserobot(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Robot>((json) => Robot.fromJson(json)).toList();
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'RoboWare';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Robot>> _future;
  @override
  void initState() {
    super.initState();
    _future = fetchrobot(http.Client());
    setUpTimedFetch();
  }

  setUpTimedFetch() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _future = fetchrobot(http.Client());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 45, 50, 77),
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Robot>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return RobotList(robot: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class RobotList extends StatelessWidget {
  const RobotList({Key? key, required this.robot}) : super(key: key);

  final List<Robot> robot;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: const EdgeInsets.all(40.0),
        children: List.generate(
          robot.length,
          (index) {
            return Card(
                color: const Color(0xFFE9EBF7),
                child: Center(
                    child: Text(
                  robot[index].location,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                )));
          },
        ));
  }
}
