

import 'package:airlogin/homepage/bookTicket.dart';
import 'package:airlogin/models/booked_flights.dart';
import 'package:airlogin/provider/timmy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flights.dart';

class CancelledBookedTicketDisplay extends StatefulWidget {
  const CancelledBookedTicketDisplay({super.key});

  @override
  State<CancelledBookedTicketDisplay> createState() => _CancelledBookedTicketDisplay();
}

class _CancelledBookedTicketDisplay extends State<CancelledBookedTicketDisplay> {
     
  @override
  Widget build(BuildContext context) {
    
return Consumer<TimsProvider>(
  builder: (context, provider, _) {
    final List<Flights?> bookedFlights = provider.bookedFlightscancelled;

    return ListView.builder(
      itemCount: bookedFlights.length,
      itemBuilder: (context, index) {
        final flight = bookedFlights[index];

    
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
          onDismissed: (direction) async {
     final user = provider.usersList;
     final userId = user[0]!.userId;
    final flightId = flight.id;

    final bool response  = await reBookedFlight(userId, flightId);

 
                  if(response) {
                    context.read<TimsProvider>().rebooked(flight);
                    context.read<TimsProvider>().removeBookedFlightCancelled(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("rebooked suceesfully!"),
                    ),
                  );
                  }
  },
            child: Ticket(
              id: flight!.id,
              departurs: flight.departurs,
              destination: flight.destination,
              dateArrival: flight.dateArrival,
              departureDate: flight.departureDate,
              price: flight.price,
              isBooked: true,
              isCancelled: true,
              index: index,
            ),
          );
      
      },
    );
  },
);
  }
}