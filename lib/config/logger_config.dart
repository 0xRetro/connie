import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'environment.dart';

/// Configures and creates logger instances with environment-specific settings
class LoggerConfig {
  /// Maximum log file size in bytes (5MB)
  static const int maxLogSize = 5 * 1024 * 1024;
  
  /// Number of backup log files to keep
  static const int maxBackupFiles = 3;

  /// Creates a configured logger instance based on environment
  static Future<Logger> createLogger() async {
    final outputs = <LogOutput>[ConsoleOutput()];
    
    // Add file output in production
    if (Environment.enableFileLogging) {
      outputs.add(await _createFileOutput());
    }

    return Logger(
      printer: PrettyPrinter(
        methodCount: Environment.showDebugInfo ? 2 : 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: Environment.showDebugInfo,
        printEmojis: Environment.showDebugInfo,
        noBoxingByDefault: !Environment.showDebugInfo,
        dateTimeFormat: DateTimeFormat.none,
      ),
      filter: Environment.isDevelopment 
        ? DevelopmentFilter() 
        : ProductionFilter(),
      output: MultiOutput(outputs),
    );
  }

  /// Creates a file output for persistent logging
  static Future<FileOutput> _createFileOutput() async {
    final logFile = await getLogFile();
    return FileOutput(
      file: logFile,
      overrideExisting: false,
      encoding: utf8,
    );
  }

  /// Gets or creates the log file in the logs directory
  static Future<File> getLogFile() async {
    final logsDir = await getLogsDirectory();
    await logsDir.create(recursive: true);
    return File(path.join(logsDir.path, 'app.log'));
  }

  /// Gets the directory where logs are stored
  static Future<Directory> getLogsDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return Directory(path.join(docsDir.path, 'logs'));
  }

  /// Add rotation handling
  static Future<void> rotateLogsIfNeeded() async {
    final logFile = await getLogFile();
    if (await logFile.length() > maxLogSize) {
      await _rotateLogFiles();
    }
  }

  /// Add cleanup method
  static Future<void> cleanupOldLogs() async {
    final logsDir = await getLogsDirectory();
    final files = await logsDir.list().toList();
    // Keep only recent files based on maxBackupFiles
    if (files.length > maxBackupFiles) {
      // Sort by modification time and delete oldest
      files.sort((a, b) => 
        (a as File).lastModifiedSync().compareTo((b as File).lastModifiedSync()));
      for (var i = 0; i < files.length - maxBackupFiles; i++) {
        await (files[i] as File).delete();
      }
    }
  }

  /// Rotates log files when size limit is reached
  static Future<void> _rotateLogFiles() async {
    final logsDir = await getLogsDirectory();
    final logFile = await getLogFile();
    
    for (var i = maxBackupFiles; i > 0; i--) {
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