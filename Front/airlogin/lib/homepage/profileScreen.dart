import 'package:airlogin/homepage/bookedticks_display.dart';
import 'package:airlogin/provider/timmy_provider.dart';
import 'package:flutter/material.dart';
import 'package:airlogin/constant.dart';
import 'package:provider/provider.dart';
import '../components/hoverMouse.dart';
import '../main.dart';
import 'bookedtickets.dart';
import 'cancelledbookings.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhiteOpacity,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainbackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 100, top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: HoverColorButton(
              text: 'Booked Flights',
              icon: Icons.airplane_ticket,
              defaultIconColor: tBlack,
              hoverIconColor: tWhite,
              defaultColor: tWhite,
              hoverColor: tBlack,
              defaultTextColor: tBlack,
              hoverTextColor: tWhite,
              buttonWidth: double.infinity,
              buttonHeight: 70.0,
              onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookedTickets(),
                        ),
                      );

              },
            ),
          ),
           Container(
            child: HoverColorButton(
              text: 'Cancelled Flights',
              icon: Icons.airplane_ticket,
              defaultIconColor: tBlack,
              hoverIconColor: tWhite,
              defaultColor: tWhite,
              hoverColor: tBlack,
              defaultTextColor: tBlack,
              hoverTextColor: tWhite,
              buttonWidth: double.infinity,
              buttonHeight: 70.0,
              onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelledBookedTickets(),
                        ),
                      );

              },
            ),
          ),
          Container(
            child: HoverColorButton(
              text: 'Settings',
              icon: Icons.settings,
              defaultIconColor: tBlack,
              hoverIconColor: tWhite,
              defaultColor: tWhite,
              hoverColor: tBlack,
              defaultTextColor: tBlack,
              hoverTextColor: tWhite,
              buttonWidth: double.infinity,
              buttonHeight: 70.0,
              onPressed: () {},
            ),
          ),
          Container(
            child: HoverColorButton(
              text: 'Log out',
              icon: Icons.logout_outlined,
              defaultIconColor: tBlack,
              hoverIconColor: tWhite,
              defaultColor: tWhite,
              hoverColor: tBlack,
              defaultTextColor: tBlack,
              hoverTextColor: tWhite,
              buttonWidth: double.infinity,
              buttonHeight: 70.0,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () {
                            context.read<TimsProvider>().logout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
