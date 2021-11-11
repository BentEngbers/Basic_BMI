import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

List<Widget> CenterList(List<Widget> widgetList) {
  return widgetList.map((widget) => Center(child: widget)).toList();
}

Option<Tuple2<double, double>> combineOptions(
        Option<double> a, Option<double> b) =>
    a.map2<double, Tuple2<double, double>>(b, (t, c) => Tuple2(t, c));

double calculateBMI(
        {required double lengthValue, required double weightValue}) =>
    weightValue / (pow(lengthValue / 100, 2));
double calculateWeight({required double bmi, required double lengthValue}) {
  return bmi * (pow(lengthValue / 100, 2));
}
