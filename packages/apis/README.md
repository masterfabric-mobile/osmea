# osmea

A Dart/Flutter package for robust API integration and network management, designed for modularity and scalability.

## Features

- **Dio-based HTTP client** with interceptors and logging
- **Dependency Injection** for easy testing and modularity
- **Network layer abstraction** for clean API calls
- **Easy configuration** for different environments

## Project Structure

- **lib/**
  - `apis.dart`: API entry point, exports all public APIs.
  - `di/`: Dependency injection setup.
    - `config/`: DI configuration files.
  - `dio_config/`: Dio HTTP client setup, logging, and interceptors.
    - `api_dio_client.dart`: Main Dio client configuration.
    - `dio_logger.dart`: Logging for HTTP requests/responses.
    - `interceptors/`: Custom Dio interceptors.
  - `network/`: Network layer.
    - `common/`: Shared network utilities.
    - `remote/`: Remote data sources and API implementations.
- **test/**: Unit and integration tests.

## Getting Started

1. **Install dependencies:**
   ```sh
   flutter pub get
   ```

2. **Configure Dependency Injection:**
   In your main entry point, initialize DI:
   ```dart
   import 'package:osmea/di/config/config_di.config.dart';

   void main() async {
     await configureDependencies();
     runApp(MyApp());
   }
   ```

3. **Making an API Call Example:**
   ```dart
   import 'package:osmea/apis.dart';

   final api = getIt<MyApiService>();

   Future<void> fetchData() async {
     final response = await api.getData();
     debugprint(response);
   }
   ```

4. **Run tests:**
   ```sh
   flutter test
   ```

5. **Build and run the app:**
   ```sh
   flutter run
   ```

## Configuration

- **Dependency Injection:**  
  Configured in [`lib/di/config/config_di.config.dart`](lib/di/config/config_di.config.dart) using injectable and get_it.
- **API Client:**  
  Setup in [`lib/dio_config/api_dio_client.dart`](lib/dio_config/api_dio_client.dart) with interceptors and logging.

## Customization

- **Add new APIs:**  
  Create a new service in `lib/network/remote/` and register it in the DI config.
- **Add interceptors:**  
  Place custom interceptors in `lib/dio_config/interceptors/` and add them to the Dio client.

## Contributing

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for guidelines.  
Pull requests are welcome!

## License

See [LICENSE](LICENSE) for details.