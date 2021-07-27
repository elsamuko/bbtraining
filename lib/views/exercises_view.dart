import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bbtraining/exercise.dart';
import 'package:bbtraining/views/exercise_view.dart';

class ExercisesView extends StatefulWidget {
  List<Exercise> exercises;

  ExercisesView(this.exercises, {Key key}) : super(key: key);

  @override
  ExercisesViewState createState() => ExercisesViewState();
}

class ExercisesViewState extends State<ExercisesView> {
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

  void showExercise(Exercise exercise) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return ExerciseView(exercise);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, widget.exercises);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Exercises"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: ListView.builder(
                      itemCount: widget.exercises.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: GestureDetector(
                            child: Text(
                              widget.exercises[i].name,
                              style: TextStyle(
                                color: widget.exercises[i].enabled ? Colors.white : Colors.white38,
                              ),
                            ),
                            onTap: () => showExercise(widget.exercises[i]),
                          ),
                          trailing: Switch(
                            value: widget.exercises[i].enabled,
                            onChanged: (v) {
                              setState(() {
                                widget.exercises[i].enabled = v;
                              });
                            },
                          ),
                        );
                      }))),
        ));
  }
}
