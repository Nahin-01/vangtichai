# VangtiChai

This project is a Flutter-based change calculator. It takes a numeric amount in taka, breaks it into Bangladeshi note denominations, and shows the result in a responsive UI that changes layout in portrait and landscape mode.

This README is written as a viva guide. It explains what each file in `lib/` does, how the widgets connect, and why the code is written this way.

## Project Idea

The app solves a simple problem:

1. The user enters an amount using a custom keypad.
2. The app calculates how many 500, 100, 50, 20, 10, 5, 2, and 1 taka notes are needed.
3. The result is shown in a table.
4. The layout adapts for phone portrait, phone landscape, and tablet-like screens.

## Main App Flow

The control flow is:

1. `main.dart` starts the app.
2. `VangtiChaiApp` creates the `MaterialApp`.
3. `VangtiChaiScreen` builds the main screen and stores the entered amount.
4. `ChangeCalculator` computes the note counts.
5. `ChangeTable` displays the counts.
6. `Keypad` handles number input and clear actions.
7. `AppDimensions` provides responsive sizes for different screen types.

## File-by-File Explanation

### `lib/main.dart`

```dart
void main() {
	runApp(const VangtiChaiApp());
}
```

This is the entry point of the Flutter app. `runApp` attaches the root widget to the screen.

```dart
class VangtiChaiApp extends StatelessWidget {
```

This is the root widget of the application. It is `StatelessWidget` because it does not store changing UI data itself.

```dart
return MaterialApp(
	title: 'VangtiChai',
	debugShowCheckedModeBanner: false,
	theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: false),
	home: const VangtiChaiScreen(),
);
```

What each property means:

1. `title` sets the app name.
2. `debugShowCheckedModeBanner: false` removes the red debug banner.
3. `theme` sets the app color theme to teal.
4. `home` defines the first screen shown to the user.

### `lib/vangtichai_screen.dart`

This is the most important file because it controls the entire screen.

```dart
class VangtiChaiScreen extends StatefulWidget {
```

It is stateful because the amount entered by the user changes over time. The screen must rebuild when digits are pressed or cleared.

```dart
String _amountText = '';
```

The amount is stored as a `String` instead of an `int` so the keypad can append digits one by one. This is why typing `2`, then `3`, then `4` shows `2 -> 23 -> 234`.

```dart
int get _amount => _amountText.isEmpty ? 0 : int.parse(_amountText);
```

This converts the text into an integer when needed for calculation. If no digits were entered, the amount becomes `0`.

```dart
void _onDigit(String digit) {
	setState(() {
		_amountText = (_amountText == '0') ? digit : _amountText + digit;
	});
}
```

This runs whenever a number button is tapped.

1. `setState` tells Flutter to rebuild the UI.
2. If the current value is `0`, it replaces it with the new digit.
3. Otherwise, it appends the new digit to the end.

```dart
void _onClear() => setState(() => _amountText = '');
```

This resets the amount to empty when the CLEAR button is pressed.

```dart
final dims = AppDimensions.of(context);
final change = ChangeCalculator.calculateChange(_amount);
final orientation = MediaQuery.of(context).orientation;
```

These three lines prepare the screen:

1. `dims` gets the responsive size values.
2. `change` calculates the note breakdown.
3. `orientation` checks whether the device is in portrait or landscape mode.

```dart
return Scaffold(
	appBar: AppBar(
		title: Text('VangtiChai', style: TextStyle(fontSize: dims.appBarFontSize)),
	),
```

`Scaffold` provides the standard page structure. `AppBar` shows the title at the top, and its text size comes from `AppDimensions`.

```dart
body: SafeArea(
	child: Padding(
		padding: EdgeInsets.all(dims.screenPadding),
```

`SafeArea` prevents the UI from overlapping notches and system bars. `Padding` adds space around the content.

```dart
orientation == Orientation.portrait
		? _buildPortrait(dims, change)
		: _buildLandscape(dims, change),
```

This switches between two layouts depending on screen orientation.

