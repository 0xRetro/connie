import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ollama_provider.dart';
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';

class OllamaSettingsCard extends ConsumerStatefulWidget {
  const OllamaSettingsCard({super.key});

  @override
  ConsumerState<OllamaSettingsCard> createState() => _OllamaSettingsCardState();
}

class _OllamaSettingsCardState extends ConsumerState<OllamaSettingsCard> {
  late final TextEditingController _urlController;
  late final TextEditingController _modelController;
  late final TextEditingController _tempController;
  late final TextEditingController _contextController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final config = ref.read(ollamaConfigProvider).valueOrNull;
    _urlController = TextEditingController(text: config?.baseUrl ?? 'http://localhost:11434');
    _modelController = TextEditingController(text: config?.model ?? 'llama2');
    _tempController = TextEditingController(text: (config?.temperature ?? 0.7).toString());
    _contextController = TextEditingController(text: (config?.contextLength ?? 4096).toString());
  }

  void _updateControllersFromConfig(config) {
    if (!_isEditing) {
      _urlController.text = config.baseUrl;
      _modelController.text = config.model;
      _tempController.text = config.temperature.toString();
      _contextController.text = config.contextLength.toString();
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
    final configAsync = ref.watch(ollamaConfigProvider);
    final notifier = ref.read(ollamaConfigProvider.notifier);

    ref.listen(ollamaConfigProvider, (previous, next) {
      next.whenData((config) => _updateControllersFromConfig(config));
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: configAsync.when(
          data: (config) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ollama Settings', style: kHeadline3),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        setState(() => _isEditing = false);
                        await notifier.resetToDefaults();
                        await notifier.saveSettings();
                      },
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
                      notifier.updateBaseUrl(value);
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
                      notifier.updateModelName(value);
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
                            final temp = double.tryParse(value);
                            if (temp != null) notifier.updateTemperature(temp);
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
                            labelText: 'Context Length',
                            helperText: 'Maximum context length',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() => _isEditing = true);
                            final length = int.tryParse(value);
                            if (length != null) notifier.updateContextLength(length);
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
                        final isConnected = await notifier.testConnection();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isConnected 
                                  ? 'Successfully connected to Ollama'
                                  : 'Failed to connect to Ollama',
                              ),
                              backgroundColor: isConnected ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Test Connection'),
                    ),
                    const SizedBox(width: kSpacingMedium),
                    FilledButton(
                      onPressed: () async {
                        try {
                          setState(() => _isEditing = false);
                          await notifier.saveSettings();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Settings saved successfully'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save settings: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Save Settings'),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(kSpacingLarge),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(kSpacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Error loading Ollama settings:', style: TextStyle(color: Colors.red)),
                const SizedBox(height: kSpacingSmall),
                Text(error.toString(), style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 