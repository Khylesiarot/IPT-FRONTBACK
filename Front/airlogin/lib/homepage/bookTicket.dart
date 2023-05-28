import 'package:airlogin/models/flights.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constant.dart';
import '../models/booked_flights.dart';
import '../models/user.dart';
import '../provider/timmy_provider.dart';

class Ticket extends StatelessWidget {
  final String id;
  final String departurs;
  final String destination;
  final DateTime? dateArrival;
  final DateTime? departureDate;
  final int price;
  final bool isBooked;
  final bool isCancelled;
  final int index;

  const Ticket({
    super.key,
    required this.id,
    required this.departurs,
    required this.destination,
    this.dateArrival,
    this.departureDate,
    required this.price,
    required this.isBooked,
    required this.isCancelled, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final timsProvider = Provider.of<TimsProvider>(context);
    List<Users?> usersList = timsProvider.usersList;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: tWhite,
              image: DecorationImage(
                image: AssetImage('assets/images/planeticket.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes the position of the shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Flight: $id",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: tBlack,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "$departurs ------✈︎------- $destination",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: tBlack,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Departure date: $departureDate",
                            style: const TextStyle(
                              fontSize: 12,
                              color: tBlack,
                            ),
                          ),
                          Text(
                            "Arrival date: $dateArrival",
                            style: const TextStyle(
                              fontSize: 12,
                              color: tBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Center(
                      child: isBooked
                          ? null
                          : IconButton(
                              onPressed: () async {
                                const uuid = Uuid();
                                final yourId = uuid.v4();
                                final userId = usersList[0]!.userId;
                                final flightId = id;

                                BookedFlights newBookedFlight = BookedFlights(
                                    id: yourId,
                                    user: userId,
                                    flight: flightId,
                                    isCancelled: false);
                                final bool isSuc;
                                
                                    // await createBookedFlight(newBookedFlight);
                                    isSuc = await createBookedFlight(
                                        newBookedFlight, userId, flightId);
                                if (isSuc) {
                                  Flights bookedFlight = Flights(
                                    id: id,
                                    departurs: departurs,
                                    departureDate: departureDate,
                                    destination: destination,
                                    dateArrival: dateArrival,
                                    price: price,
                                  );

                                  context.read<TimsProvider>().addBookedFlightSS(bookedFlight);
                                  context.read<TimsProvider>().removeflight(index);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ticket booked'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Booking Failed'),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.airplane_ticket_rounded)),
                    ))
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )));
  }
}
