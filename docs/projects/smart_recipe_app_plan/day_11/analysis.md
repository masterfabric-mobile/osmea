# Day 11 Analysis: Navigation & Flow Integration

## Objective
Connect all standalone modules into a cohesive user journey.

## Architecture & Packages
- **Routing**: `go_router` configuration refinement.

## Tasks
1. **Flow Check**:
   - Splash -> Onboarding (if no profile) -> Home.
   - Home -> Recipe Detail -> Log Meal -> Back to Home/Tracker.
   - Navbar switching: Home <-> Pantry <-> Tracker <-> Settings.
2. **Guards**:
   - Redirect to Onboarding if `ChildProfile` is null.
3. **State Sync**:
   - Ensure adding an ingredient in Pantry updates the Home Feed suggestions immediately (Bloc listener).

## UI Components Focus
- `OsmeaNavbar` (Finalize icons and routes)

## Checklist
- [ ] App starts and routes correctly based on user state.
- [ ] Bottom navigation works seamlessly.
- [ ] Data updates propagate across screens (Pantry -> Home).
