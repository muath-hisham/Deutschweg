import 'package:flutter/material.dart';
import 'package:menschen/screens/books/book_display.dart';
import 'package:menschen/shared/dimensions.dart';

class BookCard extends StatelessWidget {
  final String imagePath;
  final String folder;
  final int noPages;

  const BookCard(
      {required this.imagePath,
      required this.folder,
      super.key,
      required this.noPages});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(13),
          horizontal: Dimensions.horizontal(7),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return BookPage(
                      folder: folder,
                      noPages: noPages,
                    );
                }));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
