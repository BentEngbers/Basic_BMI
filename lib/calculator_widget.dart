import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'm_text_field_widget.dart';

const idealBMI = 25.0;

class CalculatorWidget extends ConsumerWidget {
  const CalculatorWidget({Key? key}) : super(key: key);

  double calculateBMI(
          {required double lengthValue, required double weightValue}) =>
      weightValue / (pow(lengthValue / 100, 2));
  double calculateIdealWeight({required double lengthValue}) {
    return idealBMI * (pow(lengthValue / 100, 2));
  }

  String displayBMI(
          {required Option<double> length, required Option<double> weight}) =>
      length.match(
          (lengthValue) => weight.match(
              (weightValue) => calculateBMI(
                      lengthValue: lengthValue, weightValue: weightValue)
                  .toStringAsFixed(1),
              () => ""),
          () => "");

  String displayIdealWeight({required Option<double> length}) => length.match(
      (lengthValue) =>
          calculateIdealWeight(lengthValue: lengthValue).toStringAsFixed(1),
      () => "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(valueProvider(TextFieldKind.weight)).state;
    final length = ref.watch(valueProvider(TextFieldKind.length)).state;
    return Scaffold(
      appBar: AppBar(title: const Text("Basic BMI calculator")),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text("FOO"),
                Text(
                  displayBMI(length: length, weight: weight),
                ),
                Text(idealBMI.toStringAsFixed(1))
              ],
            ),
            Column(
              children: [
                const Text("Length"),
                const Text("Weight"),
                const Text("BMI")
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                      width: 200,
                      child: MTextFieldWidget(kind: TextFieldKind.length)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                      width: 200,
                      child: MTextFieldWidget(
                        kind: TextFieldKind.weight,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
