import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WaterDataPage extends StatefulWidget {
  @override
  _WaterDataPageState createState() => _WaterDataPageState();
}

class _WaterDataPageState extends State<WaterDataPage> {
  List<Map<String, dynamic>> waterData = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchWaterData();
  }

  // Fetch data from Supabase
  Future<void> fetchWaterData() async {
    final response =
        await Supabase.instance.client.from('water_bed').select().execute();

    if (response.error == null) {
      setState(() {
        waterData = List<Map<String, dynamic>>.from(response.data);
      });
    } else {
      print('Error: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Bed Data'),
      ),
      body: waterData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              child: PaginatedDataTable(
                header: Text('Water Bed Data'),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (rowsPerPage) {
                  setState(() {
                    _rowsPerPage = rowsPerPage!;
                  });
                },
                availableRowsPerPage: [5, 10, 20],
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Created At')),
                  DataColumn(label: Text('Updated At')),
                  DataColumn(label: Text('Water Temp')),
                  DataColumn(label: Text('DO2 Level')),
                  DataColumn(label: Text('EC')),
                  DataColumn(label: Text('TDS')),
                  DataColumn(label: Text('Nitrate')),
                  DataColumn(label: Text('Nitrite')),
                  DataColumn(label: Text('Ammonia')),
                  DataColumn(label: Text('pH Level')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Sensor ID')),
                ],
                source: _DataTableSource(waterData),
                onPageChanged: (pageIndex) {
                  setState(() {
                    _currentPage = pageIndex!;
                  });
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/second');
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}

class _DataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  _DataTableSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    var row = data[index];
    return DataRow(cells: [
      DataCell(Text(row['id'].toString())),
      DataCell(Text(row['created_at']?.toString() ?? '')),
      DataCell(Text(row['updated_at']?.toString() ?? '')),
      DataCell(Text(row['water_temperature'].toString())),
      DataCell(Text(row['dissolved_o2_level'].toString())),
      DataCell(Text(row['electrical_conductivity'].toString())),
      DataCell(Text(row['total_dissolved_solids'].toString())),
      DataCell(Text(row['nitrate'].toString())),
      DataCell(Text(row['nitrite'].toString())),
      DataCell(Text(row['ammonia'].toString())),
      DataCell(Text(row['ph_level'].toString())),
      DataCell(Text(row['timestamp']?.toString() ?? '')),
      DataCell(Text(row['sensor_id'].toString())),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
