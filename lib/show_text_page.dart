import 'dart:math';

import 'package:flutter/material.dart';

import 'data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowTextPage extends StatefulWidget {
  final bool cig;
  final bool negativeAffect;
  final bool choice;
  ShowTextPage(this.cig, this.negativeAffect, this.choice);
  @override
  _ShowTextPageState createState() => _ShowTextPageState();
}

class _ShowTextPageState extends State<ShowTextPage> {
  String _selectedMessage="";
  @override
  void initState(){
    getData();
    super.initState();
  }
  String _createKey(){
    return widget.cig.toString()+"_"+widget.negativeAffect.toString()+"_"+widget.choice.toString();
  }
  Future<List<int>> _getSharedPreference(int length) async{
    List<int> res=List<int>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _createKey();
    if(!prefs.containsKey(key) || prefs.getStringList(key).length!=length){
      for(int i=0;i<length;i++){
        res.add(0);
      }
    }else{
      List<String> v = prefs.getStringList(key);
      for(int i=0;i<v.length;i++){
        if(v[i]=="0") res.add(0);
        else res.add(1);
      }
    }
    return res;
  }
  Future<int> _setSharedPreference(List<int> status) async{
    Random _r = Random();
    int index;
    List<int> indexList = new List();
    for(int i=0;i<status.length;i++){
      if(status[i]==0) indexList.add(i);
    }
    if(indexList.length==0){
      index = _r.nextInt(status.length);
      for(int i=0;i<status.length;i++){
        status[i]=0;
      }
      status[index]=1;
    }else{
      index = indexList[_r.nextInt(indexList.length)];
      status[index]=1;
    }
    List<String> res = List();
    for(int i=0;i<status.length;i++){
      if(status[i]==0)
        res.add("0");
      else res.add("1");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_createKey(), res);

    return index;
  }
  void getData() async{
    List<String> messages = Data.getMessage(widget.cig, widget.negativeAffect, widget.choice);
    List<int> status = await _getSharedPreference(messages.length);
    int _selectedIndex = await _setSharedPreference(status);
    _selectedMessage = messages[_selectedIndex];
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Low Effort Intervention"),
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(

              child: Padding(padding: EdgeInsets.all(16), child: Center(child: Text(_selectedMessage, style: TextStyle(fontSize: 24, height: 1.5),textAlign: TextAlign.center))),
            ),
            RaisedButton(
              child: Text("Close"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
    );
  }
}
