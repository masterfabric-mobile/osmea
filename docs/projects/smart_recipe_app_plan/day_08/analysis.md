# Day 08 Analysis: Calorie Tracking Logic

## Objective
Implement the backend (local) logic for tracking daily calorie intake.

## Architecture & Packages
- **Service**: `CalorieTrackerService`.
- **Database**: `sqflite` (via `masterfabric_core` if available, or direct).

## Tasks
1. **Data Model**:
   - `DailyLog` (date, totalCalories, list of `MealLog`).
   - `MealLog` (recipeId, recipeName, calories, timestamp).
2. **Storage**:
   - Setup SQLite table or Hive box for storing logs.
3. **Logic**:
   - `addMeal(Recipe recipe)`: Adds calories to today's total.
   - `getDailyLog(DateTime date)`: Returns log for specific day.
   - `getDailyGoal()`: Calculate based on Child's Age (simple formula).

## UI Components Focus
- N/A (Logic only)

## Checklist
- [ ] Database schema defined.
- [ ] Can add a meal to the log.
- [ ] Can retrieve daily total calories.
- [ ] Basic goal calculation implemented.
