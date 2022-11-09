import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefCounter extends StatefulWidget {
  const SharedPrefCounter({required Key key}) : super(key: key);

  @override
  State<SharedPrefCounter> createState() => _SharedPrefCounterState();
}

class _SharedPrefCounterState extends State<SharedPrefCounter> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  Future<void> _decrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) - 1;

    setState(() {
      if (counter < 0) {
        return;
      }
      _counter = prefs.setInt('counter', counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _resetCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) * 0;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SharedPreferences Demo"),
        actions: [
          IconButton(
            onPressed: _resetCounter,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            FutureBuilder<int>(
                future: _counter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.',
                          style: const TextStyle(fontSize: 22.0),
                        );
                      }
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 50),
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
