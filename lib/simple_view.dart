import 'dart:isolate';

import 'package:flutter/material.dart';

class SimpleView extends StatefulWidget {
  const SimpleView({super.key});

  @override
  State<SimpleView> createState() => _SimpleViewState();
}

class _SimpleViewState extends State<SimpleView> {
  String callBackMethod = "Nothing";
  int _loopResult = 0;

  // ### NOTE
  // we can use future or not future method for this action
  // here, future is used that to check the method is clear or not in future method
  Future<int> setLoopResultByNormalLoop() async {
    _loopResult = 0;
    int loopValue = 0;

    print(
        "\n\n\n----------------------------\n\n\nNormal Loop\n\n\n-----------------------------\n\n\n");

    for (int i = 0; i < 1000000000; i++) {
      loopValue = i;
    }

    print(
        "\n\n\n----------------------------\n\n\n${loopValue}\n\n\n-----------------------------\n\n\n");
    return loopValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/tenor_1.gif"),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final value = await setLoopResultByNormalLoop();
                    setState(() {
                      _loopResult = value;
                      if (value != 0) {
                        callBackMethod = "Normal Loop";
                      }
                    });
                  },
                  child: const Text(
                    "Normal Loop",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final receiver = ReceivePort();
                    await Isolate.spawn(
                        setLoopResultByIsolateLoop, receiver.sendPort);
                    receiver.listen((value) {
                      setState(() {
                        _loopResult = value + 1;
                        if (value != 0) {
                          callBackMethod = "Isolated Loop";
                        }
                      });
                    });
                  },
                  child: const Text(
                    "Isolated Loop",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              "Loop Result - $_loopResult",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Call Back Method $callBackMethod"),
          ],
        ),
      ),
    );
  }
}

void setLoopResultByIsolateLoop(SendPort sendPort) {
  int loopValue = 0;

  print(
      "\n\n\n----------------------------\n\n\nIsolated Loop\n\n\n-----------------------------\n\n\n");

  for (int i = 0; i < 1000000000; i++) {
    loopValue = i;
  }

  print(
      "\n\n\n----------------------------\n\n\n${loopValue}\n\n\n-----------------------------\n\n\n");
  sendPort.send(loopValue);
}
