# Day 06: Home Feed UI (Potential Roommates/Listings)

## Objectives
- Implement the main feed using `osmea_components` cards.
- Add toggle/tabs to switch between "Roommates" and "Rooms".
- Integrate the matching engine results into the UI.
- Implement "Like/Pass" or "Save" functionality.

## Required API Endpoints
- `GET /listings`: Fetch general list of room listings (with filters).
- `GET /users`: Fetch general list of users (if browsing is enabled).
- `GET /matches/recommendations`: Populate the main feed with smart suggestions.
