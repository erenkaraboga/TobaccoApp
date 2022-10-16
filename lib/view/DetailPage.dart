import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/DatabaseModel.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.details}) : super(key: key);
  final List<LeafDetails>? details;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TooltipBehavior _tooltipBehavior;
  final List<ChartData> chartData = [];
  final List<String> imageUrls = [];
  @override
  var numbers = [1, 5, 9, 13, 15, 17];
  int index = 0;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    widget.details?.forEach((element) {
      chartData.add(ChartData(numbers[index], element.cct?.toDouble()));
      index++;
    });
    widget.details?.forEach((element) {
      imageUrls.add(element.url!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(50, 10, 30, 20),
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
          child: Center(
              child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: _tooltipBehavior,
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  primaryXAxis: NumericAxis(
                    name: "asfsafasfasfasfasfas",
                    placeLabelsNearAxisLine: true,
                    interval: 2,
                    rangePadding: ChartRangePadding.round,
                    majorGridLines: const MajorGridLines(width: 1),
                  ),
                  primaryYAxis: NumericAxis(
                      rangePadding: ChartRangePadding.additional,
                      name: "asasfasfasfsafas",
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      placeLabelsNearAxisLine: true,
                      majorGridLines: const MajorGridLines(width: 1),
                      interval: 500),
                  series: <ChartSeries<ChartData, int>>[
                // Renders line chart
                ColumnSeries<ChartData, int>(
                    color: Colors.green,
                    name: "CCT Variation",
                    enableTooltip: true,
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    markerSettings: const MarkerSettings(isVisible: true))
              ])),
        ),
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      elevation: 50,
                      child: Container(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Image(
                          image: NetworkImage(imageUrls[index]),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      ],
    ));
  }
  void set(){
    setState(() {
      
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int? x;
  final double? y;
}
