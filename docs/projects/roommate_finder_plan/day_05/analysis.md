# Day 05: Matching Engine Logic (Mock)

## Objectives
- Develop the logic for matching users based on shared preferences.
- Create a scoring system for compatibility.
- Implement a mock service to return "Recommended Roommates" and "Top Listings".

## Required API Endpoints
- `GET /matches/recommendations`: Fetch list of recommended users or listings.
- `POST /matches/swipe`: Handle Like/Pass actions (e.g., `{ target_id, action: "like" }`).
- `GET /matches`: Retrieve list of mutual matches.
