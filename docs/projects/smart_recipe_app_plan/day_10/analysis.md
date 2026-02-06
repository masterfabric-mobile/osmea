# Day 10 Analysis: Search & Filter Functionality

## Objective
Allow users to manually search for specific recipes or filter the generated list.

## Architecture & Packages
- **Core View**: `masterfabric_core/views/search`.

## Tasks
1. **Screen: Search**:
   - Reuse `Search` view from core or build custom using `OsmeaAppbarSearchBar`.
2. **Filter Modal**:
   - `OsmeaBottomSheet` containing filter options (e.g., "Under 30 mins", "No-Cook").
3. **Logic**:
   - Update `RecipeGeneratorService` to accept a query string.
   - Implement client-side filtering on the result list.

## UI Components Focus
- `OsmeaSearchbar`
- `OsmeaBottomSheet`
- `OsmeaCheckbox` (for filters)

## Checklist
- [ ] Search input filters the recipe list in real-time or on submit.
- [ ] Filter modal opens and captures preferences.
- [ ] Applied filters update the feed correctly.
