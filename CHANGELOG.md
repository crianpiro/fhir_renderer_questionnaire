### FHIR Renderer Questionnaire

Types of changes

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 0.0.5

### Fixed
* Support for `Slivers` in the `groupItemBuilder` for the `QuestionnaireSliversViewRenderer`.

## 0.0.4 (retracted version)

### Fixed
* `childrenAssigner`changed to be optional.
* Intl version changed back to `^0.20.2`.

## 0.0.3 (retracted version)

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