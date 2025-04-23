
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:html' as html;

class ReportViewerPage extends StatefulWidget {
  @override
  _ReportViewerPageState createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedReports = prefs.getStringList('reports') ?? [];
    setState(() {
      reports = storedReports.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  void _exportToJson() {
    final jsonStr = jsonEncode(reports);
    final bytes = utf8.encode(jsonStr);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "reports.json")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _exportToCsv() {
    if (reports.isEmpty) return;

    final headers = reports.first.keys.toList();
    final rows = [
      headers.join(","),
      ...reports.map((r) => headers.map((h) => '"${r[h] ?? ''}"').join(","))
    ];
    final csvStr = rows.join("\n");
    final bytes = utf8.encode(csvStr);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "reports.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submitted Reports"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportToJson,
            tooltip: "Export to JSON",
          ),
          IconButton(
            icon: Icon(Icons.table_view),
            onPressed: _exportToCsv,
            tooltip: "Export to CSV",
          ),
        ],
      ),
      body: reports.isEmpty
          ? Center(child: Text("No reports submitted yet."))
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(report['type'] ?? "Unknown Type"),
                    subtitle: Text(report['description'] ?? "No description"),
                    trailing: Text(report['riskRating'] ?? ""),
                  ),
                );
              },
            ),
    );
  }
}
