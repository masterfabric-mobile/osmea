# Day 04: Listing Management Module (Room Details, Photos)

## Objectives
- Create `CreateListingView` for users with available rooms.
- Implement fields for room details (price, location, amenities, availability).
- Add image picker/gallery for room photos.
- Define `Listing` model and mock data service.

## Required API Endpoints
- `POST /listings`: Create a new room listing.
- `PUT /listings/{id}`: Update listing details (price, amenities).
- `POST /listings/{id}/images`: Upload room photos.
- `GET /listings/{id}`: View own listing details.
- `DELETE /listings/{id}`: Remove or deactivate a listing.
