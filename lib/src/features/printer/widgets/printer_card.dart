import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/models/vip.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../vip/bloc/vip_bloc.dart';

class PrinterCard extends StatelessWidget {
  const PrinterCard({
    super.key,
    required this.id,
    required this.title,
    this.description = '',
    this.locked = false,
    required this.onPressed,
  });

  final int id;
  final String title;
  final String description;
  final bool locked;
  final VoidCallback onPressed;

  String getAsset() {
    if (id == 1) return Assets.printer1;
    if (id == 2) return Assets.printer2;
    if (id == 3) return Assets.printer3;
    if (id == 4) return Assets.printer4;
    if (id == 5) return Assets.printer5;
    if (id == 6) return Assets.printer6;
    if (id == 7) return Assets.printer7;
    return Assets.printer8;
  }

  List<Color> getColors() {
    if (id == 1) return const [Color(0xff5C9EFD), Color(0xff1A76FF)];
    if (id == 2) return const [Color(0xff536ED9), Color(0xff102880)];
    if (id == 3) return const [Color(0xffFDE200), Color(0xffF9B400)];
    if (id == 4) return const [Color(0xff37D6F3), Color(0xff0FBFEE)];
    if (id == 5) return const [Color(0xff28F2CA), Color(0xff14DEB6)];
    if (id == 6) return const [Color(0xff9F51FF), Color(0xff603199)];
    if (id == 7) return const [Color(0xff28F23C), Color(0xff0DBE25)];
    return const [Color(0xffED2F22), Color(0xffB00B00)];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final size = (MediaQuery.sizeOf(context).width / 2) - 24;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: getColors(),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          BlocBuilder<VipBloc, Vip>(
            builder: (context, state) {
              return Button(
                onPressed: state.loading ? null : onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 64,
                        width: 64,
                        child: SvgWidget(getAsset()),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.bgOne,
                          fontSize: 18,
                          fontFamily: AppFonts.inter600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.bgOne,
                          fontSize: 14,
                          fontFamily: AppFonts.inter400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (locked)
            BlocBuilder<VipBloc, Vip>(
              builder: (context, state) {
                return Positioned(
                  top: 8,
                  right: 8,
                  child: state.loading
                      ? const LoadingWidget()
                      : state.isVip
                          ? const SizedBox()
                          : SvgWidget(
                              Assets.lock,
                              color: colors.tertiaryFour,
                            ),
                );
              },
            ),
        ],
      ),
    );
  }
}
