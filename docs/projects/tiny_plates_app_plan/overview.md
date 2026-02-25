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
**Duration**: 16 Days

## Daily Breakdown
- **Day 01**: Project Setup, Architecture, `AppConfig` & `Slang` Init (**Including AI/LLM API Endpoint Placeholders**)
- **Day 02**: UI/UX Theming via `AppConfig` & Base Layouts (**`AppConfig` Expanded for Sensory UI**)
- **Day 03**: User Profile Module (Child Details: Age, Allergies, Chewing Skills, **Texture Tolerance, Sensory Preferences, Nutrient Targets**) & **AI-Informed Solids/Texture Guidance**
- **Day 04**: Ingredient Management & Allergy Management Module (**Data Feeds AI for Personalized Filtering & Matching**)
- **Day 05**: **AI-Powered Recipe Engine Logic** (**AI to operate in two modes: 1. Generate recipe from user's ingredients. 2. Proactively recommend a recipe with ideal ingredients based on nutritional gaps.** LLM integration for balancing, substitutions, etc.)
- **Day 06**: Recipe Feed UI (**Displays Rich AI-Adapted Recipes**)
- **Day 07**: Recipe Detail View (**Comprehensive AI-Adapted Recipe Display**: Dynamic Instructions, Sensory Tips, AI Rationale, Detailed Nutrients)
- **Day 08**: **Calorie & Nutrient Tracking Logic** (Comprehensive Tracking of Calories, Macros, Key Micros for Layer 2)
- **Day 09**: Calorie & Nutrient Tracker UI & Growth Tracking (**Visualizes Comprehensive Nutrient Intake; Growth Data Informs AI Analysis**)
- **Day 10**: Search & Filter Functionality (**Natural Language Queries & LLM-Interpretable Filters**)
- **Day 11**: Navigation & Flow Integration (**Ensures Complete Data Flow for AI-Powered Features**)
- **Day 12**: Error Handling & Edge Cases (**Specific Considerations for AI/LLM Interaction Failures & Output Validation**)
- **Day 13**: Quality Assurance & Refinement (**Includes AI Content QA for Safety, Accuracy, and Appropriateness**)
- **Day 14**: Final Review & Delivery (**Focus on Responsible AI Deployment & Ongoing Monitoring**)

## Core Directives

1.  **Use `masterfabric_core`**: Prioritize using existing views (`Splash`, `Onboarding`, `Auth`, `EmptyView`) and utilities.

2.  **Use `osmea_components`**: All UI elements must come from the components package.

3.  **AppConfig Driven**: Colors, styles, and static assets must be loaded from an `AppConfig` JSON, not hardcoded.

4.  **Multilingual**: All text must be localized using `slang`.

5.  **No Dynamic Pages**: Page layouts are static; only their content/style is configurable.

6.  **Strict Architecture**: All Views MUST extend `MasterViewHydratedCubit`. All ViewModels MUST extend `BaseViewModelHydratedCubit`. This ensures consistent state persistence and lifecycle management across the entire app.

## User Experience (UX) Strategy and Main Flows (Rev. 2)
The main goal of the application is to be both a practical "savior" and a proactive "digital dietitian" for parents. These two roles combine in a hybrid model.

### Main Scenario 1: "What's in My Cupboard?" (Savior Assistant)
- **Problem:** The parent doesn't know what to make with the available ingredients at home in a limited time.
- **Solution:** The user selects the ingredients they have. The AI generates a recipe suitable for these ingredients, the child's profile (age, allergies, etc.), and safety rules (`Safety Guardrail`).
- **Application Role:** An assistant that practically solves immediate needs. This will be the most frequently used feature.

### Main Scenario 2: "What Should They Eat Today?" (Digital Dietitian)
- **Problem:** Ensuring the child's daily nutritional needs (calories, protein, vitamins, etc.) are met in a balanced way.
- **Solution:** Based on the data entered during the day, the system identifies the child's nutritional deficiencies (e.g., "Didn't get any protein today and is deficient in Vitamin C"). It then proactively suggests a recipe with ideal ingredients to address these deficiencies.
- **Application Role:** An expert guiding the parent and supporting the child's development. This is the "smart" and prestigious aspect of the application.

### Hybrid Model Flow
1.  **Suggestion Screen (Default):** When the application opens, the user is greeted by the proactive suggestion screen (`Scenario 2`).
2.  **Ingredient Check:** If the user does not have enough ingredients to make the suggested recipe, they can switch to the ingredient selection screen (`Scenario 1`) with a single tap.
3.  **Smart Matching:** As the user selects ingredients, the system provides instant feedback on the nutritional values of the selected ingredients (e.g., "This ingredient meets 50% of the daily iron requirement.").

## Development Notes and Improvement Areas (Rev. 1)

The following items will be added to the current plan to increase the security and functionality of the project.

### 1. "3-Day Rule" Monitoring Logic
- **Requirement:** A "new food introduction protocol" must be applied for babies in the complementary feeding period (6+ months).
- **Detail:** When the user marks a food as "new", the system should put this food into "tracking mode" for 3 days.
- **Constraint:** During this 3-day tracking period, the system should not suggest another **new** food-containing recipe. This feature helps to clearly identify the source of potential allergic reactions.
- **Integration:** This logic should be integrated into the `Ingredient Management` and `AI-Powered Recipe Engine` modules.

### 2. AI "Safety Guardrail" (Security Layer)
- **Requirement:** It must be ensured that AI-generated recipes do not pose a risk to infant health. AI hallucinations can carry vital risks (e.g., suggesting honey to a baby younger than 1 year old).
- **Detail:** When a recipe response is received from the AI, it must be checked by a **Hard-coded Validation Layer** immediately before being shown to the user.
- **Constraint:** This layer should contain a list of foods absolutely forbidden according to the child's age (e.g., honey, salt, sugar, processed foods, choking hazard nuts, etc.). If a forbidden content is detected, the recipe should not be shown to the user, and an alternative recipe should be presented.
- **Integration:** This control should be added to the flow between the `AI-Powered Recipe Engine Logic` and `Recipe Feed UI`.

### 3. Data Synchronization and "Partial Intake"
- **Requirement:** For the accuracy of calorie and nutrient tracking, information about how much of a meal the child consumed should be recordable.
- **Detail:** The user should be able to mark options like "all," "half," or "quarter" of a prepared recipe was eaten.
- **Constraint:** The system should automatically calculate and log calorie and macro/micro nutrient values based on this entered ratio.
- **Integration:** This feature should be added to the `Calorie & Nutrient Tracking Logic` and `Calorie & Nutrient Tracker UI` modules.