import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AppStateWidget(child: MyHomePage(title: 'Home')),
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
  @override
  Widget build(BuildContext context) {
    int count = AppStateScope.of(context).widget.count;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button ${count.toString()} many times:',
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: count < 10
                        ? () {
                            AppStateWidget.of(context).incrementCounter();
                            if (count == 9) {
                              AlertDialog alert = const AlertDialog(
                                title: Text("AlertDialog"),
                                content: Text("You cannot increment more"),
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                          }
                        : null,
                    child: const Text('+')),
                ElevatedButton(
                    onPressed: count > 0
                        ? () {
                            AppStateWidget.of(context).decrementCounter();
                            if (count == 1) {
                              AlertDialog alert = const AlertDialog(
                                title: Text("AlertDialog"),
                                content: Text("You cannot decrement more"),
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                          }
                        : null,
                    child: const Text('-'))
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppStateWidget.of(context).incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AppState {
  final int count;
  AppState({required this.count});

  AppState copyWith({int? count}) {
    return AppState(count: count ?? this.count);
  }
}

class AppStateScope extends InheritedWidget {
  final AppState widget;

  const AppStateScope({required this.widget, Key? key, required Widget child})
      : super(key: key, child: child);

  static AppStateScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!;
  }

  @override
  bool updateShouldNotify(covariant AppStateScope oldWidget) {
    return widget.count != oldWidget.widget.count;
  }
}

class AppStateWidget extends StatefulWidget {
  final Widget child;
  const AppStateWidget({Key? key, required this.child}) : super(key: key);

  static AppStateWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }

  @override
  State<AppStateWidget> createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  AppState appState = AppState(count: 0);
  //  count = appState.count;
  void incrementCounter() {
    int newCount = appState.count + 1;

    setState(() {
      appState = appState.copyWith(count: newCount);
    });
  }

  void decrementCounter() {
    int newCount = appState.count - 1;

    setState(() {
      appState = appState.copyWith(count: newCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(widget: appState, child: widget.child);
  }
}
