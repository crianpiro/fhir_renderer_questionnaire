# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

This is a monorepo hosting multiple FHIR renderer packages. Each package is self-contained (own `pubspec.yaml`, `analysis_options.yaml`, `CHANGELOG.md`, `LICENSE`, tests and example app) and published independently.

```
.
├── example/                       # Showcase app - the deployed website
├── fhir_renderer_questionnaire/   # The only implemented package
├── fhir_renderer_care_plan/       # Placeholder, not implemented yet
└── fhir_renderer_xxxx/            # Placeholder, not implemented yet
```

There is no root `pubspec.yaml` — all Flutter/Dart commands run from inside a package directory (or `example/`). Paths below are relative to `fhir_renderer_questionnaire/`.

### Showcase app (`example/`)

The root `example/` app (`fhir_renderer_showcase`) is what CI deploys to GitHub Pages. It has no example content of its own: `lib/showcase_catalog.dart` lists every package, and each entry's `builder` returns that package's own example widget, pulled in as a path dependency.

Two conventions make this work, and both matter when adding a package:

1. Each package's example is named `<package_name>_example`, not the `flutter create` default of `example` — pub cannot resolve two dependencies sharing a name.
2. Each example exposes its landing page as a widget outside `main.dart` (e.g. `example/lib/views/home_page.dart`), so the showcase can embed it without its `MaterialApp`. `main.dart` stays a thin standalone entry point.

A catalog entry with a null `builder` renders as a "coming soon" placeholder, so wiring up a new package is a one-line change plus the path dependency.

## Project Overview

`fhir_renderer_questionnaire` is a Flutter package for rendering FHIR R4 Questionnaires. It generates UI from FHIR Questionnaire definitions and produces valid QuestionnaireResponse objects. Supports 16 of 17 FHIR item types (94% coverage).

## Commands

```bash
cd fhir_renderer_questionnaire

# Run all tests
flutter test

# Run specific test file
flutter test test/core/mixins/boolean_value_mixin_test.dart

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Run example app
cd example && flutter run
```

## Architecture

### Layer Separation

- **`lib/src/core/models/`** - The package's own FHIR R4 models (no `fhir_r4` dependency)
- **`lib/src/core/`** - Business logic: controllers, mixins, utils, validation
- **`lib/src/ui/`** - Presentation: renderers, components, factories

### Models (`lib/src/core/models/`)

The package models FHIR R4 itself rather than depending on `fhir_r4`, keeping it light and leaving the FHIR library choice to the consumer. JSON is the only boundary: `Questionnaire.fromJson(map)` in, `response.toJson()` out.

- **Plain Dart types.** `item.text` is `String?`, `item.required_` is `bool?`, `item.maxLength` is `int?`. There are no `Fhir*` primitive wrappers.
- **Except dates.** `FhirDate`, `FhirDateTime` and `FhirTime` (`fhir_primitives.dart`) keep the source literal, because FHIR partial dates (`2024`, `2024-03`) carry meaning a `DateTime` cannot express. Call `.toDateTime()` when you need one; `.value` is the literal.
- **Lossless round-trips.** Every model keeps the JSON keys it does not type in an extra map and re-emits them from `toJson`. When adding a typed field, also add its key to that class's `_modelledKeys`, or it will be written twice.
- **Decimals keep their written form** via `DecimalValue`, so a JSON `1` does not come back as `1.0`.
- **`value[x]` is explicit.** `QuestionnaireResponseAnswer` has `valueString`, `valueBoolean`, `valueCoding`, … and a `value` getter returning whichever is set. Same for `enableWhen`'s `answer[x]` and `initial`'s `value[x]`.
- **Parsing is tolerant.** Unknown enum codes yield `null`; an unknown item `type` falls back to `display_` so a questionnaire from a newer source still renders.
- Value equality and `hashCode` are deep — the enableWhen cache keys on `response.hashCode`, so this matters.

### Three Renderer Options

| Renderer | Underlying Widget | Use Case |
|----------|-------------------|----------|
| `QuestionnaireListViewRenderer` | ListView.builder | Long scrollable questionnaires |
| `QuestionnairePageViewRenderer` | PageView | Step-by-step navigation |
| `QuestionnaireSliversViewRenderer` | CustomScrollView | Advanced scrolling behaviors |

All three renderers share the same customization API via builder callbacks.

### Key Design Patterns

1. **Factory Pattern**: `BoxComponentFactory` and `SliverComponentFactory` implement `QuestionnaireComponentFactory` to create item widgets based on renderer type
2. **Mixin Composition**: Value extraction and behavior logic in `lib/src/core/mixins/` - mixins are reusable across box and sliver components
3. **InheritedWidget**: `InheritedQuestionnaireRenderer` propagates questionnaire response state down the widget tree
4. **Builder Callbacks**: All item widgets customizable via builder functions defined in `type_definitions.dart`

### State Flow

1. `RendererQuestionnaireController` holds the Questionnaire and manages QuestionnaireResponse state
2. Response changes flow through `InheritedQuestionnaireRenderer` to child widgets
3. EnableWhen conditions are evaluated via `FhirRendererQuestionnaireUtils` with caching (key: `"linkId:responseHashCode"`)
4. Item behavioral data (FocusNode, TextEditingController) stored in `ItemBehavioralData` and disposed by controller

### Component Mirroring

Each item type has two implementations:
- `lib/src/ui/components/boxes/questionnaire_*_item.dart` - For ListView/PageView renderers
- `lib/src/ui/components/slivers/questionnaire_sliver_*_item.dart` - For Slivers renderer (must return Sliver widgets)

## Important Technical Notes

1. **Sliver Builders**: Custom builders for `QuestionnaireSliversViewRenderer` must return `Sliver*` widgets
2. **EnableWhen Cache**: Cleared when response hashCode changes; evaluates AND/OR behavior via `enableBehavior` field

## FHIR Extensions Supported

- `http://hl7.org/fhir/StructureDefinition/regex` - Custom validation pattern
- `http://hl7.org/fhir/StructureDefinition/entryFormat` - Custom error message
- `http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl` - Widget type (drop-down, radio-button, check-box)
- `http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive` - Mutually exclusive "all"/"none" option in multi-select items (UI-flagged with a `**` marker + legend)

## Test Structure

Tests are in `test/core/` covering mixins, utils, extensions, and validation. UI components have minimal coverage and require widget tests (`testWidgets`).
