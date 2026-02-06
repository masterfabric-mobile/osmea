# Day 05 Analysis: Recipe Engine Logic (Mock)

## Objective
Implement the logic that matches user profile (Age, Allergies) and Pantry (Ingredients) to a list of Recipes.

## Architecture & Packages
- **Service**: `RecipeGeneratorService`.
- **Pattern**: Repository Pattern (mock implementation).

## Tasks
1. **Data Model**:
   - `Recipe` model (title, ingredients needed, steps, calories, age_appropriateness, allergens).
2. **Mock Database**:
   - Create a JSON file or Dart list with ~20 diverse recipes.
3. **Filtering Logic**:
   - **Filter 1 (Safety)**: Exclude recipes containing user's allergens.
   - **Filter 2 (Age)**: Exclude recipes not suitable for the child's chewing skill.
   - **Filter 3 (Availability)**: Prioritize recipes where user has most ingredients.
4. **Service Method**:
   - `Future<List<Recipe>> generateRecipes(ChildProfile profile, List<Ingredient> pantry)`

## UI Components Focus
- N/A (Logic only)

## Checklist
- [ ] Mock recipe database created.
- [ ] Algorithm correctly filters out allergens.
- [ ] Algorithm correctly filters by chewing skill.
- [ ] Service returns a list of valid recipes based on inputs.
