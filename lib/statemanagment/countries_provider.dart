import 'package:flutter/material.dart';
import '../model/country_model.dart';
import '../service/country_service.dart';

class CountriesProvider with ChangeNotifier {
  final CountryService countryService;
  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  List<Country> _favorites = [];
  bool _isLoading = true;
  String _errorMessage = '';

  CountriesProvider(this.countryService) {
    fetchCountries();
  }

  List<Country> get countries =>
      _filteredCountries.isNotEmpty ? _filteredCountries : _countries;
  List<Country> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      _countries = await countryService.getAllCountries();
      _filteredCountries = [];
    } catch (e) {
      _errorMessage = 'Error fetching countries: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void searchCountries(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await countryService.searchByName(query);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search by full name
  void searchCountriesByFullName(String fullName) async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await countryService.searchByFullName(fullName);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search by currency
  void searchCountriesByCurrency(String currency) async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await countryService.searchByCurrency(currency);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void addToFavorites(Country country) {
    if (!_favorites.contains(country)) {
      _favorites.add(country);
    }
    notifyListeners();
  }

  void removeFromFavorites(Country country) {
    _favorites.remove(country);
    notifyListeners();
  }

  void filterCountriesByRegion(String region) async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredCountries = await countryService.getCountriesByRegion(region);
    } catch (e) {
      _errorMessage = 'Error filtering by region: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
