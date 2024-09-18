import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';

class TTSWidget extends StatefulWidget {
  final String audioText;
  final Color? color;

  const TTSWidget({super.key, required this.audioText, this.color});

  @override
  _TTSWidgetState createState() => _TTSWidgetState();
}

class _TTSWidgetState extends State<TTSWidget> {
  bool isTheAudioRun = false;
  Color? color;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    color = widget.color ?? secondTextColor;

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isTheAudioRun = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        isTheAudioRun = false;
      });
      print("Error: $msg");
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String audioText) async {
    try {
      await _flutterTts.setLanguage("de-DE");
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(0.8);
      await _flutterTts
          .setVoice({"name": "de-de-x-gfn#male_1-local", "locale": "de-DE"});
      await _flutterTts.speak(audioText);
    } catch (e) {
      print("Error occurred while trying to speak: $e");
      setState(() {
        isTheAudioRun = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isTheAudioRun
          ? null
          : () async {
              setState(() {
                isTheAudioRun = true;
              });

              try {
                await _speak(widget.audioText);
              } finally {
                // Ensure that the state is reset in case of any exception
                setState(() {
                  isTheAudioRun = false;
                });
              }
            },
      child: isTheAudioRun
          ? SizedBox(
              width: Dimensions.width(25),
              height: Dimensions.width(25),
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 2,
              ),
            )
          : Icon(
              Icons.volume_up_outlined,
              color: color,
            ),
    );
  }
}

////////////////////////////////////////////////////////////////

class ReadTextButton extends StatefulWidget {
  final String audioText;
  final String title;

  const ReadTextButton(
      {super.key, required this.audioText, required this.title});

  @override
  _ReadTextButtonState createState() => _ReadTextButtonState();
}

class _ReadTextButtonState extends State<ReadTextButton> {
  bool isTheAudioRun = false;
  Color color = secondTextColor; // Define your color here
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isTheAudioRun = false;
      });
    });
    _flutterTts.setErrorHandler((msg) {
      setState(() {
        isTheAudioRun = false;
      });
      print("Error: $msg");
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String audioText) async {
    try {
      await _flutterTts.setLanguage("de-DE");
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(0.8);
      await _flutterTts
          .setVoice({"name": "de-de-x-gfn#male_1-local", "locale": "de-DE"});
      await _flutterTts.speak(audioText);
    } catch (e) {
      print("Error occurred while trying to speak: $e");
      setState(() {
        isTheAudioRun = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isTheAudioRun
          ? SizedBox(
              width: Dimensions.width(25),
              height: Dimensions.width(25),
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 2,
              ),
            )
          : Icon(
              Icons.volume_up_outlined,
              color: color,
            ),
      title: Text(widget.title),
      onTap: isTheAudioRun
          ? null
          : () async {
              setState(() {
                isTheAudioRun = true;
              });

              try {
                await _speak(widget.audioText);
              } finally {
                // Ensure that the state is reset in case of any exception
                setState(() {
                  isTheAudioRun = false;
                });
              }
              },
    );
  }
}
