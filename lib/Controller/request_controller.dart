import 'dart:convert'; //json decode/encode
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestController {
  

  String path;
  String server;
  http.Response? _res;
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _headers = {};
  dynamic _resultData;

  RequestController({required this.path, this.server = "http://172.20.10.2"}); // Constructor with two parameter, path and server
  setBody(Map<String, dynamic> data) {
    _loadUrl();
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";
  }
  Future<void> post() async{
    _res = await http.post(
    Uri.parse(server + path),
    headers: _headers,
    body: jsonEncode(_body),
    );
    _parseResult();
    //await _storeUrl();
  }
  Future<void> get() async{
    _res = await http.get(
    Uri.parse(server + path),
    headers: _headers,
    );
    _parseResult();
    //await _storeUrl();
  }
  Future<void> put() async{
    _res = await http.put(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
  }

  Future<void> delete() async{
    _res = await http.delete(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );
    _parseResult();
  }

  void _parseResult(){
    try{
      print("raw response :${_res?.body}");
      _resultData = jsonDecode(_res?.body?? "");
  }catch(ex){
      _resultData = _res?.body;
      print("exception in http result parsing ${ex}");
  }
  }

  dynamic result(){
    return _resultData;
  }
  int status(){
    return _res?.statusCode ?? 0;
  }

  Future<void> _storeUrl() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('serverUrl', server);
  }

  Future<void> _loadUrl() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    server = prefs.getString('serverUrl') ?? "http://172.20.10.2";
  }
}
