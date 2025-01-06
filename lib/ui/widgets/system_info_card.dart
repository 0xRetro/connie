import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';
import '../../config/environment.dart';

/// A card widget that displays read-only system information
class SystemInfoCard extends ConsumerWidget {
  const SystemInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Information', style: kHeadline2),
            const SizedBox(height: kSpacingMedium),
            
            // Environment Information
            _buildSection(
              'Environment',
              [
                _buildInfoRow('Mode', Environment.isDevelopment ? 'Development' : 'Production'),
                _buildInfoRow('Environment', Environment.name),
                _buildInfoRow('Debug Info', Environment.showDebugInfo ? 'Enabled' : 'Disabled'),
                _buildInfoRow('File Logging', Environment.enableFileLogging ? 'Enabled' : 'Disabled'),
                _buildInfoRow('Analytics', Environment.enableAnalytics ? 'Enabled' : 'Disabled'),
                if (!kIsWeb) FutureBuilder<String>(
                  future: _getLogsDirectory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildInfoRow('Logs Directory', snapshot.data!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: kSpacingMedium),
            
            // App Information
            _buildSection(
              'Application',
              [
                _buildInfoRow('Version', Environment.appVersion),
                _buildInfoRow('API Endpoint', Environment.apiEndpoint),
                _buildInfoRow('Platform', _getPlatformInfo()),
                if (!kIsWeb) _buildInfoRow('OS Version', _getOSVersion()),
                _buildInfoRow('Dart Version', _getDartVersion()),
                _buildInfoRow('Debug Mode', kDebugMode ? 'Yes' : 'No'),
                _buildInfoRow('Profile Mode', kProfileMode ? 'Yes' : 'No'),
                _buildInfoRow('Release Mode', kReleaseMode ? 'Yes' : 'No'),
              ],
            ),

            const SizedBox(height: kSpacingMedium),

            // System Resources
            _buildSection(
              'System Resources',
              [
                _buildInfoRow('Locale', Localizations.localeOf(context).toString()),
                _buildInfoRow('Text Scale', MediaQuery.textScaleFactorOf(context).toStringAsFixed(2)),
                _buildInfoRow('Screen Size', _getScreenSize(context)),
                _buildInfoRow('Pixel Ratio', MediaQuery.devicePixelRatioOf(context).toStringAsFixed(2)),
                _buildInfoRow('Platform Brightness', 
                  MediaQuery.platformBrightnessOf(context).toString().split('.').last),
              ],
            ),

            const SizedBox(height: kSpacingMedium),

            // Database Information
            ...[
            _buildSection(
              'Database',
              [
                if (Environment.databaseConfig['maxConnections'] != null)
                  _buildInfoRow('Max Connections', 
                    Environment.databaseConfig['maxConnections'].toString()),
                if (Environment.databaseConfig['enableCache'] != null)
                  _buildInfoRow('Cache Enabled', 
                    Environment.databaseConfig['enableCache'] ? 'Yes' : 'No'),
                if (Environment.databaseConfig['logQueries'] != null)
                  _buildInfoRow('Query Logging', 
                    Environment.databaseConfig['logQueries'] ? 'Enabled' : 'Disabled'),
                if (Environment.databaseConfig['storagePath'] != null)
                  _buildInfoRow('Storage Path', Environment.databaseConfig['storagePath']),
                if (Environment.databaseConfig['enableBackup'] != null)
                  _buildInfoRow('Backup Enabled', 
                    Environment.databaseConfig['enableBackup'] ? 'Yes' : 'No'),
                if (!kIsWeb) FutureBuilder<String>(
                  future: _getDatabasePath(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildInfoRow('Database File', snapshot.data!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ],
          ],
        ),
      ),
    );
  }

  Future<String> _getDatabasePath() async {
    try {
      final dbName = Environment.databaseName;
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, 'databases', dbName);
    } catch (e) {
      return 'Not available';
    }
  }

  Future<String> _getLogsDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, 'logs');
    } catch (e) {
      return 'Not available';
    }
  }

  String _getPlatformInfo() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }

  String _getOSVersion() {
    try {
      return Platform.operatingSystemVersion;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getDartVersion() {
    try {
      return Platform.version.split(' ').first;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getScreenSize(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return '${size.width.toStringAsFixed(1)} × ${size.height.toStringAsFixed(1)}';
  }

  Widget _buildSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kHeadline3),
        const SizedBox(height: kSpacingSmall),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: kBodyText),
          Flexible(
            child: SelectableText(
              value, 
              style: kBodyText,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
} 