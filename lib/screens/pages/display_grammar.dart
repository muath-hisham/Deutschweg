import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/models/grammar_photo_model.dart';
import 'package:menschen/screens/pages/full_screen_image_viewer.dart';
import 'package:menschen/screens/updates/update_grammar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';
import 'package:path_provider/path_provider.dart';

class GrammarDisplay extends StatefulWidget {
  final Grammar grammar;
  const GrammarDisplay({super.key, required this.grammar});

  @override
  State<GrammarDisplay> createState() => _GrammarDisplayState();
}

class _GrammarDisplayState extends State<GrammarDisplay> {
  SqlDb sqlDb = SqlDb();
  List<GrammarPhoto> photosList = [];

  @override
  void initState() {
    super.initState();
    _getPhotos();
  }

  Future<void> _getPhotos() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM grammar_photos WHERE grammar_id = ${widget.grammar.id}");

    if (li.isNotEmpty) {
      List<GrammarPhoto> featchData = [];
      for (var element in li) {
        GrammarPhoto photo = GrammarPhoto.fromMap(element);
        featchData.add(photo);
      }
      setState(() {
        photosList.clear();
        photosList.addAll(featchData);
      });
    } else {
      setState(() {
        photosList.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      final Directory grammarImagesDir =
          Directory('$appDirPath/grammar_images');

      if (!await grammarImagesDir.exists()) {
        await grammarImagesDir.create(recursive: true);
      }

      final File newImage =
          await File(image.path).copy('${grammarImagesDir.path}/${image.name}');

      // Insert path into the database
      int i = await sqlDb.insertData(
        '''
        INSERT INTO grammar_photos (grammar_id, path) VALUES (?, ?)
      ''',
        [
          MyFunctions.clearTheText(widget.grammar.id.toString()),
          MyFunctions.clearTheText(newImage.path),
        ],
      );

      await _getPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grammar.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GrammarUpdate(grammar: widget.grammar)));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(30),
      ),
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.grammar.grammar,
              style: TextStyle(
                fontSize: Dimensions.fontSize(16),
              ),
            ),
            _addPhotosDesign(),
            _photosDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _addPhotosDesign() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height(20)),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.3,
            color: Colors.black87,
          ),
        ),
      ),
      child: ListTile(
        onTap: () async => await _pickImage(),
        title: Text(
          MyText.uploadPhoto,
          style: TextStyle(fontSize: Dimensions.fontSize(18)),
        ),
        leading: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: mainColor,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: Dimensions.fontSize(22),
          ),
        ),
      ),
    );
  }

  Widget _photosDisplay() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: photosList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildImage(photosList[index].path),
        );
      },
    );
  }

  Widget _buildImage(String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImageViewer(
              imagePath: imagePath,
              onDelete: () => _deleteImage(imagePath),
            ),
          ),
        );
      },
      child: Image.file(
        File(imagePath),
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Image not found'));
        },
      ),
    );
  }

  Future<void> _deleteImage(String imagePath) async {
    // Delete the file from the filesystem
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }

    // Remove the entry from the database
    await sqlDb
        .deletePath('DELETE FROM grammar_photos WHERE path = ?', [imagePath]);

    // Update the photos list
    await _getPhotos();
  }
}
