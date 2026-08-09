import 'core/di_core.dart';
import 'domains/di_questions.dart';
import 'domains/di_auth.dart';
import 'domains/di_settings.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

void setupServiceLocator() {
  // ============ Core ============
  CoreDependencies.register();

  // ============ Domains ============
  AuthDependencies.register();
  QuestionsDependencies.register();
  SettingsDependencies.register();
}