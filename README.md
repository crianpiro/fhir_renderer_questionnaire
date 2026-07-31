# FHIR Renderer

![Static Badge](https://img.shields.io/badge/License-BSD_3_Clause-green)

A monorepo hosting a family of Flutter packages for rendering FHIR® R4 resources. HL7®, and FHIR® are the registered trademarks of Health Level Seven International and their use of these trademarks does not constitute an endorsement by HL7.

## 📦 Packages

| Package | Status | Description |
|---------|--------|-------------|
| [`fhir_renderer_questionnaire`](./fhir_renderer_questionnaire) | ✅ Released | Renders FHIR R4 Questionnaires and produces valid `QuestionnaireResponse` objects. |
| [`fhir_renderer_care_plan`](./fhir_renderer_care_plan) | 🚧 Placeholder | Renders FHIR R4 CarePlan resources. |
| [`fhir_renderer_xxxx`](./fhir_renderer_xxxx) | 🚧 Placeholder | Reserved for an upcoming FHIR R4 resource renderer. |

## 🗂️ Repository layout

```
.
├── fhir_renderer_questionnaire/   # Package sources, tests and example app
│   ├── lib/
│   ├── test/
│   └── example/
├── fhir_renderer_care_plan/       # Placeholder
└── fhir_renderer_xxxx/            # Placeholder
```

Each package is self-contained: it owns its `pubspec.yaml`, `analysis_options.yaml`, `CHANGELOG.md`, `LICENSE`, tests and example app, and is published to pub.dev independently.

## 🛠️ Working on a package

All Flutter/Dart commands run from inside the package directory:

```bash
cd fhir_renderer_questionnaire

flutter pub get
flutter test
flutter analyze

# Run the example app
cd example && flutter run
```

## 📄 License

BSD 3-Clause — see [LICENSE](./LICENSE). Each package also ships its own copy of the license.
