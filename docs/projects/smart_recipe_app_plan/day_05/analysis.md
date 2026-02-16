# Day 05 Analysis: AI-Powered Recipe Engine Logic

## Objective
Implement the intelligent core of the application: the **AI-Powered Recipe Engine**. This engine is designed to operate in two primary modes, fulfilling the core user experience strategy. It will analyze user profiles, pantry contents, and nutritional data to generate safe, personalized, and adaptive recipes.

## Core AI Operating Modes

As defined in the project's UX Strategy, the AI engine will support two distinct user-facing scenarios:

### Mode 1: Ingredient-Based Generation ("Dolabımda Ne Var?")
- **Role:** Kurtarıcı Asistan (Savior Assistant)
- **Flow:** The user provides a list of available ingredients from their pantry. The AI's primary task is to generate the best possible recipe using **only** those ingredients, while strictly adhering to the child's profile (age, allergies, texture needs) and the hard-coded `Safety Guardrail`.
- **Primary Input:** `pantryIngredients`.

### Mode 2: Proactive Nutritional Recommendation ("Bugün Ne Yemeli?")
- **Role:** Dijital Diyetisyen (Digital Dietitian)
- **Flow:** The system analyzes the child's nutritional intake for the day and identifies gaps (e.g., missing protein, low iron). The AI's primary task is to generate a recipe with **ideal ingredients** to fill these specific gaps. It may then cross-reference with the user's pantry to check feasibility or suggest adding items to a shopping list.
- **Primary Inputs:** `currentDailyNutrientIntake`, `dailyNutrientTargets`.

---

## Architecture & Packages
- **Service**: `RecipeGeneratorService` (Orchestrates AI/LLM calls for both modes).
- **AI/LLM Integration**: `LLMClient` (e.g., using `google_generative_ai`).
- **External Services**: Potential integration with a dedicated Nutrient Database API if not provided by LLM.

## Backend Endpoints (Recipe Engine Logic)

The primary endpoint will be designed to flexibly handle both modes.

- **POST /api/recipes/generate**: Generate a list of AI-adapted recipes.
  - **Behavior in Mode 1:** The request body MUST contain `pantryIngredients`. The AI prompt will be structured around answering "What can I make with these?".
  - **Behavior in Mode 2:** The request body MUST contain `currentDailyNutrientIntake` and `dailyNutrientTargets`. The `pantryIngredients` field can be included to help the AI check feasibility. The prompt will be structured around "What should the child eat to meet their nutritional goals?".
  - Request Body:
    ```json
    {
      "mode": "ingredient_based" | "proactive_recommendation", // Explicitly define mode
      "childProfile": { /* ... */ },
      "pantryIngredients": [ /* REQUIRED for Mode 1 */ ],
      "currentDailyNutrientIntake": { /* REQUIRED for Mode 2 */ },
      "dailyNutrientTargets": { /* REQUIRED for Mode 2 */ },
      "specificRequest": "Something quick for lunch." // Optional user text
    }
    ```
  - Response Body: `List<Recipe>` (AI-adapted recipe objects)

## Core Implementation Tasks

1.  **Unified `Recipe` Data Model**:
    - Ensure the `Recipe` model can represent outputs from both modes, including `baseIngredients`, `adaptedIngredients`, `preparationStepsAdapted`, full nutrient breakdown, `sensoryAdaptationTips`, and `rationale` (AI's explanation).

2.  **`LLMClient` and Prompt Engineering**:
    - Develop a flexible `LLMClient` to interact with the chosen LLM.
    - **Crucially, design two distinct sets of master prompts:** one for Mode 1 (creativity with constraints) and one for Mode 2 (goal-oriented recommendation).

3.  **Implement Mode 1 Logic (Ingredient-Based)**:
    - The service method will take `pantryIngredients` and `childProfile`.
    - It will construct a prompt for the LLM focusing on creating a recipe from the given list.
    - **Safety First:** The generated recipe MUST pass through the `Safety Guardrail` (no honey, salt, allergens etc.) before being returned.
    - The logic must also incorporate the "3 Gün Kuralı", avoiding suggestions with new ingredients if one is already in a tracking period.

4.  **Implement Mode 2 Logic (Proactive Recommendation)**:
    - The service method will take `nutrient-related data` and `childProfile`.
    - It will construct a prompt for the LLM to devise a recipe that meets specific nutritional targets.
    - The AI can suggest "ideal" ingredients, which are not necessarily in the user's pantry.

5.  **Common Logic Implementation**:
    - **`Safety Guardrail`:** A non-negotiable validation layer that checks every AI-generated recipe before it is sent to the user.
    - **Sensory & Texture Adaptation:** Based on `childProfile.textureToleranceLevel` and `sensoryPreferences`, the LLM will adapt preparation steps (e.g., "blend longer for a smoother texture") and provide tips. This applies to both modes.

## Checklist
- [ ] `RecipeGeneratorService` structured to handle two distinct modes.
- [ ] API endpoint includes a `mode` field to differentiate calls.
- [ ] Separate, optimized LLM prompts designed for Mode 1 and Mode 2.
- [ ] **Mode 1 Logic:** Successfully generates recipes from a fixed ingredient list.
- [ ] **Mode 2 Logic:** Successfully generates goal-oriented recipes to fill nutritional gaps.
- [ ] `Safety Guardrail` implemented and applied to ALL AI outputs.
- [ ] "3 Gün Kuralı" logic is integrated into the recipe generation flow.
- [ ] Sensory and texture adaptation logic is functional for both modes.
