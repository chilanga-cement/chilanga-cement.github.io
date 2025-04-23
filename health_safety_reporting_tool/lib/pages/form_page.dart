
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final String reportType;

  FormPage({required this.reportType});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report: ${widget.reportType}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SwitchListTile(
                title: Text("Report Anonymously"),
                value: isAnonymous,
                onChanged: (value) {
                  setState(() {
                    isAnonymous = value;
                  });
                },
              ),
              if (!isAnonymous)
                TextFormField(
                  decoration: InputDecoration(labelText: "Your Name"),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email (Optional)"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 4,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Location"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Date of Incident"),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Time of Incident"),
                keyboardType: TextInputType.datetime,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Risk Rating"),
                items: ["Low", "Medium", "High"].map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Submitted ${widget.reportType}")),
                  );
                  Navigator.pop(context);
                },
                child: Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
