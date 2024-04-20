import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrico_import/services/globals.dart';

class ProvedoorServices {
  var status;

  var token;
  //a;adir producto
  void addProveedor(String nombreempresa, String razonsocial, String nombreproveedor, int numcontacto) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;

    var url = Uri.parse('${baseURL}proveedor/store');
    final response = await http.post(url,
        headers: {'Accept': 'application/json'},
        body: {"nombreempresa": nombreempresa, 'razonsocial': razonsocial, 'nombreproveedor': nombreproveedor, "numcontacto": "$numcontacto"});
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  void editProveedor(String id, String nombreempresa, String razonsocial, String nombreproveedor, int numcontacto) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;
    var url = Uri.parse('${baseURL}proveedor/update/$id');
    http.put(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "nombreempresa": nombreempresa,
      'razonsocial': razonsocial,
      'nombreproveedor': nombreproveedor,
      "numcontacto": "$numcontacto"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void removeProveedor(String id) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;
    var url = Uri.parse('${baseURL}proveedor/destroy/$id');

    http.delete(url, headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'}).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;

    var url = Uri.parse('${baseURL}proveedor/showto');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
