import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bbtraining/settings.dart';
import 'package:bbtraining/level.dart';

class SettingsView extends StatefulWidget {
  final Settings settings;

  SettingsView(this.settings, {Key? key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

Text createTitle(String s, bool b) {
  return Text(s, style: TextStyle(color: b ? Colors.white : Colors.white38));
}

FaIcon createIcon(IconData i, bool b) {
  return FaIcon(i, color: b ? Colors.white : Colors.white38);
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, widget.settings);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
              actions: [
                IconButton(
                  icon: Icon(Icons.undo),
                  onPressed: () {
                    setState(() {
                      widget.settings.reset();
                    });
                  },
                )
              ],
            ),
            body: ListView(
              children: [
                SwitchListTile(
                  secondary: createIcon(FontAwesomeIcons.dumbbell, widget.settings.useWeights),
                  title: createTitle("Use weights", widget.settings.useWeights),
                  value: widget.settings.useWeights,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useWeights = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: createIcon(FontAwesomeIcons.chair, widget.settings.useBank),
                  title: createTitle("Use bank", widget.settings.useBank),
                  value: widget.settings.useBank,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useBank = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: createIcon(FontAwesomeIcons.waveSquare, widget.settings.useBar),
                  title: createTitle("Use bar", widget.settings.useBar),
                  value: widget.settings.useBar,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useBar = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: createIcon(FontAwesomeIcons.download, widget.settings.useFloor),
                  title: createTitle("Use floor", widget.settings.useFloor),
                  value: widget.settings.useFloor,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useFloor = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: createIcon(FontAwesomeIcons.cloudSun, widget.settings.withOutdoor),
                  title: createTitle("With outdoor", widget.settings.withOutdoor),
                  value: widget.settings.withOutdoor,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.withOutdoor = v;
                    });
                  },
                ),
                Divider(),
                Slider(
                  value: widget.settings.level.index.toDouble(),
                  min: 0,
                  max: 2,
                  divisions: 2,
                  label: widget.settings.level.name,
                  onChanged: (double value) {
                    setState(() {
                      widget.settings.level = Level.values[value.toInt()];
                    });
                  },
                ),
                Center(child: Text("Level")),
                Divider(),
              ],
            )));
  }
}
