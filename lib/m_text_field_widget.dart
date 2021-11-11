import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Option<double> stringToDouble(String input) =>
    Option.fromNullable(double.tryParse(input.replaceAll(RegExp(r','), '.')));
const initialValueBMI = 25.0;

final lengthProvider = StateProvider<Option<double>>((ref) {
  return const None();
});
final weightProvider = StateProvider<Option<double>>((ref) {
  return const None();
});
final bmiProvider = StateProvider<Option<double>>((ref) {
  return const Some(initialValueBMI);
});
final lengthControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  controller.addListener(() {
    ref.read(lengthProvider).state = stringToDouble(controller.text);
  });
  return controller;
});
final weightControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  controller.addListener(() {
    ref.read(weightProvider).state = stringToDouble(controller.text);
  });
  return controller;
});
final bmiControllerProvider = Provider<TextEditingController>((ref) {
  final initialValue = ref
      .read(bmiProvider)
      .state
      .map((initialValue) => initialValue.toStringAsFixed(0))
      .toNullable();
  final controller = TextEditingController(text: initialValue);
  controller.addListener(() {
    ref.read(bmiProvider).state = stringToDouble(controller.text);
  });
  return controller;
});

class MTextFieldWidget extends HookConsumerWidget {
  final String? suffixText;
  final Function()? resetToDefault;
  final Provider<TextEditingController> provider;

  const MTextFieldWidget(
      {required this.provider, this.suffixText, this.resetToDefault, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus &&
            ref.read(provider).text.isEmpty &&
            resetToDefault != null) {
          resetToDefault!();
        }
      },
      child: TextFormField(
        controller: ref.read(provider),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"^[0-9]*(.|,)[0-9]*"))
        ],
        decoration: InputDecoration(
            hintText: "...",
            suffixText: suffixText,
            suffixIcon: IconButton(
              onPressed: () {
                if (resetToDefault != null) {
                  resetToDefault!();
                } else {
                  ref.read(provider).clear();
                }
              },
              icon: const Icon(Icons.clear),
            )),
      ),
    );
  }
}
