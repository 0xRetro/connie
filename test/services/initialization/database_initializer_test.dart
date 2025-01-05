import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:connie/services/initialization/database_initializer.dart';
import 'package:connie/services/logger_service.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:sqlite3/sqlite3.dart';

/// A simple executor user for database initialization
class _DatabaseInitializerExecutorUser extends QueryExecutorUser {
  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) async {
    // No special setup needed
  }

  @override
  int get schemaVersion => 1;
}

class MockPathProviderPlatform with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final Directory testDir;

  MockPathProviderPlatform(this.testDir);

  @override
  Future<String?> getApplicationDocumentsPath() async => testDir.path;

  @override
  Future<String?> getApplicationCachePath() async => p.join(testDir.path, 'cache');

  @override
  Future<String?> getApplicationSupportPath() async => p.join(testDir.path, 'support');

  @override
  Future<String?> getDownloadsPath() async => p.join(testDir.path, 'downloads');

  @override
  Future<List<String>?> getExternalCachePaths() async => [p.join(testDir.path, 'external', 'cache')];

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async => [p.join(testDir.path, 'external', 'storage')];

  @override
  Future<String?> getLibraryPath() async => p.join(testDir.path, 'library');

  @override
  Future<String?> getTemporaryPath() async => p.join(testDir.path, 'temp');

  @override
  Future<String?> getExternalStoragePath() async => p.join(testDir.path, 'external');
}

@TestOn('vm')
void main() {
  late Directory tempDir;
  late Directory testDir;

  setUpAll(() async {
    // Initialize SQLite for tests
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    
    // Initialize logger for tests
    await LoggerService.initialize();
    
    // Create temp directory for tests
    tempDir = await Directory.systemTemp.createTemp('db_init_test_');
    testDir = Directory(p.join(tempDir.path, 'app_data'));
    await testDir.create(recursive: true);
    
    // Set up mock path provider
    PathProviderPlatform.instance = MockPathProviderPlatform(testDir);
    
    // Verify SQLite is working
    final db = NativeDatabase.memory();
    await db.ensureOpen(_DatabaseInitializerExecutorUser());
    await db.close();
  });

  tearDownAll(() async {
    // Clean up temp directory
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    // Clean up database directory before each test
    final dbDir = Directory(p.join(testDir.path, 'connie'));
    if (dbDir.existsSync()) {
      await dbDir.delete(recursive: true);
    }
  });

  group('DatabaseInitializer', () {
    test('should initialize successfully on first run', () async {
      final result = await DatabaseInitializer.initialize();
      expect(result, isTrue);

      // Verify database file was created
      final dbPath = p.join(testDir.path, 'connie', 'connie.db');
      expect(File(dbPath).existsSync(), isTrue);
    });

    test('should validate existing database', () async {
      // First create a valid database
      final result1 = await DatabaseInitializer.initialize();
      expect(result1, isTrue);

      // Then validate it
      final result2 = await DatabaseInitializer.initialize();
      expect(result2, isTrue);
    });

    test('should handle SQLite setup correctly', () async {
      expect(
        () => DatabaseInitializer.initialize(),
        returnsNormally,
      );
    });

    test('should create default data on first run', () async {
      // Initialize new database
      final result = await DatabaseInitializer.initialize();
      expect(result, isTrue);

      // Verify default data
      final dbPath = p.join(testDir.path, 'connie', 'connie.db');
      final db = NativeDatabase(File(dbPath));
      await db.ensureOpen(_DatabaseInitializerExecutorUser());
      
      // Check admin user
      final adminUser = await db.runSelect(
        'SELECT * FROM people WHERE name = ? AND is_super_user = 1',
        ['Admin'],
      );
      expect(adminUser, hasLength(1));

      // Check default UI settings
      final uiSettings = await db.runSelect(
        'SELECT * FROM ui_settings WHERE table_name = ?',
        ['global'],
      );
      expect(uiSettings, hasLength(1));
      expect(uiSettings.first.values.first.toString(), contains('theme'));
      
      await db.close();
    });

    test('should handle database corruption', () async {
      // First create a valid database
      final result1 = await DatabaseInitializer.initialize();
      expect(result1, isTrue);

      // Corrupt the database
      final dbPath = p.join(testDir.path, 'connie', 'connie.db');
      await File(dbPath).writeAsString('corrupted data');

      // Try to initialize with corrupted database
      final result2 = await DatabaseInitializer.initialize();
      expect(result2, isFalse);
    });
  });
} 