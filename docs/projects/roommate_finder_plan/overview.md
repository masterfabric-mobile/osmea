# Roommate Finder App - Project Analysis

## Project Overview
This project aims to build a mobile application that helps individuals find compatible roommates and rental listings. It focuses on compatibility based on lifestyle preferences, budget, location, and personality traits. The app includes a matching algorithm, listing management, and integrated chat functionality.

## Technical Stack
- **Architecture**: `masterfabric_core: ^0.0.13` (Leveraging `packages/core` structure).
- **UI Components**: `packages/components` (OSMEA Components).
- **Language**: Dart (Flutter).
- **Localization**: `slang` (Multiple languages).
- **Configuration**: `AppConfig` (Dynamic styling & theming, similar to Storefront Woo).
- **Data Source**: Mock Data (Phase 1).
- **API Endpoints**: Detailed in [api_endpoints.md](./api_endpoints.md).
- **Theme**: Clean & Modern (Driven by `AppConfig`).

## Timeline
**Duration**: 2 Weeks (14 Days)

## Daily Breakdown
- **Day 01**: Project Setup, Architecture, `AppConfig` & `Slang` Init
- **Day 02**: UI/UX Theming via `AppConfig` & Base Layouts
- **Day 03**: User Profile Module (Bio, Preferences, Lifestyle)
- **Day 04**: Listing Management Module (Room Details, Photos)
- **Day 05**: Matching Engine Logic (Mock)
- **Day 06**: Home Feed UI (Potential Roommates/Listings)
- **Day 07**: Detail View (Full Profile & Room Details)
- **Day 08**: Messaging & Chat Logic
- **Day 09**: Chat UI
- **Day 10**: Search & Filter Functionality (Location, Budget, Amenities)
- **Day 11**: Navigation & Flow Integration
- **Day 12**: Error Handling & Edge Cases
- **Day 13**: Quality Assurance & Refinement
- **Day 14**: Final Review & Delivery

## Core Directives

1.  **Use `masterfabric_core`**: Prioritize using existing views (`Splash`, `Onboarding`, `Auth`, `EmptyView`) and utilities.

2.  **Use `osmea_components`**: All UI elements must come from the components package.

3.  **AppConfig Driven**: Colors, styles, and static assets must be loaded from an `AppConfig` JSON, not hardcoded.

4.  **Multilingual**: All text must be localized using `slang`.

5.  **No Dynamic Pages**: Page layouts are static; only their content/style is configurable.

6.  **Strict Architecture**: All Views MUST extend `MasterViewHydratedCubit`. All ViewModels MUST extend `BaseViewModelHydratedCubit`. This ensures consistent state persistence and lifecycle management across the entire app.
