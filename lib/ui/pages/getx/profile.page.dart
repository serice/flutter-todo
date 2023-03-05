import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../models/user.model.dart';
import '../../../providers/getx/auth.controller.dart';

// TODO immutable
class GetXProfilePage extends StatefulWidget {
  const GetXProfilePage({super.key});

  @override
  State<GetXProfilePage> createState() => _GetXProfilePageState();
}

class _GetXProfilePageState extends State<GetXProfilePage> {

  final AuthController authController = AuthController.to;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(()=> Text('${authController.me.value.name} Profile')),
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
                    'name': authController.me.value.name,
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
                            onSaveMe(_formKey.currentState!.value);
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
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onClose,
                        // color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          'Close',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  void onSaveMe(Map<String, dynamic> value) {
    authController.setMe(name: value['name']);
  }

  void onClose() {
    Get.back();
  }
}