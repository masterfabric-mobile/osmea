# Day 08 Analysis: Calorie & Nutrient Tracking Logic (Layer 2 Foundation)

## Objective
Implement the backend (local) logic for tracking daily calorie, macronutrient, and key micronutrient intake to inform the Dynamic Calorie and Macro Calculator (Layer 2). This includes handling **partial intake** of meals for accurate tracking.

## Architecture & Packages
- **Service**: `CalorieTrackerService`.
- **Database**: `sqflite` (via `masterfabric_core` if available, or direct).

### Backend Endpoints (Calorie Tracking Logic)
- **POST /api/child/{childId}/meal-logs/sync**: Synchronize local meal logs with the backend.
- **GET /api/child/{childId}/nutrient-targets/daily**: Fetch daily nutrient targets and current daily intake.
- **GET /api/child/{childId}/meal-logs**: Fetch historical meal logs.

## Tasks
1. **Data Model**:
   - `DailyLog` (date, `totalCalories`, `totalProtein`, `totalCarbs`, `totalFat`, `totalMicronutrients` (Map<String, double>), list of `MealLog`).
   - `MealLog` (recipeId, recipeName, calories, `macronutrients`, `micronutrients`, timestamp, **`portionMultiplier` (double, e.g., 1.0, 0.5, 0.25)**).
2. **Storage**:
   - Setup SQLite table or Hive box for storing logs, now accommodating detailed nutrient data and the portion multiplier.
3. **Logic**:
   - **`addMeal(Recipe recipe, double portionMultiplier)`**: This function implements the **Partial Intake** feature. It adds nutrient data from a consumed `Recipe` to today's total. The `portionMultiplier` (e.g., `1.0` for a full meal, `0.5` for half) is used to scale all nutrient values (calories, macros, micros) before they are added to the daily log.
   - `getDailyLog(DateTime date)`: Returns `DailyLog` for a specific day with full nutrient breakdown.
   - `getDailyTargetsAndIntake()`: Calculates and returns `currentDailyIntake` against `dailyNutrientTargets` (derived from `ChildProfile`).

## UI Components Focus
- N/A (Logic only)

## Checklist
- [ ] Database schema defined for detailed nutrient logging, including `portionMultiplier`.
- [ ] Can add a meal with a portion multiplier, and all nutrients are scaled correctly.
- [ ] Can retrieve daily total calories and comprehensive nutrient intake.
- [ ] Logic to calculate and provide `currentDailyIntake` vs `dailyNutrientTargets` is implemented.
