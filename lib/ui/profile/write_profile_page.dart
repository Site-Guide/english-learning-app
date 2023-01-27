// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:english/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/big_button.dart';
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

    void done({bool skip = false}) async {
      try {
        if (formKey.value.currentState!.validate()) {
          await model.write(skip: skip);
          ref.refresh(myProfileProvider);
        }
      } catch (e) {
        AppSnackbar(context).error(e);
      }
    }

    // final formKey = useRef(GlobalKey<FormState>());
    return LoadingLayer(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            // title: Text(),
            actions: [
              // LangButton(),
              TextButton(
                onPressed: () => done(skip: true),
                child: const Text("Skip"),
              ),
            ],
            title: const Text("Enter your details"),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BigButton(
                onPressed: model.enabled ? done : null,
                label: "SAVE",
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: "+91 ",
                    ),
                    initialValue: model.phone,
                    onChanged: (v) => model.phone = v,
                    validator: Validators.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Whatsapp Number",
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                                        keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      prefixText: "+91 ",
                    ),
                    initialValue: model.whatsapp,
                    onChanged: (v) => model.whatsapp = v,
                    validator: Validators.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Are you a:",
                    style: style.bodyLarge,
                  ),
                  ...WriteProfileNotifier.options.map(
                    (e) => RadioListTile(
                      title: Text(e),
                      value: e,
                      groupValue: model.profession,
                      onChanged: (v) => model.profession = v as String,
                    ),
                  ),
                  RadioListTile<bool>(
                    title: const Text("Other"),
                    value: true,
                    groupValue: model.other,
                    onChanged: (v) => model.other = v!,
                  ),
                  if (model.other)
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (v) => model.profession = v,
                      validator: Validators.required,
                    ),
                  const SizedBox(height: 16.0),
                  Text(
                    "What is your purpose for joining this app?",
                    style: style.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: model.purpose,
                    onChanged: (v) => model.purpose = v,
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
