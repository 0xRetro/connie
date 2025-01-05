import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database.dart' show AppDatabase, Person, PersonCompanion, databaseProvider;
import '../services/logger_service.dart';

part 'people_provider.g.dart';

/// Provider for managing people data
@riverpod
class PeopleNotifier extends _$PeopleNotifier {
  @override
  Future<List<Person>> build() async {
    LoggerService.debug('Building PeopleNotifier');
    final db = ref.watch(databaseProvider);
    return db.appDao.getAllPeople();
  }

  /// Creates a new person
  Future<void> createPerson(String name, {bool isSuperUser = false}) async {
    LoggerService.debug('Creating person: $name');
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    
    await db.appDao.createPerson(
      PersonCompanion.insert(
        name: name,
        isSuperUser: Value(isSuperUser),
        createdAt: now,
        updatedAt: now,
        isDeleted: const Value(false),
      ),
    );
    
    ref.invalidateSelf();
  }

  /// Updates an existing person
  Future<void> updatePerson(Person person) async {
    LoggerService.debug('Updating person: ${person.id}');
    final db = ref.read(databaseProvider);
    
    await db.appDao.updatePerson(person.copyWith(
      updatedAt: DateTime.now(),
    ));
    
    ref.invalidateSelf();
  }

  /// Deletes a person (soft delete)
  Future<void> deletePerson(int id) async {
    LoggerService.debug('Deleting person: $id');
    final db = ref.read(databaseProvider);
    final person = await db.appDao.getPerson(id);
    
    if (person != null) {
      await db.appDao.updatePerson(person.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      ));
      
      ref.invalidateSelf();
    }
  }
} 