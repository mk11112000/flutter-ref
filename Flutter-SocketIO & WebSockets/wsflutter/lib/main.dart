import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Sockets'),
    );
  }
}

//Using WebSocket Channel Package

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   final channel = IOWebSocketChannel.connect('wss://192.168.29.167:5000');
//   StreamController _streamController = StreamController.broadcast();

//   void _incrementCounter() {
//     channel.sink.add("data");
//     setState(() {
//       _counter++;
//     });
//   }

//   void initialise() {
//     channel.stream.listen((event) {
//       print(event);

//       _streamController.sink.add(event);
//     });
//   }

//   @override
//   void initState() {
//     initialise();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: StreamBuilder(
//           stream: _streamController.stream,
//           initialData: "Loading",
//           builder: (context, snapshot) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                 Text(_counter.toString()),
//               ],
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IO.Socket socket = IO.io('ws://192.168.29.167:5000', <String, dynamic>{
    'transports': ['websocket'],
    //'extraHeaders': {'foo': 'bar'} // optional
  });

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void initialise() {
    socket.on('connect', (_) {
      print('connect');
      socket.emit('dataToServer', 'test');
    });
    socket.on('messageFromServer', (data) {
      print(data);
      socket.emit('dataToServer', "dataRecieved");
    });
    socket.connect();
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder(
          initialData: "Loading",
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.hasData ? '${snapshot.data}' : ''),
                Text(_counter.toString()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
