import 'dart:convert';
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'assistant_instructions_screen.dart';
import 'sensor_running_screen.dart';

class SmartHomeScreen extends StatefulWidget {
  final BluetoothDevice server;

  const SmartHomeScreen({super.key, required this.server});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreen();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _SmartHomeScreen extends State<SmartHomeScreen> {
  var connection; //BluetoothConnection

  bool isConnecting = true;
  bool isDisconnecting = false;

  // bottom navigation bar
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // tts
  FlutterTts flutterTts = FlutterTts();

  // stt
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _indexOfResponses = null;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  final List<String> _resposes = [
    'OK',
    'Hello',
    'My name is Makkah',
    'I\'m your assistant in your smart home',
    'Thank You',
  ];

  int? _indexOfResponses;

  _doByVoice(words) async {
    if (words.toLowerCase() == 'turn on the light in room number one' ||
        words.toLowerCase() == 'turn on the lights in room number one' ||
        words.toLowerCase() == 'turn on the lights in first room' ||
        words.toLowerCase() == 'turn on the light in first room') {
      await _sendMessage('1').then((value) async {
        setState(() {
          _toggle_lights_room1 = true;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() == 'turn off the light in room number one' ||
        words.toLowerCase() == 'turn off the lights in room number one' ||
        words.toLowerCase() == 'turn off the lights in first room' ||
        words.toLowerCase() == 'turn off the light in first room') {
      await _sendMessage('2').then((value) async {
        setState(() {
          _toggle_lights_room1 = false;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() == 'turn on the light in room number two' ||
        words.toLowerCase() == 'turn on the lights in room number two' ||
        words.toLowerCase() == 'turn on the lights in second room' ||
        words.toLowerCase() == 'turn on the light in second room') {
      await _sendMessage('3').then((value) async {
        setState(() {
          _toggle_lights_room2 = true;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() == 'turn off the light in room number two' ||
        words.toLowerCase() == 'turn off the lights in room number two' ||
        words.toLowerCase() == 'turn off the lights in second room' ||
        words.toLowerCase() == 'turn off the light in second room') {
      await _sendMessage('4').then((value) async {
        setState(() {
          _toggle_lights_room2 = false;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() ==
            'turn on the light in room number three' ||
        words.toLowerCase() == 'turn on the lights in room number three' ||
        words.toLowerCase() == 'turn on the lights in third room' ||
        words.toLowerCase() == 'turn on the light in third room') {
      await _sendMessage('5').then((value) async {
        setState(() {
          _toggle_lights_room3 = true;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() ==
            'turn off the light in room number three' ||
        words.toLowerCase() == 'turn off the lights in room number three' ||
        words.toLowerCase() == 'turn off the lights in third room' ||
        words.toLowerCase() == 'turn off the light in third room') {
      await _sendMessage('6').then((value) async {
        setState(() {
          _toggle_lights_room3 = false;
          _indexOfResponses = 0;
        });
        await flutterTts.setLanguage("en-US");

        await flutterTts.setSpeechRate(0.8);

        await flutterTts.setVolume(1.0);

        await flutterTts.speak(_resposes[_indexOfResponses!]);
      });
    } else if (words.toLowerCase() == 'hello') {
      await flutterTts.setLanguage("en-US");

      await flutterTts.setSpeechRate(0.4);

      await flutterTts.setVolume(1.0);
      setState(() {
        _indexOfResponses = 1;
      });
      await flutterTts.speak(_resposes[_indexOfResponses!]);
    } else if (words.toLowerCase() == "what's your name" ||
        words.toLowerCase() == 'what is your name') {
      await flutterTts.setLanguage("en-US");

      await flutterTts.setSpeechRate(0.4);

      await flutterTts.setVolume(1.0);
      setState(() {
        _indexOfResponses = 2;
      });
      await flutterTts.speak(_resposes[_indexOfResponses!]);
    } else if (words.toLowerCase() == "what are you doing" ||
        words.toLowerCase() == 'who are you') {
      await flutterTts.setLanguage("en-US");

      await flutterTts.setSpeechRate(0.4);

      await flutterTts.setVolume(1.0);
      setState(() {
        _indexOfResponses = 3;
      });
      await flutterTts.speak(_resposes[_indexOfResponses!]);
    } else if (words.toLowerCase() == "you are great" ||
        words.toLowerCase() == 'good job' ||
        words.toLowerCase() == "you're great") {
      await flutterTts.setLanguage("en-US");

      await flutterTts.setSpeechRate(0.4);

      await flutterTts.setVolume(1.0);
      setState(() {
        _indexOfResponses = 4;
      });
      await flutterTts.speak(_resposes[_indexOfResponses!]);
    }
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    await _doByVoice(_lastWords);
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected()) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  bool _toggle_lights_room1 = false;
  bool _toggle_lights_room2 = false;
  bool _toggle_lights_room3 = false;
  //bool _toggle_window = false;

  @override
  Widget build(BuildContext context) {
    // final List<Row> list = messages.map((message) {
    //   return Row(
    //     mainAxisAlignment: message.whom == clientID
    //         ? MainAxisAlignment.end
    //         : MainAxisAlignment.start,
    //     children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.all(12.0),
    //         margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
    //         width: 222.0,
    //         decoration: BoxDecoration(
    //             color:
    //                 message.whom == clientID ? Colors.blueAccent : Colors.grey,
    //             borderRadius: BorderRadius.circular(7.0)),
    //         child: Text(
    //             (text) {
    //               return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
    //             }(message.text.trim()),
    //             style: const TextStyle(color: Colors.white)),
    //       ),
    //     ],
    //   );
    // }).toList();

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: isConnecting
            ? const Center(
                child: Text(
                  "WAIT UNTIL CONNECTED ...",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : isConnected()
                ? selectedIndex == 0
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 18, left: 24, right: 24),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "HI THERE",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (conte) =>
                                                  const AssistantInstructionsScreen()));
                                    },
                                    icon: const RotatedBox(
                                      quarterTurns: 135,
                                      child: Icon(
                                        Icons.bar_chart_rounded,
                                        size: 28,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    const SizedBox(
                                      height: 32,
                                    ),
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
                                    const Text(
                                      "SERVICES",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _cardMenu(
                                          title: !_toggle_lights_room1
                                              ? "Turn on Lights in Room 1"
                                              : "Turn Off Lights in Room 1",
                                          icon: Icons.light,
                                          color: Colors.indigoAccent,
                                          fontColor: !_toggle_lights_room1
                                              ? Colors.black
                                              : Colors.white,
                                          onTap: isConnected()
                                              ? () async {
                                                  await _sendMessage(
                                                          _toggle_lights_room1
                                                              ? "2"
                                                              : "1")
                                                      .then((value) {
                                                    setState(() {
                                                      _toggle_lights_room1 =
                                                          !_toggle_lights_room1;
                                                    });
                                                  });
                                                }
                                              : null,
                                        ),
                                        _cardMenu(
                                          title: !_toggle_lights_room2
                                              ? "Turn on Lights in Room 2"
                                              : "Turn Off Lights in Room 2",
                                          icon: Icons.light,
                                          color: Colors.indigoAccent,
                                          fontColor: !_toggle_lights_room2
                                              ? Colors.black
                                              : Colors.white,
                                          onTap: isConnected()
                                              ? () async {
                                                  await _sendMessage(
                                                          _toggle_lights_room2
                                                              ? "4"
                                                              : "3")
                                                      .then((value) {
                                                    setState(() {
                                                      _toggle_lights_room2 =
                                                          !_toggle_lights_room2;
                                                    });
                                                  });
                                                }
                                              : null,
                                        ),

                                        // _cardMenu(
                                        //   title: !_toggle_window
                                        //       ? "Open The Window"
                                        //       : "Close The Window",
                                        //   icon: !_toggle_window
                                        //       ? Icons.square
                                        //       : Icons.crop_square_sharp,
                                        //   color: Colors.indigoAccent,
                                        //   fontColor: !_toggle_window
                                        //       ? Colors.black
                                        //       : Colors.white,
                                        //   onTap: isConnected()
                                        //       ? () async {
                                        //           await _sendMessage(
                                        //                   _toggle_window ? "-2" : "2")
                                        //               .then((value) {
                                        //             setState(() {
                                        //               _toggle_window =
                                        //                   !_toggle_window;
                                        //             });
                                        //           });
                                        //         }
                                        //       : null,
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        _cardMenu(
                                          title: !_toggle_lights_room3
                                              ? "Turn on Lights in Room 3"
                                              : "Turn Off Lights in Room 3",
                                          icon: Icons.light,
                                          color: Colors.indigoAccent,
                                          fontColor: !_toggle_lights_room3
                                              ? Colors.black
                                              : Colors.white,
                                          onTap: isConnected()
                                              ? () async {
                                                  await _sendMessage(
                                                          _toggle_lights_room3
                                                              ? "6"
                                                              : "5")
                                                      .then((value) {
                                                    setState(() {
                                                      _toggle_lights_room3 =
                                                          !_toggle_lights_room3;
                                                    });
                                                  });
                                                }
                                              : null,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(_lastWords),
                            ),
                            GestureDetector(
                              onTap: _speechToText.isNotListening
                                  ? _startListening
                                  : _stopListening,
                              child: AvatarGlow(
                                animate: _speechToText.isListening,
                                glowColor: Colors.blue,
                                endRadius: 90.0,
                                duration: const Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration:
                                    const Duration(milliseconds: 100),
                                child: Material(
                                  // Replace this child with your own
                                  elevation: 8.0,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    radius: 40.0,
                                    child: const Icon(
                                      Icons.mic,
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _speechToText.isListening
                                    ? ''
                                    : _speechEnabled
                                        ? 'Tap the microphone to start listening...'
                                        : 'Speech not available',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _indexOfResponses != null
                                    ? _resposes[_indexOfResponses!]
                                    : '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.indigoAccent, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      )
                : const Center(
                    child: Text(
                      "DISCONNECTED",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: isConnected()
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Buttons',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: 'Assistant',
                ),
              ],
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              unselectedLabelStyle: const TextStyle(
                  color: Colors.grey, fontFamily: "Cairo", fontSize: 15),
              currentIndex: selectedIndex,
              selectedItemColor: Colors.indigoAccent,
              selectedLabelStyle: const TextStyle(
                  color: Colors.grey, fontFamily: "Cairo", fontSize: 15),
              onTap: _onItemTapped,
            )
          : null,
    );
  }

  void _onDataReceived(Uint8List data) {
    String message = String.fromCharCodes(data);

    if (int.tryParse(message) == 15 || message == "15") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const SensorRunningScreen(isFire: true)));
    } else if (int.tryParse(message) == 16 || message == "16") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const SensorRunningScreen(isFire: false)));
    }
  }

  Future<void> _sendMessage(String text) async {
    text = text.trim();
    //textEditingController.clear();
    if (text.isNotEmpty) {
      try {
        connection.output.add(utf8.encode("$text\r\n"));
        await connection.output.allSent;
      } catch (e) {
        setState(() {});

        rethrow;

        // Ignore error, but notify state
      }
    }
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  Widget _cardMenu({
    required String title,
    required IconData icon,
    required void Function()? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: fontColor,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            )
          ],
        ),
      ),
    );
  }
}
