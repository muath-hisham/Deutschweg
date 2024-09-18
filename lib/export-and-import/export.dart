import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/sqldb.dart';

// Function to export SQLite data to JSON or CSV
Future<void> exportData() async {
  // 1. Get the database path
  SqlDb sqlDb = SqlDb();

  // 2. Fetch data from tables
  Map<String, List<Map<String, dynamic>>> allData = {};

  for (MyTable table in MyTable.values) {
    try {
      List<Map<String, dynamic>> data = await sqlDb.readData(
          'SELECT * FROM ${getMyTableName(table)}');
      allData[getMyTableName(table)] = data;
    } catch (e) {
      print("Error fetching data from table ${getMyTableName(table)}: $e");
    }
  }

  // 3. Convert data to JSON or CSV format
  // For JSON
  String jsonData = jsonEncode(allData);

  // 4. Save data to file
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String jsonFilePath = join(documentsDirectory.path, "menschen.json");

  File(jsonFilePath).writeAsBytes(utf8.encode(jsonData));

  // 5. Share data via WhatsApp
  XFile jsonFile = XFile(jsonFilePath);
  await Share.shareXFiles([jsonFile]);
}
