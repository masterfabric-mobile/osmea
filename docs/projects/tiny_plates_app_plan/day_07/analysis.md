# Day 07 Analysis: Recipe Detail View

## Objective
Create the detailed view for a specific **AI-generated and adapted recipe**, showing dynamically adjusted ingredients, preparation steps, comprehensive nutrient information, and sensory adaptation guidance.

## Architecture & Packages
- **Navigation**: Push route `/recipe/:id`.

### Backend Endpoints (Recipe Detail View)
- **GET /api/recipes/{recipeId}**: Fetch full, AI-enriched `Recipe` object as defined in Day 05, including `adaptedIngredients`, `preparationStepsAdapted`, `sensoryAdaptationTips`, `videoTipLink`, `macronutrients`, `rationale`.
- **POST /api/child/{childId}/meals**: Log the consumption of a recipe/meal with detailed nutrient breakdown.
  - Request Body: `{ "recipeId": "...", "calories": 350, "macronutrients": { "protein": 20.0, "fat": 15.0, "carbs": 30.0 }, "nutrients": { "iron": 4.0, "vitaminD": 100 }, "date": "YYYY-MM-DD" }`
- **POST /api/child/{childId}/favorites/recipes**: Add a recipe to the child's favorites.
  - Request Body: `{ "recipeId": "..." }`
- **DELETE /api/child/{childId}/favorites/recipes/{recipeId}**: Remove a recipe from the child's favorites.
- **GET /api/child/{childId}/pantry**: (Used for comparison) Fetch child's pantry to highlight missing ingredients.
- **GET /api/nutrients/{nutrientId}/details**: Fetch detailed information about a specific nutrient (e.g., RDA, absorption factors).

## Tasks
1. **Screen: Recipe Detail**:
   - **Header**: Title, Calories, `macronutrients`, `nutrients` highlight (e.g., "Demir Deposu"), Age Tag, Dietary Tags.
   - **Ingredients Section**: Display `adaptedIngredients`, clearly highlighting AI substitutions (e.g., "Tereyağı yerine zeytinyağı"). Indicate missing pantry items.
   - **Instructions Section**: Display `preparationStepsAdapted`, written to match `textureToleranceLevel` (e.g., "Daha pütürsüz olması için patatesi haşladıktan sonra 2 kez süzgeçten geçirin.").
   - **Nutrient Information Section**:
     - Display key `macronutrients`, vitamins and minerals and their amounts per serving.
     - Highlight how the recipe specifically addresses `nutrientGaps` identified by Layer 2.
     - Show food sources for these nutrients.
     - Include information on factors increasing/decreasing absorption for critical nutrients.
     - Provide guidance on when supplementation might be considered, with a disclaimer.
   - **New Section: Sensory Adaptation Guidance**: Display `sensoryAdaptationTips` (e.g., "Havuç kokusuna direnç varsa, önce tabağın kenarına bir parça koyup koklamasına izin verin.").
   - **New Section: AI Rationale**: Display `rationale` (AI's explanation for recipe adaptations and why it's suitable for the child).
   - **New Section: Video Tip**: Embed `videoTipLink` if available.
2. **Interactions**:
   - "Cooked This" button (triggers Calorie Log - prep for Day 8).
   - "Add to Favorites" (optional).
3. **Layout**:
   - Use `OsmeaScrollView` (or `SingleChildScrollView`).
   - Use `OsmeaDivider` to separate sections.

## UI Components Focus
- `OsmeaAppbar` (with Back button)
- `OsmeaListTile` (for ingredients and nutrient items)
- `OsmeaButton` (Action: "Log Meal")
- `OsmeaTag` (for labels like "Nut Free", "12m+", "Vegetarian")
- `OsmeaProgressBar` (optional, for visualizing nutrient intake relative to RDA)

## Checklist
- [ ] Navigation passes Recipe ID/Object correctly.
- [ ] Details (Adapted Ingredients, Adapted Steps, Nutrient info, Sensory Tips) are rendered.
- [ ] "Log Meal" button is placed (functionality pending).
- [ ] UI maintains Black & White theme.
