import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:money_manager/presentation/constants.dart';
import 'package:money_manager/presentation/dashboard_views/home_view.dart';
import 'package:money_manager/presentation/landing_views/landing_page.dart';
import 'package:money_manager/presentation/transaction_views/transaction_form_view.dart';
import 'dashboard_views/stats_views/stats_view.dart';
import 'dashboard_views/transaction_view.dart';

class DashBoard extends StatefulWidget {
  static const String route = '/DashBoard';
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Widget> _views = [HomeView(), const TransactionView(), StatsView(), HomeView()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 24.0,
                ),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    '${weekday[DateTime.now().weekday - 1]} ${DateTime.now().day} ${month[DateTime.now().month - 1]}',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 24.0,
                  right: 24.0,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Hello, User", style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                      onPressed: () async {
                        await SecureStorage().deleteToken();
                        Navigator.of(context).pushReplacementNamed(LandingPage.route);
                      },
                      icon: Image.asset('assets/common/profile.png')),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 24.0,
                  right: 24.0,
                ),
                child: BlocBuilder<DashBoardBloc, DashBoardState>(
                  builder: (context, state) {
                    if (state is DashBoardLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceChip(
                                label: Text('This Month'),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onSelected: (val) {
                                  BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsThisMonthEvent());
                                },
                                labelStyle:
                                    TextStyle(color: state.filter == "This Month" ? Colors.white : Colors.black),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selectedColor: Color(0xFF486C7C),
                                selected: state.filter == 'This Month'),
                            ChoiceChip(
                                label: Text('Last Month'),
                                labelStyle:
                                    TextStyle(color: state.filter == "Last Month" ? Colors.white : Colors.black),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onSelected: (val) {
                                  BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsLastMonthEvent());
                                },
                                selectedColor: Color(0xFF486C7C),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selected: state.filter == 'Last Month'),
                            ChoiceChip(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                label: Text('Last 3 Months'),
                                onSelected: (val) {
                                  BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsLast3MonthEvent());
                                },
                                selectedColor: Color(0xFF486C7C),
                                labelStyle:
                                    TextStyle(color: state.filter == "Last 3 Months" ? Colors.white : Colors.black),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selected: state.filter == "Last 3 Months"),
                            ChoiceChip(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                labelStyle:
                                    TextStyle(color: state.filter == "Last 6 Months" ? Colors.white : Colors.black),
                                label: Text('Last 6 Months'),
                                onSelected: (val) {
                                  BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsLast6MonthEvent());
                                },
                                selectedColor: Color(0xFF486C7C),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selected: state.filter == "Last 6 Months"),
                            ChoiceChip(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                label: Text('All time'),
                                labelStyle: TextStyle(color: state.filter == "All Time" ? Colors.white : Colors.black),
                                onSelected: (val) {
                                  BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionEvent());
                                },
                                selectedColor: Color(0xFF486C7C),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selected: state.filter == "All Time"),
                            ChoiceChip(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                label: Text('Custom'),
                                labelStyle: TextStyle(color: state.filter == "Custom" ? Colors.white : Colors.black),
                                onSelected: (val) async {
                                  var output = await Future.delayed(
                                      const Duration(seconds: 0),
                                      () async => await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime.now().subtract(const Duration(days: 360)),
                                            lastDate: DateTime.now().add(const Duration(days: 360)),
                                          ));
                                  if (output != null) {
                                    BlocProvider.of<DashBoardBloc>(context)
                                        .add(LoadTransactionsCustomEvent(startDate: output.start, endDate: output.end));
                                  }
                                },
                                selectedColor: Color(0xFF486C7C),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                selected: state.filter == "custom"),
                          ],
                        ),
                      );
                    } else {
                      return LinearProgressIndicator();
                    }
                  },
                ),
              ),
              _views[_selectedIndex],
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset('assets/common/home.png'),
                  label: "Home",
                  activeIcon: Image.asset('assets/common/home-active.png')),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/common/transaction.png'),
                  label: "Transaction",
                  activeIcon: Image.asset('assets/common/transaction-active.png')),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/common/pie-chart.png'),
                  activeIcon: Image.asset('assets/common/pie-chart-active.png'),
                  label: "Stats"),
              BottomNavigationBarItem(
                icon: Image.asset('assets/common/user.png'),
                activeIcon: Image.asset('assets/common/user-active.png'),
                label: "Profile",
              ),
            ],
            onTap: (int val) {
              setState(() {
                _selectedIndex = val;
              });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Color(0xFF486C7C),
          onPressed: () {
            Navigator.of(context).pushNamed(TransactionFormView.route);
          },
        ),
      ),
    );
  }
}
