import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 't_to_t.dart';
import 's_to_s.dart';
import 'ocr.dart';
import 'dict.dart';
import 'learn.dart';
import 'rive_utils.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;
  final int currentTab;
  final Object name;

  RiveAsset(this.src,
      {required this.artboard,
        required this.stateMachineName,
        required this.title,
        required this.currentTab,
        required this.name,
        this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset("assets/icons1.riv",
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
      title: "Chat",
      currentTab: 1,
      name: s_to_s()),
  RiveAsset("assets/icons1.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search",
      currentTab: 2,
      name: ocr()),
  RiveAsset("assets/icons1.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
      title: "HOME",
      currentTab: 0,
      name: t_to_t()),
  RiveAsset("assets/icons1.riv",
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
      title: "Reload",
      currentTab: 3,
      name: dict()),
  RiveAsset("assets/icons1.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      title: "Star",
      currentTab: 4,
      name: learn()),
];

