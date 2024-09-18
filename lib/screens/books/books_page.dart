import 'package:flutter/material.dart';
import 'package:menschen/screens/books/book_card.dart';
import 'package:menschen/shared/BottomBar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Map<String, dynamic>> booksToListen = [
    {
      "folder": "listen/a1.1_KB",
      "image": "assets/books/a1.1_KB.jpg",
      "no_pages": 13
    },
    {
      "folder": "listen/a1.1_AB",
      "image": "assets/books/a1.1_AB.jpg",
      "no_pages": 5
    },
    {
      "folder": "listen/a1.2_KB",
      "image": "assets/books/a1.2_KB.jpg",
      "no_pages": 9
    },
    {
      "folder": "listen/a1.2_AB",
      "image": "assets/books/a1.2_AB.jpg",
      "no_pages": 5
    },
  ];

  List<Map<String, dynamic>> booksToAnswer = [
    {
      "folder": "answers/a1.1_AB",
      "image": "assets/books/a1.1_AB.jpg",
      "no_pages": 17
    },
    {
      "folder": "answers/a1.2_AB",
      "image": "assets/books/a1.2_AB.jpg",
      "no_pages": 17
    },
  ];

  final String link =
      "https://drive.google.com/drive/folders/1JLIKyEOMuQdbC9d-Bd88rGQgJg_UZtWM?usp=sharing";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await MyWidgets.showExitConfirmationDialog(context);
        return shouldExit;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async => _openLink(),
            backgroundColor: mainColor,
            child: Icon(
              Icons.volume_up,
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: BottomBar(active: "books"),
          body: Center(
            child: SafeArea(top: true, child: _body()),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _tabs(),
        _tabsContent(),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.height(20),
        left: Dimensions.horizontal(30),
        right: Dimensions.horizontal(30),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(3),
        vertical: Dimensions.vertical(3),
      ),
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color(0xffc2c2c2), width: 0.5)),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Creates border
          color: tabControllerColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: MyText.listens),
          Tab(text: MyText.answers),
        ],
      ),
    );
  }

  Widget _tabsContent() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.height(15)),
        child: TabBarView(
          children: [
            _listens(),
            _answers(),
          ],
        ),
      ),
    );
  }

  Widget _listens() {
    return ListView.builder(
      itemCount: booksToListen.length ~/
          2, // Assumes each row contains 2 booksToListen
      itemBuilder: (context, index) {
        final book1 = booksToListen[index * 2];
        final book2 = booksToListen[index * 2 + 1];
        return Row(
          children: [
            BookCard(
              imagePath: book1['image'],
              folder: book1['folder'],
              noPages: book1['no_pages'],
            ),
            BookCard(
              imagePath: book2['image'],
              folder: book2['folder'],
              noPages: book2['no_pages'],
            ),
          ],
        );
      },
    );
  }

  Widget _answers() {
    return ListView.builder(
      itemCount: booksToAnswer.length ~/
          2, // Assumes each row contains 2 booksToAnswer
      itemBuilder: (context, index) {
        final book1 = booksToAnswer[index * 2];
        final book2 = booksToAnswer[index * 2 + 1];
        return Row(
          children: [
            BookCard(
              imagePath: book1['image'],
              folder: book1['folder'],
              noPages: book1['no_pages'],
            ),
            BookCard(
              imagePath: book2['image'],
              folder: book2['folder'],
              noPages: book2['no_pages'],
            ),
          ],
        );
      },
    );
  }

  _openLink() async {
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
