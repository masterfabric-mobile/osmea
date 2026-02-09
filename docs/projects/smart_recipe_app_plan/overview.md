# Smart Child Recipe & Calorie Tracker - Project Analysis

## Project Overview
This project aims to build a mobile application that generates recipes for children based on available home ingredients, age, allergies, and chewing skills. It also includes a daily calorie tracking feature.

## Technical Stack
- **Architecture**: `masterfabric_core: ^0.0.13` (Leveraging `packages/core` structure).
- **UI Components**: `packages/components` (OSMEA Components).
- **Language**: Dart (Flutter).
- **Localization**: `slang` (Multiple languages).
- **Configuration**: `AppConfig` (Dynamic styling & theming, similar to Storefront Woo).
- **Data Source**: Mock Data (Phase 1).
- **Theme**: Minimalist Black & White (Driven by `AppConfig`).

## Timeline
**Duration**: 2 Weeks (14 Days)

## Daily Breakdown
- **Day 01**: Project Setup, Architecture, `AppConfig` & `Slang` Init
- **Day 02**: UI/UX Theming via `AppConfig` & Base Layouts
- **Day 03**: User Profile Module (Child Details)
- **Day 04**: Ingredient Management Module
- **Day 05**: Recipe Engine Logic (Mock)
- **Day 06**: Recipe Feed UI
- **Day 07**: Recipe Detail View
- **Day 08**: Calorie Tracking Logic
- **Day 09**: Calorie Tracker UI
- **Day 10**: Search & Filter Functionality
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
