# Day 06 Analysis: Recipe Feed UI

## Objective
Display the generated recipes in a clean, minimal feed.

## Architecture & Packages
- **State Management**: `RecipeFeedViewModel` extending `BaseViewModelHydratedCubit` (to cache last seen results).
- **View**: `RecipeFeedView` extending `MasterViewHydratedCubit`.
- **Core Views**: Use `masterfabric_core/views/loading` for fetching state.

## Tasks
1. **Screen: Home/Feed**:
   - Call `RecipeGeneratorService` on load.
   - Show `OsmeaLoading` while fetching.
   - Render list of recipes.
   - **Implementation**:
     ```dart
     class RecipeFeedView extends MasterViewHydratedCubit<RecipeFeedViewModel, RecipeFeedState> { ... }
     ```
2. **Card Design**:
   - Use `OsmeaCard`.
   - Display: Title, Calorie count, Match score (e.g., "You have 4/5 ingredients").
   - Style: High contrast, large typography (Black & White).
3. **Empty State**:
   - Use `masterfabric_core/views/empty_view` if no recipes match.

## UI Components Focus
- `OsmeaCard`
- `OsmeaImage` (Placeholder B&W icons for food categories)
- `OsmeaText` (Styles: H2 for titles, Body for details)
- `OsmeaLoading`

## Checklist
- [ ] Feed loads recipes from the service.
- [ ] `RecipeFeedView` inherits from `MasterViewHydratedCubit`.
- [ ] Last loaded recipes are cached (offline support).
- [ ] Empty state handles "no matches" scenario.
