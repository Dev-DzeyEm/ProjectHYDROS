import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<ChartData> chartDataList = [];
  bool isLoading = true;
  String? errorMessage;

  int _currentCarouselIndex = 0; 

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
        'xColumn': 'created_at',
        'yColumn': 'electrical_conductivity'
      },
      {
        'name': 'greenhouse_monitoring',
        'title': 'Relative Humidity',
        'xColumn': 'created_at',
        'yColumn': 'relative_humidity'
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
              x: DateTime.parse(item['created_at'] as String)
                  .millisecondsSinceEpoch
                  .toDouble(),
              y: (item[table['yColumn']] as num?)?.toDouble() ?? 0.0,
            );
          }).toList();

          fetchedData.add(ChartData(
              title: table['title'] as String,
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
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.85,
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
                      color: Colors.black26,
                      blurRadius: 10,
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
                          isVisible: false, // Hide X axis labels
                          axisLine: const AxisLine(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(size: 0),
                        ),
                        plotAreaBorderWidth: 0,
                        series: <LineSeries<DataPoint, DateTime>>[
                          LineSeries<DataPoint, DateTime>(
                          color: chartData.color,
                          width: 2,
                          dataSource: chartData.points,
                          xValueMapper: (DataPoint data, _) =>
                            DateTime.fromMillisecondsSinceEpoch(
                              data.x.toInt()),
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            borderWidth: 2,
                            height: 6,
                            width: 6,
                          ),
                          dataLabelSettings:
                            const DataLabelSettings(
                            isVisible: true,
                            labelAlignment:
                              ChartDataLabelAlignment.top,
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.y',
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
  final List<DataPoint> points;
  final Color color;

  ChartData({
    required this.title,
    required this.points,
    required this.color,
  });
}

class DataPoint {
  final double x;
  final double y;

  DataPoint({required this.x, required this.y});
}