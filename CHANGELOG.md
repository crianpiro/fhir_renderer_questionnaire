### FHIR Renderer Questionnaire

Types of changes

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

### 1.1.0

#### Added

##### Builder Support for Reference Items
* **`QuestionnaireReferenceWidgetBuilder`** - New builder callback type for customizing reference item rendering
* **Custom Reference Builder example** demonstrating autocomplete-style FHIR resource selection
* Mock data for Practitioners and Organizations with searchable dropdown

##### Builder Support for Attachment Items
* **`QuestionnaireAttachmentWidgetBuilder`** - New builder callback type for customizing attachment item rendering

#### Fixed

##### Reference Item Cursor Jumping
* **Fixed cursor jumping to beginning** when typing in `QuestionnaireReferenceItem` fields

---

### 1.0.0

This is the first stable release of `fhir_renderer_questionnaire`, featuring comprehensive FHIR R4 questionnaire rendering capabilities with 94% coverage of questionnaire item types (16 of 17).

#### Added

##### New Item Types
* **Support for `attachment` item type** - File upload functionality with support for images, PDFs, and documents
* **Support for `reference` item type** - Reference to FHIR resources (Practitioner, Patient, etc.)

##### Validation & Input Handling
* Regex validation support using standard FHIR extension `http://hl7.org/fhir/StructureDefinition/regex`
* Automatic default validation for field types: `integer`, `decimal`, `url`, and `quantity` (no extensions required)
* Automatic keyboard type selection based on field type (integer → number pad, decimal → decimal pad, url → URL keyboard, text → multiline)
* Input formatters to restrict invalid characters during typing (e.g., letters in integer fields, multiple decimal points in decimal fields)
* Smart text input actions (newline for multiline text, next for single-line fields)
* Support for `entryFormat` extension to provide custom validation error messages
* Automatic validation feedback with `TextFormField` for real-time input validation
* New `KeyboardTypeHelper` utility class providing keyboard configuration for different field types
* New `DefaultValidationPatterns` class providing built-in patterns for common field types
* New `RegexValidationMixin` for reusable validation logic with support for default patterns
* Extension methods `regexValidationPattern` and `regexValidationErrorMessage` on `QuestionnaireItem`
* `regexValidationPattern` and `regexValidationError` fields in `ItemBehavioralData`
* Example questionnaires demonstrating both custom regex patterns and automatic default validation

##### Item Control Extensions
* Support for FHIR `questionnaire-itemControl` extension for customizing choice rendering
* Dropdown rendering for choice items using `drop-down` item control
* Radio button rendering for choice items using `radio-button` item control
* Checkbox rendering for choice items using `check-box` item control

##### Features & Functionality
* `forceReadOnlyView` in the `RendererQuestionnaireController` to force the renderer to be in read-only mode for the entire view
* `onPageChanged` callback in `QuestionnairePageViewRenderer` to track page navigation
* Initial values support for default slivers in `QuestionnaireSliversViewRenderer`
* Unit tests for core utilities: `FhirRendererQuestionnaireUtils` and `FhirRendererQuestionnaireResponseUtils`
* Comprehensive test coverage for enableWhen evaluation logic (AND/OR behavior, operators, data types)
* Tests for QuestionnaireResponse generation, manipulation, and answer handling

##### Architecture & Performance
* **Performance optimizations** using caching system for `enableWhen` evaluations
* **Mixin-based architecture** for better code reuse (boolean, choice, datetime, text field, open choice, group filtering, regex validation)
* **Factory pattern implementation** for component creation (BoxComponentFactory, SliverComponentFactory)
* EnableWhen caching to prevent redundant conditional logic evaluations
* InheritedWidget optimization using `identical()` checks for better performance

#### Changed

##### Code Quality & Architecture
* **Major refactoring** to reduce code duplication (~1040 insertions, ~694 deletions)
* **Replaced `ChoiceValueMixin` with `ChoiceBaseMixin`** for choice components - now exported publicly for custom implementations
* **Improved state propagation** to prevent updates on unmounted widgets
* Optimized InheritedWidget checks for better performance
* Better code organization with mixin-based approach
* Improved rendering performance by removing unnecessary builds

#### Fixed

##### Memory Management
* **Memory leak fix**: `RendererQuestionnaireController.dispose()` is now properly called from `BaseQuestionnaireState.dispose()`
* **Proper cleanup** of `FocusNode` and `TextEditingController` resources when questionnaire renderer is disposed

##### EnableWhen Logic
* **EnableWhen behavior** for slivers view renderer
* **EnableWhen behavior** for custom group items
* **EnableWhen unit tests** added to ensure correctness of conditional logic (AND/OR behavior)

##### Rendering Issues
* **Keys problem** in Slivers view causing incorrect widget reuse
* **Proper subIndex handling** for nested questionnaire items
* **Proper linking** of ScrollControllers and PageViewController
* **Rendering optimizations** to remove unnecessary rebuilds
* State propagation issues when widgets are unmounted

#### Breaking Changes
* None - this is the first stable release

#### Migration Notes
If upgrading from pre-1.0.0 versions (0.0.x):
* `ChoiceValueMixin` has been replaced with `ChoiceBaseMixin` - update any custom implementations
* Controller disposal is now automatic - remove manual disposal code if present
* EnableWhen behavior has been fixed - test any complex conditional logic.

---

### 0.0.7

### Breaking changes
* `questionnaire` is now part of the `QuestionnaireRendererController` as a required parameter.
* `initialQuestionnaireResponse` is now part of the `QuestionnaireRendererController` as an optional parameter.

## 0.0.6

### Breaking changes
* `rendererController` is now required in all renderers.
* `RendererQuestionnaireController` was changed to allow you to extend it. 
* `QuestionnaireRendererController` removed. 

### Added
* Support for `sliversInitialIndex` in the `rendererController` for the `QuestionnaireSliversViewRenderer`.

### Changed
* `BaseDecorator` and `SliverBaseDecorator` don't use background color, to allow the user to define it from outside.

## 0.0.5

### Fixed
* Support for `Slivers` in the `groupItemBuilder` for the `QuestionnaireSliversViewRenderer`.

## 0.0.4 (retracted)

### Fixed
* `childrenAssigner`changed to be optional.
* Intl version changed back to `^0.20.2`.

## 0.0.3 (retracted)

### Changed
* Default text for boolean changed to its English version.

### Added
* `childrenAssigner`in `QuestionnaireGroupWidgetBuilder` to support default widgets for group items children.

## 0.0.2

### Added
* Support for initial values for types: `choice`, `open-choice`, `date`, `dateTime`, `time`, `decimal`, `integer`, `string`, `text`, `url` and `quantity`.

## 0.0.1

* Renderers `QuestionnaireListViewRenderer`, `QuestionnairePageViewRenderer` and `QuestionnaireSliversViewRenderer` implemented.
* Initial implementation, support for FHIR R4 Questionnaire Item Types: `group`, `display`, `boolean`, `decimal`, `integer`, `date`, `dateTime`, `time`, `string`, `text`, `url`, `choice`, `open-choice` and `quantity`.