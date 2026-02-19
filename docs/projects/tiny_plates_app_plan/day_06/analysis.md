# Day 06 Analysis: Recipe Feed UI

## Objective
Display the **AI-generated and dynamically adapted** recipes in a clean, minimal feed.

## Architecture & Packages
- **State Management**: `RecipeFeedViewModel` extending `BaseViewModelHydratedCubit` (to cache last seen results).
- **View**: `RecipeFeedView` extending `MasterViewHydratedCubit`.
- **Core Views**: Use `masterfabric_core/views/loading` for fetching state.

### Backend Endpoints (Recipe Feed UI)
- **POST /api/recipes/generate**: (Primary interaction) Fetch a list of generated recipes based on user criteria. (See Day 05 for full details; now returns richer `Recipe` objects).
- **GET /api/recipes/{recipeId}/image**: Fetch a specific recipe's image or primary visual asset.

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
   - Display: Title, `calories` and `macronutrients`, `nutrients` highlight (e.g., "Demir Deposu"), Match score (e.g., "You have 4/5 ingredients" **+ "Perfect for 8-month-old, fills protein gap"**).
   - Style: High contrast, large typography (Black & White).
   - **New**: Indicators for ingredient substitutions or sensory adaptation tips.
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
