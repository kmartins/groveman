import 'package:flutter/material.dart';
import 'package:groveman/groveman.dart';
import 'package:groveman_sentry/groveman_sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  Groveman.plantTree(DebugTree(showColor: true));
  Groveman.captureErrorInZone(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SentryFlutter.init(
      (options) {
        options.dsn = const String.fromEnvironment('SENTRY_DNS');
      },
    );
    Groveman.plantTree(SentryTree());
    Groveman.captureErrorInCurrentIsolate();
    runApp(const MyApp());
  });
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
      _counter++;
      Groveman.info(
        'Counter - $_counter',
        tag: 'counter',
        json: {'my_counter': _counter},
      );
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
          FloatingActionButton.extended(
            onPressed: () {
              Groveman.fatal(
                'Fatal',
                error: 'Fatal',
                stackTrace: StackTrace.current,
                json: {'my_counter': _counter},
              );
            },
            label: const Text('Report fatal error'),
            icon: const Icon(Icons.bug_report),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Future.delayed(
                Duration.zero,
                () => throw Exception('Async error'),
              );
            },
            label: const Text('Report error'),
            icon: const Icon(Icons.error),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton.extended(
            onPressed: _incrementCounter,
            label: const Text('Increment'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}