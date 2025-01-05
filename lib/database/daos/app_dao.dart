import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/people_table.dart';
import '../tables/ui_settings_table.dart';
import '../tables/plugin_settings_table.dart';

part 'app_dao.g.dart';

@DriftAccessor(tables: [PeopleTable, UiSettingsTable, PluginSettingsTable])
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

  // UI Settings operations
  Future<List<UiSetting>> getUiSettingsForTable(String tableName) =>
      (select(uiSettingsTable)..where((t) => t.targetTableName.equals(tableName))).get();

  Future<int> saveUiSettings(UiSettingCompanion settings) =>
      into(uiSettingsTable).insert(settings);

  Future<bool> updateUiSettings(UiSetting settings) =>
      update(uiSettingsTable).replace(settings);


} 