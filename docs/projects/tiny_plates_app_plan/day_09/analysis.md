# Day 09 Analysis: Calorie & Nutrient Tracker UI (Layer 2 Visualization)

## Objective
Visualize the daily **comprehensive nutrient intake (calories, macros, key micros)** against the recommended goals, providing clear insights for the Dynamic Calorie and Macro Calculator (Layer 2).

## Architecture & Packages
- **State Management**: `CalorieTrackerViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `CalorieTrackerView` extending `MasterViewHydratedCubit`.

### Backend Endpoints (Calorie & Nutrient Tracker)
- **GET /api/child/{childId}/nutrient-targets/daily**: Fetch daily nutrient targets and current daily intake.
- **POST /api/child/{childId}/meals**: Log a meal with full nutrient breakdown.

## Tasks
1. **Screen: Tracker Dashboard**:
   - **Progress Indicator**: `OsmeaCircularProgress` or `OsmeaLinearProgress` showing Consumed vs Goal for **Calories, Protein, Carbs, Fat**, and key `Micronutrients`.
   - **History List**: List of meals eaten today, displaying **calories, macros, and key micros** for each meal. **Should also indicate the portion consumed (e.g., "Half Portion") based on the `portionMultiplier` from the `MealLog`**.
   - **Implementation**:
     ```dart
     class CalorieTrackerView extends MasterViewHydratedCubit<CalorieTrackerViewModel, CalorieTrackerState> { ... }
     ```
2. **Integration**:
   - Connect "Log Meal" button from Recipe Detail (Day 7) to this system. The UI for logging should allow specifying the portion (full, half, quarter).
3. **Visuals**:
   - "Calories/Nutrients Remaining" text.
   - Clear, bold numbers and graphical representations for nutrient intake.

## UI Components Focus
- `OsmeaProgressBar` (potentially multiple)
- `OsmeaCard` (for Meal History items, showing detailed nutrient breakdown)
- `OsmeaText` (Big typography for stats)

## Checklist
- [ ] Tracker screen shows correct daily progress for calories, macros, and key micros.
- [ ] History list displays logged meals, including portion size.
- [ ] Progress indicators update visually when a new meal is logged.

# Day 09.5 Analysis: Growth Tracking (Age-Height-Weight)

## Objective
Implement a dedicated module for tracking a child's growth based on WHO standards, including visualization and alert mechanisms. **Growth data also feeds into the comprehensive understanding of a child's health, informing nutrient requirements and potential AI analysis (Layer 2).**

## Architecture & Packages
- **State Management**: `GrowthTrackerViewModel` extending `BaseViewModelHydratedCubit`.
- **View**: `GrowthTrackerView` extending `MasterViewHydratedCubit`.
- **Data Models**: New model for `GrowthEntry`.
- **Charting Library**: Potentially a simple plotting library if `osmea_components` doesn't provide one (e.g., `fl_chart` or custom drawing).

### Backend Endpoints (Growth Tracking)
- **POST /api/child/{childId}/growth-entries**: Add a new growth entry for the child.
  - Request Body: `{ "date": "YYYY-MM-DD", "weight": 10.5, "height": 75.2, "headCircumference": 45.1 }`
- **GET /api/child/{childId}/growth-entries**: Fetch all growth entries for the child.
- **GET /api/who-growth-data**: Fetch WHO growth chart data for percentile curves.
  - Query Params: `age={age}&gender={gender}&metric={metric}`
- **POST /api/child/{childId}/growth-analysis**: Analyze recent growth entries and nutrient intake (from Day 08) using AI (Layer 2) to provide deeper insights or generate proactive alerts regarding growth and development.
  - Request Body: `{ "growthEntries": [ ... ], "nutrientIntakeHistory": [ ... ] }`
  - Response Body: `{ "alerts": [ ... ], "insights": [ ... ] }`
- **GET /api/child/{childId}/growth-alerts**: Fetch any triggered growth alerts.

## Tasks
1. **Data Models**:
   - `GrowthEntry` model: `date` (DateTime), `weight` (double, kg), `height` (double, cm), `headCircumference` (double, cm, optional).
   - Store a list of `GrowthEntry` for the `ChildProfile` (Day 03).
2. **Growth Data Input UI**:
   - Screen to manually add new `GrowthEntry` records.
   - `OsmeaTextField` for weight, height, head circumference.
   - `OsmeaDatePicker` for the entry date.
3. **Growth Chart Visualization**:
   - Display growth data over time.
   - **Percentile Curves**: Overlay WHO growth curves (mock or simplified percentile calculations initially).
   - Separate charts for Weight-for-age, Height-for-age, Head circumference-for-age.
4. **BMI Calculation**:
   - Automatically calculate BMI from height and weight for appropriate ages.
   - Display BMI percentile.
5. **Alert Mechanisms**:
   - Define "alarm situations" (e.g., sudden drop in percentile, failure to thrive). **These can now be informed by AI analysis from `growth-analysis` endpoint.**
   - Display `OsmeaDialog` or `OsmeaSnackbar` alerts with "when to see a doctor?" guidance.
   - Link to `ChildProfile` age for WHO-specific charts.

## UI Components Focus
- `OsmeaCard` (for displaying current growth stats)
- `OsmeaListTile` (for growth history)
- `OsmeaChart` (if available in `osmea_components`) or integrate a third-party library for plotting.
- `OsmeaButton` (to add new entry)

## Checklist
- [ ] `GrowthEntry` data model is defined and persisted.
- [ ] UI for adding new growth records is implemented.
- [ ] Basic visualization of growth data (e.g., a line graph).
- [ ] BMI calculation is integrated.
- [ ] "Alarm situations" are defined and triggered with appropriate guidance.