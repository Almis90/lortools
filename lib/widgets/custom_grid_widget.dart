import 'package:flutter/material.dart';

class CustomGridWidget extends StatelessWidget {
  final List<Widget>? children;

  const CustomGridWidget({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildRows(),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    final nonNullableChildren = children ?? [];

    if (nonNullableChildren.isEmpty) return [];
    if (children!.length == 1) return [buildCenteredRow(children!.first)];

    rows.add(buildRow(children!.sublist(
        0, nonNullableChildren.length > 3 ? 3 : nonNullableChildren.length)));

    if (nonNullableChildren.length == 4) {
      rows.add(buildCenteredRow(nonNullableChildren[3]));
    }

    return rows;
  }

  Widget buildRow(List<Widget> rowChildren) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowChildren.map((child) => Expanded(child: child)).toList(),
    );
  }

  Widget buildCenteredRow(Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [child],
    );
  }
}
