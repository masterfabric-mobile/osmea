# Day 04 Analysis: Ingredient Management

## Objective
Build the interface for users to input the ingredients they currently have at home. **This data will directly inform the AI/LLM-powered recipe generation for ingredient matching (Layer 3).**

## Architecture & Packages
- **State Management**: `PantryViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `PantryView` extending `MasterViewHydratedCubit`.

### Backend Endpoints (Ingredient Management)
- **GET /api/ingredients**: Search and list available ingredients.
  - Query Params: `query={search_term}`
- **GET /api/child/{childId}/pantry**: Fetch the current pantry contents for a child. **The list of ingredients from this endpoint is crucial input for the AI recipe generator.**
- **POST /api/child/{childId}/pantry**: Add an ingredient to the child's pantry.
  - Request Body: `{ "ingredientId": "uuid_of_ingredient", "quantity": "amount_or_unit" }`
- **DELETE /api/child/{childId}/pantry/{pantryItemId}**: Remove an ingredient from the child's pantry.

## Tasks
1. **Data Model**:
   - `Ingredient` model (name, category, id).
2. **Screen: Pantry Manager**:
   - **Search/Add**: `OsmeaSearchbar` to find ingredients (mock list initially). **The search results should be rich enough for AI interpretation.**
   - **List**: `OsmeaListView` showing added ingredients.
   - **Remove**: Swipe to delete or 'X' button on `OsmeaListTile`.
   - **Implementation**:
     ```dart
     class PantryView extends MasterViewHydratedCubit<PantryViewModel, PantryState> { ... }
     ```
3. **Mock Data**:
   - Create a predefined list of common ingredients (Vegetables, Fruits, Grains, Proteins).

## UI Components Focus
- `OsmeaSearchbar`
- `OsmeaListTile` (with trailing action)
- `OsmeaFloatingActionButton` (optional, for manual add)
- `OsmeaEmptyState` (when pantry is empty)

## Checklist
- [ ] Users can search/select ingredients from a mock list.
- [ ] `PantryView` uses `MasterViewHydratedCubit`.
- [ ] Selected ingredients persist across restarts.
- [ ] List persists in local state.

# Day 04.5 Analysis: Allergy Management & Introduction Tracker

## Objective
Implement a robust system for tracking food introductions, monitoring reactions, and providing critical allergy management guidance. **This data forms a core part of the Personalized Filtering Layer (Layer 1) for the AI recipe generator.**

## Architecture & Packages
- **State Management**: `AllergyTrackerViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `AllergyTrackerView` extending `MasterViewHydratedCubit`.
- **Data Models**: New models for `FoodIntroduction` and `ReactionEntry`.
- **Integration**: Link to `ChildProfile` (Day 03) and `RecipeGeneratorService` (Day 05).

### Backend Endpoints (Allergy Management & Introduction Tracker)
- **GET /api/allergens**: Fetch a list of predefined allergens (e.g., "The Big 9").
- **PUT /api/child/{childId}/allergies/history**: Update child's family allergy history and risk classification.
  - Request Body: `{ "familyHistory": "...", "riskClassification": "..." }`
- **POST /api/child/{childId}/food-introductions**: Log a new food introduction for the child.
  - Request Body: `{ "foodName": "...", "dateIntroduced": "YYYY-MM-DD", "reactionObserved": false }`
- **GET /api/child/{childId}/food-introductions**: Fetch all food introductions for the child.
- **PUT /api/child/{childId}/food-introductions/{introductionId}/reaction**: Record or update a reaction for a specific food introduction.
  - Request Body: `{ "severity": "Mild", "symptoms": "...", "actionTaken": "..." }`
- **GET /api/guidance/emergency-protocols**: Fetch static guidance on emergency protocols (e.g., "When to call 112?").

## Tasks
1. **Data Models**:
   - `Allergen` model: `name`, `type` (`Big9`, `Other`), `prevalence`.
   - `FoodIntroduction` model: `foodName`, `dateIntroduced`, `reactionObserved` (boolean), `reactionDetails` (list of `ReactionEntry`).
   - `ReactionEntry` model: `date`, `severity` (enum: `Mild`, `Moderate`, `Severe`, `Anaphylaxis`), `symptoms`, `actionTaken`.
   - Update `ChildProfile` (Day 03) to include `familyAllergyHistory` and `riskClassification`.
2. **Allergy Introduction Tracker UI**:
   - Dedicated screen to log food introductions.
   - **"3-Day Rule" Protocol**: Step-by-step guidance for introducing new foods.
   - **Log Introduction**: `OsmeaTextField` for food name, `OsmeaDatePicker` for date.
   - **Record Reaction**: `OsmeaCheckbox` for "Reaction Observed?", if yes, trigger `ReactionEntry` form.
3. **Reaction Management & Guidance UI**:
   - **Reaction Levels Display**: Clear explanation of Mild, Moderate, Severe, Anaphylaxis symptoms.
   - **"The Big 9" Allergens**: List with prevalence rates and common examples.
   - **Family History Risk Assessment**: Input for family history, leading to a risk classification.
   - **Emergency Protocols**:
     - "When to call 112?" section with clear emergency criteria.
     - `OsmeaDialog` or dedicated emergency screen.
4. **Recipe Engine Integration (Day 05 Update)**:
   - `RecipeGeneratorService` (Day 05) must filter out any foods the child has had a severe reaction to. **It will also use the allergy data to perform automatic ingredient substitutions as defined by the AI/LLM (Layer 1).**
   - For newly introduced foods with mild/moderate reactions, consider providing a warning or a re-introduction option.

## UI Components Focus
- `OsmeaListTile` (for introduced foods)
- `OsmeaButton` (to log new introductions)
- `OsmeaDialog` (for emergency info)
- `OsmeaCard` (for allergen info and guidance)
- `OsmeaProgressBar` or `OsmeaChip` (to show progress through 3-day rule)

## Checklist
- [ ] Data models for `FoodIntroduction` and `ReactionEntry` are defined.
- [ ] UI for logging food introductions and tracking the "3-Day Rule" is implemented.
- [ ] UI provides clear guidance on reaction levels and "The Big 9" allergens.
- [ ] Emergency contact information and criteria for calling 112 are prominently displayed.
- [ ] `ChildProfile` updated for family allergy history and risk.