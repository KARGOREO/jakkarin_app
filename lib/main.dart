import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:aasd/Home/intro_screens/start.dart';

import 'screens/details/details_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('th')],
      path:'assets/lang',
      fallbackLocale: Locale('th'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyWidget(),
        '//': (context) => DetailsScreen(),
      },
    );
  }
}
