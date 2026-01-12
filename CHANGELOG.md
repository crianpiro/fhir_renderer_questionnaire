### FHIR Renderer Questionnaire

Types of changes

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

### 1.0.0 (Unreleased)

### Added
* Regex validation support for text field types using standard FHIR extension `http://hl7.org/fhir/StructureDefinition/regex`
* Support for `entryFormat` extension to provide custom validation error messages
* Automatic validation feedback with `TextFormField` for real-time input validation
* `regexValidationPattern` and `regexValidationError` fields in `ItemBehavioralData`
* Extension methods `regexValidationPattern` and `regexValidationErrorMessage` on `QuestionnaireItem`
* New `RegexValidationMixin` for reusable validation logic across components
* Example questionnaire demonstrating regex validation patterns (email, phone, ZIP code, URL, date formats, alphanumeric codes)
* `forceReadOnlyView` in the `RendererQuestionnaireController` to force the renderer to be in read-only mode for the entire view
* Support for `onPageChanged` callback in `QuestionnairePageViewRenderer` to track page navigation
* Initial values support for default slivers in `QuestionnaireSliversViewRenderer`
* Performance optimizations using caching system for `enableWhen` evaluations
* Mixin-based architecture for better code reuse (boolean, choice, datetime, text field, open choice, group filtering, regex validation)
* Factory pattern implementation for component creation (BoxComponentFactory, SliverComponentFactory)

### Changed
* Major refactoring to reduce code duplication (~1040 insertions, ~694 deletions)
* InheritedWidget optimization using `identical()` checks for better performance
* Improved state propagation to prevent updates on unmounted widgets

### Fixed
* Memory leak: `RendererQuestionnaireController.dispose()` is now properly called from `BaseQuestionnaireState.dispose()`
* Proper cleanup of `FocusNode` and `TextEditingController` resources when questionnaire renderer is disposed
* EnableWhen behavior for slivers and custom groups
* Rendering optimizations to remove unnecessary builds
* Proper linking of ScrollControllers and PageViewController

### 0.0.7

### Breaking changes
* `questionnaire` is now part of the `QuestionnaireRendererController` as a required parameter.
* `initialQuestionnaireResponse` is now part of the `QuestionnaireRendererController` as an optional parameter.

## 0.0.6

### Breaking changes
* `rendererController` is now required in all renderers.
* `RenderereQuestionnaireController` was changed to allow you to extend it. 
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