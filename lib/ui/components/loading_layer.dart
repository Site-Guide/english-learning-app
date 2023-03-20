import 'package:english/ui/components/logo_loading.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cores/providers/loading_provider.dart';

class LoadingLayer extends StatelessWidget {
  const LoadingLayer({Key? key, required this.child, this.logo = false})
      : super(key: key);

  final Widget child;
  final bool logo;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      children: [
        child,
        Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(loadingProvider);
            return model.loading
                ? Material(
                    color: scheme.surfaceVariant.withOpacity(0.5),
                    child: logo
                        ? const LogoLoading()
                        // ignore: prefer_const_constructors
                        : Center(
                            child: const CircularProgressIndicator(),
                          ),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}
