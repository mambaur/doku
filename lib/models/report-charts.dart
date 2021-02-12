import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportChart {
  final String day;
  final int value;
  final charts.Color color;

  ReportChart(this.day, this.value, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
