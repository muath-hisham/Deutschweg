import 'package:flutter/material.dart';
import 'package:menschen/screens/lessons/teacher_model.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherPage extends StatefulWidget {
  final Teacher teacher;
  const TeacherPage({super.key, required this.teacher});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher.name),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: widget.teacher.chapters.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.teacher.chapters.length) {
            return _chaptersCard(widget.teacher.chapters[index]);
          }
          return SizedBox(height: Dimensions.height(50));
        },
      ),
    );
  }

  Widget _chaptersCard(Map<String, String> chapter) {
    return MyWidgets.card(
      onTap: () => _openLink(chapter["link"].toString().trim()),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(20),
          horizontal: Dimensions.horizontal(5),
        ),
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(chapter['name'].toString()),
      ),
    );
  }

  _openLink(String link) async {
    try {
      final Uri url = Uri.parse(link);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() {
        print("error in launch link: $e");
      });
    }
  }
}
