import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Elevation APIs
const apiEndpoint = 'https://api.open-elevation.com/api/v1/lookup';

Future<String> fetchElevation() async {
  var location = '';
  try {
    location = await getLocation();
  } catch (e) {
    return 'Waiting for Location';
  }
  final Uri url = Uri.parse('$apiEndpoint?locations=$location');
  try {
    final http.Response response = await http.get(url);
    final Map data = jsonDecode(response.body);
    return data['results'][0]['elevation'].toInt().toString();
  } catch (e) {
    return 'Waiting for Elevation';
  }
}

Future<String> getLocation() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    return '${position.latitude},${position.longitude}';
  } else {
    throw Exception();
  }
}
