import 'package:example/data/mocks.dart';
import 'package:example/views/list_view_renderer.dart';
import 'package:example/views/page_view_renderer.dart';
import 'package:example/views/slivers_view_renderer.dart';
import 'package:fhir_renderer_questionnaire/fhir_renderer_questionnaire.dart';
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
                          (context) => ListViewRenderer(questionnaire: example),
                    ),
                  );
                },
                child: Text("ListView Renderer"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => PageViewRenderer(questionnaire: example),
                    ),
                  );
                },
                child: Text("PageView Renderer"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SliversViewRenderer(questionnaire: example),
                    ),
                  );
                },
                child: Text("SliversView Renderer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CubitA {
  static QuestionnaireRendererController? handler;
}
