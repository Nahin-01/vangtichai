import 'package:flutter/material.dart';
import 'change_calculator.dart';
import 'dimensions.dart';

/// Shows the note:count breakdown.
/// - Portrait: single column (matches the assignment screenshots).
/// - Landscape: split into two columns (500,100,50,20 | 10,5,2,1) to save
///   vertical space, again matching the assignment screenshots.
class ChangeTable extends StatelessWidget {
  final Map<int, int> change;
  final AppDimensions dims;
  final bool twoColumns;

  const ChangeTable({
    super.key,
    required this.change,
    required this.dims,
    this.twoColumns = false,
  });

  @override
  Widget build(BuildContext context) {
    final notes = ChangeCalculator.denominations;

    if (!twoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: notes.map(_row).toList(),
      );
    }

    final firstHalf = notes.sublist(0, 4); // 500,100,50,20
    final secondHalf = notes.sublist(4); // 10,5,2,1

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: firstHalf.map(_row).toList(),
        ),
        SizedBox(width: dims.tableColumnSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: secondHalf.map(_row).toList(),
        ),
      ],
    );
  }

  Widget _row(int note) {
    final count = change[note] ?? 0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dims.tableRowSpacing / 2),
      child: Text('$note: $count', style: TextStyle(fontSize: dims.tableFontSize)),
    );
  }
}
