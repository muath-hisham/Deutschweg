import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final ValueNotifier<double> progress;

  ProgressDialog({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Loading..."),
            SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, child) {
                return Column(
                  children: [
                    LinearProgressIndicator(value: value),
                    SizedBox(height: 8),
                    Text("${(value * 100).toStringAsFixed(1)}%"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
