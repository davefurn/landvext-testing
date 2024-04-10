import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';

final fingerPrintState =
    StateNotifierProvider<FingerprintState, bool>((ref) => FingerprintState());

class FingerprintState extends StateNotifier<bool> {
  FingerprintState() : super(false) {
    // Load state from SharedPreferences during initialization

    loadFromSharedPreferences();
  }

  void setEnabled({required bool value}) {
    state = value;
    saveToSharedPreferences(value: value);
  }

  Future<void> saveToSharedPreferences({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fingerprint_enabled', value);
  }

  Future<void> loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('fingerprint_enabled') ?? false;
  }
}
