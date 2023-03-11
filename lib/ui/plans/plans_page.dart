import 'package:english/ui/components/app_button.dart';
import 'package:english/ui/components/async_widget.dart';
import 'package:english/ui/components/loading_layer.dart';
import 'package:english/ui/components/snackbar.dart';
import 'package:english/ui/plans/providers/plan_puchase_view_model_provider.dart';
import 'package:english/ui/plans/providers/plans_provider.dart';
import 'package:english/ui/plans/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cores/enums/payment_status.dart';

class PlansPage extends ConsumerWidget {
  const PlansPage({super.key});

  static const route = '/plans';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(planPurchaseViewModelProvider);
    return LoadingLayer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plans for you'),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: AppButton(
              label: "Buy",
              onPressed: model.plan !=null? () async {
                try {
                  await model.purchase(
                    onDone: (v) {
                      if (v.key == PaymentStatus.failed) {
                        AppSnackbar(context).error(v.value);
                      } else {
                        AppSnackbar(context).message(v.value);
                      }
                      Navigator.pop(context);
                    },
                  );
                } catch (e) {
                  AppSnackbar(context).error(e);
                }
              }:null,
            ),
          ),
        ),
        body: AsyncWidget(
          value: ref.watch(plansProvider),
          data: (data) => ListView(
            padding: const EdgeInsets.all(8),
            children: data
                .map(
                  (e) => PlanCard(
                    plan: e,
                    onTap: () {
                      model.plan = e;
                    },
                    selected: e.id == model.plan?.id,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
