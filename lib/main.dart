import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Check Fibonacci Sequence'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var number = TextEditingController();
  int num;
  bool result = false;
  List<TextInputFormatter> keypad = [ WhitelistingTextInputFormatter.digitsOnly ];

  Future<bool> fib(int num) async {
    var queryParameters = {
      'number': '$num'
    };

    //var url = new Uri.https("us-central1-pruooo.cloudfunctions.net", "/helloWorld123", queryParameters);
    var url = "https://us-central1-pruooo.cloudfunctions.net/helloWorld123?number=$num";

    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    setState(() {
      result = jsonDecode(response.body)["success"];
    });
    print(result);

    //print(await http.read('https://us-central1-pruooo.cloudfunctions.net/helloWorld123'));
    return result;

  }

  @override
  Widget build(BuildContext context) {

    Future<void> alert(int num) async {
      bool res = await fib(num);
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('The number: '+num.toString()),
            content: Text(res ? "is a Fibonacci Number" : "is not a Fibonacci Number"),
            actions: <Widget>[
              FlatButton(
                child: Text('Try another one?'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: number,
                onChanged: (txt){
                  num = int.parse(txt);
                },
                decoration: new InputDecoration(labelText: "Enter your number"),
                keyboardType: TextInputType.number,
                inputFormatters: keypad,
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () async{
                print(num);
                //result = await fib(num);
                //print("res: "+result.toString());
                //result = true;
                //alert(num);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator(),);
                    });
                await alert(num);
                Navigator.pop(context);
              },
              child: Text("Ckeck"),
            ),
            //Text(result.toString());
          ],
        ),
      ),
    );
  }
}
