import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groveman/groveman.dart';

void main() {
  Groveman.plantTree(DebugTree(showColor: true));
  Groveman.captureErrorInCurrentIsolate();
  Groveman.captureErrorInZone(() => runApp(const MyApp()));
  Groveman.debug('Run App', tag: 'app');
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      Groveman.info(
        'Counter',
        json: <String, Object>{
          'counter': _counter,
        },
      );
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Groveman.fatal(
                'Fatal',
                error: 'Fatal',
                stackTrace: StackTrace.current,
              );
            },
            tooltip: 'Fatal',
            child: const Icon(Icons.bug_report),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: () {
              Future.delayed(
                Duration.zero,
                () => throw Exception('Async error'),
              );
            },
            tooltip: 'Error',
            child: const Icon(Icons.error),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