#### `_buildHeader`

```dart
RichText(
	text: TextSpan(
		style: DefaultTextStyle.of(context).style,
		children: [
			TextSpan(text: 'Taka: '),
			TextSpan(text: '$_amount', ...),
		],
	),
)
```

This displays the entered amount. `RichText` is used so the label and value can have different styles in the same line.

#### `_buildPortrait`

Portrait mode uses a vertical screen layout:

1. The amount header is shown at the top.
2. The change table is placed on the left.
3. The keypad is placed on the right.

```dart
Expanded(flex: 2, child: ChangeTable(...))
```

The change table gets less width than the keypad because the keypad needs more space for buttons.

```dart
Keypad(onDigit: _onDigit, onClear: _onClear, dims: dims, columns: 3)
```

The portrait keypad uses 3 columns.

#### `_buildLandscape`

Landscape mode uses the same basic structure, but with a two-column change table and a wider 4-column keypad.

```dart
ChangeTable(change: change, dims: dims, twoColumns: true)
```

This splits the notes into two groups to save vertical space.

```dart
Keypad(onDigit: _onDigit, onClear: _onClear, dims: dims, columns: 4)
```

The landscape keypad uses 4 columns so the wider screen is used efficiently.

### `lib/change_calculator.dart`

This file contains the pure logic for calculating change.

```dart
static const List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];
```

These are the supported note denominations, arranged from largest to smallest.

```dart
static Map<int, int> calculateChange(int amount) {
```

This method returns a map where the key is the denomination and the value is the number of notes needed.

```dart
int remaining = amount;
for (final note in denominations) {
	result[note] = remaining ~/ note;
	remaining = remaining % note;
}
```

This is a greedy algorithm:

1. Divide the remaining amount by the current note value using integer division `~/`.
2. Store how many notes fit.
3. Use `%` to keep only the leftover amount.
4. Move to the next smaller denomination.

Example for `234`:

1. `100` notes = `2`, remainder `34`
2. `20` notes = `1`, remainder `14`
3. `10` notes = `1`, remainder `4`
4. `2` notes = `2`, remainder `0`

So the result becomes:

```text
500: 0
100: 2
50: 0
20: 1
10: 1
5: 0
2: 2
1: 0
```

### `lib/change_table.dart`

This widget displays the calculated note counts.

```dart
class ChangeTable extends StatelessWidget {
```

It is stateless because it only displays the `change` map passed from the parent.

```dart
final Map<int, int> change;
final AppDimensions dims;
final bool twoColumns;
```

These are the inputs:

1. `change` contains the note counts.
2. `dims` provides spacing and font sizes.
3. `twoColumns` decides whether the table should be split into two columns.

```dart
const notes = ChangeCalculator.denominations;
```

The table uses the same denomination order as the calculator, so the display always matches the logic.

```dart
if (!twoColumns) {
	return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: notes.map(_row).toList(),
	);
}
```

In portrait mode, all rows are shown in one vertical column.

```dart
final firstHalf = notes.sublist(0, 4);
final secondHalf = notes.sublist(4);
```

In landscape mode, the denominations are split into two groups:

1. `500, 100, 50, 20`
2. `10, 5, 2, 1`

This makes the table shorter and easier to fit on the screen.

```dart
Widget _row(int note) {
	final count = change[note] ?? 0;
```

Each row shows one denomination and its count. If a value is missing, it defaults to `0`.

### `lib/keypad.dart`

This file builds the custom numeric keypad.

```dart
class Keypad extends StatelessWidget {
```

It does not store state itself. Instead, it sends events back to the parent screen through callbacks.

```dart
final ValueChanged<String> onDigit;
final VoidCallback onClear;
```

These are callback functions:

1. `onDigit` runs when a number button is pressed.
2. `onClear` runs when CLEAR is pressed.

```dart
final int columns; // 3 in portrait, 4 in landscape
```

This controls the keypad layout depending on orientation.

```dart
final rows = columns == 4 ? _landscapeRows() : _portraitRows();
```

