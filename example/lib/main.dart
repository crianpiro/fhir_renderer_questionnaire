import 'package:example/views/focus_test_page.dart';
import 'package:example/views/list_view_example_page.dart';
import 'package:example/views/page_view_renderer_page.dart';
import 'package:example/views/slivers_view_example_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(234, 221, 255, 1),
          foregroundColor: Color.fromRGBO(103, 80, 164, 1),
        ),
      ),
      title: 'FHIR Renderer - Questionnaire',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fhir Renderer - Questionnaire"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ListViewExamplePage(),
                      ),
                    );
                  },
                  child: Text("ListViewRenderer"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PageViewExamplePage(),
                      ),
                    );
                  },
                  child: Text("PageViewRenderer"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SliversViewExamplePage(),
                      ),
                    );
                  },
                  child: Text("SliversViewRenderer"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FocusTestPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    foregroundColor: Colors.green.shade900,
                  ),
                  child: const Text("Focus & EnableWhen Test"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
