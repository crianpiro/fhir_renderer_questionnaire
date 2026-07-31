import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/src/ui/components/boxes/questionnaire_attachment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../widget_test_helpers.dart';

void main() {
  group('QuestionnaireAttachmentItem', () {
    QuestionnaireItem createAttachmentItem({
      required String linkId,
      String? text,
      bool? repeats,
    }) {
      return QuestionnaireItem(
        linkId: FhirString(linkId),
        type: QuestionnaireItemType.attachment,
        text: text != null ? FhirString(text) : null,
        repeats: repeats != null ? FhirBoolean(repeats) : null,
      );
    }

    testWidgets('should render with title text', (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Upload your document'), findsOneWidget);
    });

    testWidgets('should render select file button', (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );
      await tester.pump();

      // Check that the button exists by finding the text
      expect(find.text('Select File'), findsOneWidget);
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });

    testWidgets('should show attach icon', (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
    });

    testWidgets('should show single file helper text when repeats is false',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
        repeats: false,
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('Only one file can be attached'), findsOneWidget);
    });

    testWidgets('should show multiple files helper text when repeats is true',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'documents',
        text: 'Upload your documents',
        repeats: true,
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      await tester.pumpWidget(
        TestQuestionnaireWrapper(
          questionnaire: questionnaire,
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.text('You can attach multiple files'), findsOneWidget);
    });

    testWidgets('should display existing attachment',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: FhirString('document'),
            answer: [
              QuestionnaireResponseAnswer(
                valueX: Attachment(
                  contentType: FhirCode('application/pdf'),
                  title: FhirString('test-document.pdf'),
                  size: FhirUnsignedInt(1024),
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
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should display the attachment filename
      expect(find.text('test-document.pdf'), findsOneWidget);
      // File size is 1024 bytes = 1 KB (implementation uses .toStringAsFixed(1))
      expect(find.text('1.0 KB'), findsOneWidget);
      // Should show replace button instead of select
      expect(find.text('Replace File'), findsOneWidget);
    });

    testWidgets('should show close icon for removing attachment',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: FhirString('document'),
            answer: [
              QuestionnaireResponseAnswer(
                valueX: Attachment(
                  contentType: FhirCode('application/pdf'),
                  title: FhirString('test-document.pdf'),
                  size: FhirUnsignedInt(1024),
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
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      // Should display close icon for removing
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should show PDF icon for PDF attachments',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'document',
        text: 'Upload your document',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: FhirString('document'),
            answer: [
              QuestionnaireResponseAnswer(
                valueX: Attachment(
                  contentType: FhirCode('application/pdf'),
                  title: FhirString('test.pdf'),
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
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
    });

    testWidgets('should show image icon for image attachments',
        (WidgetTester tester) async {
      final item = createAttachmentItem(
        linkId: 'photo',
        text: 'Upload your photo',
      );
      final questionnaire =
          WidgetTestHelpers.createQuestionnaire(items: [item]);

      final initialResponse = QuestionnaireResponse(
        status: QuestionnaireResponseStatus.inProgress,
        item: [
          QuestionnaireResponseItem(
            linkId: FhirString('photo'),
            answer: [
              QuestionnaireResponseAnswer(
                valueX: Attachment(
                  contentType: FhirCode('image/png'),
                  title: FhirString('photo.png'),
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
          child: QuestionnaireAttachmentItem(
            questionnaireItem: item,
            index: 0,
            isLastItem: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.image), findsOneWidget);
    });
  });
}
