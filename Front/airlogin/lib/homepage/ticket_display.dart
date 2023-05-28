import 'package:airlogin/homepage/bookTicket.dart';
import 'package:airlogin/provider/timmy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flights.dart';

class TicketDisplay extends StatefulWidget {
  const TicketDisplay({Key? key}) : super(key: key);

    @override
  State<TicketDisplay> createState() => _TicketDisplayState();
}

class _TicketDisplayState extends State<TicketDisplay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimsProvider>(
      builder: (context, provider, _) {
        final List<Flights?> flightsList = provider.flightsList;

        return ListView.builder(
          itemCount: flightsList.length,
          itemBuilder: (context, index) {
            final flight = flightsList[index];
            final String id = flight!.id;

            // Check if the flight is booked
            bool isBooked = provider.bookedFlightsList.any((bf) => bf.flight == id);

            // Check if the flight is cancelled
      

            // Return the UI elements for each flight that is not booked or is booked but cancelled
            if (!isBooked ) {
              return Ticket(
                id: flight.id,
                departurs: flight.departurs,
                destination: flight.destination,
                dateArrival: flight.dateArrival,
                departureDate: flight.departureDate,
                price: flight.price,
                isBooked: false,
                isCancelled: false,
              );
            } else {
              // Return an empty container for booked flights that are not cancelled
              return Container();
            }
          },
        );
      },
    );
  }
}
