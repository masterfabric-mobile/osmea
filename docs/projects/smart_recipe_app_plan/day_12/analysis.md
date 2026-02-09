# Day 12 Analysis: Error Handling & Edge Cases

## Objective
Implement robust error handling and empty states using `masterfabric_core` standards.

## Architecture & Packages
- **Core Views**: `masterfabric_core/views/error_handling`, `empty_view`, `store_configuration_error`.

## Tasks
1. **Global Error Boundary**:
   - Wrap main app with error catcher.
   - Show `ErrorView` for unrecoverable crashes.
2. **Empty States**:
   - **No Ingredients**: "Your pantry is empty. Add items to see recipes." (Use `EmptyView`).
   - **No Recipes Found**: "No recipes match your criteria."
3. **Validation**:
   - Prevent negative numbers in age/calories.
   - Prevent saving empty profile.

## UI Components Focus
- `OsmeaDialog` (for alerts)
- `EmptyView` (from Core)

## Checklist
- [ ] Empty states implemented for all lists.
- [ ] Input validation prevents bad data.
- [ ] Core Error views are triggered correctly on simulated failures.
