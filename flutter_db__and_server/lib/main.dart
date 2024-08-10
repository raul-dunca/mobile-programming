import 'package:adoptr/pages/list.dart';
import 'package:adoptr/repo/dbrepo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
//  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PetsDarabaseRepository(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final PetsDarabaseRepository petRepo =
        Provider.of<PetsDarabaseRepository>(context);
    return MaterialApp(
      title: 'Adoptr',
      theme: ThemeData(fontFamily: 'Angkor'),
      debugShowCheckedModeBanner: false,
      home: ListPage(repository: petRepo),
    );
  }
}
