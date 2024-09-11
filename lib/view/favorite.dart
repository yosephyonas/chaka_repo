import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../statemanagment/countries_provider.dart';
import 'country_detailpage.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Countries'),
      ),
      body: Consumer<CountriesProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          } else {
            return ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final country = provider.favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(country.flag, width: 50),
                    title: Text(country.name),
                    subtitle: Text(country.capital),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        provider.removeFromFavorites(country);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountryDetailPage(country: country),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
