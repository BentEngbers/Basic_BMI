import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'm_text_field_widget.dart';

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

List<Widget> CenterList(List<Widget> widgetList) {
  return widgetList.map((widget) => Center(child: widget)).toList();
}

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
    final tableHeight = MediaQuery.of(context).size.height / 2.5;
    return Scaffold(
      appBar: AppBar(title: const Text("Basic BMI calculator")),
      body: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
              children: CenterList([
            HeightBox(
              Container(),
              height: tableHeight / 3,
            ),
            const Text("Length"),
            Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                  width: 200,
                  child: MTextFieldWidget(kind: TextFieldKind.length)),
            ),
          ])),
          TableRow(
              children: CenterList([
            HeightBox(
              Text(displayIdealWeight(length: length)),
              height: tableHeight / 3,
            ),
            const Text("Weight"),
            Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                  width: 200,
                  child: MTextFieldWidget(
                    kind: TextFieldKind.weight,
                  )),
            ),
          ])),
          TableRow(
              children: CenterList([
            HeightBox(
              Text(idealBMI.toStringAsFixed(1)),
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
