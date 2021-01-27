import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:world/models/Country.dart';
import 'package:world/pages/country_view.dart';


class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();

}

class ListSearchState extends State<ListSearch>  with AutomaticKeepAliveClientMixin {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();


  Future<List<Country>> getAll() async {
    String strContries= await rootBundle.loadString('data/all.json');
     Iterable l=json.decode(strContries);
    List<Country> list = List<Country>.from(l.map((model)=> Country.fromJson(model)));
    actualDataList=list;
    if(tempList==null){
      tempList=actualDataList;
    }
    return list;
  }

  // Copy Main List into New List.
  List<Country> actualDataList =null;
  List<Country> tempList =null;

  onItemChanged(String value) {
    setState(() {
        getAll().then((contries) => {tempList=contries
          .where((country) => country.name.toLowerCase().contains(value.toLowerCase()))
          .toList()});
    });
  }


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: getAll(),
    builder:(context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    } else {
    return
      Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  itemCount: tempList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage:Image.asset('assets/images/countries_sm/${tempList[index]
                            .alpha2Code}.png'.toLowerCase()).image,
                        backgroundColor: Colors.transparent,),
                      title: Text(tempList[index].name),
                      onTap: () {
                        Navigator.push (
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                CountryView(tempList[index]),
                          ),
                        );
                      },
                    );
                  }
              )
          )
        ],
      ),
    );
    }
    }
      );
  }

  @override
  bool get wantKeepAlive => true;
}