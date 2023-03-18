// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:english/ui/components/app_button.dart';
import 'package:english/utils/labels.dart';
import 'package:english/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/loading_layer.dart';
import '../components/snackbar.dart';
import 'providers/my_profile_provider.dart';
import 'providers/write_profile_notifier_provider.dart';

class WriteProfilePage extends HookConsumerWidget {
  const WriteProfilePage({super.key});

  static const route = "/write-profile";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final formKey = useRef(GlobalKey<FormState>());
    final model = ref.watch(writeProfileNotifierProvider);
    final controller = useScrollController();
    void done({bool skip = false}) async {
      try {
        if (formKey.value.currentState!.validate()) {
          if(model.profile.profession.isEmpty){
            AppSnackbar(context).message("Please select your profession");
            controller.animateTo(
              0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
            return;
          }
          formKey.value.currentState!.save();
          await model.write(skip: skip);
          ref.refresh(profileProvider);
        }
      } catch (e) {
        AppSnackbar(context).error(e);
      }
    }

    return LoadingLayer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Labels.enterYourDetails),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0).copyWith(top: 0),
              child: AppButton(
                onPressed: done,
                label: Labels.save,
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Labels.phoneNumber,
                    style: style.bodyLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: "${Labels.plus91} ",
                    ),
                    initialValue: model.profile.phone,
                    onChanged: (v) => model.profile.phone = v,
                    validator: Validators.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    Labels.whatsappNumber,
                    style: style.bodyLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: "${Labels.plus91} ",
                    ),
                    initialValue: model.profile.whatsapp,
                    onChanged: (v) => model.profile.whatsapp = v,
                    validator: Validators.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    Labels.areYouA,
                    style: style.bodyLarge,
                  ),
                  ...WriteProfileNotifier.options.map(
                    (e) => RadioListTile(
                      title: Text(e),
                      value: e,
                      groupValue: model.profile.profession,
                      onChanged: (v) => model.setAreYou(v as String),
                    ),
                  ),
                  RadioListTile<bool>(
                    title: const Text(Labels.other),
                    value: true,
                    groupValue: model.other,
                    onChanged: (v) => model.other = v!,
                  ),
                  if (model.other)
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (v) => model.profile.profession = v.trim(),
                      validator: Validators.required,
                    ),
                  const SizedBox(height: 16.0),
                  Text(
                    Labels.howMuchExperience,
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: model.profile.experience,
                    onChanged: (v) => model.profile.experience = v.trim(),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    Labels.haveYouEverJoinedAnyOther,
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: model.profile.haveYou,
                    onChanged: (v) => model.profile.haveYou = v.trim(),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    Labels.whatsSomethingThatYou,
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: model.profile.lookingFor,
                    onChanged: (v) => model.profile.lookingFor = v.trim(),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    Labels.whatIsYourPurpose,
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: model.profile.purpose,
                    onChanged: (v) => model.profile.purpose = v.trim(),
                    validator: Validators.required,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
