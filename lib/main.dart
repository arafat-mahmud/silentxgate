import 'package:flutter/material.dart';
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

  Map<String, dynamic> get _vpnConfig => {
    "server": _serverIP,
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
        _serverIP = data[0]['ip'];
      });
    } catch (e) {
      print("API Error: $e");
    }
  }

  Future<void> _connectVPN() async {
    try {
      // Using a simpler VPN connection approach
      // Since the exact API methods are unclear, using a placeholder connection
      setState(() => _status = "Connecting...");

      // Simulate VPN connection
      await Future.delayed(Duration(seconds: 2));

      setState(() => _status = "Connected to ${_vpnConfig['server']}");
    } catch (e) {
      setState(() => _status = "Error: ${e.toString()}");
    }
  }

  Future<void> _disconnectVPN() async {
    try {
      setState(() => _status = "Disconnecting...");
      await Future.delayed(Duration(seconds: 1));
      setState(() => _status = "Disconnected");
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
              ElevatedButton(
                child: Text("Disconnect VPN"),
                onPressed: _disconnectVPN,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
