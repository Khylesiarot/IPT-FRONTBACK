import 'package:flutter/material.dart';

import '../constant.dart';
import 'bookedticks_display.dart';
import 'cancelledbookingdisplay.dart';

class CancelledBookedTickets extends StatelessWidget {
  const CancelledBookedTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 230,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainbackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 50, bottom: 100, top: 20),
              child: Row(
                children: const [
                  Icon(
                    Icons.airplane_ticket,
                    color: tWhite,
                    size: 40,
                  ),
                  Text(
                    "Let's book your\nflight",
                    style: TextStyle(
                        color: tWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: tWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:  const CancelledBookedTicketDisplay()),
          ),
        ],
      ),
    );
  }
}