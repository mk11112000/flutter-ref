import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Load from assets
// PDFDocument doc = await PDFDocument.fromAsset('assets/test.pdf');

// // Load from URL

// // Load from file
// File file  = File('...');
// PDFDocument doc = await PDFDocument.fromFile(file);
  PDFDocument doc;
  File file;
  Future<void> _incrementCounter(BuildContext context) async {
    File _pickedFile = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ["pdf"]);

    PDFDocument document = await PDFDocument.fromFile(_pickedFile);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewPage(document),
        ));
  }

  Future getFile(BuildContext context) async {
    try {
      PDFDocument document = await PDFDocument.fromURL(
          'https://ipfs.io/ipfs/QmQy9DP2PeEpNGBD8uBm4RB2823qikRLsBnX6w16Yqmv4W');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewPage(document),
          ));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(child: Center(child: Text("data"))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: "getFile",
            onPressed: () async {
              await getFile(context);
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async {
              await _incrementCounter(context);
            },
            heroTag: "2",
          ),
        ],
      ),
    );
  }
}

class PdfViewPage extends StatelessWidget {
  final PDFDocument pdf;
  PdfViewPage(this.pdf);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(child: PDFViewer(document: pdf)),
    );
  }
}
