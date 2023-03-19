import 'dart:async';

import 'package:english/cores/enums/level.dart';
import 'package:english/cores/models/quiz_question.dart';
import 'package:english/cores/providers/loading_provider.dart';
import 'package:english/cores/repositories/repository_provider.dart';
import 'package:english/ui/profile/providers/my_profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizViewModelProvider = ChangeNotifierProvider(
  (ref) => QuizViewModel(ref)..init(),
);

class QuizViewModel extends ChangeNotifier {
  final Ref _ref;

  QuizViewModel(this._ref);

  Repository get _repository => _ref.read(repositoryProvider);

  DateTime? startedAt;

  bool get active => startedAt != null;

  late Timer _timer;
  late Duration totalDuration;
  late Duration _remainingDuration;

  bool loading = true;

  List<QuizQuestion> questions = [];

  DateTime get endedAt => startedAt!.add(_remainingDuration);

  Duration get timeLeft => endedAt.difference(DateTime.now());
  Duration get timeSpend => totalDuration - timeLeft;

  void init() async {
    questions = await _repository.listQuizQuestions();
    totalDuration = Duration(seconds: questions.length * 90);
    loading = false;
    notifyListeners();
  }

  void start(VoidCallback onTimeOut) async {
    final profile = await _ref.read(profileProvider.future);
    final spend = Duration(seconds: profile.quizTimeSpend);
    _remainingDuration = totalDuration - spend;
    startedAt = DateTime.now();
    _timer = Timer(_remainingDuration, () {
      onTimeOut();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    submit();
    _timer.cancel();
    super.dispose();
  }

  Map<int, String> answers = {};

  void updateAns(int index, String v) {
    answers[index] = v;
    notifyListeners();
  }

  Loading get _loading => _ref.read(loadingProvider);

  Future<Level> submit() async {
    _timer.cancel();
    try {
      _loading.start();
      await _repository.updateLevel(level, timeSpend: timeSpend);
      _loading.end();
      return level;
    } catch (e) {
      _loading.stop();
      return Future.error(e);
    }
  }

  Level get level {
    final correct = questions
        .where((element) => element.ans == answers[questions.indexOf(element)])
        .length;
    if (correct >= 7) {
      return Level.advanced;
    } else if (correct >= 5) {
      return Level.intermediate;
    } else {
      return Level.beginner;
    }
  }
}
