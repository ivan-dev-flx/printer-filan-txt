import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../home/screens/home_screen.dart';
import '../../firebase/bloc/firebase_bloc.dart';
import '../data/onboard_repository.dart';
import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    context.read<FirebaseBloc>().add(GetFirebaseData());

    Future.delayed(
      const Duration(seconds: 3),
      () {
        _controller.stop();
        if (mounted) {
          if (context.read<OnboardRepository>().isOnboard()) {
            context.go(OnboardScreen.routePath);
          } else {
            context.go(HomeScreen.routePath);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      backgroundColor: colors.accentPrimary,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const SvgWidget(Assets.splash),
        ),
      ),
    );
  }
}
