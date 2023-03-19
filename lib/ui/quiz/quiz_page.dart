// ignore_for_file: use_build_context_synchronously

import 'package:english/ui/auth/providers/user_provider.dart';
import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/loading_layer.dart';
import 'package:english/ui/components/logo_loading.dart';
import 'package:english/ui/quiz/providers/quiz_view_model_provider.dart';
import 'package:english/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/labels.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final model = ref.watch(quizViewModelProvider);

    void submit() async {
      try {
        final level = await model.submit();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: scheme.surface,
            surfaceTintColor: scheme.surface,
            title: const Text(Labels.congratulation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(Labels.youHaveReached(level.name.toUpperCase())),
                const SizedBox(height: 16),
                AppButton(
                  label: Labels.ok,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
        ref.refresh(userProvider);
      } catch (e) {
        return Future.error(e);
      }
    }

    return LoadingLayer(
      child: Scaffold(
        bottomNavigationBar: !model.loading? SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: AppButton(
              label: model.active ? Labels.submit : Labels.startQuiz,
              onPressed: () async {
                if (model.active) {
                  final value = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: scheme.surface,
                      surfaceTintColor: scheme.surface,
                      title: const Text(Labels.areYouSureYouWantToSubmitQuiz),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(Labels.no),
                        ),
                        MaterialButton(
                          color: scheme.primary,
                          textColor: scheme.onPrimary,
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(Labels.yes),
                        ),
                      ],
                    ),
                  );
                  if (value == true) {
                    submit();
                  }
                } else {
                  model.start(() {
                    submit();
                  });
                }
              },
            ),
          ),
        ): null,
        appBar: AppBar(
          title: const Text(Labels.quiz),
          actions: [
            if (model.active)
              StreamBuilder(
                  stream: Stream.periodic(
                    const Duration(seconds: 1),
                  ),
                  builder: (context, _) {
                    final fiveMinuteLeft =
                        model.timeLeft <= const Duration(minutes: 1);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 20,
                            color: fiveMinuteLeft ? scheme.error : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            model.timeLeft.isNegative
                                ? const Duration().data
                                : model.timeLeft.data,
                            style: TextStyle(
                              color: fiveMinuteLeft ? scheme.error : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    );
                  })
          ],
        ),
        body: model.loading? const LogoLoading() : !model.active
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "Let us know your level of English",
                    style: style.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This quiz will help us to know your level of English. You will be given ${model.questions.length} questions and you will have ${model.totalDuration.format} to answer them. After that, we will know your level of English. Good luck!",
                    style: style.bodyLarge,
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(8),
                children: model.questions.map((e) {
                  final index = model.questions.indexOf(e);
                  final no = index + 1;
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: scheme.secondaryContainer,
                              child: Text(
                                "$no",
                                style: style.bodySmall!.copyWith(
                                  color: scheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  e.question,
                                  style: style.titleMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...e.options.entries.map(
                          (e) => RadioListTile<String>(
                            value: e.key,
                            groupValue: model.answers[index],
                            title: Text(
                              e.value,
                              style: style.bodyLarge,
                            ),
                            onChanged: (v) {
                              model.updateAns(index, v!);
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
