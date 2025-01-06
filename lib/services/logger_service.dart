import 'package:logger/logger.dart';
import '../config/logger_config.dart';
import '../config/environment.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Provides centralized logging functionality with environment awareness.
class LoggerService {
  static Logger? _logger;
  static int _groupLevel = 0;

  /// Initializes the logger service.
  /// This method must be called before using any logging methods.
  static Future<void> initialize() async {
    _logger = await LoggerConfig.createLogger();
  }

  /// Ensures logger is initialized.
  static void _ensureInitialized() {
    if (_logger == null) {
      throw StateError('LoggerService not initialized. Call initialize() first.');
    }
  }

  /// Logs debug messages in development environment.
  static void debug(String message, {Map<String, dynamic>? data}) {
    _ensureInitialized();
    if (Environment.isDevelopment) {
      _logger!.d(_formatMessage(message, data));
    }
  }

  /// Logs informational messages.
  static void info(String message, {Map<String, dynamic>? data}) {
    _ensureInitialized();
    _logger!.i(_formatMessage(message, data));
  }

  /// Logs warning messages.
  static void warn(String message, {Map<String, dynamic>? data}) {
    _ensureInitialized();
    _logger!.w(_formatMessage(message, data));
  }

  /// Logs error messages with optional stack traces.
  static void error(
    String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _ensureInitialized();
    final formattedMessage = _formatMessage(message, data);
    _logger!.e(formattedMessage, error: error, stackTrace: stackTrace);
  }

  /// Formats log messages with optional metadata.
  static String _formatMessage(String message, Map<String, dynamic>? data) {
    final prefix = _groupLevel > 0 ? '│ ' * _groupLevel : '';
    if (data != null) {
      final sanitizedData = _sanitizeData(data);
      return '$prefix$message - Data: $sanitizedData';
    }
    return '$prefix$message';
  }

  /// Sanitizes sensitive data from logs.
  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (_isSensitive(key)) {
        return MapEntry(key, '***');
      }
      return MapEntry(key, value);
    });
  }

  /// Checks if a key contains sensitive information.
  static bool _isSensitive(String key) {
    return [
      'password',
      'token',
      'secret',
      'auth',
      'key',
      'credential',
    ].any((term) => key.toLowerCase().contains(term));
  }

  /// Starts a new log group.
  static void startGroup(String groupName) {
    _groupLevel++;
    debug('┌── Starting: $groupName');
  }

  /// Ends the current log group.
  static void endGroup(String groupName) {
    debug('└── Ending: $groupName');
    _groupLevel = (_groupLevel - 1).clamp(0, 99);
  }

  /// Logs a performance measurement.
  static void logPerformance(String operation, Duration duration) {
    info('Performance: $operation took ${duration.inMilliseconds}ms');
  }

  /// Logs a navigation event.
  static void logNavigation(String from, String to) {
    debug('Navigation: $from → $to');
  }

  /// Logs a database operation.
  static void logDatabase(
    String operation,
    String table, {
    Map<String, dynamic>? details,
  }) {
    debug('Database: $operation on $table', data: details);
  }

  /// Rotates log files when size limit is reached.
  static Future<void> rotateLogFiles() async {
    final logsDir = await LoggerConfig.getLogsDirectory();
    final logFile = File(path.join(logsDir.path, 'app.log'));
    
    if (!await logFile.exists()) return;
    
    final size = await logFile.length();
    if (size > LoggerConfig.maxLogSize) {
      for (var i = LoggerConfig.maxBackupFiles; i > 0; i--) {
        final file = File(path.join(logsDir.path, 'app.$i.log'));
        final previousFile = File(
          path.join(logsDir.path, 'app.${i - 1}.log'),
        );
        
        if (await file.exists()) {
          await file.delete();
        }
        if (await previousFile.exists()) {
          await previousFile.rename(file.path);
        }
      }
      await logFile.rename(
        path.join(logsDir.path, 'app.1.log'),
      );
    }
  }

  /// Cleans up old log files.
  static Future<void> cleanupOldLogs() async {
    final logsDir = await LoggerConfig.getLogsDirectory();
    final files = await logsDir.list().toList();
    
    for (var file in files) {
      if (file is File) {
        final fileName = path.basename(file.path);
        if (fileName.startsWith('app.') && 
            fileName.endsWith('.log')) {
          final number = int.tryParse(
            fileName.split('.')[1],
          );
          if (number != null && 
              number > LoggerConfig.maxBackupFiles) {
            await file.delete();
          }
        }
      }
    }
  }

  /// Verifies log file exists and is writable.
  static Future<void> verifyLogFile() async {
    try {
      final logFile = await LoggerConfig.getLogFile();
      if (!await logFile.exists()) {
        throw StateError('Log file does not exist');
      }
      // Test write
      await logFile.writeAsString(
        'Log file verification\n',
        mode: FileMode.append,
      );
      LoggerService.debug('Log file verified');
    } catch (e, stack) {
      LoggerService.error(
        'Log file verification failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}