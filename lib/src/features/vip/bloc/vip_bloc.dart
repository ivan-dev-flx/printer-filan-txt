import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/models/vip.dart';
import '../../../core/utils.dart';

part 'vip_event.dart';

class VipBloc extends Bloc<VipEvent, Vip> {
  VipBloc() : super(Vip()) {
    on<VipEvent>(
      (event, emit) => switch (event) {
        CheckVip() => _checkVip(event, emit),
      },
    );
  }

  void _checkVip(
    CheckVip event,
    Emitter<Vip> emit,
  ) async {
    if (Platform.isIOS) {
      emit(Vip(loading: true));

      try {
        CustomerInfo customerInfo =
            await Purchases.getCustomerInfo().timeout(Duration(seconds: 2));

        bool isVip = customerInfo.entitlements.active.isNotEmpty;

        Offerings offerings =
            await Purchases.getOfferings().timeout(Duration(seconds: 2));

        final offering = offerings.getOffering(event.identifier);

        emit(Vip(
          isVip: isVip,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(Vip());
      }
    } else {
      emit(Vip(isVip: true));
    }
  }
}
