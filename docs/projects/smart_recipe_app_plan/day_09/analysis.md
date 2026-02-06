# Day 09 Analysis: Calorie Tracker UI

## Objective
Visualize the daily calorie intake against the recommended goal.

## Architecture & Packages
- **State Management**: `CalorieTrackerViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `CalorieTrackerView` extending `MasterViewHydratedCubit`.

## Tasks
1. **Screen: Tracker Dashboard**:
   - **Progress Indicator**: `OsmeaCircularProgress` or `OsmeaLinearProgress` showing Consumed vs Goal.
   - **History List**: List of meals eaten today.
   - **Implementation**:
     ```dart
     class CalorieTrackerView extends MasterViewHydratedCubit<CalorieTrackerViewModel, CalorieTrackerState> { ... }
     ```
2. **Integration**:
   - Connect "Log Meal" button from Recipe Detail (Day 7) to this system.
3. **Visuals**:
   - "Calories Remaining" text.
   - Simple, bold numbers.

## UI Components Focus
- `OsmeaProgressBar`
- `OsmeaCard` (for Meal History items)
- `OsmeaText` (Big typography for stats)

## Checklist
- [ ] Tracker screen shows correct daily progress.
- [ ] `CalorieTrackerView` inherits from `MasterViewHydratedCubit`.
- [ ] History list displays logged meals.
- [ ] Progress bar updates visually when a new meal is logged.
