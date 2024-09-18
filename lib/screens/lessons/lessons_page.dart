import 'package:flutter/material.dart';
import 'package:menschen/screens/lessons/teacher_model.dart';
import 'package:menschen/screens/lessons/teacher_page.dart';
import 'package:menschen/shared/BottomBar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<Teacher> teachers = [];

  @override
  void initState() {
    super.initState();
    _addTeachers();
  }

  _addTeachers() {
    List<Teacher> li = [];
    Teacher t1 = Teacher.fromMap({
      "name": "Frau Hend",
      "image": "frau_hend.png",
      "chapters": [
        {
          "name": "أساسيات اللغة الألمانية",
          "link": "https://t.me/frauhendtahakanal/33",
        },
        {
          "name": "مستوى A1.1 (من درس 1 الى 12)",
          "link": "https://t.me/frauhendtahakanal/35",
        },
        {
          "name": "مستوى A1.2 (درس 13 الى 24)",
          "link": "https://t.me/frauhendtahakanal/47",
        },
        {
          "name": "ملفات مستوى A1",
          "link":
              "https://drive.google.com/drive/folders/1hcVj8re7Y0j22RX2NBRxI4sprRrve4nd?usp=sharing",
        },
        {
          "name": "زيتونة القواعد مستوى A1",
          "link": "https://t.me/frauhendtahakanal/64",
        },
        {
          "name": "مستوى A2.1 (درس 1 الى 12)",
          "link": "https://t.me/frauhendtahakanal/82",
        },
        {
          "name": "مستوى A2.2 (درس 13 الى 24)",
          "link": "https://t.me/frauhendtahakanal/94",
        },
        {
          "name": "ملفات A2",
          "link":
              "https://drive.google.com/drive/folders/12N_amw_geZZYdvwMWWDPEOKtTvYobXqk?usp=sharing",
        },
        {
          "name": "زيتونة القواعد A2",
          "link": "https://t.me/frauhendtahakanal/108",
        }
      ]
    });

    li.add(t1);

    Teacher t2 = Teacher.fromMap({
      "name": "Herr Deyaa",
      "image": "herr_deyaa.png",
      "chapters": [
        {
          "name": "دقائق المانية مع ضياء A1-A2-B1",
          "link":
              "https://www.youtube.com/playlist?list=PLb4LszRKRuSHBbEHGYi8GJHaBAxwYhSnc",
        },
      ]
    });

    li.add(t2);

    Teacher t3 = Teacher.fromMap({
      "name": "Herr Mohamed Ali",
      "image": "herr_mohamed_ali.png",
      "chapters": [
        {
          "name": "A1.1",
          "link":
              "https://www.youtube.com/playlist?list=PLJnQn7RjLK6_QCU_wAgi1wlOExmcBJrEC",
        },
        {
          "name": "A1.2",
          "link":
              "https://www.youtube.com/playlist?list=PLJnQn7RjLK68wyowfh7mAm_nJfuOOC7z1",
        },
        {
          "name": "A2.1",
          "link":
              "https://www.youtube.com/playlist?list=PLJnQn7RjLK69UZunetgtb6eWZjK_U4qiD",
        },
        {
          "name": "A2.2",
          "link":
              "https://www.youtube.com/playlist?list=PLJnQn7RjLK6-ykuxgIM5AeYD_hCz-G094",
        },
        {
          "name": "B1.1",
          "link":
              "https://www.youtube.com/playlist?list=PLJnQn7RjLK68yA06XSreQf7WMoH1btewv",
        },
      ]
    });

    li.add(t3);

    setState(() {
      teachers.addAll(li);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await MyWidgets.showExitConfirmationDialog(context);
        return shouldExit;
      },
      child: Scaffold(
        bottomNavigationBar: BottomBar(active: "lessons"),
        body: SafeArea(top: true, child: _body()),
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        return _teacherCardDesign(teachers[index]);
      },
    );
  }

  Widget _teacherCardDesign(Teacher teacher) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TeacherPage(teacher: teacher))),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(10),
          horizontal: Dimensions.horizontal(10),
        ),
        height: Dimensions.height(200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0.2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          child: Image.asset(
            "assets/teachers/${teacher.image}",
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
