import 'package:bbtraining/views/separated_rounded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bbtraining/exercise.dart';

extension RangeExtension on int {
  List<Widget> each(Widget w) => [for (int i = 0; i < this; i++) w];
}

class ExerciseView extends StatefulWidget {
  final Exercise exercise;

  ExerciseView(this.exercise, {Key key}) : super(key: key);

  @override
  ExerciseViewState createState() => ExerciseViewState();
}

class ExerciseViewState extends State<ExerciseView> {
  Row stars(int count, IconData icon) {
    return Row(
      children: count.each(Row(children: [
        SizedBox(width: 3),
        Container(
          width: 20,
          child: Center(child: FaIcon(icon, size: 18, color: Colors.white)),
        ),
      ])),
    );
  }

  Widget line(String label, int count, IconData icon) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        stars(count, icon),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget images = Divider();
    Widget description = Divider();

    if (widget.exercise.images > 0) {
      images = CarouselSlider(
        options: CarouselOptions(height: 280.0),
        items: [
          for (int i = 0; i < widget.exercise.images; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('res/images/${widget.exercise.name}_$i.jpg')),
            )
        ],
      );
    }

    if (widget.exercise.instructions.isNotEmpty) {
      description = Center(
        child: SizedBox(
          width: 290.0,
          child: Card(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.exercise.instructions
                      .map((e) => IntrinsicHeight(
                              child: Row(
                            children: [
                              Column(
                                children: [Icon(Icons.play_arrow, size: 16)],
                              ),
                              SizedBox(width: 3),
                              Flexible(child: Text(e)),
                            ],
                          )))
                      .toList(),
                ),
              )),
        ),
      );
    }

    Widget stats = SeparatedRounded(height: 33, children: [
      line("Upper", widget.exercise.upper, FontAwesomeIcons.arrowAltCircleUp),
      line("Lower", widget.exercise.lower, FontAwesomeIcons.arrowAltCircleDown),
      line("Core", widget.exercise.core, FontAwesomeIcons.dotCircle),
      line("Strength", widget.exercise.strength, FontAwesomeIcons.fistRaised),
      line("Cardio", widget.exercise.cardio, FontAwesomeIcons.heartbeat),
      line("Mobility", widget.exercise.mobility, FontAwesomeIcons.expandArrowsAlt),
      line("Difficulty", widget.exercise.difficulty, FontAwesomeIcons.star),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name, style: TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: [
              images,
              SizedBox(height: 8),
              description,
              SizedBox(height: 16),
              stats,
            ],
          ),
        ),
      ),
    );
  }
}
