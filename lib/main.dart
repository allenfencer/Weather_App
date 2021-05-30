import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Map _data;

void main()async{
  _data= await getWeather();
  print(_data['main']);


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Weather App',style: TextStyle(fontSize: 24),),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getWeather(),
        builder: (BuildContext context,snapshot){
          if(snapshot.hasData)
            {
              return ListView(
                children: [
                  BodyDetails(),
                ],
              );
            }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


Future <Map> getWeather()async{
  final _apiId='ff90fc3ebed6863c9040a73680446cc6';
  String url='https://api.openweathermap.org/data/2.5/weather?q=Malappuram&appid=$_apiId&units=metric';
  http.Response response = await http.get(Uri.parse(url));
  return jsonDecode(response.body);
}

TextStyle styling(){
  return TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}


class BodyDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 300,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.yellow[700],
                      Colors.blue,
                    ]
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Currently in ${_data['name']}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: Colors.white),),
                Text('${_data['main']['temp']}\u00B0',style: TextStyle(fontSize: 50,fontWeight: FontWeight.w500,color: Colors.white),),
                Text('${_data['weather'][0]['main']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w400,color: Colors.white),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.thermometerThreeQuarters,size: 30,color: Colors.red,),
              title: Text('Temperature',style: styling(),),
              trailing: Text('${_data['main']['temp']}\u00B0',style: styling(),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.cloudSunRain,size: 30,color: Colors.yellow[600],),
              title: Text('Weather',style: styling(),),
              trailing: Text('${_data['weather'][0]['main']}',style: styling(),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.tint,size: 30,color: Colors.blue,),
              title: Text('Humidity',style: styling(),),
              trailing: Text('${_data['main']['humidity']}',style: styling(),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(FontAwesomeIcons.wind,size: 30,color: Colors.blueGrey,),
              title: Text('Wind Speed',style: styling(),),
              trailing: Text('${_data['wind']['speed']}',style: styling(),),
            ),
          ),
        ],
      ),
    );
  }
}
