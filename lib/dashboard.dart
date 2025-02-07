import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<ChartData> chartDataList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final tables = [
      {
        'name': 'water_bed',
        'title': 'Electrical Conductivity',
        'yAxisData': 'Electrical conductivity (mS/m)',
        'xColumn': 'created_at',
        'yColumn': 'electrical_conductivity'
      },
      {
        'name': 'greenhouse_monitoring',
        'title': 'Relative Humidity',
        'yAxisData': 'Relative Humidity %rh',
        'xColumn': 'created_at',
        'yColumn': 'relative_humidity'
      },
      {
        'name': 'water_bed',
        'title': 'Total Dissolved Oxygen',
        'yAxisData': 'Dissolved O₂ (mg/L)',
        'xColumn': 'created_at',
        'yColumn': 'dissolved_o2_level'
      },
    ];

    try {
      List<ChartData> fetchedData = [];

      for (var table in tables) {
        final response = await Supabase.instance.client
            .from(table['name'] as String)
            .select('${table['xColumn']}, ${table['yColumn']}')
            .order('created_at', ascending: true)
            .execute();

        if (response.error == null) {
          final data = response.data as List<dynamic>;
          List<DataPoint> points = data.map((item) {
            return DataPoint(
              date: DateTime.parse(item['created_at']),
              y: (item[table['yColumn']] as num?)?.toDouble() ?? 0.0,
            );
          }).toList();

          fetchedData.add(ChartData(
              title: table['title'] as String,
              yAxisData: table['yAxisData'] as String,
              points: points,
              color: _getChartColor(fetchedData.length)));
        } else {
          errorMessage = response.error?.message;
        }
      }

      setState(() {
        chartDataList = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Color _getChartColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final chartHeight = screenHeight * 0.5; // 40% of screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (isLoading)
              SizedBox(
                height: chartHeight,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Loading sensor data...'),
                    ],
                  ),
                ),
              )
            else if (errorMessage != null)
              Container(
                height: chartHeight,
                padding: const EdgeInsets.all(16),
                color: Colors.red[100],
                child: Center(
                  child: Text(
                    'Error: $errorMessage',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (chartDataList.isNotEmpty)
                SizedBox(
                height: chartHeight,
                child: CarouselSlider(
                  options: CarouselOptions(
                  height: chartHeight,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  enableInfiniteScroll: false,
                  ),
                  items: chartDataList.map((chartData) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                      ),
                    ],
                    ),
                    child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Center(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          chartData.title,
                          style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: chartData.color,
                          ),
                        ),
                        ),
                      ),
                      Expanded(
                        child: SfCartesianChart(
                        margin: EdgeInsets.zero,
                        primaryXAxis: DateTimeAxis(
                          title: AxisTitle(text: 'Date'),
                          dateFormat: DateFormat('MM/dd/yyyy'), // Format the date and time as needed
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          interval: 1, // Show one label per day
                          intervalType: DateTimeIntervalType.days, // Set the interval type to days
                          labelIntersectAction: AxisLabelIntersectAction.hide, // Hide intersecting labels
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: chartData.yAxisData),
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(size: 0),
                        ),
                        plotAreaBorderWidth: 0,
                        series: <LineSeries<DataPoint, DateTime>>[
                          LineSeries<DataPoint, DateTime>(
                          color: chartData.color,
                          width: 1,
                          dataSource: chartData.points,
                          xValueMapper: (DataPoint data, _) => data.date,
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            borderWidth: 1,
                            height: 3,
                            width: 3,
                          ),
                          dataLabelSettings:
                            const DataLabelSettings(
                            isVisible: false,
                            labelAlignment:
                              ChartDataLabelAlignment.top,
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          ),
                          
                        ],
                        tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'point.x : point.y',
                            // For better date formatting, use:
                            // format: '${DateFormat.yMd().add_jm().format(point.x)}: ${point.y.toStringAsFixed(2)}',
                            header: '', // Remove series name header
                          ),
                        ),
                      ),
                   ],
                    ),
                  ),
                  );
                }).toList(),
                ),
              ),
            
            // Add other dashboard content here
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String title;
  final String yAxisData;
  final List<DataPoint> points;
  final Color color;

  ChartData({
    required this.title,
    required this.points,
    required this.color,
    required this.yAxisData,
  });
}

class DataPoint {
  final DateTime date;
  final double y;

  DataPoint({required this.date, required this.y});
}