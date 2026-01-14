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
/// * [RendererQuestionnaireController] - Controller for accessing questionnaire state
///
/// For more information, see the individual widget documentation.
library fhir_renderer_questionnaire;

export 'src/ui/renderers/renderers.dart'
    show
        QuestionnaireListViewRenderer,
        QuestionnairePageViewRenderer,
        QuestionnaireSliversViewRenderer;
export 'src/core/controllers/renderer_questionnaire_controller.dart'
    show RendererQuestionnaireController;

// Mixins for value handling (useful for custom builder implementations)
export 'src/core/mixins/text_field_value_mixin.dart' show TextFieldValueMixin;
export 'src/core/mixins/boolean_value_mixin.dart' show BooleanValueMixin;
export 'src/core/mixins/choice_base_mixin.dart' show ChoiceBaseMixin;
export 'src/core/mixins/open_choice_value_mixin.dart' show OpenChoiceValueMixin;
export 'src/core/mixins/datetime_value_mixin.dart' show DateTimeValueMixin;
export 'src/core/mixins/group_filtering_mixin.dart' show GroupFilteringMixin;

// Factories for component creation (advanced usage)
export 'src/ui/factories/questionnaire_component_factory.dart'
    show QuestionnaireComponentFactory;
export 'src/ui/factories/box_component_factory.dart' show BoxComponentFactory;
export 'src/ui/factories/sliver_component_factory.dart'
    show SliverComponentFactory;
