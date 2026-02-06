# Day 03 Analysis: User Profile (Child Settings)

## Objective
Create the initial setup screens for the user to input child details (Age, Allergies, Chewing Skills).

## Architecture & Packages
- **State Management**: `UserProfileViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `UserProfileView` extending `MasterViewHydratedCubit`.
- **Core Views**:
  - Use `masterfabric_core/views/onboarding` as a base or reference.

## Tasks
1. **Data Model**:
   - Create `ChildProfile` model (age, list of allergies, chewing level enum).
   - Ensure model has `fromJson` and `toJson` for Hydrated storage.
2. **ViewModel Implementation**:
   - Create `UserProfileViewModel` that persists `ChildProfile`.
   - Default state should load from storage automatically.
3. **Screen: Profile Setup**:
   - **Step 1: Age**: `OsmeaTextField` or `OsmeaWheelPicker`.
   - **Step 2: Allergies**: `OsmeaCheckbox` list or `OsmeaChips`.
   - **Step 3: Chewing**: `OsmeaRadioButton` or `OsmeaCard`.
   - **View Implementation**:
     ```dart
     class UserProfileView extends MasterViewHydratedCubit<UserProfileViewModel, UserProfileState> {
        // ...
     }
     ```
4. **Storage**:
   - Handled automatically by `HydratedCubit`. No manual SharedPreferences needed.

## UI Components Focus
- `OsmeaStepper` (to guide through setup)
- `OsmeaTextField`
- `OsmeaChips` (for allergies)
- `OsmeaRadioButton`
- `OsmeaButton` (Next/Save)

## Checklist
- [ ] `ChildProfile` model created with JSON serialization.
- [ ] `UserProfileView` inherits from `MasterViewHydratedCubit`.
- [ ] Profile data persists across app restarts (tested via Hydrated storage).
- [ ] UI reflects `AppConfig` theme.
