import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../service/counter.dart';
import 'sharedPrefPage.dart';

final provider = StateNotifierProvider<CounterNotifier, CounterModel>(
  (ref) => CounterNotifier(),
);

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Counter App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const SharedPrefCounter(key: Key('SharedPrefCounter')),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            const CounterTextWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    context.read(provider.notifier).increment();
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.read(provider.notifier).decrement();
                  },
                  tooltip: 'Decrement',
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

class CounterTextWidget extends HookWidget {
  const CounterTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('building CounterTextWidget');
    final counterModel = useProvider(provider);
    return Text(
      '${counterModel.count}',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
