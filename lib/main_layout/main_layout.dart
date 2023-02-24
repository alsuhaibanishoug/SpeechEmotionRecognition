import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/main_layout/cubit/main_cubit.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';

class MainLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return BlocProvider(
      create: (context) => MainCubit()..init(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: cubit.currentIndex == 2 ? AppBar() : null,
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeCurrentIndex(index: index),
            ),
          );
        },
      ),
    );
  }
}
