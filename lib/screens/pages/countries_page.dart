import 'package:flutter/material.dart';
import 'package:menschen/models/country_model.dart';
import 'package:menschen/screens/adds/add_country.dart';
import 'package:menschen/screens/updates/update_country.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  bool isThereCountries = true;

  List<Country> countriesList = [];

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  Future<void> _getCountries() async {
    try {
      List<Map<String, dynamic>> li =
          await sqlDb.readData("SELECT * FROM countries");

      setState(() {
        if (li.isNotEmpty) {
          countriesList =
              li.map((element) => Country.fromMap(element)).toList();
          isThereCountries = true;
        } else {
          countriesList.clear();
          isThereCountries = false;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isThereCountries = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching countries: $e')),
      );
    }
  }

  Future<void> _deleteCountry(int id) async {
    await sqlDb.deleteData("DELETE FROM countries WHERE country_id = $id");
    await _getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.countries),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isThereCountries
              ? _body()
              : Center(
                  child: Text(
                    MyText.addCountry,
                    style: TextStyle(fontSize: Dimensions.fontSize(18)),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddCountry()));
        },
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          left: Dimensions.horizontal(10),
          right: Dimensions.horizontal(10),
          top: Dimensions.vertical(30),
          bottom: Dimensions.vertical(80),
        ),
        child: _buildTable(),
      ),
    );
  }

  Widget _buildTable() {
    List<TableRow> rows = [
      _buildFirstTableRow(),
      ...countriesList.map((country) => _buildTableRow(country)).toList(),
    ];
    return _buildTableDesign(children: rows);
  }

  Widget _buildTableDesign({required List<TableRow> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: children,
      ),
    );
  }

  TableRow _buildFirstTableRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      children: [
        _buildHeaderCell(MyText.country),
        _buildHeaderCell(MyText.translation),
        _buildHeaderCell(MyText.nationality),
        _buildHeaderCell(MyText.language),
      ],
    );
  }

  TableRow _buildTableRow(Country country) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[300]!),
        ),
      ),
      children: [
        _buildTableCell(
          country.article!.isEmpty
              ? country.country
              : "${country.article} ${country.country}",
          country.article!.isEmpty
              ? () => MyFunctions.speak(country.country)
              : () =>
                  MyFunctions.speak("${country.article} ${country.country}"),
          () => _showList(context, country),
        ),
        _buildTableCell(
          country.translation,
          () => MyFunctions.speak(country.translation),
          () => _showList(context, country),
        ),
        if (country.nationality != null && country.nationality!.isNotEmpty)
          _buildTableCell(
            country.nationality!,
            () => MyFunctions.speak(country.nationality!),
            () => _showList(context, country),
          )
        else
          const SizedBox(),
        if (country.language != null && country.language!.isNotEmpty)
          _buildTableCell(
            country.language!,
            () => MyFunctions.speak(country.language!),
            () => _showList(context, country),
          )
        else
          const SizedBox(),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.fontSize(14),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, VoidCallback onTap,
      [VoidCallback? onLongPress]) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Dimensions.fontSize(14)),
          ),
        ),
      ),
    );
  }

  void _showList(BuildContext context, Country country) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            MyWidgets.deleteButton(
              context,
              title: MyText.deleteThisCountry,
              accept: () async {
                await _deleteCountry(country.id);
                Navigator.of(context).pop();
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CountryUpdate(country: country)));
              },
            ),
          ],
        );
      },
    );
  }
}
