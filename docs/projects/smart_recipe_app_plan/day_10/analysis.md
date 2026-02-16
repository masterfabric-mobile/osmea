# Day 10 Analysis: Search & Filter Functionality

## Objective
Allow users to manually search for specific recipes using **natural language queries** or filter the generated list with **LLM-interpretable criteria**.

## Architecture & Packages
- **Core View**: `masterfabric_core/views/search`.

### Backend Endpoints (Search & Filter Functionality)
- **POST /api/recipes/generate**: (Extension of Day 05) Primary endpoint for recipe generation, now including `searchTerm` (natural language query), `maxPreparationTimeMinutes`, `cookingMethod`, `texturePreferences`, `sensoryAversions` etc. in the `filters` object. **The LLM will interpret these.**
- **GET /api/recipe-filters/options**: Fetch dynamic filter options (e.g., available cooking methods, meal types, preparation time ranges, **LLM-interpretable sensory/texture preferences**).

## Tasks
1. **Screen: Search**:
   - Reuse `Search` view from core or build custom using `OsmeaAppbarSearchBar`.
   - **New**: The search input (`OsmeaSearchbar`) should be designed to accept and forward natural language queries directly to the `RecipeGeneratorService` as `specificRequest`.
2. **Filter Modal**:
   - `OsmeaBottomSheet` containing filter options (e.g., "Under 30 mins", "No-Cook", **"Smooth Texture", "No Strong Smells"**).
   - **New**: Filter options should leverage the `GET /api/recipe-filters/options` endpoint to fetch dynamically interpreted LLM-friendly criteria.
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
