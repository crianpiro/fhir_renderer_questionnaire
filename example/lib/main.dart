import 'package:example/data/mocks.dart';
import 'package:example/views/list_view_renderer.dart';
import 'package:example/views/page_view_renderer.dart';
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
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.lightBlue,
          secondary: Colors.lightBlue,
          onSecondary: Colors.lightBlueAccent,
          error: Colors.red,
          onError: Colors.redAccent,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
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
                          (context) => ListViewRenderer(
                            questionnaire: mockAnamneseQuestionnaire,
                          ),
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
                          (context) => PageViewRenderer(
                            questionnaire: mockAnamneseQuestionnaire,
                          ),
                    ),
                  );
                },
                child: Text("PageView Renderer"),
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
