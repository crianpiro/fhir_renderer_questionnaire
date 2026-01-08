import 'package:example/data/mocks.dart';
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ListViewExamplePage(questionnaire: example),
                    ),
                  );
                },
                child: Text("ListViewRenderer"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PageViewExamplePage(questionnaire: example),
                    ),
                  );
                },
                child: Text("PageViewRenderer"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SliversViewExamplePage(questionnaire: example),
                    ),
                  );
                },
                child: Text("SliversViewRenderer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
