# Day 11 Analysis: Navigation & Flow Integration

## Objective
Connect all standalone modules into a cohesive user journey.

## Architecture & Packages
- **Routing**: `go_router` configuration refinement.

### Backend Endpoints
- **None New**: Day 11 focuses on client-side navigation and state synchronization. Existing backend endpoints (e.g., `POST /api/recipes/generate` when pantry changes) are leveraged for data updates, but no new API definitions are required.

## Tasks
1. **Flow Check**:
   - Splash -> Onboarding (if no profile) -> Home.
   - Home -> Recipe Detail -> Log Meal -> Back to Home/Tracker.
   - Navbar switching: Home <-> Pantry <-> Tracker <-> Settings.
   - **New**: Verify that `ChildProfile` (including `textureToleranceLevel`, `sensoryPreferences`, etc.) is fully collected and persisted before allowing access to AI recipe generation features.
   - **New**: Ensure `currentDailyNutrientIntake` and `dailyNutrientTargets` are accurately passed from the Calorie Tracker to the `RecipeGeneratorService` whenever recipes are requested.
2. **Guards**:
   - Redirect to Onboarding if `ChildProfile` is null or incomplete for core functionalities.
3. **State Sync**:
   - Ensure adding an ingredient in Pantry updates the Home Feed suggestions immediately (Bloc listener), **triggering `RecipeGeneratorService` with the most up-to-date ChildProfile, Pantry, and DailyNutrientIntake.**

## UI Components Focus
- `OsmeaNavbar` (Finalize icons and routes)

## Checklist
- [ ] App starts and routes correctly based on user state.
- [ ] Bottom navigation works seamlessly.
- [ ] Data updates propagate across screens (Pantry -> Home).
