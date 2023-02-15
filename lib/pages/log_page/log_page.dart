import 'package:eec_app/services/log_service/log_service.dart';
import 'package:eec_app/utils/instance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  void initState() {
    InstanceController().getByType<LogService>().connect();
    super.initState();
  }

  @override
  void dispose() {
    InstanceController().getByType<LogService>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('Log Page', style: Theme.of(context).textTheme.displaySmall),
          Divider(),
          const SizedBox(height: 20),
          Expanded(
              child: StreamBuilder(
                  stream: InstanceController().getByType<LogService>().stream,
                  builder: (context, snapshot) {
                    return Card(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.grey[900],
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(snapshot.data ?? '',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    );
                  })),
        ],
      )),
    );
  }
}