// services/utils.dart
import 'dart:math';

double generateMockPrice() {
  final random = Random();
  return (random.nextInt(20) + 5) + random.nextDouble(); // Prices between $5.00 and $24.99
}