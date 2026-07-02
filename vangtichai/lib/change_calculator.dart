class ChangeCalculator {
  // Denominations in descending order, as required by the assignment.
  static const List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];

  /// Greedy algorithm: for each denomination (largest first), take as many
  /// notes as fit into the remaining amount, then move to the next.
  static Map<int, int> calculateChange(int amount) {
    final Map<int, int> result = {};
    int remaining = amount;
    for (final note in denominations) {
      result[note] = remaining ~/ note;
      remaining = remaining % note;
    }
    return result;
  }
}
