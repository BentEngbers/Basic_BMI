import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'm_text_field_widget.dart';
import 'utils.dart';

const idealBMI = 25.0;

class HeightBox extends StatelessWidget {
  final Widget widget;
  final double height;
  const HeightBox(this.widget, {required this.height, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(child: widget),
      height: height,
    );
  }
}

String displayBMI(
    {required Option<double> length, required Option<double> weight}) {
  return combineOptions(length, weight).match(
      (tuple) =>
          calculateBMI(lengthValue: tuple.first, weightValue: tuple.second)
              .toStringAsFixed(1),
      () => "");
}

class CalculatorWidget extends ConsumerWidget {
  const CalculatorWidget({Key? key}) : super(key: key);

  String displayIdealWeight(
          {required Option<double> length, required Option<double> bmi}) =>
      combineOptions(length, bmi).match(
          (tuple) =>
              calculateWeight(lengthValue: tuple.first, bmi: tuple.second)
                  .toStringAsFixed(1),
          () => "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(weightProvider).state;
    final length = ref.watch(lengthProvider).state;
    final bmi = ref.watch(bmiProvider).state;
    final tableHeight = MediaQuery.of(context).size.height / 2.5;
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Basic BMI calculator"))),
      body: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // columnWidths: const {
        //   1: IntrinsicColumnWidth(flex: 0.4),
        //   2: IntrinsicColumnWidth(flex: 0.2),
        //   3: IntrinsicColumnWidth(flex: 0.4)
        // },
        children: <TableRow>[
          TableRow(
              children: CenterList([
            HeightBox(
              Container(),
              height: tableHeight / 3,
            ),
            const Text("Length"),
            Padding(
              padding: const EdgeInsets.all(8),
              child: MTextFieldWidget(
                provider: lengthControllerProvider,
                suffixText: "cm",
              ),
            ),
          ])),
          TableRow(
              children: CenterList([
            HeightBox(
              Text("${displayIdealWeight(length: length, bmi: bmi)} kg"),
              height: tableHeight / 3,
            ),
            const Text("Weight"),
            Padding(
              padding: const EdgeInsets.all(8),
              child: MTextFieldWidget(
                provider: weightControllerProvider,
                suffixText: "kg",
              ),
            ),
          ])),
          TableRow(
              children: CenterList([
            HeightBox(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MTextFieldWidget(
                  provider: bmiControllerProvider,
                  resetToDefault: () => ref.read(bmiControllerProvider).text =
                      initialValueBMI.toStringAsFixed(0),
                ),
              ),
              height: tableHeight / 3,
            ),
            const Text("BMI"),
            Text(
              displayBMI(length: length, weight: weight),
            ),
          ]))
        ],
      ),
    );
  }
}
