# FHIR Renderer Questionnaire
A Flutter package for FHIR® Questionnaires. HL7®, and FHIR® are the registered trademarks of Health Level Seven International and their use of these trademarks does not constitute an endorsement by HL7.

This package was inspired by [fhir_questionnaire](https://pub.dev/packages/fhir_questionnaire). Built to allow isolated customization and different ways to render a questionnaire.

## Why fhir_renderer_questionnaire?

- **🎨 Customization** — Replace the default Questionnaire Item widgets with your own to achieve the desired UI.
- **🤸 Flexibility** — Use the RendererView that suits you the best (ListViewRenderer, PageViewRenderer, SliversViewRenderer).
- **🚀 Rapid Development:** Automatically generates UI from FHIR R4 Questionnaires, saving time compared to building forms manually.
- **📝 Automatic QuestionnaireResponse Generation:** Collects user input and produces a valid `QuestionnaireResponse`.
- **⚙️ Behavior Handling:** Manages conditional logic (`enableWhen` and `required`) out of the box.

## 🌟 QuestionnaireListViewRenderer
The `QuestionnaireListViewRenderer` widget will make your

**Ideal for long questionnaires as it uses `ListView.builder` under the hook.**

```dart
import 'package:flutter_fx/flutter_fx.dart';

class HomeController {
  static final Fx<int>  currentTab = 0.toFx;
}
```

## QuestionnairePageViewRenderer

```dart
import 'package:flutter_fx/flutter_fx.dart';

class HomeController {
  static final Fx<int>  currentTab = 0.toFx;
}
```

## QuestionnaireSliverViewRenderer

```dart
import 'package:flutter_fx/flutter_fx.dart';

class HomeController {
  static final Fx<int>  currentTab = 0.toFx;
}
```

## Supported Questionnaire Items

Currently, **fhir_renderer_questionnaire** offers support out of the box to: `group`, `display`, `boolean`, `decimal`, `integer`, `date`, `dateTime`, `time`, `string`, `text`, `url`, `choice`, `openChoice` and `quantity`.