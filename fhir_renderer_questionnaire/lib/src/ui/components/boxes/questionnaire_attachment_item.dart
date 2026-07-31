import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../layout/inherited_questionnaire_renderer.dart';
import '../../../core/utils/fhir_renderer_questionnaire_response_utils.dart';
import 'base_decorator.dart';
import '../questionnaire_base_item.dart';

/// Widget for rendering attachment-type questionnaire items.
///
/// Allows users to pick files (images, PDFs, documents) and upload them
/// as Base64-encoded attachments. Supports single or multiple files based
/// on the questionnaire item's `repeats` property.
class QuestionnaireAttachmentItem extends QuestionnaireBaseItem {
  const QuestionnaireAttachmentItem({
    required super.questionnaireItem,
    required super.index,
    required super.isLastItem,
    super.key,
  });

  @override
  Widget buildQuestionnaireItem(BuildContext context) {
    final inheritedData = InheritedQuestionnaireRenderer.of(context);
    final currentResponse = findQuestionnaireResponseItem(
      inheritedData.questionnaireResponse,
      itemLinkId,
    );

    final allowMultiple = questionnaireItem.repeats?.valueBoolean ?? false;
    final existingAttachments = currentResponse?.answer
            ?.map((a) => a.valueAttachment)
            .whereType<Attachment>()
            .toList() ??
        [];

    return BaseDecorator(
      title: itemTextTitle,
      roundBottomBorder: isLastItem,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display existing attachments
            if (existingAttachments.isNotEmpty)
              ...existingAttachments.asMap().entries.map((entry) {
                final idx = entry.key;
                final attachment = entry.value;
                return _AttachmentPreview(
                  attachment: attachment,
                  onRemove: () => _removeAttachment(
                    context,
                    inheritedData,
                    idx,
                    existingAttachments,
                  ),
                );
              }),

            // Add file button
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _pickFile(
                context,
                inheritedData,
                allowMultiple,
                existingAttachments,
              ),
              icon: const Icon(Icons.attach_file),
              label: Text(
                existingAttachments.isEmpty
                    ? 'Select File'
                    : (allowMultiple ? 'Add Another File' : 'Replace File'),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
            ),

            // Helper text
            const SizedBox(height: 8),
            Text(
              allowMultiple
                  ? 'You can attach multiple files'
                  : 'Only one file can be attached',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(
    BuildContext context,
    InheritedQuestionnaireRenderer inheritedData,
    bool allowMultiple,
    List<Attachment> existingAttachments,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple && existingAttachments.isEmpty,
        type: FileType.any,
        withData: true, // Get file bytes for Base64 encoding
      );

      if (result == null || result.files.isEmpty) return;

      final newAttachments = <Attachment>[];

      for (final file in result.files) {
        if (file.bytes != null) {
          // Web platform - use bytes directly
          final attachment = await _createAttachmentFromBytes(
            file.bytes!,
            file.name,
            file.extension,
          );
          newAttachments.add(attachment);
        } else if (file.path != null) {
          // Mobile/Desktop - read file
          final fileData = await File(file.path!).readAsBytes();
          final attachment = await _createAttachmentFromBytes(
            fileData,
            file.name,
            file.extension,
          );
          newAttachments.add(attachment);
        }
      }

      if (newAttachments.isEmpty) return;

      // Combine with existing attachments or replace
      final allAttachments = allowMultiple
          ? [...existingAttachments, ...newAttachments]
          : newAttachments;

      if (!context.mounted) return;
      _updateResponse(context, inheritedData, allAttachments);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<Attachment> _createAttachmentFromBytes(
    Uint8List bytes,
    String fileName,
    String? extension,
  ) async {
    // Encode to Base64
    final base64Data = base64Encode(bytes);

    // Determine MIME type
    String? mimeType;
    if (extension != null) {
      mimeType = lookupMimeType(fileName);
    }
    mimeType ??= 'application/octet-stream';

    return Attachment(
      contentType: FhirCode(mimeType),
      data: FhirBase64Binary(base64Data),
      title: FhirString(fileName),
      size: FhirUnsignedInt(bytes.length),
      creation: FhirDateTime.fromDateTime(DateTime.now()),
    );
  }

  void _removeAttachment(
    BuildContext context,
    InheritedQuestionnaireRenderer inheritedData,
    int index,
    List<Attachment> existingAttachments,
  ) {
    final updatedAttachments = List<Attachment>.from(existingAttachments)
      ..removeAt(index);

    _updateResponse(context, inheritedData, updatedAttachments);
  }

  void _updateResponse(
    BuildContext context,
    InheritedQuestionnaireRenderer inheritedData,
    List<Attachment> attachments,
  ) {
    QuestionnaireResponse resp;

    if (attachments.isEmpty) {
      // Clear the answer
      resp = FhirRendererQuestionnaireResponseUtils
          .setResponseAnswerInQuestionnaireResponse(
        inheritedData.questionnaireResponse,
        questionnaireItem,
        null,
      );
    } else if (attachments.length == 1) {
      // Single attachment
      resp = FhirRendererQuestionnaireResponseUtils
          .setResponseAnswerInQuestionnaireResponse(
        inheritedData.questionnaireResponse,
        questionnaireItem,
        QuestionnaireResponseAnswer(valueX: attachments.first),
      );
    } else {
      // Multiple attachments - use the existing item and update answers directly
      resp = inheritedData.questionnaireResponse;
      final responseItem = findQuestionnaireResponseItem(
        resp,
        itemLinkId,
      );

      if (responseItem != null) {
        final answers = attachments
            .map((a) => QuestionnaireResponseAnswer(valueX: a))
            .toList();

        // Create updated response item with multiple answers
        final updatedItem = responseItem.copyWith(answer: answers);

        // Replace in the response hierarchy
        resp = _replaceResponseItem(resp, updatedItem);
      }
    }

    inheritedData.onResponseChanged(resp);
  }

  QuestionnaireResponse _replaceResponseItem(
    QuestionnaireResponse response,
    QuestionnaireResponseItem updatedItem,
  ) {
    List<QuestionnaireResponseItem> modifiedItems = [];

    if (response.item != null) {
      for (final item in response.item!) {
        if (item.linkId.valueString == updatedItem.linkId.valueString) {
          modifiedItems.add(updatedItem);
        } else if (item.item != null) {
          // Recursively search in nested items
          modifiedItems.add(_replaceInNestedItems(item, updatedItem));
        } else {
          modifiedItems.add(item);
        }
      }
    }

    return response.copyWith(item: modifiedItems);
  }

  QuestionnaireResponseItem _replaceInNestedItems(
    QuestionnaireResponseItem parent,
    QuestionnaireResponseItem updatedItem,
  ) {
    if (parent.linkId.valueString == updatedItem.linkId.valueString) {
      return updatedItem;
    }

    if (parent.item != null) {
      final modifiedChildren = <QuestionnaireResponseItem>[];
      for (final child in parent.item!) {
        modifiedChildren.add(_replaceInNestedItems(child, updatedItem));
      }
      return parent.copyWith(item: modifiedChildren);
    }

    return parent;
  }
}

/// Preview widget for displaying an attachment
class _AttachmentPreview extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback onRemove;

  const _AttachmentPreview({
    required this.attachment,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = attachment.title?.valueString ?? 'Attachment';
    final fileSize = attachment.size?.valueInt;
    final mimeType = attachment.contentType?.valueString;

    // Determine icon based on MIME type
    IconData icon = Icons.insert_drive_file;
    Color iconColor = Colors.grey;

    if (mimeType != null) {
      if (mimeType.startsWith('image/')) {
        icon = Icons.image;
        iconColor = Colors.blue;
      } else if (mimeType.startsWith('video/')) {
        icon = Icons.video_file;
        iconColor = Colors.purple;
      } else if (mimeType.startsWith('audio/')) {
        icon = Icons.audio_file;
        iconColor = Colors.orange;
      } else if (mimeType.contains('pdf')) {
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
      } else if (mimeType.contains('zip') || mimeType.contains('archive')) {
        icon = Icons.folder_zip;
        iconColor = Colors.amber;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatFileSize(fileSize),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: onRemove,
          tooltip: 'Remove attachment',
        ),
      ),
    );
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return 'Unknown size';

    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
