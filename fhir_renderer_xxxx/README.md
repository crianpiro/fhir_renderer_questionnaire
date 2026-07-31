# fhir_renderer_xxxx

🚧 **Placeholder** — this package has not been implemented yet, and its name is not final.

Reserved slot for an upcoming Flutter package rendering a FHIR® R4 resource, following the same conventions as [`fhir_renderer_questionnaire`](../fhir_renderer_questionnaire).

## Planned layout

```
fhir_renderer_xxxx/
├── lib/
│   ├── fhir_renderer_xxxx.dart        # Public API barrel file
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

When work begins on this package, rename the folder to the final package name and scaffold it with:

```bash
flutter create --template=package fhir_renderer_xxxx
```

and mirror the structure and conventions documented in the [repository README](../README.md).

Name the example app `<package_name>_example` rather than the default
`example`, then register it in the [showcase app](../example/README.md) so it
appears on the published website. It currently renders there as a "coming soon"
placeholder.
