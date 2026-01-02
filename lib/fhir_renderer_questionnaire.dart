/// A Flutter package for rendering FHIR Questionnaires.
///
/// This library provides widgets and controllers to render FHIR R4 questionnaires
/// in Flutter applications. It supports multiple rendering layouts:
///
/// * **List View** - Displays all questionnaire items in a scrollable list
/// * **Page View** - Displays questionnaire items as paginated screens for step-by-step navigation
/// * **Slivers View** - Uses slivers for advanced scrolling behavior and custom layouts
///
/// ## Usage
///
/// Import the package and choose a renderer based on your UI needs:
///
/// ```dart
/// import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
///
/// // Use QuestionnaireListViewRenderer for list-based layout
/// // Use QuestionnairePageViewRenderer for paginated layout
/// // Use QuestionnaireSliversViewRenderer for sliver-based layout
/// ```
///
/// ## Key Components
///
/// * [QuestionnaireListViewRenderer] - List-based questionnaire renderer
/// * [QuestionnairePageViewRenderer] - Page-based questionnaire renderer
/// * [QuestionnaireSliversViewRenderer] - Sliver-based questionnaire renderer
/// * [QuestionnaireRendererController] - Controller for accessing questionnaire state
///
/// For more information, see the individual widget documentation.
library fhir_renderer_questionnaire;

export 'src/ui/renderers/renderers.dart'
    show
        QuestionnaireListViewRenderer,
        QuestionnairePageViewRenderer,
        QuestionnaireSliversViewRenderer;
export 'src/core/controllers/questionnaire_renderer_controller.dart'
    show QuestionnaireRendererController;
