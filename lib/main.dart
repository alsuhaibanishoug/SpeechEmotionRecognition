import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/layout_un_registerd/layout_un_registerd.dart';
import 'package:saghi/screens/auth/login/cubit/login_cubit.dart';
import 'package:saghi/screens/auth/splash_screen/splash_screen.dart';
import 'shared/services/local/cache_helper.dart';
import 'shared/styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CachedHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>LoginCubit())
        ],
        child: MaterialApp(
          title: 'Saghi',
          debugShowCheckedModeBanner: false,
          // builder: (_, Widget? child) => Directionality(textDirection: TextDirection.rtl, child: child!),
          theme: ThemeManger.setLightTheme(),
          home: const SplashScreen(),
        ));
  }
}
