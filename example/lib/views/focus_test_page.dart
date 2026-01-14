import 'dart:developer';

import 'package:example/data/focus_enable_test_mock.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

/// Test page for verifying focus retention and enableWhen behavior
/// in QuestionnaireSliversViewRenderer
class FocusTestPage extends StatelessWidget {
  FocusTestPage({super.key});

  final RendererQuestionnaireController controller =
      RendererQuestionnaireController(
        questionnaire: focusAndEnableWhenTest,
        forceReadOnlyView: false,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus & EnableWhen Test"),
        actions: [
          IconButton(
            onPressed: () {
              final generatedQuestionnaireResponse =
                  controller.generateQuestionnaireResponse();

              // Log the generated response
              log(generatedQuestionnaireResponse.toString());

              // Show a snackbar with validation result
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Response generated! Check debug console.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check),
            tooltip: 'Generate Response',
          ),
        ],
      ),
      body: QuestionnaireSliversViewRenderer(
        rendererController: controller,
        fieldItemBuilder: (
          index,
          isLastItem,
          fieldController,
          selectedResponse,
          questionnaireItem,
          onAnswerChanged,
        ) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: fieldController,
                  style: const TextStyle(fontSize: 14),
                  onChanged: onAnswerChanged,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText:
                        questionnaireItem.text?.valueString ?? 'Enter text...',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
