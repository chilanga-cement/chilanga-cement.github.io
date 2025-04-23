
import 'package:flutter/material.dart';
import 'pages/form_page.dart';
import 'pages/report_viewer_page.dart';

void main() {
  runApp(HealthSafetyApp());
}

class HealthSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Safety Reporting',
      theme: ThemeData(primarySwatch: Colors.green),
      home: NavigationController(),
    );
  }
}

class NavigationController extends StatefulWidget {
  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ReportingHomePage(),
    ReportViewerPage(),
  ];

  final List<String> _titles = [
    "Report Incident",
    "Submitted Reports",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close drawer if open
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report Incident'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Reports'),
              onTap: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Reports'),
        ],
      ),
    );
  }
}

class ReportingHomePage extends StatelessWidget {
  void navigateToForm(BuildContext context, String reportType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage(reportType: reportType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReportButton(title: "Near Miss", onTap: () => navigateToForm(context, "Near Miss")),
            ReportButton(title: "Visible Personal Commitment", onTap: () => navigateToForm(context, "Visible Personal Commitment")),
            ReportButton(title: "Risk Assessment Audit", onTap: () => navigateToForm(context, "Risk Assessment Audit")),
            ReportButton(title: "Plant Task Observation", onTap: () => navigateToForm(context, "Plant Task Observation")),
          ],
        ),
      ),
    );
  }
}

class ReportButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ReportButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text("Report $title"),
      ),
    );
  }
}
