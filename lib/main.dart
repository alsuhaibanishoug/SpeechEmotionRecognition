import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/screens/auth/login/cubit/login_cubit.dart';
import 'package:saghi/screens/auth/splash_screen/splash_screen.dart';
import 'package:saghi/shared/helper/bloc_observer.dart';
import 'screens/layout/speech_to_text/cubit/speech_cubit.dart';
import 'shared/services/local/cache_helper.dart';
import 'shared/styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CachedHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => SpeechCubit()..init())
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
