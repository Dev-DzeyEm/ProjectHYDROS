import 'package:flutter/material.dart';
import 'package:project_hydros/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Project HYDROS';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle, // Root widget
      home: const HomeScreen(title: appTitle,),
      routes: {
        '/home':(context) => const HomeScreen(title: appTitle,),
        '/dashboard':(context) => Dashboard(),
      }
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: _buildNavigationDrawer(context),
      body: const Center(child: Text('Home Screen')),
    );
  }

  Widget _buildDrawerHeader() {
  return Padding(
    padding:
        const EdgeInsets.only(top: 20.0, left: 16.0), // Adjust as needed for spacing from top and left edges.
    child:
        Row(crossAxisAlignment :
	      CrossAxisAlignment.center,
          children:[
            Icon(Icons.account_circle,size : Theme.of (context).iconTheme.size ??48,),
            SizedBox(width :8),
            Text ('ADMIN',
            style : TextStyle(fontSize :24)
            ),
          ]
        ),
		);
	}

  Drawer _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildDrawerHeader (),
          const SizedBox(height :16,),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context), // Close drawer, no need to navigate again if already on home screen
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'), // This should ideally lead to a different route or page.
                            // For now, it will just close the drawer.
                            // Consider adding a settings page or route.
                            // Here it leads back to home for demonstration purposes.
                            // You can change this as needed based on your app structure.
                          onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/home');
                          },
                  ),
                ],
              ),
            );
          }
}