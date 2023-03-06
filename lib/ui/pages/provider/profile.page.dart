import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/provider/auth.provider.dart';

// TODO immutable
class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {

  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('${authProvider.me.name} Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  // enabled: false,
                  onChanged: () {
                    _formKey.currentState!.save();
                  },
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: {
                    'name': authProvider.me.name,
                  },
                  // skipDisabled: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: '이름',
                          suffixIcon: _nameHasError
                          ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _nameHasError = !(
                              _formKey.currentState?.fields['name'] ?.validate() ?? false
                            );
                          });
                        },
                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(10),
                        ]),
                        // initialValue: '12',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ],

                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            debugPrint(_formKey.currentState?.value.toString());
                            onSaveMe(context, _formKey.currentState!.value);
                          } else {
                            debugPrint(_formKey.currentState?.value.toString());
                            debugPrint('validation failed');
                          }
                        },
                        child: const Text(
                          '저장',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                        },
                        // color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    closeButtonWidget(context),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  void onSaveMe(BuildContext context, Map<String, dynamic> value) {
    context.read<AuthProvider>().setMe(name: value['name']);
  }

  Widget closeButtonWidget(BuildContext context) {
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