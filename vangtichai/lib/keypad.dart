import 'package:flutter/material.dart';
import 'dimensions.dart';

/// A numeric keypad built entirely from scratch out of Rows/Expanded and
/// InkWell-based buttons (no built-in number-pad widget used), as required.
class Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onClear;
  final AppDimensions dims;
  final int columns; // 3 in portrait, 4 in landscape

  const Keypad({
    super.key,
    required this.onDigit,
    required this.onClear,
    required this.dims,
    this.columns = 3,
  });

  @override
  Widget build(BuildContext context) {
    final rows = columns == 4 ? _landscapeRows() : _portraitRows();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < rows.length; i++) ...[
          if (i != 0) SizedBox(height: dims.keypadButtonSpacing),
          _buildRow(rows[i]),
        ],
      ],
    );
  }

  // Portrait: 3-wide grid; last row is [0, CLEAR] with CLEAR spanning 2 cells.
  List<List<_KeyDef>> _portraitRows() => [
        [_KeyDef('1'), _KeyDef('2'), _KeyDef('3')],
        [_KeyDef('4'), _KeyDef('5'), _KeyDef('6')],
        [_KeyDef('7'), _KeyDef('8'), _KeyDef('9')],
        [_KeyDef('0'), _KeyDef('CLEAR', flex: 2)],
      ];

  // Landscape: 4-wide grid; last row is [9, 0, CLEAR] with CLEAR spanning 2.
  List<List<_KeyDef>> _landscapeRows() => [
        [_KeyDef('1'), _KeyDef('2'), _KeyDef('3'), _KeyDef('4')],
        [_KeyDef('5'), _KeyDef('6'), _KeyDef('7'), _KeyDef('8')],
        [_KeyDef('9'), _KeyDef('0'), _KeyDef('CLEAR', flex: 2)],
      ];

  Widget _buildRow(List<_KeyDef> keys) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i != 0) SizedBox(width: dims.keypadButtonSpacing),
          Expanded(flex: keys[i].flex, child: _buildButton(keys[i].label)),
        ],
      ],
    );
  }

  Widget _buildButton(String label) {
    final isClear = label == 'CLEAR';
    return SizedBox(
      height: dims.keypadButtonHeight,
      child: Material(
        color: isClear ? Colors.teal.shade300 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(dims.keypadButtonRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(dims.keypadButtonRadius),
          onTap: () => isClear ? onClear() : onDigit(label),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: dims.keypadButtonFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyDef {
  final String label;
  final int flex;
  _KeyDef(this.label, {this.flex = 1});
}
