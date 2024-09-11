import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../statemanagment/countries_provider.dart';
import 'country_detailpage.dart';
import 'favorite.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  String _searchType = 'Name'; // Default search type
  final TextEditingController _searchController =
      TextEditingController(); // Controller for the search field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Countries List',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context); // Filter by region dialog
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search countries...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          _showSearchTypeDialog(context); // Search type dialog
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: (value) {
                      _performSearch(context, value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<CountriesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            );
          } else if (provider.countries.isEmpty) {
            return const Center(
              child: Text(
                'No countries found. Try a different search.',
                style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.countries.length,
              itemBuilder: (context, index) {
                final country = provider.countries[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(country.flag, width: 50),
                    ),
                    title: Text(
                      country.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      country.capital,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: provider.favorites.contains(country)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        provider.addToFavorites(country);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CountryDetailPage(country: country),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Filter by Region',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Africa',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 18),
                ),
                onTap: () {
                  context
                      .read<CountriesProvider>()
                      .filterCountriesByRegion('Africa');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Asia',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 18),
                ),
                onTap: () {
                  context
                      .read<CountriesProvider>()
                      .filterCountriesByRegion('Asia');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Search Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Search by Name'),
                onTap: () {
                  setState(() {
                    _searchType = 'Name';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Search by Full Name'),
                onTap: () {
                  setState(() {
                    _searchType = 'Full Name';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Search by Currency'),
                onTap: () {
                  setState(() {
                    _searchType = 'Currency';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _performSearch(BuildContext context, String value) {
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a search term.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final provider = context.read<CountriesProvider>();

    try {
      switch (_searchType) {
        case 'Name':
          provider.searchCountries(value);
          break;
        case 'Full Name':
          provider.searchCountriesByFullName(value);
          break;
        case 'Currency':
          provider.searchCountriesByCurrency(value);
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
