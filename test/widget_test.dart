import 'package:countries/service/country_service.dart';
import 'package:countries/statemanagment/countries_provider.dart';
import 'package:countries/view/country_ListPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive
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
          create: (_) =>
              CountriesProvider(CountryService()),
              
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Explore Country',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: CountryListPage(),
      ),
    );
  }
}
