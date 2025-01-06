import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ollama_provider.dart';
import '../../config/ollama_config.dart';
import '../../services/errors.dart';
import '../../services/logger_service.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

class OllamaSettingsCard extends ConsumerStatefulWidget {
  const OllamaSettingsCard({super.key});

  @override
  ConsumerState<OllamaSettingsCard> createState() => _OllamaSettingsCardState();
}

class _OllamaSettingsCardState extends ConsumerState<OllamaSettingsCard> {
  late TextEditingController _urlController;
  late TextEditingController _modelController;
  late TextEditingController _tempController;
  late TextEditingController _contextController;
  // ignore: unused_field
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(ollamaConfigProvider);
    _urlController = TextEditingController(text: config.baseUrl);
    _modelController = TextEditingController(text: config.model);
    _tempController = TextEditingController(text: config.temperature.toString());
    _contextController = TextEditingController(text: config.connectionTimeout.toString());
  }

  void _resetSettings() {
    final config = const OllamaConfig();
    _urlController.text = config.baseUrl;
    _modelController.text = config.model;
    _tempController.text = config.temperature.toString();
    _contextController.text = config.connectionTimeout.toString();
    setState(() => _isEditing = false);
    
    // Reset config to defaults
    final notifier = ref.read(ollamaConfigProvider.notifier);
    notifier.resetToDefaults();
  }

  /// Save the current settings
  Future<void> _saveSettings() async {
    final currentContext = context;
    final scaffoldMessenger = ScaffoldMessenger.of(currentContext);
    setState(() => _isEditing = false);
    
    try {
      // Validate URL format
      var baseUrl = _urlController.text.trim();
      if (!baseUrl.startsWith('http://') && !baseUrl.startsWith('https://')) {
        baseUrl = 'http://$baseUrl';
      }
      // Remove trailing slashes
      baseUrl = baseUrl.replaceAll(RegExp(r'/+$'), '');

      // Validate model name
      final model = _modelController.text.trim();
      if (model.isEmpty) {
        throw const ValidationError(
          'Model name cannot be empty',
          field: 'model',
        );
      }

      // Validate temperature
      final temperature = double.tryParse(_tempController.text);
      if (temperature == null || temperature < 0 || temperature > 1) {
        throw ValidationError(
          'Temperature must be between 0 and 1',
          field: 'temperature',
          value: _tempController.text,
        );
      }

      // Validate timeout
      final timeout = int.tryParse(_contextController.text);
      if (timeout == null || timeout < 1000) {
        throw ValidationError(
          'Timeout must be at least 1000ms',
          field: 'timeout',
          value: _contextController.text,
        );
      }

      LoggerService.debug('Saving Ollama settings', data: {
        'baseUrl': baseUrl,
        'model': model,
        'temperature': temperature,
        'timeout': timeout,
      });

      // Update config
      final notifier = ref.read(ollamaConfigProvider.notifier);
      await notifier.updateConfig(
        baseUrl: baseUrl,
        model: model,
        temperature: temperature,
        connectionTimeout: timeout,
      );

      if (currentContext.mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Settings saved'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _modelController.dispose();
    _tempController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ollama Settings', style: kHeadline3),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _resetSettings,
                  tooltip: 'Reset to defaults',
                ),
              ],
            ),
            const SizedBox(height: kSpacingMedium),
            Focus(
              onFocusChange: (hasFocus) => setState(() => _isEditing = hasFocus),
              child: TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  helperText: 'The URL where Ollama is running',
                ),
                onChanged: (value) {
                  setState(() => _isEditing = true);
                },
              ),
            ),
            const SizedBox(height: kSpacingMedium),
            Focus(
              onFocusChange: (hasFocus) => setState(() => _isEditing = hasFocus),
              child: TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model Name',
                  helperText: 'The name of the Ollama model to use',
                ),
                onChanged: (value) {
                  setState(() => _isEditing = true);
                },
              ),
            ),
            const SizedBox(height: kSpacingMedium),
            Row(
              children: [
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) => setState(() => _isEditing = hasFocus),
                    child: TextFormField(
                      controller: _tempController,
                      decoration: const InputDecoration(
                        labelText: 'Temperature',
                        helperText: 'Controls randomness (0.0 - 1.0)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        setState(() => _isEditing = true);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: kSpacingMedium),
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) => setState(() => _isEditing = hasFocus),
                    child: TextFormField(
                      controller: _contextController,
                      decoration: const InputDecoration(
                        labelText: 'Connection Timeout',
                        helperText: 'Connection timeout in ms',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => _isEditing = true);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final service = ref.read(ollamaServiceProvider);
                    try {
                      await service.testConnection();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully connected to Ollama'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                    }
                    } catch (e) {
                      if (context.mounted) {
                        final message = e.toString().replaceAll('Exception: ', '');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Test Connection'),
                ),
                const SizedBox(width: kSpacingMedium),
                FilledButton(
                  onPressed: _saveSettings,
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 