# fhir_renderer_showcase

The monorepo-wide showcase app. This is the project deployed to GitHub Pages by
[`.github/workflows/release_website.yaml`](../.github/workflows/release_website.yaml).

It contains no example content of its own. It lists every package in the
repository and hands off to that package's **own example app**, which it pulls
in as a path dependency — so the published site always shows the real examples
rather than a copy that can drift out of date.

## Running it

```bash
cd example
flutter pub get
flutter run           # or: flutter run -d chrome
```

Building the site the way CI does:

```bash
flutter build web --release
# output: example/build/web
```

## Adding a package to the showcase

Each package's example is a separate Flutter project under
`<package>/example`, and stays independently runnable.

1. **Give the example a unique package name.** `flutter create` names every
   example `example`, and pub cannot resolve two dependencies with the same
   name. Use `<package_name>_example` — see
   `fhir_renderer_questionnaire/example/pubspec.yaml`.
2. **Expose the example's landing page as a widget** outside `main.dart`, so it
   can be embedded without its `MaterialApp`. The questionnaire example puts
   its `HomePage` in `lib/views/home_page.dart` and keeps `main.dart` as a thin
   standalone entry point.
3. **Add the path dependency** in this app's `pubspec.yaml`:
   ```yaml
   fhir_renderer_care_plan_example:
     path: ../fhir_renderer_care_plan/example
   ```
4. **Give the catalog entry a `builder`** in `lib/showcase_catalog.dart`. An
   entry without a builder renders as a "coming soon" placeholder, so this is
   the only switch that needs flipping.

The widget tests in `test/widget_test.dart` iterate over the catalog, so a new
entry is covered automatically.
