import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_choice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireChoiceItem', () {
    testWidgets('should render with title text', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'gender',
        text: 'What is your gender?',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('What is your gender?'), findsOneWidget);
    });

    testWidgets('should render answer options', (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'gender',
        text: 'What is your gender?',
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'male',
              display: 'Male',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'female',
              display: 'Female',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'other',
              display: 'Other',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('should render radio buttons for single selection',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'gender',
        text: 'What is your gender?',
        repeats: false,
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Single choice items render RadioListTile<String> with option codes
      expect(find.byType(RadioListTile<String>), findsWidgets);
    });

    testWidgets('should update response when option is selected',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'gender',
        text: 'What is your gender?',
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'male',
              display: 'Male',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'female',
              display: 'Female',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Tap on "Male" option
      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();

      // Verify response was updated
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId == 'gender',
      );
      expect(
        responseItem?.answer?.first.valueCoding?.code,
        equals('male'),
      );
    });

    testWidgets('should render checkboxes for multiple selection',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'hobbies',
        text: 'Select your hobbies',
        repeats: true,
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'reading',
              display: 'Reading',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'sports',
              display: 'Sports',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Multi-select items render CheckboxListTile
      expect(find.byType(CheckboxListTile), findsNWidgets(2));
    });

    testWidgets('should allow multiple selections when repeats is true',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'hobbies',
        text: 'Select your hobbies',
        repeats: true,
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'reading',
              display: 'Reading',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'sports',
              display: 'Sports',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      QuestionnaireResponse? capturedResponse;

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          onResponseChanged: (response) {
            capturedResponse = response;
          },
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Select "Reading"
      await tester.tap(find.text('Reading'));
      await tester.pumpAndSettle();

      // Select "Sports"
      await tester.tap(find.text('Sports'));
      await tester.pumpAndSettle();

      // Verify both options are selected
      expect(capturedResponse, isNotNull);
      final responseItem = capturedResponse!.item?.firstWhere(
        (i) => i.linkId == 'hobbies',
      );
      expect(responseItem?.answer?.length, equals(2));
    });

    testWidgets('should show existing response value',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'gender',
        text: 'What is your gender?',
        answerOptions: [
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'male',
              display: 'Male',
            ),
          ),
          const QuestionnaireAnswerOption(
            valueCoding: Coding(
              code: 'female',
              display: 'Female',
            ),
          ),
        ],
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: 'gender',
            answer: [
              QuestionnaireResponseAnswer(
                valueCoding: const Coding(
                  code: 'female',
                  display: 'Female',
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          initialResponse: initialResponse,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // RadioListTile<String> uses option code strings for value/groupValue
      final radioTiles = tester.widgetList<RadioListTile<String>>(
        find.byType(RadioListTile<String>),
      );

      // Verify the "female" option is selected by checking groupValue matches value
      bool foundSelected = false;
      for (final tile in radioTiles) {
        // The tile with value 'female' should have groupValue == 'female' (selected)
        if (tile.value == 'female' && tile.groupValue == 'female') {
          foundSelected = true;
          break;
        }
      }
      expect(foundSelected, isTrue);
    });

    testWidgets('should render default options when no options provided',
        (WidgetTester tester) async {
      final item = WidgetTestHelpers.createChoiceItem(
        linkId: 'choice',
        text: 'Select an option',
      );
      final questionnaire = WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireChoiceItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should render the default options from helper
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    group('exclusive option indicator', () {
      QuestionnaireItem buildGenderItem() {
        return WidgetTestHelpers.createChoiceItem(
          linkId: 'gender',
          text: 'Select a gender',
          repeats: true,
          answerOptions: [
            QuestionnaireAnswerOption.fromJson({
              'valueCoding': {'code': 'male', 'display': 'Male'},
              'extension': [
                {
                  'url':
                      'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
                  'valueBoolean': true,
                },
              ],
            }),
            QuestionnaireAnswerOption.fromJson({
              'valueCoding': {'code': 'female', 'display': 'Female'},
              'extension': [
                {
                  'url':
                      'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
                  'valueBoolean': true,
                },
              ],
            }),
            QuestionnaireAnswerOption.fromJson({
              'valueCoding': {'code': 'other', 'display': 'Other'},
              'extension': [
                {
                  'url':
                      'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
                  'valueBoolean': true,
                },
              ],
            }),
          ],
        );
      }

      testWidgets('marks exclusive options with ** and shows the legend',
          (WidgetTester tester) async {
        final item = buildGenderItem();
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireChoiceItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(
          find.text('Options marked with ** are exclusive.'),
          findsOneWidget,
        );
        expect(find.text('Male **'), findsOneWidget);
        expect(find.text('Female **'), findsOneWidget);
        expect(find.text('Other **'), findsOneWidget);
      });

      testWidgets('omits marker and legend when no option is exclusive',
          (WidgetTester tester) async {
        final item = WidgetTestHelpers.createChoiceItem(
          linkId: 'gender',
          text: 'Select a gender',
          repeats: true,
          answerOptions: [
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'male',
                display: 'Male',
              ),
            ),
            const QuestionnaireAnswerOption(
              valueCoding: Coding(
                code: 'female',
                display: 'Female',
              ),
            ),
          ],
        );
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireChoiceItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(
          find.text('Options marked with ** are exclusive.'),
          findsNothing,
        );
        expect(find.text('Male'), findsOneWidget);
        expect(find.text('Male **'), findsNothing);
      });

      testWidgets(
          'shows marker and legend together for a check-box control without '
          'repeats', (WidgetTester tester) async {
        // A check-box itemControl forces checkboxes even when repeats is false.
        // The marker and legend must still appear together in that case.
        final item = QuestionnaireItem.fromJson({
          'linkId': 'gender',
          'type': 'choice',
          'text': 'Select a gender',
          'extension': [
            {
              'url':
                  'http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl',
              'valueCodeableConcept': {
                'coding': [
                  {
                    'system': 'http://hl7.org/fhir/questionnaire-item-control',
                    'code': 'check-box',
                  },
                ],
              },
            },
          ],
          'answerOption': [
            {
              'valueCoding': {'code': 'male', 'display': 'Male'},
            },
            {
              'valueCoding': {'code': 'none', 'display': 'Prefer not to say'},
              'extension': [
                {
                  'url':
                      'http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive',
                  'valueBoolean': true,
                },
              ],
            },
          ],
        });
        final questionnaire =
            WidgetTestHelpers.createQuestionnaire(items: [item]);

        await tester.pumpWidget(
          TestQuestionnaireWrapper(
            questionnaire: questionnaire,
            child: QuestionnaireChoiceItem(
              questionnaireItem: item,
              index: 0,
              isLastItem: true,
            ),
          ),
        );

        expect(
          find.text('Options marked with ** are exclusive.'),
          findsOneWidget,
        );
        expect(find.text('Prefer not to say **'), findsOneWidget);
        expect(find.text('Male'), findsOneWidget);
        expect(find.text('Male **'), findsNothing);
      });
    });
  });
}
