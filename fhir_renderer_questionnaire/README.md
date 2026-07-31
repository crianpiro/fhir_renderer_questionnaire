# FHIR Renderer Questionnaire

![Static Badge](https://img.shields.io/badge/License-BSD_3_Clause-green) ![Pub Version](https://img.shields.io/pub/v/fhir_renderer_questionnaire?color=blue) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/crianpiro/fhir_renderer_questionnaire?label=bug)

A Flutter package for FHIR® R4 Questionnaires. HL7®, and FHIR® are the registered trademarks of Health Level Seven International and their use of these trademarks does not constitute an endorsement by HL7.

This package was inspired by [fhir_questionnaire](https://pub.dev/packages/fhir_questionnaire). Built to allow isolated customization and different ways to render a [FHIR R4 Questionnaire](https://hl7.org/fhir/R4/questionnaire.html).

## 🔆 Why fhir_renderer_questionnaire?

- **🎨 Customization** — Replace the default Questionnaire Item widgets with your own to achieve the desired UI.
- **🤸 Flexibility** — Use the RendererView that suits you the best (ListViewRenderer, PageViewRenderer, SliversViewRenderer).
- **🚀 Rapid Development:** Automatically generates UI from FHIR R4 Questionnaires, saving time compared to building forms manually.
- **📝 Automatic QuestionnaireResponse Generation:** Collects user input and produces a valid `QuestionnaireResponse`.
- **⚙️ Behavior Handling:** Manages conditional logic (`enableWhen` and `required`) out of the box.

## 🔆 Widgets
✳️  In order to provide full customization, not only for the `QuestionnaireItems` but also the `Questionnaire` itself, there are **three rendering options** to suit specific UI needs: `QuestionnaireListViewRenderer`, `QuestionnairePageViewRenderer` and `QuestionnaireSliversViewRenderer`.

✳️ The three rendering options use by default the theme of your application.

### 💫 QuestionnaireListViewRenderer

<div align="center">
<img src="https://raw.githubusercontent.com/crianpiro/fhir_renderer_questionnaire/main/fhir_renderer_questionnaire/example/assets/list_view_renderer_example.gif" width="220"/>
</a>
</div>


💡 Ideal for long questionnaires as it uses `ListView.builder` under the hook.

```dart
QuestionnaireListViewRenderer(
  rendererController: RendererQuestionnaireController(questionnaire: example),
),
```

### 💫 QuestionnairePageViewRenderer

<div align="center">
<img src="https://raw.githubusercontent.com/crianpiro/fhir_renderer_questionnaire/main/fhir_renderer_questionnaire/example/assets/page_view_renderer_example.gif" width="220"/>
</a>
</div>

💡 Ideal for strict grouping in the questionnaires as gives the user a clear separation of the `QuestionnaireItems`.

```dart
QuestionnairePageViewRenderer(
  rendererController: RendererQuestionnaireController(questionnaire: example),
);
```

### 💫 QuestionnaireSliversViewRenderer

<div align="center">
<img src="https://raw.githubusercontent.com/crianpiro/fhir_renderer_questionnaire/main/fhir_renderer_questionnaire/example/assets/slivers_view_renderer_example.gif" width="220"/>
</a>
</div>

💡 Ideal for fancy behaviors through your questionnaire.

```dart
QuestionnaireSliversViewRenderer(
  rendererController: RendererQuestionnaireController(questionnaire: example),
);
```

> ❗❗ The builders of the `QuestionnaireSliversViewRenderer` expect you to return a `Widget` of type `Sliver`.

## 🔆 Core Capabilities

- **Validation Support**: Custom regex validation via FHIR extensions plus automatic default validation for integer, decimal, url, and quantity types
- **Smart Keyboard Types**: Automatically selects appropriate keyboard (number pad for integers, decimal pad for decimals, URL keyboard for URLs, multiline for text)
- **Conditional Logic**: Full support for `enableWhen` with AND/OR behavior to show/hide items based on user responses
- **Read-Only Mode**: Force the entire questionnaire into read-only mode using `forceReadOnlyView`
- **Initial Values**: Pre-populate questionnaires with existing data using `initialQuestionnaireResponse`
- **Item Control Extensions**: Support for dropdown, radio-button, and checkbox rendering via FHIR `questionnaire-itemControl` extension
- **Exclusive Options**: Support for mutually exclusive "all"/"none" options in multi-select items via the FHIR `questionnaire-optionExclusive` extension. Exclusive options are flagged in the UI with a `**` marker and an explanatory legend
- **Custom Builders**: Replace any default widget with your own implementation for complete UI control
- **Performance Optimized**: EnableWhen caching system and optimized rendering for large questionnaires
- **Memory Management**: Proper cleanup of resources (FocusNode, TextEditingController) to prevent memory leaks

## 🔆 Usage

✳️ The `QuestionnaireListViewRenderer`, `QuestionnairePageViewRenderer` and `QuestionnaireSliversViewRenderer` allow you to customize each QuestionnaireItem widget  by using builders.

Each builder receives:
- `index`, to know its own position within the group or set of items.
- `isLastItem`, a boolean to allow last-item customization.
- `questionnaireItem`, the questionnaire item to display.

The builders for the questionnaire items that allow a user answer receive also:
- `selectedResponse`, the selected questionnaire response item.
- `onAnswerChanged`/`onAnswerOptionSelected`, to notify when the answer changes.

The following example uses the choiceItemBuilder to replace the default UI of the `choice` item type for a custom one:

```dart
import 'package:example/widgets/segmented_choice.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

//Cubit or Bloc or Controller for the view to assign
//the QuestionnaireRendererController instance.
class CubitOrBlocOrController {
  QuestionnaireRendererController? rendererController;
}

class ListViewExamplePage extends StatelessWidget {
  final Questionnaire questionnaire;
  ListViewExamplePage({super.key, required this.questionnaire});

  final CubitOrBlocOrController controller = CubitOrBlocOrController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuestionnaireListViewRenderer"),
        actions: [
          IconButton(
            onPressed: () {
              final generatedQuestionnaireResponse =
                  controller.rendererController
                      ?.getGeneratedQuestionnaireResponse();

              //Do something with the generated response
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: QuestionnaireListViewRenderer(
        rendererController: RendererQuestionnaireController(
          questionnaire: questionnaire,
        ),
        choiceItemBuilder: (
          index,
          isLastItem,
          selectedResponse,
          questionnaireItem,
          onAnswerOptionSelected,
        ) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${questionnaireItem.text}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SegmentedChoice<QuestionnaireAnswerOption>(
                  selectedValue:
                      questionnaireItem.answerOption
                          ?.where(
                            (item) =>
                                item.valueCoding ==
                                selectedResponse
                                    ?.answer
                                    ?.firstOrNull
                                    ?.valueCoding,
                          )
                          .firstOrNull,
                  values: questionnaireItem.answerOption!,
                  valueNameResolver:
                      (value) => "${value.valueCoding?.display?.valueString}",
                  enabled: true,
                  onSelectedValueChanged: (value) {
                    onAnswerOptionSelected(value);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

```


<div align="center" style="align-items:center;">

<h4>Using choiceItemBuilder:</h4>

<img src="https://raw.githubusercontent.com/crianpiro/fhir_renderer_questionnaire/main/fhir_renderer_questionnaire/example/assets/choice_builder_example.gif" width="300"/>
</div>

## 🔆 Supported Questionnaire Items

**fhir_renderer_questionnaire** supports the following **Questionnaire Item types from FHIR R4**:

- `group` - Container for nested items
- `display` - Instructional/display text
- `boolean` - Yes/No questions
- `decimal` - Decimal numbers
- `integer` - Whole numbers
- `date` - Date picker
- `dateTime` - Date and time picker
- `time` - Time picker
- `string` - Short text input
- `text` - Multi-line text input
- `url` - URL input
- `choice` - Single selection from options
- `open-choice` - Choice with free-text option
- `quantity` - Numeric value with units
- `attachment` - File upload (images, PDFs, documents) ✨ **NEW**
- `reference` - Reference to FHIR resources (Practitioner, Patient, etc.) ✨ **NEW**

**16 of 17 FHIR R4 types implemented**

Missing: `question` (deprecated generic type, rarely used)

✳️ **[Use the example project](https://crianpiro.github.io/fhir_renderer_questionnaire/)** ✳️

## 🔆 📣 🔜 Roadmap

🔳 Support for localization extensions

❗❗ The roadmap above was created out of specific needs. If you have ideas for features or important functionality to support, please create an issue with your suggestion.