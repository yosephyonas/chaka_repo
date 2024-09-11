class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String flag;
  final List<String> borders;
  final int population;
  final List<String> timezones;
  final List<String> languages;
  final String currencies;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.flag,
    required this.borders,
    required this.population,
    required this.timezones,
    required this.languages,
    required this.currencies,
  });

  // Factory method to create a Country object from JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    // Extract languages as a list of strings
    List<String> extractedLanguages = (json['languages'] != null)
        ? (json['languages'] as Map<String, dynamic>)
            .values
            .cast<String>()
            .toList()
        : [];

    // Extract currencies as a single string of currency names
    String extractedCurrencies = (json['currencies'] != null)
        ? (json['currencies'] as Map<String, dynamic>)
            .values
            .map((currency) => currency['name'])
            .join(', ')
        : 'N/A';

    return Country(
      name: json['name']['common'],
      officialName: json['name']['official'],
      capital: (json['capital'] != null) ? json['capital'][0] : 'N/A',
      region: json['region'],
      flag: json['flags']['png'],
      borders: List<String>.from(json['borders'] ?? []),
      population: json['population'] ?? 0,
      timezones: List<String>.from(json['timezones'] ?? []),
      languages: extractedLanguages,
      currencies: extractedCurrencies,
    );
  }

  // Method to convert a Country object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': name,
        'official': officialName,
      },
      'capital': [capital],
      'region': region,
      'flags': {'png': flag},
      'borders': borders,
      'population': population,
      'timezones': timezones,
      'languages': languages,
      'currencies': currencies,
    };
  }
}
