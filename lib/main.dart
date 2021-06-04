import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Map _data;
String defaultCity='malappuram';

void main()async{
  _data= await getWeather(defaultCity);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _cityName=TextEditingController();

  void search(){
    setState(() {
      if(_cityName.text.isEmpty)
        {
          defaultCity='Malappuram';
        }
      else{
        defaultCity=_cityName.text.toString();
      }
    });
  }

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
        future: getWeather(defaultCity),
        builder: (BuildContext context,snapshot){
          _data=snapshot.data;
          if(snapshot.hasData)
            {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5,10,5,30),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: TextStyle(color: Colors.white,fontSize: 25),
                                  keyboardType: TextInputType.text,
                                  controller: _cityName,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.white,width: 1)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.blue,width: 3)),
                                    labelText: 'City',
                                    labelStyle: TextStyle(fontSize: 25,color: Colors.blue),
                                    hintText: 'Enter your City',
                                    hintStyle: TextStyle(fontSize: 25,color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              IconButton(onPressed: (){
                                search();
                                print(defaultCity);
                                },icon: Icon(Icons.search,size: 35,color: Colors.white,),),
                            ],
                          ),
                        ),
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
                              Text('${_data['main']['temp']}\u00B0C',style: TextStyle(fontSize: 50,fontWeight: FontWeight.w500,color: Colors.white),),
                              Text('${_data['weather'][0]['main']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w400,color: Colors.white),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: ListTile(
                            leading: Icon(FontAwesomeIcons.thermometerThreeQuarters,size: 30,color: Colors.red,),
                            title: Text('Temperature',style: styling(),),
                            trailing: Text('${_data['main']['temp']}\u00B0C',style: styling(),),
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
                  ),
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



Future <Map> getWeather(String city)async{
  final _apiId='ff90fc3ebed6863c9040a73680446cc6';
  String url='https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiId&units=metric';
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


