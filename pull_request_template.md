# 📋 PR Description

This PR introduces a comprehensive location picker component with Google Maps integration, providing multiple variants and customization options for selecting locations in Flutter applications. The component uses BLoC/Cubit pattern for state management and offers a flexible, production-ready solution for location selection needs.

### ✨ Features Added

#### 🗺️ Core Functionality
•⁠  ⁠*Google Maps Integration*: Full integration with Google Maps SDK for interactive map selection
•⁠  ⁠*Place Autocomplete*: Real-time location suggestions using Google Places API with debounce optimization
•⁠  ⁠*Geocoding Support*: Bidirectional address-to-coordinates and coordinates-to-address conversion
•⁠  ⁠*Current Location Detection*: Automatic detection and selection of user's current location with permission handling
•⁠  ⁠*Interactive Map Picker*: Tap-to-select location with draggable markers and smooth interactions
•⁠  ⁠*Location Display*: Dedicated view screen for displaying selected locations with detailed information

#### 🎨 Component Variants
•⁠  ⁠*Combined Mode*: Search input with integrated map button for hybrid selection
•⁠  ⁠*Input Only*: Text-based location search with autocomplete suggestions
•⁠  ⁠*Map Only*: Direct map selection interface with tap-and-drag functionality
•⁠  ⁠*Search Only*: Manual text entry without API-powered suggestions

#### ⚙️ Customization Options
•⁠  ⁠*Sizes*: Small, Medium (default), Large - responsive sizing for different use cases
•⁠  ⁠*Styles*: Outlined (default), Filled - visual style variations
•⁠  ⁠*Autofocus*: Automatic current location detection and focus on component mount
•⁠  ⁠*Configurable Controls*: 
  - Show/hide current location button
  - Show/hide map button in search
  - Optional field validation (isRequired)
  - Custom labels and hint text

### 🏗️ Architecture & State Management

#### BLoC/Cubit Pattern Implementation
•⁠  ⁠*LocationPickerCubit*: Centralized state management for location picker
  - ⁠ onSearchChanged ⁠: Debounced search query processing
  - ⁠ _fetchSuggestions ⁠: Location suggestion matching and filtering
  - ⁠ selectLocation/clearLocation ⁠: Location state updates
  - ⁠ getCurrentLocation ⁠: Single-execution device location fetch
  
•⁠  ⁠*LocationPickerState*: Immutable state structure
  - ⁠ selectedLocation ⁠: Currently selected location data
  - ⁠ searchQuery ⁠: Active search input
  - ⁠ suggestions ⁠: Real-time location suggestions
  - ⁠ isMapVisible ⁠: Map visibility control
  - ⁠ showMapButtonInSearch ⁠: Map button display flag
  - Uses ⁠ copyWith ⁠ pattern for immutable updates



#### Dependencies
•⁠  ⁠⁠ google_maps_flutter ⁠ - Map rendering and interaction
•⁠  ⁠⁠ geolocator ⁠ - Current location detection with permission handling
•⁠  ⁠⁠ geocoding ⁠ - Address resolution and reverse geocoding
•⁠  ⁠⁠ http ⁠ - Google Places API communication
•⁠  ⁠⁠ flutter_dotenv ⁠ - Secure API key management
•⁠  ⁠⁠ flutter_bloc ⁠ - State management pattern

#### API Integration
•⁠  ⁠*Google Places Autocomplete API*: Real-time location suggestions
•⁠  ⁠*Google Places Details API*: Detailed location information retrieval
•⁠  ⁠*Google Maps SDK*: Interactive map rendering
•⁠  ⁠*Geocoding API*: Address conversion services
•⁠  ⁠*Region Restriction*: Configured for Turkey (⁠ country:tr ⁠) in demo

### 🔒 Security & Configuration

#### API Key Management
⁠ dart
// .env file (not committed)
API_KEY=your_google_maps_api_key_here
 ⁠

