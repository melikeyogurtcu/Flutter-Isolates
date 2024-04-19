import 'package:flutter/material.dart';
import 'dart:isolate';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = 'Press the button to run with or without isolate';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Isolate Demo'),
          backgroundColor: Colors.deepPurple.shade100,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: runWithoutIsolate,
                child: const Text('Run without Isolate'),
              ),
              ElevatedButton(
                onPressed: runWithIsolate,
                child: const Text('Run with Isolate'),
              ),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }

  void runWithoutIsolate() {
    print('Starting without isolate');

    int sum = 0;
    for (int i = 0; i < 1000000000; i++) {
      sum += i;
    }

    print('Result: $sum');
    print('Finished without isolate');

    setState(() {
      result = 'Result: $sum\nFinished without isolate';
    });
  }

  void runWithIsolate() async {
    print('Starting with isolate');

    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(longRunningTask, receivePort.sendPort);

    receivePort.listen((data) {
      print('Result: $data');
      print('Finished with isolate');
      isolate.kill();

      setState(() {
        result = 'Result: $data\nFinished with isolate';
      });
    });
  }

  static void longRunningTask(SendPort sendPort) {
    int result = 0;
    for (int i = 0; i < 1000000000; i++) {
      result += i;
    }
    sendPort.send(result);
  }
}