import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  const supabaseUrl = 'https://bndwsjneufdbocwgqcbe.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuZHdzam5ldWZkYm9jd2dxY2JlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MDI5MjIsImV4cCI6MjA1NDM3ODkyMn0.JzjepJzfz7cUki7bsCvDFICrBKFmbiAhBhvDdZ8oYNQ';

  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    print('Supabase initialized successfully'); // Log successful initialization
  } catch (e) {
    print('Supabase initialization error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Quality Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<_ChartData> chartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      final response = await Supabase.instance.client
          .from('water_bed')
          .select('dissolved_o2_level, created_at')
          .execute();

      if (response.error != null) throw response.error!.message;

      setState(() {
        chartData = _processChartData(response.data);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching chart data: $e');
      setState(() => isLoading = false);
    }
  }

  List<_ChartData> _processChartData(List<dynamic> data) {
    return data.map((item) {
      return _ChartData(
        date: DateTime.parse(item['created_at']), // Parse the timestamptz
        y: item['dissolved_o2_level']?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Water Quality')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CarouselSlider(
              options: CarouselOptions(
                height: 400,
                autoPlay: false, // Disable auto-play for now
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: [
                _buildChartSlide(),
              ],
            ),
    );
  }

  Widget _buildChartSlide() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6)],
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: 'Dissolved Oxygen Levels Over Time'),
        primaryXAxis: DateTimeAxis(
          title: AxisTitle(text: 'Date'),
          dateFormat: DateFormat('MM/dd/yyyy HH:mm'), // Format the date and time as needed
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        ),
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Dissolved O₂ (mg/L)')),
        series: <ChartSeries>[
          LineSeries<_ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (data, _) => data.date,
            yValueMapper: (data, _) => data.y,
            name: 'Dissolved O₂',
            markerSettings: MarkerSettings(isVisible: true, color: Colors.blue),
            color: Colors.blue,
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

class _ChartData {
  final DateTime date;
  final double y;

  _ChartData({required this.date, required this.y});
}