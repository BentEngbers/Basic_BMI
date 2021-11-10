import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final valueProvider =
    StateProvider.family<Option<double>, TextFieldKind>((ref, kind) {
  final isLength = kind == TextFieldKind.length;
  final provider = isLength ? lengthStringProvider : weightStringProvider;
  final inputValue =
      double.tryParse(ref.watch(provider).state.replaceAll(RegExp(r','), '.'));
  if (inputValue == null) {
    return const None();
  }
  return Some(inputValue);
}, dependencies: [weightProvider, lengthProvider]);

final lengthStringProvider = StateProvider<String>((ref) {
  return "";
});
final weightStringProvider = StateProvider<String>((ref) {
  return "";
});
final lengthProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  controller.addListener(() {
    ref.read(lengthStringProvider).state = controller.text;
  });
  return controller;
});
final weightProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  controller.addListener(() {
    ref.read(weightStringProvider).state = controller.text;
  });
  return controller;
});
enum TextFieldKind { length, weight }

class MTextFieldWidget extends HookConsumerWidget {
  final TextFieldKind kind;
  bool get isLength => kind == TextFieldKind.length;
  final Provider<TextEditingController> provider;

  MTextFieldWidget({required this.kind, Key? key})
      : provider =
            kind == TextFieldKind.length ? lengthProvider : weightProvider,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: ref.read(provider),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"^[0-9]*(.|,)[0-9]*"))
      ],
      decoration: InputDecoration(
          hintText: isLength ? "Length" : "Weight",
          suffixText: isLength ? "cm" : "kg",
          suffixIcon: IconButton(
            onPressed: () {
              ref.read(provider).clear();
            },
            icon: const Icon(Icons.clear),
          )),
    );
  }
}
