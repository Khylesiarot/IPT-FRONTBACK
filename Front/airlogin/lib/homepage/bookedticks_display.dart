import 'package:airlogin/homepage/bookTicket.dart';
import 'package:airlogin/provider/timmy_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booked_flights.dart';
import '../models/flights.dart';

class BookedTicketDisplay extends StatefulWidget {
  const BookedTicketDisplay({super.key});

  @override
  State<BookedTicketDisplay> createState() => _TicketDisplayState();
}

class _TicketDisplayState extends State<BookedTicketDisplay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimsProvider>(
      builder: (context, provider, _) {
        final List<Flights?> bookedFlights = provider.bookedFlights; //pwede ra mo buhat api na mo return for flights na cancelled para mo update largo

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

                  final bool response = await cancelBookedFlight(userId, flightId);
                
                  if(response) {
                    context.read<TimsProvider>().lBookedFlightCancelled(flight);
                    context.read<TimsProvider>().removedBookedFlightSS(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("reservation cancelled!"),
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
                  isCancelled: false,
                  index: index,
                ),
              );
            
          },
        );
      },
    );
  }
}
