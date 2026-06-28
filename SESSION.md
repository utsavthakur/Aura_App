# Aura App — Session Summary

## Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Spring Boot (Java 17) on port **8080**
- **Database**: PostgreSQL 18 on port **5433** (`aura_db`, user `aura_user`, pass `AuraPass#2024`)
- **Auth**: JWT (stored in `flutter_secure_storage`)
- **Status**: Migrated from Supabase SDK → custom REST API

## Key State
- Backend schema: 8 tables (users, posts, stories, likes, comments, follows, messages, notifications) + 2 DB triggers
- `supabase_flutter` removed from `pubspec.yaml`
- `AuthService.signUp()` now requires `username`
- Model field `profilePicture` → `avatarUrl`
- `MockApiService` kept as fallback when API returns empty/error
- `dart analyze` passes with 0 errors

## Commands
- Start backend: `cd backend && mvn spring-boot:run`
- Run Flutter: `flutter run`
- Analyze: `dart analyze`

## Next Steps
1. Start backend and test login/register
2. Add `@RestControllerAdvice` for consistent error JSON
3. Remove `MockApiService` once API endpoints are stable
