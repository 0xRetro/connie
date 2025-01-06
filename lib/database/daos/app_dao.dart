import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/people_table.dart';

part 'app_dao.g.dart';

@DriftAccessor(tables: [PeopleTable])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(AppDatabase db) : super(db);

  // People operations
  Future<List<Person>> getAllPeople() => select(peopleTable).get();

  Future<Person?> getPerson(int id) =>
      (select(peopleTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> createPerson(PersonCompanion person) =>
      into(peopleTable).insert(person);

  Future<bool> updatePerson(Person person) =>
      update(peopleTable).replace(person);

  Future<int> deletePerson(int id) =>
      (delete(peopleTable)..where((t) => t.id.equals(id))).go();
} 