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
        final List<Flights?> bookedFlights = provider.bookedFlights;

        return ListView.builder(
          itemCount: bookedFlights.length,
          itemBuilder: (context, index) {
            final flight = bookedFlights[index];

            // Check if the flight is cancelled
            bool isCancelled = provider.bookedFlightsList
                .firstWhere((bf) => bf.flight == flight!.id)
                .isCancelled;

            // Return the UI elements for each flight that is not cancelled
            if (!isCancelled) {
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) async {
                  final user = provider.usersList;
                  final userId = user[0]!.userId;
                  final flightId = flight.id;

                  final String response =
                      await cancelBookedFlight(userId, flightId);
                  context
                      .read<TimsProvider>()
                      .editBookedFlightCancellationStatus(flightId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );
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
                ),
              );
            } else {
              // Return an empty container for cancelled flights
              return Container();
            }
          },
        );
      },
    );
  }
}
