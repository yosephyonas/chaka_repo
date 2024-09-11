import 'package:countries/service/country_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'statemanagment/countries_provider.dart';
import 'view/country_ListPage.dart';
import 'view/favorite.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const CountryApp());
}

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CountriesProvider(CountryService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Explore Country',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: CountryListPage(),
        routes: {
          '/favorites': (context) => FavoritesPage(),
        },
      ),
    );
  }
}
