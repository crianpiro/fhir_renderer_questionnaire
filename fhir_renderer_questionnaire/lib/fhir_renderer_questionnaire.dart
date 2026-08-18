/// A Flutter package for rendering FHIR® R4 Questionnaires.
///
/// This library provides widgets and controllers to render FHIR® R4 questionnaires
/// in Flutter applications. It supports multiple rendering layouts:
///
/// * **List View** - Displays all questionnaire items in a scrollable list
/// * **Page View** - Displays questionnaire items as paginated screens for step-by-step navigation
/// * **Slivers View** - Uses slivers for advanced scrolling behavior and custom layouts
///
/// ## Quick Start
///
/// Import the package and choose a renderer based on your UI needs:
///
/// ```dart
/// import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
///
/// // Create a controller
/// final controller = RendererQuestionnaireController(
///   questionnaire: myQuestionnaire,
/// );
///
/// // Use a renderer widget
/// QuestionnaireListViewRenderer(
///   rendererController: controller,
/// )
/// ```
///
/// ## Key Components
///
/// ### Renderers
/// * [QuestionnaireListViewRenderer] - List-based questionnaire renderer
/// * [QuestionnairePageViewRenderer] - Page-based questionnaire renderer
/// * [QuestionnaireSliversViewRenderer] - Sliver-based questionnaire renderer
///
/// ### Controller
/// * [RendererQuestionnaireController] - Controller for managing questionnaire state
///
/// ### Utilities
/// * [FhirRendererQuestionnaireUtils] - Utility methods for enableWhen evaluation
/// * [FhirRendererQuestionnaireResponseUtils] - Utility methods for response manipulation
/// * [KeyboardTypeHelper] - Keyboard configuration for field types
/// * [DefaultValidationPatterns] - Default regex validation patterns
///
/// ### Builder Types
/// Use these type definitions when implementing custom builders:
/// * [QuestionnaireDisplayWidgetBuilder] - For display items
/// * [QuestionnaireFieldWidgetBuilder] - For text field items
/// * [QuestionnaireBooleanWidgetBuilder] - For boolean items
/// * [QuestionnaireChoiceWidgetBuilder] - For choice/open-choice items
/// * [QuestionnaireDateTimeWidgetBuilder] - For date/time items
/// * [QuestionnaireGroupWidgetBuilder] - For group items
/// * [QuestionnaireReferenceWidgetBuilder] - For reference items
/// * [QuestionnaireAttachmentWidgetBuilder] - For attachment items
///
/// ## Custom Builders
///
/// To customize widget rendering, use the mixins provided:
/// * [TextFieldValueMixin] - For text field value handling
/// * [BooleanValueMixin] - For boolean value handling
/// * [ChoiceBaseMixin] - For choice value handling
/// * [OpenChoiceValueMixin] - For open-choice value handling
/// * [DateTimeValueMixin] - For date/time value handling
/// * [RegexValidationMixin] - For input validation
/// * [ChoiceWidgetBuilderMixin] - For choice widget building
///
/// ## FHIR SDC Extensions
///
/// The package supports the following FHIR SDC extensions:
/// * `questionnaire-itemControl` - For dropdown rendering (`drop-down`, `radio-button`, `check-box`)
/// * `questionnaire-optionExclusive` - For a mutually exclusive "all"/"none" option in multi-select items
/// * `regex` - For custom input validation patterns
/// * `entryFormat` - For custom validation error messages
/// For more information, see the individual class documentation.
library fhir_renderer_questionnaire;

// ============================================================================
// MAIN RENDERERS
// ============================================================================

/// Main renderer widgets for displaying questionnaires
export 'src/ui/renderers/renderers.dart'
    show
        QuestionnaireListViewRenderer,
        QuestionnairePageViewRenderer,
        QuestionnaireSliversViewRenderer;

// ============================================================================
// CONTROLLER
// ============================================================================

/// Controller for managing questionnaire state and responses
export 'src/core/controllers/renderer_questionnaire_controller.dart'
    show RendererQuestionnaireController;

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

/// Builder callback types for custom widget implementations
export 'src/core/definitions/type_definitions.dart'
    show
        QuestionnaireDisplayWidgetBuilder,
        QuestionnaireDateTimeWidgetBuilder,
        QuestionnaireBooleanWidgetBuilder,
        QuestionnaireGroupWidgetBuilder,
        QuestionnaireChoiceWidgetBuilder,
        QuestionnaireFieldWidgetBuilder,
        QuestionnaireReferenceWidgetBuilder,
        QuestionnaireAttachmentWidgetBuilder;

// ============================================================================
// UTILITIES
// ============================================================================

/// Core utility classes for questionnaire processing
export 'src/core/utils/fhir_renderer_questionnaire_utils.dart'
    show FhirRendererQuestionnaireUtils;
export 'src/core/utils/fhir_renderer_questionnaire_response_utils.dart'
    show FhirRendererQuestionnaireResponseUtils;
export 'src/core/utils/keyboard_type_helper.dart' show KeyboardTypeHelper;

// ============================================================================
// VALIDATION
// ============================================================================

/// Validation utilities for field input
export 'src/core/validation/default_validation_patterns.dart'
    show DefaultValidationPatterns;

/// Response verification: what is missing or malformed, rendered or not
export 'src/core/validation/questionnaire_finding.dart'
    show QuestionnaireFinding, QuestionnaireFindingReason;
export 'src/core/validation/questionnaire_validator.dart'
    show QuestionnaireValidator;

// ============================================================================
// MIXINS - Value Handling
// ============================================================================

/// Mixins for value extraction and handling in custom builders
export 'src/core/mixins/text_field_value_mixin.dart' show TextFieldValueMixin;
export 'src/core/mixins/boolean_value_mixin.dart' show BooleanValueMixin;
export 'src/core/mixins/choice_base_mixin.dart' show ChoiceBaseMixin;
export 'src/core/mixins/open_choice_value_mixin.dart' show OpenChoiceValueMixin;
export 'src/core/mixins/datetime_value_mixin.dart' show DateTimeValueMixin;
export 'src/core/mixins/group_filtering_mixin.dart' show GroupFilteringMixin;
export 'src/core/mixins/regex_validation_mixin.dart' show RegexValidationMixin;
export 'src/core/mixins/choice_widget_builder_mixin.dart'
    show ChoiceWidgetBuilderMixin;

// ============================================================================
// EXTENSIONS
// ============================================================================

/// Extension methods for FHIR objects
export 'src/core/extensions/fhir_extensions.dart'
    show
        FhirExtensionListLookup,
        QuestionnaireExtensionUrls,
        QuestionnaireItemDisplayExtensions,
        QuestionnaireItemValidationExtensions,
        QuestionnaireAnswerOptionExtensions;

// ============================================================================
// MODELS
// ============================================================================

/// The FHIR R4 Questionnaire and QuestionnaireResponse models.
///
/// This package defines its own models rather than depending on `fhir_r4`, so
/// it stays light and does not force a FHIR library choice on its users.
/// Build them from FHIR JSON with `fromJson` and serialize with `toJson`.
export 'src/core/models/models.dart';

// ============================================================================
// FACTORIES
// ============================================================================

/// Factories for component creation (advanced usage)
export 'src/ui/factories/questionnaire_component_factory.dart'
    show QuestionnaireComponentFactory;
export 'src/ui/factories/box_component_factory.dart' show BoxComponentFactory;
export 'src/ui/factories/sliver_component_factory.dart'
    show SliverComponentFactory;
