# Day 01 Analysis: Project Setup, Architecture & Configuration

## Objective
Initialize the Flutter project, integrate `masterfabric_core` (v0.0.13), and establish the `AppConfig` and `Slang` (i18n) infrastructure.

## Architecture & Packages
- **Package**: `masterfabric_core`
- **Modules to Enable**:
  - `Dependency Injection` (setup `injectable`)
  - `Routing` (setup `go_router`)
  - `Localization` (setup `slang` & `slang_flutter`)
  - `Configuration` (AppConfig Service)

### Backend Endpoints
- **None**: Day 01 focuses on local project setup and infrastructure. Dynamic `AppConfig` fetching from a backend could be considered in later stages, but is not part of this initial setup.

## Tasks
1. **Initialize Project**: Create a new Flutter project.
2. **Dependency Setup**:
   - Add `masterfabric_core`, `osmea_components`, `slang`, `slang_flutter` to `pubspec.yaml`.
   - Add `slang_build_runner` to `dev_dependencies`.
3. **Localization (Slang) Setup**:
   - Create `slang.yaml`.
   - Create `assets/i18n` directory.
   - Add `strings.i18n.json` (English) and `strings_tr.i18n.json` (Turkish).
   - Run `dart run build_runner build`.
4. **AppConfig Setup**:
   - Create `assets/app_config.json` with initial keys:
     - `theme`: { `primaryColor`: "#000000", `backgroundColor`: "#FFFFFF" }
     - `features`: { `calorieTracking`: true }
     - `apiEndpoints`: { `aiRecipeGeneration`: "https://api.smartrecipe.com/generate", `nutrientDatabase`: "https://api.smartrecipe.com/nutrients" } // New: Example AI/LLM and external API endpoints
   - Create `AppConfigService` to load this JSON.
   - Register `AppConfigService` in DI.
5. **Core Configuration**:
   - Configure `main.dart` to use `CoreApp` and initialize `AppConfig`.
   - Initialize `HydratedBloc.storage` using `path_provider` (critical for `MasterViewHydratedCubit`).
   - Set up `GetIt` for DI.

## UI Components Focus
- None specific for today, focusing on infrastructure.

## Checklist
- [ ] Project compiles with `masterfabric_core` and `slang` dependencies.
- [ ] `AppConfigService` successfully loads `assets/app_config.json`.
- [ ] `Slang` is generated and text can be accessed (e.g., `t.welcome`).
- [ ] Application runs and shows the `SplashView`.
- [ ] Routing system is in place.