This chooses which button arrangement to use.

#### Portrait keypad layout

```dart
[_KeyDef('1'), _KeyDef('2'), _KeyDef('3')],
[_KeyDef('4'), _KeyDef('5'), _KeyDef('6')],
[_KeyDef('7'), _KeyDef('8'), _KeyDef('9')],
[_KeyDef('0'), _KeyDef('CLEAR', flex: 2)],
```

The portrait keypad is a 3-column grid. The CLEAR button spans two cells so the row stays balanced.

#### Landscape keypad layout

```dart
[_KeyDef('1'), _KeyDef('2'), _KeyDef('3'), _KeyDef('4')],
[_KeyDef('5'), _KeyDef('6'), _KeyDef('7'), _KeyDef('8')],
[_KeyDef('9'), _KeyDef('0'), _KeyDef('CLEAR', flex: 2)],
```

The landscape keypad is wider, so it uses 4 columns and fewer rows.

```dart
Expanded(flex: keys[i].flex, child: _buildButton(keys[i].label))
```

`Expanded` makes each button fill its available space. The `flex` value allows CLEAR to become wider than the number buttons.

```dart
Material(
	color: isClear ? Colors.teal.shade300 : Colors.grey.shade300,
	borderRadius: BorderRadius.circular(dims.keypadButtonRadius),
	child: InkWell(...),
)
```

This creates a touchable button with:

1. A different color for CLEAR.
2. Rounded corners.
3. Ripple feedback using `InkWell`.

```dart
onTap: () => isClear ? onClear() : onDigit(label),
```

This connects the visual button to the parent logic. Digits go to `onDigit`, and CLEAR goes to `onClear`.

### `lib/dimensions.dart`

This file stores all responsive sizes in one place.

```dart
final bool isTablet;
```

The app checks whether the shortest screen side is at least 600 logical pixels. If yes, it treats the device like a tablet.

```dart
factory AppDimensions.of(BuildContext context) {
	final shortestSide = MediaQuery.of(context).size.shortestSide;
	return AppDimensions._(shortestSide >= 600);
}
```

This is a common responsive design pattern in Flutter.

1. Read the screen size.
2. Check the shortest side.
3. Mark it as tablet-sized if the shortest side is `>= 600`.

```dart
double get appBarFontSize => isTablet ? 26 : 20;
```

The rest of the getters work the same way: tablet screens get larger fonts, padding, and button sizes.

## Why These Design Choices Were Used

### 1. State is stored as text

The entered amount is kept in a `String` so digits can be appended naturally from the keypad.

### 2. Calculation is separate from UI

`ChangeCalculator` contains only the math. This makes the code easier to test and explain in a viva.

### 3. The layout changes with orientation

Portrait and landscape use different arrangements because a single layout would feel cramped on smaller screens.

### 4. Responsive sizes are centralized

`AppDimensions` avoids hardcoding size values in multiple widgets. If the UI needs to be adjusted later, there is only one place to edit.

### 5. The keypad is custom-built

The keypad is made manually using `Row`, `Column`, `Expanded`, `Material`, and `InkWell`. This gives full control over spacing and layout.

## Viva Questions You May Be Asked

1. Why is `VangtiChaiScreen` stateful?
2. Why is the amount stored as a string first?
3. What does the greedy algorithm do in `ChangeCalculator`?
4. Why are note denominations sorted from large to small?
5. Why does the app use different layouts for portrait and landscape?
6. Why is `AppDimensions` useful?
7. Why did you build a custom keypad instead of using a ready-made widget?
8. What is the purpose of `setState()`?
9. Why use `RichText` in the header?
10. What is the role of `SafeArea`?

## Short Viva Answer Summary

If you need a short explanation in the viva, you can say:

"This Flutter app takes a taka amount from a custom keypad, calculates the required change using a greedy denomination algorithm, and displays the result in a responsive table. The UI adapts to portrait, landscape, and tablet sizes using a centralized dimensions class."
