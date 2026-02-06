# Day 02 Analysis: UI/UX Standards & AppConfig Theme

## Objective
Implement the minimalist Black & White theme using `osmea_components`, driven by the `AppConfig` loaded in Day 01.

## Architecture & Packages
- **Package**: `packages/components`
- **Core Integration**:
  - Use `AppConfigService` to inject theme values into the app.
  - Ensure `masterfabric_core` views adapt to these config values.

## Tasks
1. **AppConfig Expansion**:
   - Update `assets/app_config.json` to include detailed style tokens:
     - `buttonStyle`: { `primary`: { `bg`: "#000000", `text`: "#FFFFFF" }, ... }
     - `typography`: { `fontFamily`: "Roboto", ... }
2. **Theme Factory**:
   - Create a `ThemeFactory` that reads `AppConfig` and generates `ThemeData`.
   - Apply this `ThemeData` to `MaterialApp`.
3. **Component Styling**:
   - Configure `OsmeaButton`, `OsmeaTextField`, `OsmeaAppbar` to look up their styles from the `ThemeData` (which is derived from `AppConfig`).
   - Ensure the "Black & White" aesthetic is enforced via the JSON config, not hardcoded Dart files.
4. **Main Layout**:
   - Create a `DashboardShell` using `OsmeaScaffold` and `OsmeaNavbar` (Bottom Navigation).
   - Icons and labels for the Navbar should be localized via `slang`.

## UI Components Focus
- `OsmeaScaffold`
- `OsmeaNavbar` (Bottom Navigation)
- `OsmeaAppbar`
- `OsmeaButton` (Theme check)

## Checklist
- [ ] `ThemeData` is generated dynamically from `AppConfig`.
- [ ] Changing a color in `app_config.json` updates the app look (after restart).
- [ ] `OsmeaButton` and `OsmeaTextField` reflect the configured theme.
- [ ] `DashboardShell` text is localized.

