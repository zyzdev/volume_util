import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volume_util/volume_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _sliderVolume = 0;
  bool _showSystemPanel = true;
  final _volumeUtil = VolumeUtil();
  String _info = "";
  late StreamSubscription ss;

  @override
  void initState() {
    super.initState();

    ss = _volumeUtil.getVolumeChangeStream().listen((volume) {
      setState(() {
        _sliderVolume = volume;
        _info = "Volume:$volume";
      });
    });
    _volumeUtil.getVolume().then((volume) {
      _updateInfo(volume);
    });
  }

  @override
  void dispose() {
    ss.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 36,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                Text(
                  _info,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Slider(
                value: _sliderVolume,
                onChanged: (v) {
                  _volumeUtil.setVolume(
                    v,
                  );
                  setState(() {
                    _sliderVolume = v;
                  });
                }),
            _showSystemPanelOption()
          ],
        ),
      ),
    );
  }

  Widget _showSystemPanelOption() => StatefulBuilder(
        builder: (context, setState) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 8,
              ),
              Checkbox(
                  value: _showSystemPanel,
                  onChanged: (showSystemPanel) {
                    setState(() {
                      _showSystemPanel = showSystemPanel!;
                      _volumeUtil.showSystemPanel(_showSystemPanel);
                    });
                  }),
              InkWell(
                onTap: () {
                  setState(() {
                    _showSystemPanel = !_showSystemPanel;
                    _volumeUtil.showSystemPanel(_showSystemPanel);
                  });
                },
                child: Text(
                  "Show system panel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _showSystemPanel ? Colors.green : Colors.red),
                ),
              ),
            ],
          );
        },
      );

  void _updateInfo(double volume) {
    setState(() {
      _info = "Volume: $volume";
      _sliderVolume = volume;
    });
  }
}
