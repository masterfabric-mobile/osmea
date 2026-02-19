# Day 03 Analysis: User Profile (Child Settings) & Personalized Guidance Foundation

## Objective
Create the initial setup screens for the user to input child details (Age, Allergies, Chewing Skills, **Texture Tolerance, Sensory Preferences**). This forms the critical foundation for the **Personalized Filtering (Layer 1)** and **Ergoterapi & Duyusal Adaptasyon (Layer 4)**. A key output of this day is to provide users with **AI-Informed Solids/Texture Guidance** based on the data they provide.

## Architecture & Packages
- **State Management**: `UserProfileViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `UserProfileView` extending `MasterViewHydratedCubit`.
- **Core Views**:
  - Use `masterfabric_core/views/onboarding` as a base or reference.

### Backend Endpoints (User Profile - Child Settings)
- **POST /api/children**: Create a new child profile.
- **PUT /api/child/{childId}**: Update an existing child's profile.
- **GET /api/guidance/texture**: **NEW**. Fetch AI-generated guidance based on child's age and texture level.
  - Request Query Params: `?ageMonths=7&textureLevel=smooth`
  - Response Body: `{ "tip": "Your child is ready to explore slightly thicker purees. Try mashing banana with a fork instead of blending it." }`

## Tasks
1. **Data Model (`ChildProfile`) Expansion**:
   - Create `ChildProfile` model (age, list of allergies, chewing level enum, `specialDietaryNeeds`, `isPremature`, `foodIntolerances`, **`textureToleranceLevel` (enum/numeric), `sensoryPreferences` (list of strings)**).
   - Ensure model has `fromJson` and `toJson` for Hydrated storage.
   - **New**: `dailyCalorieTarget` (int), `dailyProteinTarget` (int).
   - **New**: `FoodRestriction` model: `name`, `type` (`neverGive`, `allergen`), `ageRestriction`, **`isAutoSubstitutable` (boolean)**.
2. **ViewModel Implementation**:
   - Create `UserProfileViewModel` that persists `ChildProfile`.
3. **Screen: Profile Setup UI**:
   - **Step 1: Age**: `OsmeaTextField` or `OsmeaWheelPicker`.
   - **Step 2: Allergies**: `OsmeaCheckbox` list or `OsmeaChips`.
   - **Step 3: Chewing & Texture**: `OsmeaRadioButton` or `OsmeaCard` for `chewingLevel` AND **new `textureToleranceLevel` input**.
   - **Step 4: Special Conditions & Sensory**:
     - `OsmeaCheckbox` for `isPremature`, `specialDietaryNeeds`.
     - `OsmeaTextField` for `foodIntolerances`.
     - **New**: `OsmeaChips` or `OsmeaCheckbox` for `sensoryPreferences`.
4. **Storage**:
   - Handled automatically by `HydratedCubit`.
5. **AI-Informed Guidance UI & Logic (NEW)**:
   - **Objective Fulfillment**: This task directly implements the **"AI-Informed Solids/Texture Guidance"** goal.
   - **UI**: Design and implement a non-intrusive UI component (e.g., an `OsmeaInfoCard` or a dedicated section) within the `UserProfileView` or on a summary screen.
   - **Logic**: After the user saves the profile, trigger a call to the new `/api/guidance/texture` endpoint.
   - **AI Prompt (Backend)**: The backend for this endpoint should use a prompt like: `"A parent has a child who is [X] months old and is currently on [Y] texture level (e.g., 'smooth purees'). Provide a single, encouraging, and practical tip (max 2-3 sentences) for the next step in their texture progression journey. Frame it positively."`
   - **Display**: Display the returned `tip` in the UI component.

## UI Components Focus
- `OsmeaStepper` (to guide through setup)
- `OsmeaTextField`
- `OsmeaChips` (for allergies, dietary needs, sensory preferences)
- `OsmeaRadioButton` (for chewing/texture levels)
- `OsmeaButton` (Next/Save)
- **`OsmeaInfoCard` (for AI Guidance)**

## Checklist
- [ ] `ChildProfile` model created with all required fields including sensory and nutritional targets.
- [ ] `UserProfileView` includes UI for all profile fields.
- [ ] Profile data persists across app restarts.
- [ ] **New**: A UI component displays AI-generated texture guidance after the profile is saved.
- [ ] **New**: Logic to call the `/api/guidance/texture` endpoint is implemented.
- [ ] i18n localization for all new profile fields and guidance text.