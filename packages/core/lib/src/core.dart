import 'package:get_it/get_it.dart'; // 📦 Importing the GetIt package for dependency injection

// 🏗️ Core class responsible for initializing core dependencies
class Core {
  // 🚀 Initializes dependencies using GetIt instance
  Future<GetIt> init(GetIt getIt) async {
    // ✅ Return the initialized GetIt instance
    return getIt;
  }
}