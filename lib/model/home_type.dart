// import 'package:flutter/material.dart';

// import 'package:lottie/lottie.dart';

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luna/screen/feature/chatbot_feature.dart';
import 'package:luna/screen/feature/image_feature.dart';
import 'package:luna/screen/feature/translator_feature.dart';

enum HomeType { aiChatBot, aiImage, aiTranslator }

extension MyHomeType on HomeType {
  String get title => switch (this) {
        // TODO: Handle this case.
        HomeType.aiChatBot => "Ai chatbot",
        HomeType.aiImage => "Ai image generator",
        HomeType.aiTranslator => "Language Translator",
      };
  String get Lottie => switch (this) {
        HomeType.aiChatBot => "askme1.json",
        HomeType.aiImage => "gpt1.json",
        HomeType.aiTranslator => "askme.json",
      };
  VoidCallback get OnTap => switch (this) {
        HomeType.aiChatBot => () => Get.to(() => const ChatbotFeature()),
        HomeType.aiImage => () => Get.to(() => const ImageFeature()),
        HomeType.aiTranslator => () => Get.to(() => TranslatorFeature()),
      };
}
