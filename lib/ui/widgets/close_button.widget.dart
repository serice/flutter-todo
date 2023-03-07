import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/provider/auth.provider.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => context.pop(),
        // color: Theme.of(context).colorScheme.secondary,
        child: Text(
          'Close',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
    );
  }
}