import 'package:flutter/material.dart';
import 'change_calculator.dart';
import 'change_table.dart';
import 'dimensions.dart';
import 'keypad.dart';

class VangtiChaiScreen extends StatefulWidget {
  const VangtiChaiScreen({super.key});

  @override
  State<VangtiChaiScreen> createState() => _VangtiChaiScreenState();
}

class _VangtiChaiScreenState extends State<VangtiChaiScreen> {
  // Kept as a String so digits are entered "from the right", exactly as
  // specified: typing 2, 3, 4 in order shows 2 -> 23 -> 234.
  String _amountText = '';

  int get _amount => _amountText.isEmpty ? 0 : int.parse(_amountText);

  void _onDigit(String digit) {
    setState(() {
      _amountText = (_amountText == '0') ? digit : _amountText + digit;
    });
  }

  void _onClear() => setState(() => _amountText = '');

  @override
  Widget build(BuildContext context) {
    final dims = AppDimensions.of(context);
    final change = ChangeCalculator.calculateChange(_amount);
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text('VangtiChai', style: TextStyle(fontSize: dims.appBarFontSize)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(dims.screenPadding),
          child: orientation == Orientation.portrait
              ? _buildPortrait(dims, change)
              : _buildLandscape(dims, change),
        ),
      ),
    );
  }

  Widget _buildHeader(AppDimensions dims) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dims.headerVerticalPadding),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: 'Taka: ',
                style: TextStyle(fontSize: dims.amountLabelFontSize, color: Colors.black87),
              ),
              TextSpan(
                text: '$_amount',
                style: TextStyle(
                  fontSize: dims.amountValueFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Portrait: header, change table on the left, keypad on the right.
  Widget _buildPortrait(AppDimensions dims, Map<int, int> change) {
    return Column(
      children: [
        _buildHeader(dims),
        SizedBox(height: dims.sectionSpacing),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: ChangeTable(change: change, dims: dims)),
              SizedBox(width: dims.sectionSpacing),
              Expanded(
                flex: 3,
                child: Keypad(onDigit: _onDigit, onClear: _onClear, dims: dims, columns: 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Landscape: header, two-column change table, wider 4-column keypad.
  Widget _buildLandscape(AppDimensions dims, Map<int, int> change) {
    return Column(
      children: [
        _buildHeader(dims),
        SizedBox(height: dims.sectionSpacing),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ChangeTable(change: change, dims: dims, twoColumns: true),
              ),
              SizedBox(width: dims.sectionSpacing),
              Expanded(
                flex: 3,
                child: Keypad(onDigit: _onDigit, onClear: _onClear, dims: dims, columns: 4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
