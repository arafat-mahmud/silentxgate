import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _serverIP = "192.168.1.101";
  String _status = "Disconnected";

  final Map<String, dynamic> _vpnConfig = {
    "server": "10.0.0.1",
    "port": "51820",
    "username": "silentxgate",
    "password": "123456",
    "dns": "8.8.8.8",
  };

  @override
  void initState() {
    super.initState();
    _fetchServerIP();
  }

  Future<void> _fetchServerIP() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.101:8000/api/servers/'),
      );
      final data = jsonDecode(response.body);
      setState(() {
        _serverIP = data[0]['ip']; // Django API থেকে IP নিন
        _vpnConfig['server'] = _serverIP;
      });
    } catch (e) {
      print("API Error: $e");
    }
  }

  Future<void> _connectVPN() async {
    try {
      await FlutterVpn.connect(
        server: _vpnConfig['server'],
        username: _vpnConfig['username'],
        password: _vpnConfig['password'],
      );
      setState(() => _status = "Connected");
    } catch (e) {
      setState(() => _status = "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SilentXGate VPN")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Status: $_status", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Connect VPN"),
                onPressed: _connectVPN,
              ),
              SizedBox(height: 10),
              Text("Server: ${_vpnConfig['server']}:${_vpnConfig['port']}"),
              Text("DNS: ${_vpnConfig['dns']}"),
            ],
          ),
        ),
      ),
    );
  }
}
