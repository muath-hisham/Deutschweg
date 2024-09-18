import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/exams/exams_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({super.key});

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Plays a sound based on whether the answer is correct or not
  Future<void> _playSound() async {
    String soundPath = 'sounds/congratulations.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height(130)),
              alignment: Alignment.center,
              child: Image.asset("assets/images/cong.jpg"),
            ),
            SizedBox(height: Dimensions.height(40)),
            Text(
              MyText.congratulations,
              style: TextStyle(fontSize: Dimensions.fontSize(20)),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(MyText.done)),
            SizedBox(height: Dimensions.height(50)),
          ],
        ),
      ),
    );
  }
}
