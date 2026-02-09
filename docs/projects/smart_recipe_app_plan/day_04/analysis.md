# Day 04 Analysis: Ingredient Management

## Objective
Build the interface for users to input the ingredients they currently have at home.

## Architecture & Packages
- **State Management**: `PantryViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `PantryView` extending `MasterViewHydratedCubit`.

## Tasks
1. **Data Model**:
   - `Ingredient` model (name, category, id).
2. **Screen: Pantry Manager**:
   - **Search/Add**: `OsmeaSearchbar` to find ingredients (mock list initially).
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
