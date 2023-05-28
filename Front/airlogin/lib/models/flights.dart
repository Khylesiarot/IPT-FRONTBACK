import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Flights {
  final String id;
  final String departurs;
  final String destination;
  final DateTime? dateArrival;
  final DateTime? departureDate;
  final int price;

  Flights({
    required this.id,
    this.departurs = "Philippines",
    required this.destination,
    this.dateArrival,
    this.departureDate,
    required this.price,
  });

  factory Flights.fromJson(Map<String, dynamic> json) {
    return Flights(
      id: json['id'],
      departurs: json['departurs'],
      destination: json['destination'],
      dateArrival: json['dateArrival'] != null
          ? DateTime.parse(json['dateArrival'])
          : null,
      departureDate: json['departureDate'] != null
          ? DateTime.parse(json['departureDate'])
          : null,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departurs': departurs,
      'destination': destination,
      'dateArrival': dateArrival?.toIso8601String(),
      'departureDate': departureDate?.toIso8601String(),
      'price': price,
    };
  }
}


Future<List<Flights>> getFlights() async {
  final response = await http.get(Uri.parse('http://localhost:8000/flights/'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Flights.fromJson(item)).toList();
  } else {
    throw Exception('Failed to fetch flights');
  }
}

Future<List<Flights>> fetchUserBookedFlights(String userId) async {
  final url = 'http://localhost:8000/users/$userId/booked-flights/';
  
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
  
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) => Flights.fromJson(item)).toList();

  } else {
    throw Exception('Failed to fetch booked flights');
  }
}