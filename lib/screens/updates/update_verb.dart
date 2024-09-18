import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/screens/pages/display_verb.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class VerbUpdate extends StatefulWidget {
  final Verb verb;
  const VerbUpdate({super.key, required this.verb});

  @override
  State<VerbUpdate> createState() => _VerbUpdateState();
}

class _VerbUpdateState extends State<VerbUpdate> {
  final _formKey = GlobalKey<FormState>();
  final verbController = TextEditingController();
  final translationController = TextEditingController();
  final ichController = TextEditingController();
  final duController = TextEditingController();
  final erController = TextEditingController();
  final wirController = TextEditingController();
  final ihrController = TextEditingController();
  final sieController = TextEditingController();
  final imperativeController = TextEditingController();
  final partizipTwoController = TextEditingController();
  final prateritumIchController = TextEditingController();
  final prateritumDuController = TextEditingController();
  final prateritumErController = TextEditingController();
  final prateritumWirController = TextEditingController();
  final prateritumIhrController = TextEditingController();
  final prateritumSieController = TextEditingController();
  String _selectedPerfekt = "";
  bool _isDativSelected = false;
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;
  Lesson? selectedLesson;
  bool isFinishLoad = false;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    verbController.text = widget.verb.verb;
    translationController.text = widget.verb.translation;
    ichController.text = widget.verb.ich;
    duController.text = widget.verb.du;
    erController.text = widget.verb.er;
    wirController.text = widget.verb.wir;
    ihrController.text = widget.verb.ihr;
    sieController.text = widget.verb.sie;
    imperativeController.text = widget.verb.imperative;
    partizipTwoController.text = widget.verb.partizipTwo;
    prateritumIchController.text = widget.verb.prateritumIch;
    prateritumDuController.text = widget.verb.prateritumDu;
    prateritumErController.text = widget.verb.prateritumEr;
    prateritumWirController.text = widget.verb.prateritumWir;
    prateritumIhrController.text = widget.verb.prateritumIhr;
    prateritumSieController.text = widget.verb.prateritumSie;
    _selectedPerfekt = widget.verb.perfekt;
    _isDativSelected = widget.verb.dativ;
    _getData();
  }

  Future _getData() async {
    await getLessonById(widget.verb.lessonId).then((lesson) {
      setState(() {
        selectedLesson = lesson;
      });
    });
    await getLevelsUndLessonsToUpdatePages(selectedLesson!.levelId);
    setState(() {
      isFinishLoad = true;
    });
  }

  Future _updateVerb() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE verbs SET verb = ?, translation = ?, ich = ?, du = ?, er = ?, wir = ?, ihr = ?, sie = ?, partizip_two = ?, imperative = ?, dativ = ?, perfekt = ?, prateritum_ich = ?, prateritum_du = ?, prateritum_er = ?, prateritum_wir = ?, prateritum_ihr = ?, prateritum_sie = ?, lesson_id = ? WHERE verb_id = ?''',
          [
            MyFunctions.clearTheText(verbController.text),
            MyFunctions.clearTheText(translationController.text),
            MyFunctions.clearTheText(ichController.text),
            MyFunctions.clearTheText(duController.text),
            MyFunctions.clearTheText(erController.text),
            MyFunctions.clearTheText(wirController.text),
            MyFunctions.clearTheText(ihrController.text),
            MyFunctions.clearTheText(sieController.text),
            MyFunctions.clearTheText(partizipTwoController.text),
            MyFunctions.clearTheText(imperativeController.text),
            _isDativSelected ? 1 : 0,
            MyFunctions.clearTheText(_selectedPerfekt),
            MyFunctions.clearTheText(prateritumIchController.text),
            MyFunctions.clearTheText(prateritumDuController.text),
            MyFunctions.clearTheText(prateritumErController.text),
            MyFunctions.clearTheText(prateritumWirController.text),
            MyFunctions.clearTheText(prateritumIhrController.text),
            MyFunctions.clearTheText(prateritumSieController.text),
            selectedLesson!.id,
            widget.verb.id
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        List<Map<String, dynamic>> li = await sqlDb
            .readData("SELECT * FROM verbs WHERE verb_id = ${widget.verb.id}");
        Verb newVerb = Verb.fromMap(li.first);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DisplayVerb(verb: newVerb)));
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          desc: MyText.somethingWrong,
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        desc: MyText.pleaseEnterAllData,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.updateVerb),
        centerTitle: true,
      ),
      body: isThereLessons && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereLessons
              ? Text(MyText.addLessons)
              : selectedLesson == null || isFinishLoad == false
                  ? Center(child: CircularProgressIndicator())
                  : _body(),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(30),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepTapped: (step) => setState(() => _currentStep = step),
                controlsBuilder: (context, details) {
                  return Row();
                },
                steps: _steps(),
              ),
            ),
            MaterialButton(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                MyText.update,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                _updateVerb();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _steps() {
    return [
      Step(
        title: Text(MyText.verb),
        content: _stepVerb(),
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('PRÄSENS'),
        content: _stepPraesens(),
        state: _currentStep > 1 ? StepState.complete : StepState.editing,
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('PERFEKT'),
        content: _stepPerfekt(),
        state: _currentStep > 2 ? StepState.complete : StepState.editing,
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('PRÄTERITUM'),
        content: _stepPrateritum(),
        state: StepState.editing,
        isActive: _currentStep >= 3,
      ),
    ];
  }

  Widget _stepVerb() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        controlsDesignToAddPages(() {
          setState(() {});
        }),
        SizedBox(height: Dimensions.height(25)),
        MyWidgets.inputForm(
          controller: verbController,
          label: MyText.verb,
          error: MyText.enterTheVerb,
        ),
        SizedBox(height: Dimensions.height(25)),
        MyWidgets.inputFormToArabic(
          controller: translationController,
          label: MyText.translation,
          error: MyText.enterTheTranslation,
        ),
        SizedBox(height: Dimensions.height(25)),
        _dativButton(),
        SizedBox(height: Dimensions.height(25)),
        MyWidgets.inputFormOptional(
          controller: imperativeController,
          label: MyText.imperative,
        ),
      ],
    );
  }

  Widget _stepPraesens() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.horizontalSpace),
          MyWidgets.inputFormOptional(
            controller: ichController,
            label: MyText.conjugationWithIch,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: duController,
            label: MyText.conjugationWithDu,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: erController,
            label: MyText.conjugationWithEr,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: wirController,
            label: MyText.conjugationWithWir,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: ihrController,
            label: MyText.conjugationWithIhr,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: sieController,
            label: MyText.conjugationWithSie,
          ),
        ],
      ),
    );
  }

  Widget _stepPerfekt() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.horizontalSpace),
          Row(
            children: [
              _textButton("haben"),
              SizedBox(width: Dimensions.width(10)),
              _textButton("sein"),
            ],
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: partizipTwoController,
            label: MyText.partizipTwo,
          ),
        ],
      ),
    );
  }

  Widget _stepPrateritum() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.horizontalSpace),
          MyWidgets.inputFormOptional(
            controller: prateritumIchController,
            label: MyText.conjugationWithIch,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: prateritumDuController,
            label: MyText.conjugationWithDu,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: prateritumErController,
            label: MyText.conjugationWithEr,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: prateritumWirController,
            label: MyText.conjugationWithWir,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: prateritumIhrController,
            label: MyText.conjugationWithIhr,
          ),
          SizedBox(height: Dimensions.height(25)),
          MyWidgets.inputFormOptional(
            controller: prateritumSieController,
            label: MyText.conjugationWithSie,
          ),
        ],
      ),
    );
  }

  Widget _textButton(String text) {
    bool isSelected = _selectedPerfekt == text;
    Color color = isSelected ? mainColor : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;

    return Expanded(
      child: SizedBox(
        height: Dimensions.height(48),
        child: ElevatedButton(
          onPressed: () async {
            if (_selectedPerfekt == text) {
              setState(() {
                _selectedPerfekt = "";
              });
            } else {
              setState(() {
                _selectedPerfekt = text;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            backgroundColor: color,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dativButton() {
    Color color = _isDativSelected ? mainColor : Colors.white;
    Color textColor = _isDativSelected ? Colors.white : Colors.black;

    return SizedBox(
      height: Dimensions.height(48),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_isDativSelected) {
            setState(() {
              _isDativSelected = false;
            });
          } else {
            setState(() {
              _isDativSelected = true;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: color,
        ),
        child: Text(
          "Dativ",
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