#### iOS Configuration (Info.plist)
⁠ xml
<key>API_KEY</key>
<string>YOUR_API_KEY_HERE</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos and videos.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show your current location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs location access to show your current location.</string>
 ⁠

#### Android Configuration (AndroidManifest.xml)
⁠ xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE" />
</application>
 ⁠

### 🎭 UI/UX Improvements

#### User Experience Features
•⁠  ⁠*Debounced Search*: Optimized API calls with intelligent debouncing
•⁠  ⁠*Loading States*: Clear visual feedback during async operations
•⁠  ⁠*Error Handling*: Graceful fallback with user-friendly messages
•⁠  ⁠*Responsive Design*: Adapts to all screen sizes and orientations
•⁠  ⁠*Interactive Elements*:
  - Draggable map markers with smooth animations
  - Info windows with location details
  - Bottom sheet for detailed location information
  - Visual feedback for all user interactions

#### Performance Optimizations
•⁠  ⁠*Single Autofocus Execution*: ⁠ _autofocusUsed ⁠ and ⁠ _autofocusInitialized ⁠ flags prevent redundant location requests
•⁠  ⁠*Debounce Logic*: Reduces unnecessary API calls during search input
•⁠  ⁠*State Separation*: BLoC pattern separates UI from business logic
•⁠  ⁠*Resource Cleanup*: Proper disposal of controllers and listeners
•⁠  ⁠*Mounted Checks*: Safe state updates preventing memory leaks

### 📱 Component Variants & Examples

#### Example Implementations
The example screen demonstrates:
1.⁠ ⁠*Combined Variant*: Input + Map button with suggestions
2.⁠ ⁠*Input Only*: Pure text-based search with autocomplete
3.⁠ ⁠*Autofocus Current Location*: Automatic location detection on load
4.⁠ ⁠*Map Only*: Direct map selection interface
5.⁠ ⁠*Search Only*: Manual entry without suggestions
6.⁠ ⁠*Size Variations*: Small, Medium, Large comparisons
7.⁠ ⁠*Style Variations*: Outlined vs Filled designs

### 💡 Development Best Practices

#### State Management
•⁠  ⁠Immutable state using ⁠ copyWith ⁠ pattern
•⁠  ⁠Clear separation between UI and business logic
•⁠  ⁠Centralized state in LocationPickerCubit
•⁠  ⁠Type-safe state updates

#### Error Handling
⁠ dart
try {
  final placemarks = await placemarkFromCoordinates(lat, lng);
  // Handle success
} catch (e) {
  // Fallback to coordinates display
  address = 'Lat: $lat, Lng: $lng';
}
 ⁠

#### Preventing Duplicate Actions
•⁠  ⁠⁠ _isPickerOpen ⁠ map prevents multiple picker instances
•⁠  ⁠⁠ _isConfirming ⁠ flag prevents double confirmation clicks
•⁠  ⁠⁠ _isProcessing ⁠ flag indicates ongoing operations

### 📝 Usage Examples

#### Basic Usage
⁠ dart
OsmeaComponents.locationPicker(
  apiKey: 'YOUR_API_KEY',
  onLocationChanged: (location) {
    print('Selected: ${location?.address}');
  },
  variant: LocationPickerVariant.combined,
  showCurrentLocation: true,
)
 ⁠

#### Advanced Configuration
⁠ dart
LocationPickerWithSuggestions(
  apiKey: apiKey,
  onLocationChanged: (location) => setState(() => _location = location),
  onShowMapPressed: () => _showLocationDetails(),
  onCurrentLocationPressed: () => _getCurrentLocation(),
  variant: LocationPickerVariant.combined,
  size: LocationPickerSize.medium,
  style: LocationPickerStyle.outlined,
  autofocusCurrentLocation: true,
  showCurrentLocation: true,
  showMapButtonInSearch: true,
  label: 'Delivery Location',
  hintText: 'Search for address...',
  isRequired: true,
)
```

### 🔧 Setup Instructions

#### 1. Enable Google APIs
Required APIs in Google Cloud Console:
- Maps SDK for Android.
- Maps SDK for iOS.
- Places API.
- Geocoding API.

#### 2. Configure API Key
```bash
# Create .env file
echo "API_KEY=your_api_key_here" > .env

