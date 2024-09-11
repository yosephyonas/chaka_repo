import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:countries/model/country_model.dart';
import 'package:dio/dio.dart';

class CountryService {
  final Dio _dio = Dio();
  final Connectivity _connectivity = Connectivity();

  Future<List<Country>> getAllCountries() async {
    if (!await _isConnected()) {
      throw Exception('No internet connection.');
    }
    try {
      final response = await _dio.get('https://restcountries.com/v3.1/all');
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  Future<List<Country>> getCountriesByRegion(String region) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection.');
    }
    try {
      final response =
          await _dio.get('https://restcountries.com/v3.1/region/$region');
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load region countries: $e');
    }
  }

  Future<List<Country>> searchByName(String name) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection.');
    }
    try {
      final response =
          await _dio.get('https://restcountries.com/v3.1/name/$name');
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to find country by name: $e');
    }
  }

  Future<List<Country>> searchByFullName(String fullName) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection.');
    }
    try {
      final response = await _dio
          .get('https://restcountries.com/v3.1/name/$fullName?fullText=true');
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to find country by full name: $e');
    }
  }

  Future<List<Country>> searchByCurrency(String currency) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection.');
    }
    try {
      final response =
          await _dio.get('https://restcountries.com/v3.1/currency/$currency');
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to find countries by currency: $e');
    }
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
