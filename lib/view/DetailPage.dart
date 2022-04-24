

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../model/DatabaseModel.dart';
class DetailPage extends StatefulWidget {

  DetailPage({Key? key, required this.details}) : super(key: key);
  final List<LeafDetails>? details;
  @override
  State<DetailPage> createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  late TooltipBehavior _tooltipBehavior;
  final List<ChartData> chartData = [
  ];
  final List<String> imageUrls =[ ];
  @override
  void initState() {
    _tooltipBehavior =  TooltipBehavior(enable: true);
    widget.details?.forEach((element) {
      chartData.add(ChartData(DateTime.parse(element.time!), element.cct?.toDouble()));
    });
    widget.details?.forEach((element) {imageUrls.add(element.url!);});
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(50, 10, 30, 0),
              padding: EdgeInsetsDirectional.fromSTEB(0, 30, 30,0),
              child: Center(
                  child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      tooltipBehavior: _tooltipBehavior,
                      legend: Legend(isVisible: true,overflowMode:  LegendItemOverflowMode.wrap),
                      primaryXAxis: DateTimeAxis(
                        interval: 3,
                          rangePadding: ChartRangePadding.round,
                        majorGridLines: const MajorGridLines(width: 1),
                      ),
                      primaryYAxis: NumericAxis(
                          rangePadding: ChartRangePadding.additional,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          majorGridLines: const MajorGridLines(width: 1),
                          interval: 65005
                      ),
                      series: <ChartSeries<ChartData, DateTime>>[
                        // Renders line chart
                        LineSeries<ChartData, DateTime>(
                         color: Colors.green,
                          name: "CCT Variation",
                          enableTooltip: true,
                          dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            markerSettings: MarkerSettings(
                                isVisible: true
                            )
                        )

                      ]
                  )
              ),
            ),
            SizedBox(height: 50,),
            Expanded(
              child: ListView.builder(scrollDirection: Axis.horizontal,itemCount:imageUrls.length,itemBuilder: (context,index){
                return Column(
                  children:  [
                    Card(
                      elevation:50,
                      child: Container(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Image(image: NetworkImage(imageUrls[index]),
                          height: 150,
                          width: 150,
                        ),
                      ),
                    )
                  ],
                );

              }),
            ),
          ],
        )
    );
  }
}
class ChartData{
  ChartData(this.x, this.y);
  final DateTime? x;
  final double? y;
}
