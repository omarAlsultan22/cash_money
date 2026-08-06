import '../enums/questions_keys.dart';
import 'package:flutter/cupertino.dart';


mixin ListenerMixin<T extends StatefulWidget> on State<T> {
  late QuestionsKeys key;

  void initializeListener(QuestionsKeys screenKey) {
    key = screenKey;
  }

  bool handleListener(QuestionsKeys? screenKey) {
    return key == screenKey;
  }
}