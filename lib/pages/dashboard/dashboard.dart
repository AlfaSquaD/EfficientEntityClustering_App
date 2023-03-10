import 'package:easy_localization/easy_localization.dart';
import 'package:eec_app/controllers/dashboard/dashboard_contoller.dart';
import 'package:eec_app/controllers/dashboard/dashboard_state.dart';
import 'package:eec_app/widgets/responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

part 'widgets/dashboard_small.dart';

final dashboardProvider = StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController();
});

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(smallScreen: _DashboardSmall(key: key));
  }
}
