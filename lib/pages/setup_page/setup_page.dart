import 'package:eec_app/services/setup_service/setup_service.dart';
import 'package:eec_app/utils/instance_controller.dart';
import 'package:eec_app/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _wsUrlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _wsUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _urlController.text = 'http://0.0.0.0:8000';
    _wsUrlController.text = 'ws://0.0.0.0:8000';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Setup Page'),
                  Divider(),
                  const SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        CustomTextField.formField(
                          controller: _urlController,
                          hintText: 'URL',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField.formField(
                          controller: _wsUrlController,
                          hintText: 'WS URL',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final bool result = await InstanceController()
                                  .getByType<SetupService>()
                                  .configure(_urlController.text,
                                      _wsUrlController.text);
                              if (result) {
                                GoRouter.of(context).go('/');
                              }
                            }
                          },
                          child: Text('Submit'),
                        )
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}