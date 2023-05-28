import 'package:flutter/material.dart';

import '../models/booked_flights.dart';
import '../models/flights.dart';
import '../models/user.dart';

class TimsProvider extends ChangeNotifier{

final List<Users?> _usersList = [];

List<Users?> get usersList => _usersList;

final List<Flights?> _flightsList = [];

List<Flights?> get flightsList => _flightsList;

final List<BookedFlights> _bookedFlightsList = [];

List<BookedFlights> get bookedFlightsList => _bookedFlightsList;

final List<Flights?> _bookedFlights = [];

List<Flights?> get bookedFlights => _bookedFlights;


  void addUser(Users user) {
    _usersList.add(user);
    notifyListeners();
  }

  void addBookedFlight(BookedFlights bookedFlight) {
    _bookedFlightsList.add(bookedFlight);
    notifyListeners();
  }


  void addFlights(List<Flights> flight) {
    _flightsList.addAll(flight);
    notifyListeners();
  }


  
  void addAllBookedFlight(List<BookedFlights> bookedFlight) {
    _bookedFlightsList.addAll(bookedFlight);
    notifyListeners();
  }

   void addBookedFlightSS(Flights bookedFlight) {
    _bookedFlights.add(bookedFlight);
    notifyListeners();
  }

  void flightsBooked(List<Flights?> bookedFlight) {
    _bookedFlights.addAll(bookedFlight);
    notifyListeners();
  }



void editBookedFlightCancellationStatus(String bookedFlightId) {
    final bookedFlight = _bookedFlightsList.firstWhere(
      (flight) => flight.id == bookedFlightId
    );

    bookedFlight.isCancelled = true;
    notifyListeners();
  }



void reBookedFlightCancellationStatus(String bookedFlightId) {
    final bookedFlight = _bookedFlightsList.firstWhere(
      (flight) => flight.id == bookedFlightId
    );

    bookedFlight.isCancelled = false;
    notifyListeners();
  }
}