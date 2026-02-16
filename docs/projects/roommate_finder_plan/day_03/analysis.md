# Day 03: User Profile Module (Bio, Preferences, Lifestyle)

## Objectives
- Create `UserProfileView` and `UserProfileViewModel`.
- Implement forms for personal details (age, gender, occupation).
- Add lifestyle preference selection (smoking, pets, sleep schedule, cleanliness).
- Ensure state management using `BaseViewModelHydratedCubit`.

## Required API Endpoints
- `GET /users/me`: Fetch current user data and preferences.
- `PUT /users/me`: Update profile details (bio, age, etc.).
- `POST /users/me/avatar`: Upload user profile picture.
- `GET /users/{id}`: View public profile of potential roommates.
