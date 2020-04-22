import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'User'),
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
  Future<List<User>> _getUsers() async {
    var data = await http.get("http://jsonplaceholder.typicode.com/users");
    var jsonData = json.decode(data.body);
    List<User> users = [];
    for(var u in jsonData){
      User user = User(u["id"],u["name"],u["username"], u["email"],u['phone']);
      users.add(user);
    }
    print(users.length);
    return users;

  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        child:  FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading Data,Please wait"),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,


                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/flutter.png',),

                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),

                     onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => InfoPage(snapshot.data[index]))
                  );
                }
                );
              });
            }
          }),

       ),
    );
  }
}
class InfoPage extends StatelessWidget {
  final User user;
  InfoPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(user.phone),

          Text(user.email),
          Align(
            alignment: Alignment.topCenter,
            child: Text(user.username),




          )
        ],


      ),





    );

  }
}

class User{
  final int id;

  final String name;
  final String username;
  final String email;
  final String phone;


  User(this.id,this.name,this.username,this.email,this.phone);
}