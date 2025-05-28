import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/vip.dart';
import '../../../core/utils.dart';
import '../../../core/config/constants.dart';
import '../../settings/screens/settings_screen.dart';
import '../../printer/screens/printer_screen.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_sheet.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showPaywall = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VipBloc, Vip>(
      listener: (context, state) {
        if (showPaywall && !state.loading && !state.isVip) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                if (context.mounted) {
                  showPaywall = false;
                  VipSheet.show(
                    context,
                    identifier: Identifiers.paywall1,
                  );
                }
              },
            );
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const HomeAppbar(),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 62 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  logger(state.runtimeType);
                },
                buildWhen: (previous, current) {
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  int index = state is HomePrinter ? 0 : 1;

                  return IndexedStack(
                    index: index,
                    children: const [
                      PrinterScreen(),
                      SettingsScreen(),
                    ],
                  );
                },
              ),
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }
}
