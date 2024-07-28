import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/bloc/dashboard_bloc/stats_bloc/stats_bloc.dart';
import 'package:money_manager/presentation/dashboard_views/stats_views/widgets/bar.dart';

import '../../../domain/value_objects/transaction/value_objects.dart';
import '../../bloc/dashboard_bloc/dashboard_bloc.dart';
import 'widgets/pie_chart.dart';

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DashBoardBloc, DashBoardState>(builder: (context, state) {
      if (state is DashBoardLoaded) {
        return BlocProvider(
          create: (context) => StatsBloc()..add(MapCategoryEvent(categoryMap: state.transactions)),
          child: BlocBuilder<StatsBloc, StatsState>(
            builder: (context, state) {
              if (state is StatsLoaded) {
                return SizedBox(
                  height: height * 0.7,
                  child: Column(children: [
                    SizedBox(
                      height: height * 0.33,
                      child: PieChartCase(categoryMapping: state.categoryMapping),
                    ),
                    // _buildSwitches(state, context),
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.categoryMapping.keys.length,
                          itemBuilder: (context, index) {
                            List<Category> cList = state.categoryMapping.keys.toList();
                            List<int> vList = state.categoryMapping.values.toList();
                            int totalMoney = 0;
                            for (var value1 in vList) {
                              totalMoney += value1;
                            }
                            return Container(
                              margin: const EdgeInsets.all(12),
                              height: height * 0.08,
                              child: Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(cList[index].value.fold((l) => '', (r) => r)),
                                  Text('Rs ${vList[index].toString()}')
                                ]),
                                Bar(
                                  color: cList[index].color,
                                  height: height * 0.04,
                                  width: width,
                                  value: (vList[index] / totalMoney) * width,
                                ),
                              ]),
                            );
                          }),
                    )
                  ]),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
