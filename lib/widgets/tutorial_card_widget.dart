import 'package:flutter/material.dart';

class TutorialCardWidget extends StatefulWidget {
  final String text;
  final String nextText;
  final String previousText;
  final void Function()? onPrevious;
  final void Function()? onNext;
  const TutorialCardWidget({
    super.key,
    required this.text,
    required this.nextText,
    required this.previousText,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<TutorialCardWidget> createState() => _TutorialCardWidgetState();
}

class _TutorialCardWidgetState extends State<TutorialCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: widget.onPrevious,
                  child: Text(widget.previousText),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text(widget.nextText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
