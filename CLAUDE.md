# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter package for rendering FHIR R4 Questionnaires. It generates UI from FHIR Questionnaire definitions and produces valid QuestionnaireResponse objects. Supports 16 of 17 FHIR item types (94% coverage).

## Commands

```bash
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

- **`lib/src/core/`** - Business logic: controllers, mixins, utils, validation
- **`lib/src/ui/`** - Presentation: renderers, components, factories

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

1. **FHIR R4 Primitives**: Types like `FhirInteger`, `FhirBoolean` don't expose `.value` - compare directly with FHIR type instances
2. **Sliver Builders**: Custom builders for `QuestionnaireSliversViewRenderer` must return `Sliver*` widgets
3. **EnableWhen Cache**: Cleared when response hashCode changes; evaluates AND/OR behavior via `enableBehavior` field

## FHIR Extensions Supported

- `http://hl7.org/fhir/StructureDefinition/regex` - Custom validation pattern
- `http://hl7.org/fhir/StructureDefinition/entryFormat` - Custom error message
- `http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl` - Widget type (drop-down, radio-button, check-box)

## Test Structure

Tests are in `test/core/` covering mixins, utils, extensions, and validation. UI components have minimal coverage and require widget tests (`testWidgets`).
