import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void createDatabase() {
  getDatabasesPath().then(
    (dbPath) {
      final String path = join(
        dbPath,
        'banckApp.dp',
      );
    },
  );
}
