# Day 07 Analysis: Recipe Detail View

## Objective
Create the detailed view for a specific recipe, showing ingredients and preparation steps.

## Architecture & Packages
- **Navigation**: Push route `/recipe/:id`.

## Tasks
1. **Screen: Recipe Detail**:
   - **Header**: Title, Calories, Age Tag.
   - **Ingredients Section**: List of required items. Highlight missing items (if any).
   - **Instructions Section**: Step-by-step list.
2. **Interactions**:
   - "Cooked This" button (triggers Calorie Log - prep for Day 8).
   - "Add to Favorites" (optional).
3. **Layout**:
   - Use `OsmeaScrollView` (or `SingleChildScrollView`).
   - Use `OsmeaDivider` to separate sections.

## UI Components Focus
- `OsmeaAppbar` (with Back button)
- `OsmeaListTile` (for ingredients)
- `OsmeaButton` (Action: "Log Meal")
- `OsmeaTag` (for labels like "Nut Free", "12m+")

## Checklist
- [ ] Navigation passes Recipe ID/Object correctly.
- [ ] Details (Ingredients, Steps) are rendered.
- [ ] "Log Meal" button is placed (functionality pending).
- [ ] UI maintains Black & White theme.
