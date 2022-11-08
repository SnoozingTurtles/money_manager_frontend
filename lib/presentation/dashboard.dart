import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/constants.dart';
import 'package:money_manager/presentation/dashboard_views/home_view.dart';
import 'package:money_manager/presentation/dashboard_views/stats_view.dart';
import 'package:money_manager/presentation/transaction_views/transaction_view.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final List<Widget> _views = [const HomeView(), const StatsView()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    sw = MediaQuery.of(context).size.width;
    sh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.pie_chart_rounded,
                ),
                label: "Stats"),
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
          Navigator.pushNamed(context,TransactionView.route);
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionEvent());
  }
}
