import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssistantInstructionsScreen extends StatelessWidget {
  const AssistantInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Assistant Instructions",
          style: TextStyle(
            fontSize: 18,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.left_chevron),
          color: Colors.indigo,
        ),
        elevation: 0,
        backgroundColor: Colors.indigo.shade50,
      ),
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/banner.png",
                    scale: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Center(
                  child: Text(
                    "Smart Home",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _roomInstructions(1),
                _roomInstructions(2),
                _roomInstructions(3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _roomInstructions(int roomNumber) {
    late String room;

    if (roomNumber == 1) {
      room = "First";
    } else if (roomNumber == 2) {
      room = "Second";
    } else if (roomNumber == 3) {
      room = "Third";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${room.toUpperCase()} ROOM",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _containerTitle("Turn On The Light/s In Room Number $roomNumber"),
        const SizedBox(height: 10),
        _containerTitle(" Turn On The Light/s In $room Room"),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }

  _containerTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 36,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 17.0),
        child: Row(
          children: [
            const Icon(
              Icons.mic,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
