# fhir_renderer_care_plan

🚧 **Placeholder** — this package has not been implemented yet.

A Flutter package for rendering FHIR® R4 [CarePlan](https://hl7.org/fhir/R4/careplan.html) resources, following the same conventions as [`fhir_renderer_questionnaire`](../fhir_renderer_questionnaire).

## Planned layout

```
fhir_renderer_care_plan/
├── lib/
│   ├── fhir_renderer_care_plan.dart   # Public API barrel file
│   └── src/
│       ├── core/                      # Controllers, mixins, utils, validation
│       └── ui/                        # Renderers, components, factories
├── test/
├── example/
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE
└── pubspec.yaml
```

## Getting started

When work begins on this package, scaffold it with:

```bash
flutter create --template=package fhir_renderer_care_plan
```

and mirror the structure and conventions documented in the [repository README](../README.md).

Name the example app `fhir_renderer_care_plan_example` rather than the default
`example`, then register it in the [showcase app](../example/README.md) so it
appears on the published website. It currently renders there as a "coming soon"
placeholder.
