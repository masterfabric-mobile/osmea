// Entry point is flavor-specific. Use:
//   flutter run --flavor dev -t lib/flavors/main_dev.dart
//   flutter run --flavor prod -t lib/flavors/main_prod.dart
import 'package:done_together/flavors/main_dev.dart' as dev;

void main() => dev.main();
