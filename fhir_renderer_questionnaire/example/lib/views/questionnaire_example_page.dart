import 'dart:developer';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
import 'package:flutter/material.dart';

/// Enum for selecting which renderer to use
enum RendererType { listView, pageView, slivers }

/// A reusable example page that can display any questionnaire
/// using any of the three available renderers
class QuestionnaireExamplePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final String title;
  final RendererType initialRenderer;
  final bool forceReadOnly;

  const QuestionnaireExamplePage({
    super.key,
    required this.questionnaire,
    required this.title,
    this.initialRenderer = RendererType.listView,
    this.forceReadOnly = false,
  });

  @override
  State<QuestionnaireExamplePage> createState() =>
      _QuestionnaireExamplePageState();
}

class _QuestionnaireExamplePageState extends State<QuestionnaireExamplePage> {
  late RendererType _selectedRenderer;
  late RendererQuestionnaireController _controller;

  @override
  void initState() {
    super.initState();
    _selectedRenderer = widget.initialRenderer;
    _initController();
  }

  void _initController() {
    _controller = RendererQuestionnaireController(
      questionnaire: widget.questionnaire,
      forceReadOnlyView: widget.forceReadOnly,
      pageViewController: PageController(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchRenderer(RendererType type) {
    if (_selectedRenderer != type) {
      setState(() {
        _selectedRenderer = type;
        // Reinitialize controller when switching renderers
        _controller.dispose();
        _initController();
      });
    }
  }

  void _generateResponse() {
    final response = _controller.generateQuestionnaireResponse();
    log(response.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Response generated! Check debug console.'),
        duration: Duration(seconds: 2),
      ),
    );

    // Show dialog with response summary
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('QuestionnaireResponse Generated'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Status: ${response.status}'),
                  const SizedBox(height: 8),
                  Text('Items: ${response.item?.length ?? 0}'),
                  const SizedBox(height: 8),
                  Text('Authored: ${response.authored?.valueString ?? "N/A"}'),
                  const Divider(),
                  const Text(
                    'Full response logged to console.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _generateResponse,
            icon: const Icon(Icons.check),
            tooltip: 'Generate Response',
          ),
        ],
      ),
      body: Column(
        children: [
          // Renderer selector
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Renderer: '),
                const SizedBox(width: 8),
                SegmentedButton<RendererType>(
                  segments: const [
                    ButtonSegment(
                      value: RendererType.listView,
                      label: Text('ListView'),
                      icon: Icon(Icons.view_list),
                    ),
                    ButtonSegment(
                      value: RendererType.pageView,
                      label: Text('PageView'),
                      icon: Icon(Icons.view_carousel),
                    ),
                    ButtonSegment(
                      value: RendererType.slivers,
                      label: Text('Slivers'),
                      icon: Icon(Icons.view_day),
                    ),
                  ],
                  selected: {_selectedRenderer},
                  onSelectionChanged: (selected) {
                    _switchRenderer(selected.first);
                  },
                ),
              ],
            ),
          ),
          // Renderer content
          Expanded(child: _buildRenderer()),
        ],
      ),
    );
  }

  Widget _buildRenderer() {
    switch (_selectedRenderer) {
      case RendererType.listView:
        return QuestionnaireListViewRenderer(
          useExpansibleGroups: true,
          rendererController: _controller,
        );
      case RendererType.pageView:
        return QuestionnairePageViewRenderer(rendererController: _controller);
      case RendererType.slivers:
        return QuestionnaireSliversViewRenderer(
          rendererController: _controller,
          groupItemBuilder: _buildSliverGroup,
        );
    }
  }

  Widget _buildSliverGroup(
    int index,
    bool isLastItem,
    QuestionnaireItem questionnaireItem,
    Widget Function(QuestionnaireItem questionnaireItem, int index)
    childrenAssigner,
  ) {
    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          key: Key("${questionnaireItem.linkId.valueString}"),
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.folder_outlined),
              ),
              Flexible(
                child: Text(
                  "${questionnaireItem.text?.valueString}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        if (questionnaireItem.item != null)
          DecoratedSliver(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverMainAxisGroup(
                slivers: List.generate(
                  questionnaireItem.item!.length,
                  (i) => childrenAssigner(questionnaireItem.item![i], i),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
