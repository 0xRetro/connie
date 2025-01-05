import 'package:flutter/material.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

/// Dialog for creating or editing a person
///
/// Features:
/// - Name input with validation
/// - Super user toggle
/// - Submit and cancel actions
/// - Pre-fill support for editing
class PersonFormDialog extends StatefulWidget {
  /// Initial name for editing (optional)
  final String? initialName;

  /// Initial super user state for editing (optional)
  final bool? initialIsSuperUser;

  /// Callback when form is submitted
  final Future<void> Function(String name, bool isSuperUser) onSubmit;

  const PersonFormDialog({
    super.key,
    this.initialName,
    this.initialIsSuperUser,
    required this.onSubmit,
  });

  @override
  State<PersonFormDialog> createState() => _PersonFormDialogState();
}

class _PersonFormDialogState extends State<PersonFormDialog> {
  late final TextEditingController _nameController;
  late bool _isSuperUser;
  bool _isSubmitting = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _isSuperUser = widget.initialIsSuperUser ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
    });
  }

  Future<void> _handleSubmit() async {
    _validateName();
    if (_nameError != null) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_nameController.text.trim(), _isSuperUser);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialName == null ? 'Create Person' : 'Edit Person',
        style: kHeadline3,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: _nameError,
            ),
            enabled: !_isSubmitting,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: kSpacingMedium),
          SwitchListTile(
            title: const Text('Super User'),
            value: _isSuperUser,
            onChanged: _isSubmitting ? null : (value) {
              setState(() => _isSuperUser = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save'),
        ),
      ],
    );
  }
} 