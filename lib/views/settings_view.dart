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
                  secondary: FaIcon(FontAwesomeIcons.dumbbell),
                  title: Text("Use weights"),
                  value: widget.settings.useWeights,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useWeights = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: FaIcon(FontAwesomeIcons.chair),
                  title: Text("Use bank"),
                  value: widget.settings.useBank,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useBank = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: FaIcon(FontAwesomeIcons.waveSquare),
                  title: Text("Use bar"),
                  value: widget.settings.useBar,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useBar = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: FaIcon(FontAwesomeIcons.download),
                  title: Text("Use floor"),
                  value: widget.settings.useFloor,
                  onChanged: (v) {
                    setState(() {
                      widget.settings.useFloor = v;
                    });
                  },
                ),
                SwitchListTile(
                  secondary: FaIcon(FontAwesomeIcons.cloudSun),
                  title: Text("With Outdoor"),
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
