import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connie/database/database.dart';
import 'package:connie/services/logger_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

void main() {
  late AppDatabase database;

  setUpAll(() async {
    // Initialize logger for tests
    await LoggerService.initialize();

    // Initialize SQLite for tests
    if (Platform.isWindows) {
      final libraryPath = p.join(
        Directory.current.path,
        'sqlite3.dll',
      );
      if (File(libraryPath).existsSync()) {
        sqlite3.open(libraryPath);
      }
    }
  });

  setUp(() {
    // Use Drift's built-in handling for SQLite
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (db) {
          // Enable foreign keys for tests
          db.execute('PRAGMA foreign_keys = ON');
        },
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('Database Operations', () {
    test('should create database successfully', () async {
      expect(database, isNotNull);
      expect(database.schemaVersion, equals(1));
    });

    test('should initialize with default admin user', () async {
      await database.initialize();
      
      final people = await database.select(database.peopleTable).get();
      expect(people, hasLength(1));
      expect(people.first.name, equals('Admin'));
      expect(people.first.isSuperUser, isTrue);
    });

    group('People Table Operations', () {
      test('should perform CRUD operations on people table', () async {
        final now = DateTime.now();
        
        // Create
        final id = await database.into(database.peopleTable).insert(
          PersonCompanion.insert(
            name: 'Test User',
            isSuperUser: const Value(false),
            createdAt: now,
            updatedAt: now,
            isDeleted: const Value(false),
          ),
        );

        // Read
        final person = await (database.select(database.peopleTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(person.name, equals('Test User'));
        expect(person.isSuperUser, isFalse);

        // Update
        await database.update(database.peopleTable).replace(
          PersonCompanion(
            id: Value(person.id),
            name: const Value('Updated User'),
            isSuperUser: Value(person.isSuperUser),
            createdAt: Value(person.createdAt),
            updatedAt: Value(DateTime.now()),
            isDeleted: Value(person.isDeleted),
          ),
        );
        final updatedPerson = await (database.select(database.peopleTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(updatedPerson.name, equals('Updated User'));

        // Delete
        await (database.delete(database.peopleTable)
          ..where((t) => t.id.equals(id))).go();
        final deletedPerson = await (database.select(database.peopleTable)
          ..where((t) => t.id.equals(id))).get();
        expect(deletedPerson, isEmpty);
      });

      test('should enforce name constraint', () async {
        expect(
          () => database.into(database.peopleTable).insert(
            PersonCompanion.insert(
              name: '', // Empty name should fail
              isSuperUser: const Value(false),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          ),
          throwsA(anything),
        );
      });
    });

    group('UI Settings Table Operations', () {
      test('should perform CRUD operations on ui settings table', () async {
        final now = DateTime.now();
        final settings = {'theme': 'dark', 'fontSize': 14};
        
        // Create
        final id = await database.into(database.uiSettingsTable).insert(
          UiSettingCompanion.insert(
            targetTableName: 'people',
            settings: settings.toString(),
            createdAt: now,
            updatedAt: now,
            isDeleted: const Value(false),
          ),
        );

        // Read
        final setting = await (database.select(database.uiSettingsTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(setting.targetTableName, equals('people'));
        expect(setting.settings, equals(settings.toString()));

        // Update
        final updatedSettings = {'theme': 'light', 'fontSize': 16};
        await database.update(database.uiSettingsTable).replace(
          UiSettingCompanion(
            id: Value(setting.id),
            targetTableName: Value(setting.targetTableName),
            settings: Value(updatedSettings.toString()),
            createdAt: Value(setting.createdAt),
            updatedAt: Value(DateTime.now()),
            isDeleted: Value(setting.isDeleted),
          ),
        );
        final updatedSetting = await (database.select(database.uiSettingsTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(updatedSetting.settings, equals(updatedSettings.toString()));

        // Delete
        await (database.delete(database.uiSettingsTable)
          ..where((t) => t.id.equals(id))).go();
        final deletedSetting = await (database.select(database.uiSettingsTable)
          ..where((t) => t.id.equals(id))).get();
        expect(deletedSetting, isEmpty);
      });

      test('should enforce table name and settings constraints', () async {
        expect(
          () => database.into(database.uiSettingsTable).insert(
            UiSettingCompanion.insert(
              targetTableName: '', // Empty table name should fail
              settings: '{}',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          ),
          throwsA(anything),
        );

        expect(
          () => database.into(database.uiSettingsTable).insert(
            UiSettingCompanion.insert(
              targetTableName: 'people',
              settings: '', // Empty settings should fail
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          ),
          throwsA(anything),
        );
      });
    });

    /*group('Plugin Settings Table Operations', () {
      test('should perform CRUD operations on plugin settings table', () async {
        final now = DateTime.now();
        
        // Create
        final id = await database.into(database.pluginSettingsTable).insert(
          PluginSettingCompanion.insert(
            pluginName: 'test_plugin',
            settingsKey: 'api_key',
            settingsValue: 'test_value',
            createdAt: now,
            updatedAt: now,
            isDeleted: const Value(false),
          ),
        );

        // Read
        final setting = await (database.select(database.pluginSettingsTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(setting.pluginName, equals('test_plugin'));
        expect(setting.settingsKey, equals('api_key'));
        expect(setting.settingsValue, equals('test_value'));

        // Update
        await database.update(database.pluginSettingsTable).replace(
          PluginSettingCompanion(
            id: Value(setting.id),
            pluginName: Value(setting.pluginName),
            settingsKey: Value(setting.settingsKey),
            settingsValue: const Value('updated_value'),
            createdAt: Value(setting.createdAt),
            updatedAt: Value(DateTime.now()),
            isDeleted: Value(setting.isDeleted),
          ),
        );
        final updatedSetting = await (database.select(database.pluginSettingsTable)
          ..where((t) => t.id.equals(id))).getSingle();
        expect(updatedSetting.settingsValue, equals('updated_value'));

        // Delete
        await (database.delete(database.pluginSettingsTable)
          ..where((t) => t.id.equals(id))).go();
        final deletedSetting = await (database.select(database.pluginSettingsTable)
          ..where((t) => t.id.equals(id))).get();
        expect(deletedSetting, isEmpty);
      });

      test('should enforce plugin name and settings key constraints', () async {
        expect(
          () => database.into(database.pluginSettingsTable).insert(
            PluginSettingCompanion.insert(
              pluginName: '', // Empty plugin name should fail
              settingsKey: 'api_key',
              settingsValue: 'test_value',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          ),
          throwsA(anything),
        );

        expect(
          () => database.into(database.pluginSettingsTable).insert(
            PluginSettingCompanion.insert(
              pluginName: 'test_plugin',
              settingsKey: '', // Empty settings key should fail
              settingsValue: 'test_value',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          ),
          throwsA(anything),
        );
      });
    });

    group('Database Health and Error Handling', () {
      test('should handle database health checks', () async {
        final isHealthy = await database.verifyConnection();
        expect(isHealthy, isTrue);

        final metrics = await database.getDatabaseMetrics();
        expect(metrics['version'], equals(1));
        expect(metrics['isHealthy'], isTrue);
        expect(metrics['tables'], equals(3)); // people, ui_settings, plugin_settings
      });

      test('should handle error conditions gracefully', () async {
        // Test invalid query
        expect(
          () => database.customSelect('SELECT * FROM non_existent_table').get(),
          throwsA(anything),
        );

        // Test connection still works after error
        final isHealthy = await database.verifyConnection();
        expect(isHealthy, isTrue);
      });

      test('should handle concurrent operations', () async {
        final futures = List.generate(10, (index) => 
          database.into(database.peopleTable).insert(
            PersonCompanion.insert(
              name: 'User $index',
              isSuperUser: const Value(false),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isDeleted: const Value(false),
            ),
          )
        );

        final results = await Future.wait(futures);
        expect(results, hasLength(10));
        
        final count = await database.select(database.peopleTable).get();
        expect(count, hasLength(11)); // 10 new + 1 admin
      });
    });
  });

  group('Dynamic Table Operations', () {
    test('should create and manage dynamic tables', () async {
      final dynamicDao = database.dynamicTableDao;

      // Create table
      await dynamicDao.createTable(
        'test_table',
        [
          GeneratedColumn<String>('name', 'test_table', false, type: DriftSqlType.string),
          GeneratedColumn<bool>('active', 'test_table', false, type: DriftSqlType.bool),
        ],
      );

      // Add column
      await dynamicDao.addColumn(
        'test_table',
        GeneratedColumn<int>('count', 'test_table', false, type: DriftSqlType.int),
      );

      // Query table
      final results = await dynamicDao.queryTable('test_table');
      expect(results, isEmpty);

      // Drop table
      await dynamicDao.deleteTable('test_table');
    });

    test('should handle dynamic table errors gracefully', () async {
      final dynamicDao = database.dynamicTableDao;

      // Try to create table with invalid name
      expect(
        () => dynamicDao.createTable(
          '', // Empty table name should fail
          [
            GeneratedColumn<String>('name', '', false, type: DriftSqlType.string),
          ],
        ),
        throwsA(anything),
      );

      // Try to add column to non-existent table
      expect(
        () => dynamicDao.addColumn(
          'non_existent_table',
          GeneratedColumn<String>('name', 'non_existent_table', false, type: DriftSqlType.string),
        ),
        throwsA(anything),
      );
    });
  });

  group('Migration Testing', () {
    test('should handle schema upgrades', () async {
      // Create a database with version 1
      final dbV1 = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (db) {
            db.execute('PRAGMA foreign_keys = ON');
          },
        ),
      );
      expect(dbV1.schemaVersion, equals(1));

      // Verify schema structure
      final tables = await dbV1.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table'"
      ).get();
      
      expect(
        tables.map((row) => row.data['name']),
        containsAll(['people', 'ui_settings', 'plugin_settings']),
      );
      
      await dbV1.close();
    });

    test('should preserve data during migrations', () async {
      // Insert test data in V1
      final person = await database.into(database.peopleTable).insertReturning(
        PersonCompanion.insert(
          name: 'Migration Test User',
          isSuperUser: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: const Value(false),
        ),
      );

      // Verify data persists
      final result = await (database.select(database.peopleTable)
        ..where((t) => t.id.equals(person.id))).getSingle();
      expect(result.name, equals('Migration Test User'));
    });
  });

  group('Comprehensive Health Checks', () {
    test('should verify database integrity', () async {
      final result = await database.customSelect('PRAGMA integrity_check').get();
      expect(result.first.data['integrity_check'], equals('ok'));
    });

    test('should check foreign key constraints', () async {
      final result = await database.customSelect('PRAGMA foreign_key_check').get();
      expect(result, isEmpty);
    });

    test('should monitor database size', () async {
      final result = await database.customSelect('PRAGMA page_count').get();
      final pageCount = result.first.data['page_count'] as int;
      final pageSize = (await database.customSelect('PRAGMA page_size').get())
          .first.data['page_size'] as int;
      
      final dbSize = pageCount * pageSize;
      expect(dbSize, greaterThan(0));
    });
  });

  group('Database Configuration', () {
    test('should verify connection settings', () async {
      // Test connection timeout
      final timeoutResult = await database
          .customSelect('PRAGMA busy_timeout')
          .getSingle();
      expect(timeoutResult.data['busy_timeout'], greaterThan(0));

      // Test journal mode
      final journalMode = await database
          .customSelect('PRAGMA journal_mode')
          .getSingle();
      expect(journalMode.data['journal_mode'], equals('wal'));

      // Test synchronous setting
      final syncMode = await database
          .customSelect('PRAGMA synchronous')
          .getSingle();
      expect(syncMode.data['synchronous'], equals(2)); // FULL
    });

    test('should handle connection pool', () async {
      // Simulate multiple connections
      final futures = List.generate(5, (index) => 
        database.customSelect('SELECT 1').getSingle()
      );
      
      final results = await Future.wait(futures);
      expect(results, hasLength(5));
    });*/
  });
} 