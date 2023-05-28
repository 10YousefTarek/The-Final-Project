import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SensorRunningScreen extends StatefulWidget {
  final bool isFire;
  const SensorRunningScreen({super.key, required this.isFire});

  @override
  State<SensorRunningScreen> createState() => _SensorRunningScreenState();
}

class _SensorRunningScreenState extends State<SensorRunningScreen> {
  final audioPlayer = AudioPlayer();

  Future setAudio() async {
    audioPlayer
        .setReleaseMode(widget.isFire ? ReleaseMode.loop : ReleaseMode.stop);
    audioPlayer
        .play(AssetSource(widget.isFire ? 'fire_alarm.mp3' : 'rain_alarm.mp3'));
  }

  @override
  void initState() {
    super.initState();
    setAudio();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isFire ? Colors.red : Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.left_chevron, color: Colors.white,),
        ),
      ),
      backgroundColor: widget.isFire ? Colors.red : Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: Text(
            widget.isFire ? "Fire Sensor is Running" : "Rain Sensor is Running",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