# Add to .gitignore
echo ".env" >> .gitignore

#### 3. Platform Configuration
Follow the iOS and Android configuration steps above.

### 🐛 Bug Fixes & Improvements

#### Fixed Issues
- Prevents duplicate map picker instances.
- Handles missing API keys gracefully with clear error messages.
- Proper cleanup of resources (controllers, listeners).
- Safe state updates with mounted checks.
- Prevents confirmation spam clicks.
- Handles permission denials gracefully.
- Fallback address display when geocoding fails.

#### Performance Improvements
- Optimized search with debouncing.
- Single autofocus execution.
- Efficient state management with BLoC.
- Reduced unnecessary rebuilds.

---

## ✅ Checklist

- [ ] Code follows the project standards and guidelines.
- [ ] Relevant unit tests are written and all tests are passing.
  <!-- Not included in the provided context, would be a good follow-up. -->
- [ ] Test coverage is adequate for the changes.
  <!-- Not included in the provided context, would be a good follow-up. -->
- [ ] Any unnecessary files or debug statements have been removed.
- [ ] Documentation is updated where necessary.
  <!-- Internal code documentation is present. External documentation (README, Storybook) can be updated in a follow-up PR. -->
- [ ] The PR has been reviewed by at least one team member before merging.

---


## 🛠 Steps to Test

1.  Create a `.env` file named `API_KEY` and add your Google Maps/Places API key to it. (e.g., `API_KEY=YOUR_GOOGLE_MAPS_API_KEY`)
2.  Run `flutter pub get` in the root directory of the `osmea` project.
3.  Navigate to the `projects/components_app` directory (`cd projects/components_app`).
4.  Run the application (`flutter run`).
5.  Once the app is open, go to the "Location Picker Example" page.
6.  Test the different "Variant", "Size", and "Style" examples on the page:
    *   **Combined (Input + Map):** Perform a search, select suggestions. Test the "Use current location" and "Show on map" buttons.
    *   **Input Only:** Try selecting a location using only the search field.
    *   **Autofocus Current Location:** Verify that your current location is automatically selected when the app first opens or this component loads (you may need to grant location permissions).
    *   **Map Only:** Open the map picker, select a location on the map, and confirm it.
    *   **Search Only:** Test manually entering a location address using only text input.
    *   **Different Sizes (Small, Medium, Large) and Styles (Outlined, Filled):** Check for visual consistency and functionality.
7.  On the map picker screen (`_GoogleMapPickerScreen`):
    *   Select a location by tapping on the map.
    *   Try changing the location by dragging the selected marker.
    *   Confirm the selection by pressing the check button in the top right.
8.  On the location view screen (`_LocationMapViewScreen`):
    *   Verify that the selected location is displayed correctly on the map.
9.  Verify that an error message is displayed when the API key is missing.

---

## 🔗 Related Links

- Issue: https://github.com/masterfabric-mobile/osmea/issues/180
- Documentation: https://gist.github.com/berkayvuranok/8b06ba117372b0e53a8eba9044f8fd9e

---

### 📷 Screenshots (Optional)
| ![Screenshot 1](https://github.com/user-attachments/assets/732a2469-3da8-4041-ac07-e73cec253945) | ![Screenshot 2](https://github.com/user-attachments/assets/7fc52c1d-4adb-4323-9b80-46444a7aac2b) |
|:--:|:--:|
| Ekran 1 | Ekran 2 |

| ![Screenshot 3](https://github.com/user-attachments/assets/969eb64d-8dc3-4efd-9d05-89cd0eb150ab) | ![Screenshot 4](https://github.com/user-attachments/assets/599e0af0-9efa-48ff-9070-0ebd645c0c11) |
|:--:|:--:|
| Ekran 3 | Ekran 4 |