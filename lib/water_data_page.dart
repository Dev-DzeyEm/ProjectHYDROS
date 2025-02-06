import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WaterDataPage extends StatefulWidget {
  @override
  _WaterDataPageState createState() => _WaterDataPageState();
}

class _WaterDataPageState extends State<WaterDataPage> {
  List<Map<String, dynamic>> waterData = [];

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
              child: DataTable(
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
                rows: waterData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['id'].toString())),
                    DataCell(Text(data['created_at']?.toString() ?? '')),
                    DataCell(Text(data['updated_at']?.toString() ?? '')),
                    DataCell(Text(data['water_temperature'].toString())),
                    DataCell(Text(data['dissolved_o2_level'].toString())),
                    DataCell(Text(data['electrical_conductivity'].toString())),
                    DataCell(Text(data['total_dissolved_solids'].toString())),
                    DataCell(Text(data['nitrate'].toString())),
                    DataCell(Text(data['nitrite'].toString())),
                    DataCell(Text(data['ammonia'].toString())),
                    DataCell(Text(data['ph_level'].toString())),
                    DataCell(Text(data['timestamp']?.toString() ?? '')),
                    DataCell(Text(data['sensor_id'].toString())),
                  ]);
                }).toList(),
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
