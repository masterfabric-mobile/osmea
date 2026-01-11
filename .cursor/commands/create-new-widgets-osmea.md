# 🎨 OSMEA Components Library - Component Creation Commands

This file contains command prompts for creating new components following the OSMEA Components Library pattern.

## 📋 Table of Contents
- [Basic Stateless Widget](#basic-stateless-widget)
- [Stateful Widget with Cubit](#stateful-widget-with-cubit)
- [Container-Based Widget](#container-based-widget)
- [Form Input Widget](#form-input-widget)
- [Navigation Widget](#navigation-widget)
- [Layout Widget](#layout-widget)

---

## 🏗️ Basic Stateless Widget

**Use Case:** Simple display components, icons, badges, dividers, etc.

**Command Prompt:**
```
Create a new OSMEA component called [ComponentName] following the OSMEA Components Library pattern:

1. **File Structure:**
   - Create: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Follow the AbstractCoreWidget pattern

2. **Component Requirements:**
   - Extend AbstractCoreWidget
   - Include comprehensive documentation header with:
     * Component name with emoji
     * Copyright notice
     * GitHub link
     * {@category Components} and {@subCategory [Category]}
   - Support customTheme parameter
   - Use OsmeaColors for theming
   - Include size variants (small, medium, large) if applicable
   - Add proper accessibility support
   - Include RTL/LTR support

3. **Documentation:**
   - Add detailed doc comments with Features list
   - Include usage example in code block
   - List all properties with descriptions
   - Add "See also" references

4. **Export:**
   - Add export to `packages/components/lib/osmea_components.dart`
   - Add to appropriate section (Buttons, Form Elements, etc.)

5. **Follow Pattern:**
   - Use theme getter: `theme`
   - Implement buildWidget method
   - Use OsmeaComponents helpers (text, container, etc.)
   - Use OsmeaColors for colors
   - Add size extension if needed: `packages/components/lib/src/utils/[component_name]_extensions.dart`

**Component Details:**
- Component Name: [Your Component Name]
- Category: [e.g., Display, Interaction, Form, Navigation]
- Description: [Brief description]
- Key Features: [List main features]
- Props Needed: [List required/optional props]
```

---

## 🔄 Stateful Widget with Cubit

**Use Case:** Interactive components with state management (counters, toggles, dropdowns, etc.)

**Command Prompt:**
```
Create a new OSMEA component called [ComponentName] with Cubit state management following the OSMEA Components Library pattern:

1. **File Structure:**
   - Component: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Cubit: `packages/components/lib/src/components/[component_name]/cubit/[component_name]_cubit.dart`
   - State: `packages/components/lib/src/components/[component_name]/cubit/[component_name]_state.dart`
   - Extensions: `packages/components/lib/src/utils/[component_name]_extensions.dart` (if needed)

2. **Component Requirements:**
   - Extend StatefulWidget (not AbstractCoreWidget for stateful)
   - Use BlocProvider and BlocBuilder for state management
   - Initialize Cubit in initState
   - Dispose Cubit in dispose
   - Support customTheme parameter
   - Include comprehensive documentation

3. **Cubit Requirements:**
   - Extend Cubit<[ComponentName]State>
   - Include all state-changing methods
   - Handle validation if needed
   - Include error handling
   - Add proper state transitions

4. **State Requirements:**
   - Use freezed or sealed classes if complex
   - Include all necessary state properties
   - Add copyWith if needed

5. **Documentation:**
   - Document component, cubit, and state classes
   - Include usage examples
   - List all callbacks and events

6. **Export:**
   - Export component, cubit, and state in osmea_components.dart
   - Add to appropriate section

**Component Details:**
- Component Name: [Your Component Name]
- State Management: Cubit
- Initial State: [Describe initial state]
- State Changes: [List state-changing actions]
- Callbacks: [List callbacks needed]
```

---

## 📦 Container-Based Widget

**Use Case:** Widgets that wrap content in a container (cards, modals, panels, etc.)

**Command Prompt:**
```
Create a new OSMEA container-based component called [ComponentName] following the OSMEA Components Library pattern:

1. **File Structure:**
   - Create: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Use CoreContainer or extend AbstractCoreWidget

2. **Component Requirements:**
   - Extend AbstractCoreWidget or use CoreContainer wrapper
   - Support container properties:
     * padding, margin
     * width, height
     * backgroundColor
     * borderRadius
     * border, borderColor
     * shadow/elevation
   - Support customTheme
   - Include variant support (filled, outlined, elevated, etc.)

3. **Styling:**
   - Use OsmeaColors for colors
   - Support size variants
   - Include proper spacing using theme
   - Add animation support if needed

4. **Documentation:**
   - Document all container properties
   - Include variant examples
   - Show usage with different sizes

5. **Export:**
   - Add to osmea_components.dart
   - Add to Components section

**Component Details:**
- Component Name: [Your Component Name]
- Variants: [List variants: filled, outlined, etc.]
- Sizes: [List sizes: small, medium, large]
- Container Properties: [List specific container props]
```

---

## 📝 Form Input Widget

**Use Case:** Text fields, checkboxes, radio buttons, dropdowns, switches, etc.

**Command Prompt:**
```
Create a new OSMEA form input component called [ComponentName] following the OSMEA Components Library pattern:

1. **File Structure:**
   - Component: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Controller (if needed): `packages/components/lib/src/components/[component_name]/controllers/[component_name]_controller.dart`
   - Cubit/State (if needed): `packages/components/lib/src/components/[component_name]/cubit/`
   - Extensions: `packages/components/lib/src/utils/[component_name]_extensions.dart`

2. **Component Requirements:**
   - Support validation
   - Include error states
   - Support disabled/enabled states
   - Include label and helper text
   - Support required indicator
   - Add accessibility labels
   - Support RTL/LTR

3. **Form Integration:**
   - Work with Flutter FormField if applicable
   - Support FormFieldValidator
   - Include onChanged, onSubmitted callbacks
   - Support focus management

4. **Styling:**
   - Use OsmeaColors for states (error, success, etc.)
   - Support size variants
   - Include focus/hover states
   - Add animation transitions

5. **Documentation:**
   - Document validation rules
   - Include form integration examples
   - Show error handling
   - List all callbacks

6. **Export:**
   - Add to Form Elements section in osmea_components.dart
   - Export controller if applicable

**Component Details:**
- Component Name: [Your Component Name]
- Input Type: [text, number, email, etc.]
- Validation: [List validation rules]
- States: [enabled, disabled, error, success, etc.]
- Callbacks: [onChanged, onSubmitted, onFocus, etc.]
```

---

## 🧭 Navigation Widget

**Use Case:** App bars, nav bars, tab bars, steppers, breadcrumbs, etc.

**Command Prompt:**
```
Create a new OSMEA navigation component called [ComponentName] following the OSMEA Components Library pattern:

1. **File Structure:**
   - Component: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Cubit/State: `packages/components/lib/src/components/[component_name]/cubit/`
   - Extensions: `packages/components/lib/src/utils/[component_name]_extensions.dart`

2. **Component Requirements:**
   - Support navigation actions
   - Include active/inactive states
   - Support icons and labels
   - Include badge/notification support
   - Add accessibility navigation
   - Support RTL/LTR

3. **State Management:**
   - Use Cubit for navigation state if complex
   - Track active item/route
   - Handle navigation callbacks
   - Support programmatic navigation

4. **Styling:**
   - Use OsmeaColors for active/inactive states
   - Support size variants
   - Include animation transitions
   - Add hover/press states

5. **Documentation:**
   - Document navigation flow
   - Include routing examples
   - Show state management usage
   - List all navigation callbacks

6. **Export:**
   - Add to Navigation section in osmea_components.dart
   - Export cubit and state

**Component Details:**
- Component Name: [Your Component Name]
- Navigation Type: [bottom nav, top nav, tabs, etc.]
- Active State: [How active state is determined]
- Navigation Callback: [onItemSelected, onRouteChanged, etc.]
- Badge Support: [Yes/No, how badges work]
```

---

## 📐 Layout Widget

**Use Case:** Grids, lists, stacks, flex layouts, etc.

**Command Prompt:**
```
Create a new OSMEA layout component called [ComponentName] following the OSMEA Components Library pattern:

1. **File Structure:**
   - Component: `packages/components/lib/src/components/[component_name]/[component_name].dart`
   - Use CoreContainer or AbstractCoreWidget as base

2. **Component Requirements:**
   - Support child widgets
   - Include spacing/gap properties
   - Support alignment options
   - Include responsive breakpoints
   - Support scroll behavior if needed
   - Add accessibility support

3. **Layout Properties:**
   - Main axis alignment
   - Cross axis alignment
   - Spacing between items
   - Padding and margin
   - Width/height constraints
   - Flex properties if applicable

4. **Styling:**
   - Use theme spacing
   - Support custom spacing
   - Include proper constraints
   - Add animation if needed

5. **Documentation:**
   - Document layout behavior
   - Include alignment examples
   - Show responsive examples
   - List all layout properties

6. **Export:**
   - Add to Components section in osmea_components.dart

**Component Details:**
- Component Name: [Your Component Name]
- Layout Type: [grid, list, flex, etc.]
- Alignment: [start, center, end, stretch, etc.]
- Spacing: [gap, padding, margin options]
- Responsive: [Yes/No, breakpoints]
```

---

## 🎯 General Guidelines for All Components

### Documentation Template:
```dart
/// 🎨 **OSMEA Components Library - [Component Name]**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// [Brief description of what the component does]
///
/// {@category Components}
/// {@subCategory [Category]}
///
/// **Features:**
/// * 🎨 Feature 1
/// * 📏 Feature 2
/// * 🔄 Feature 3
///
/// **Usage Example:**
/// ```dart
/// [ComponentName](
///   [property]: [value],
///   [callback]: ([params]) => [action],
/// )
/// ```
///
/// **Properties:**
/// * [property] - [description]
///
/// See also:
/// * [RelatedComponent] - [description]
```

### Export Pattern:
```dart
// In osmea_components.dart, add to appropriate section:

// 🎨 [Category Name]
export 'src/components/[component_name]/[component_name].dart';
export 'src/components/[component_name]/cubit/[component_name]_cubit.dart'; // if applicable
export 'src/components/[component_name]/cubit/[component_name]_state.dart'; // if applicable
export 'src/utils/[component_name]_extensions.dart'; // if applicable
```

### Extension Pattern (if needed):
```dart
// In utils/[component_name]_extensions.dart

extension [ComponentName]SizeExtension on [ComponentName]Size {
  [ComponentName]SizeConfig config(BuildContext context) {
    // Return size configuration
  }
}
```

### Color Usage:
- Always use `OsmeaColors` from the theme
- Never hardcode colors
- Support customTheme override
- Use theme-aware colors for different states

### Accessibility:
- Add semantic labels
- Support screen readers
- Include proper focus management
- Support keyboard navigation
- Add proper ARIA attributes if applicable

---

## 📝 Quick Reference Checklist

When creating any component, ensure:

- [ ] Extends AbstractCoreWidget (stateless) or StatefulWidget (with state)
- [ ] Includes comprehensive documentation header
- [ ] Uses OsmeaColors for theming
- [ ] Supports customTheme parameter
- [ ] Includes size variants if applicable
- [ ] Has proper accessibility support
- [ ] Includes RTL/LTR support
- [ ] Uses OsmeaComponents helpers
- [ ] Exported in osmea_components.dart
- [ ] Follows naming conventions
- [ ] Includes usage examples
- [ ] Has proper error handling (if applicable)
- [ ] Includes animation support (if applicable)
- [ ] Has proper state management (if applicable)

---

## 🚀 Example Usage

To create a new component, use one of the command prompts above and replace:
- `[ComponentName]` with your component name (PascalCase)
- `[component_name]` with your component name (snake_case)
- `[Category]` with appropriate category
- Fill in all component details

The AI will generate all necessary files following the OSMEA Components Library pattern.
