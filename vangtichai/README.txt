VangtiChai - CSE 489 Assignment 1
==================================

Language: Flutter/Dart
Min SDK: API 21 (Android 5.0 Lollipop)

HOW TO RUN
----------
1. Make sure Flutter SDK is installed (flutter.dev).
2. Unzip this folder.
3. From a terminal, inside the project folder, run:
      flutter pub get
      flutter run
4. Or open the folder directly in Android Studio (File > Open) and run
   from there once it finishes indexing / syncing.

PROJECT STRUCTURE
------------------
lib/
  main.dart                - App entry point
  vangtichai_screen.dart   - Main screen, layout switching (portrait/landscape)
  keypad.dart              - Custom-built numeric keypad (no built-in widget used)
  change_table.dart        - Displays note:count breakdown
  change_calculator.dart   - Greedy change-making algorithm
  dimensions.dart          - Central responsive sizing (phone vs tablet)

APPROACH
--------
- Custom keypad built from scratch using Row/Expanded/InkWell/Material
  (no built-in number-pad widget used).
- Change breakdown computed with a greedy algorithm over
  [500, 100, 50, 20, 10, 5, 2, 1].
- Digits are entered "from the right": typing 2, then 3, then 4 shows
  2 -> 23 -> 234, exactly as specified.
- No hardcoded dimensions anywhere: all sizes come from lib/dimensions.dart,
  which behaves like values/sizes.xml + values-sw600dp/sizes.xml on native
  Android, switching automatically based on
  MediaQuery.of(context).size.shortestSide >= 600 (tablet breakpoint).
- Four effective layouts are produced from one codebase by combining:
    isTablet (phone vs tablet)  x  Orientation (portrait vs landscape)
  In landscape, the change table splits into two columns
  (500,100,50,20 | 10,5,2,1) and the keypad switches to a 4-column layout,
  matching the assignment's reference screenshots.

STATE ACROSS ROTATION
----------------------
Unlike a native Android Activity (which is destroyed and recreated on
rotation, requiring onSaveInstanceState/onRestoreInstanceState), Flutter
does NOT destroy the widget's State object on an orientation change.
_VangtiChaiScreenState survives rotation automatically, so the entered
amount is preserved with no extra code needed.

TESTED DEVICES
---------------
- Pixel XL (411 x 731 dp)  - portrait & landscape   [phone layout]
- Nexus 10 (800 x 1280 dp) - portrait & landscape   [tablet layout]
(Add/replace with whichever emulators or physical devices you personally
tested before submitting.)
