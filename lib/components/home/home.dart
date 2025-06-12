import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:taskmanagementapp/components/my_task/add_task.dart';
import 'package:taskmanagementapp/components/my_task/my_task.dart';
import 'package:taskmanagementapp/components/task_calendar/task_calendar.dart';
import 'package:taskmanagementapp/utils/pref/pref_manager.dart';
import '../../widgets/splash_screen.dart';
import '../authentication/email_authentication.dart';
import 'home_bloc.dart';

class Home extends StatefulWidget {
  final bool isFirstTime;

  const Home({super.key, this.isFirstTime = false});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {
        'icon1': "assets/dashboard_icons/icons8-home.png",
        'icon2': "assets/dashboard_icons/icons8-home-grey.png",
        'label': 'Home'
      },
      {
        'icon1': "assets/dashboard_icons/icons8-order-history.png",
        'icon2': "assets/dashboard_icons/icons8-order-history-grey.png",
        'label': 'History '
      },
    ];
    final List<Widget> children = [MyTask(), TaskCalendar()];
    return BlocProvider(
      create: (context) =>
          HomeBloc()..add(OnLoadHome(isFirstTime: widget.isFirstTime)),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) async {},
        builder: (context, state) {
          if (state is ShowSplashScreen) {
            return const SplashScreen();
          }
          if (state is ShowUserAuthentication) {
            return const UserEmailAuthentication();
          }
          if (state is HomeTabSelected) {
            return Scaffold(
              appBar: AppBar(
                title: Text('WhatBytes'),
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xfff7f7f7),
                centerTitle: true,
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Logout"),
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      if (value == 1) {
                        _handleLogout(context);
                      }
                    },
                  ),
                ],
              ),
              backgroundColor: Color(0xfff7f7f7),
              body: children[state.tabPosition],
              floatingActionButton: Container(
                height: 64,
                width: 64,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xff666af6),
                  shape: CircleBorder(),
                  elevation: 4.0,
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  tooltip: 'Add Todos',
                  child: Icon(
                    Icons.add,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                color: Color(0xffffffff),
                shape: CircularNotchedRectangle(),
                notchMargin: 6.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //My Task
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(OnHomeTabPressed(0));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted_add,
                              size: 28,
                              color: state.tabPosition == 0
                                  ? const Color(0xff666af6)
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Calendar
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(OnHomeTabPressed(1));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 28,
                              color: state.tabPosition == 1
                                  ? const Color(0xff666af6)
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ErrorLoadingHome) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("WhatBytes"),
              ),
              //Need to write Custom Show Error msg
              body: const Text("Error:Home.dart-Something went wrong!"),
            );
          }
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Just a moment"),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Theme.of(context).brightness == Brightness.dark
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : CircularProgressIndicator(
                          color: Colors.blue[900],
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  _handleLogout(BuildContext context) async {
    await PrefManager.db.clearAll();
    await FirebaseAuth.instance.signOut();
    Phoenix.rebirth(context);
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddTaskContent(),
        );
      },
    );
  }
}
