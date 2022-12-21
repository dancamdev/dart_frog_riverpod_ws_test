// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Web Socket Counter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel counterChannel;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse('ws://localhost:8080/ws');
    counterChannel = WebSocketChannel.connect(uri);
  }

  @override
  void dispose() {
    counterChannel.sink.close();
    super.dispose();
  }

  void _incrementCounter() {
    counterChannel.sink.add('increment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<String>(
              stream: counterChannel.stream.cast<String>(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? '${snapshot.data}' : '0',
                  style: Theme.of(context).textTheme.headline4,
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
