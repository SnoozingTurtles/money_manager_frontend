import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/auth_views/login_view.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/constants.dart';
import 'package:money_manager/presentation/dashboard_views/home_view.dart';
import 'package:money_manager/presentation/dashboard_views/stats_view.dart';
import 'package:money_manager/presentation/transaction_views/transaction_form_view.dart';

import 'bloc/user_bloc/user_bloc.dart';
import 'dashboard_views/transaction_view.dart';
import 'landing_views/landing_page.dart';

class DashBoard extends StatefulWidget {
  static const String route = '/DashBoard';
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Widget> _views = [HomeView(), const TransactionView(), HomeView(), HomeView()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
        userBloc: BlocProvider.of<UserBloc>(context),
      )..add(LoadTransactionsThisMonthEvent()),
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: BlocConsumer<HomeBloc, HomeState>(
          //       listener: (context, state) {},
          //       builder: (context, state) {
          //         return state is HomeLoaded ? Text(state.filter) : Text("Loading");
          //       }),
          //   actions: [
          //     BlocBuilder<UserBloc, UserState>(
          //       builder: (context, state) {
          //         if (!(state as UserLoaded).loggedIn) {
          //           return IconButton(
          //               icon: const Icon(Icons.login),
          //               onPressed: () {
          //                 Navigator.of(context).pushReplacementNamed(LandingPage.route);
          //               });
          //         } else {
          //           return IconButton(
          //               icon: Icon(Icons.logout_rounded),
          //               onPressed: ()async {
          //                 await SecureStorage().deleteToken();
          //                 Navigator.of(context).pushReplacementNamed(LandingPage.route);
          //               });
          //         }
          //       },
          //     ),
          //     PopupMenuButton(itemBuilder: (context) {
          //       return [
          //         PopupMenuItem(
          //             child: const Text("This Month"),
          //             onTap: () {
          //               BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
          //             }),
          //         PopupMenuItem(
          //             child: const Text("Last Month"),
          //             onTap: () {
          //               BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLastMonthEvent());
          //             }),
          //         PopupMenuItem(
          //             child: const Text("Last 3 Months"),
          //             onTap: () {
          //               BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLast3MonthEvent());
          //             }),
          //         PopupMenuItem(
          //             child: const Text("Last 6 Months"),
          //             onTap: () {
          //               BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLast6MonthEvent());
          //             }),
          //         PopupMenuItem(
          //             child: const Text("All Time"),
          //             onTap: () {
          //               BlocProvider.of<HomeBloc>(context).add(const LoadTransactionEvent());
          //             }),
          //         PopupMenuItem(
          //             child: const Text("Custom"),
          //             onTap: () async {
          //               var output = await Future.delayed(
          //                   const Duration(seconds: 0),
          //                   () async => await showDateRangePicker(
          //                         context: context,
          //                         firstDate: DateTime.now().subtract(const Duration(days: 360)),
          //                         lastDate: DateTime.now().add(const Duration(days: 360)),
          //                       ));
          //               if (output != null) {
          //                 BlocProvider.of<HomeBloc>(context)
          //                     .add(LoadTransactionsCustomEvent(startDate: output.start, endDate: output.end));
          //               }
          //             }),
          //       ];
          //     }),
          //   ],
          // ),
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
                    IconButton(onPressed: () {}, icon: Image.asset('assets/common/profile.png')),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoaded) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                  label: Text('This Month'),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onSelected: (val) {
                                    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
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
                                    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLastMonthEvent());
                                  },
                                  selectedColor: Color(0xFF486C7C),
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  selected: state.filter == 'Last Month'),
                              ChoiceChip(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  label: Text('Last 3 Months'),
                                  onSelected: (val) {
                                    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLast3MonthEvent());
                                  },
                                  selectedColor: Color(0xFF486C7C),
                                  labelStyle:
                                      TextStyle(color: state.filter == "Last 3 Months" ? Colors.white : Colors.black),
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  selected: state.filter == "Last 3 Months"),
                              ChoiceChip(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),labelStyle:
                              TextStyle(color: state.filter == "Last 6 Months" ? Colors.white : Colors.black),
                                  label: Text('Last 6 Months'),
                                  onSelected: (val) {
                                    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsLast6MonthEvent());
                                  },
                                  selectedColor: Color(0xFF486C7C),
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  selected: state.filter == "Last 6 Months"),
                              ChoiceChip(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  label: Text('All time'),
                                  labelStyle:
                                  TextStyle(color: state.filter == "All Time" ? Colors.white : Colors.black),
                                  onSelected: (val) {
                                    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionEvent());
                                  },
                                  selectedColor: Color(0xFF486C7C),
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  selected: state.filter == "All Time"),
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
              Navigator.pushNamed(context, TransactionFormView.route);
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
