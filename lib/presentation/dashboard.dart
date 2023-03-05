import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/auth_views/login_view.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/constants.dart';
import 'package:money_manager/presentation/dashboard_views/home_view.dart';
import 'package:money_manager/presentation/dashboard_views/stats_view.dart';
import 'package:money_manager/presentation/transaction_views/transaction_view.dart';

import 'bloc/user_bloc/user_bloc.dart';
import 'landing_views/landing_page.dart';

class DashBoard extends StatefulWidget {
  static const String route = '/DashBoard';
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Widget> _views = [HomeView(), const StatsView(), HomeView(), HomeView()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
        userBloc: BlocProvider.of<UserBloc>(context),
      ),
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
        body: _views[_selectedIndex],
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
          onPressed: () {
            Navigator.pushNamed(context, TransactionView.route);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
