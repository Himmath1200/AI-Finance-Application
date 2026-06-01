import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class StockMarketService {
  final String _baseUrl = 'https://www.alphavantage.co/query';

  String get _apiKey {
    try {
      return dotenv.env['ALPHA_VANTAGE_API_KEY'] ?? '';
    } catch (e) {
      developer.log('Alpha Vantage API key not available: $e');
      return '';
    }
  }

  /// Get current stock price
  Future<Map<String, dynamic>?> getStockPrice(String symbol) async {
    try {
      if (_apiKey.isEmpty) {
        developer.log('Alpha Vantage API key not found');
        return null;
      }

      final url = Uri.parse(
        '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
      );

      developer.log('Fetching stock price for: $symbol');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quote = data['Global Quote'] as Map<String, dynamic>?;

        if (quote == null || quote.isEmpty) {
          developer.log('Symbol not found or invalid: $symbol');
          return null;
        }

        final result = {
          'symbol': quote['01. symbol']?.toString() ?? symbol,
          'price': double.tryParse(quote['05. price']?.toString() ?? '0') ?? 0.0,
          'change': double.tryParse(quote['09. change']?.toString() ?? '0') ?? 0.0,
          'changePercent': (quote['10. change percent']?.toString() ?? '0%').replaceAll('%', ''),
          'timestamp': DateTime.now().toIso8601String(),
        };

        developer.log('Stock data received: $result');
        return result;
      } else {
        developer.log('Error: ${response.statusCode} - ${response.body}');
      }
      return null;
    } catch (e) {
      developer.log('Error fetching stock price: $e', error: e);
      return null;
    }
  }

  /// Get intraday data for charting
  Future<List<Map<String, dynamic>>> getIntradayData(String symbol) async {
    try {
      if (_apiKey.isEmpty) {
        developer.log('Alpha Vantage API key not found');
        return [];
      }

      final url = Uri.parse(
        '$_baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&apikey=$_apiKey',
      );

      developer.log('Fetching intraday data for: $symbol');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timeSeries = data['Time Series (60min)'] as Map<String, dynamic>?;

        if (timeSeries == null || timeSeries.isEmpty) {
          developer.log('No intraday data available for: $symbol');
          return [];
        }

        final results = timeSeries.entries
            .take(24)
            .map((entry) => {
              'time': entry.key,
              'open': double.tryParse(entry.value['1. open']?.toString() ?? '0') ?? 0.0,
              'high': double.tryParse(entry.value['2. high']?.toString() ?? '0') ?? 0.0,
              'low': double.tryParse(entry.value['3. low']?.toString() ?? '0') ?? 0.0,
              'close': double.tryParse(entry.value['4. close']?.toString() ?? '0') ?? 0.0,
              'volume': int.tryParse(entry.value['5. volume']?.toString() ?? '0') ?? 0,
            })
            .toList();

        developer.log('Intraday data received: ${results.length} candles');
        return results;
      }
      return [];
    } catch (e) {
      developer.log('Error fetching intraday data: $e', error: e);
      return [];
    }
  }

  /// Search for company symbol
  Future<List<Map<String, dynamic>>> searchSymbol(String keywords) async {
    try {
      if (_apiKey.isEmpty) {
        developer.log('Alpha Vantage API key not found');
        return [];
      }

      final url = Uri.parse(
        '$_baseUrl?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$_apiKey',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['bestMatches'] as List<dynamic>? ?? [];

        return results
            .map((match) => {
              'symbol': match['1. symbol']?.toString() ?? '',
              'name': match['2. name']?.toString() ?? '',
            })
            .toList();
      }
      return [];
    } catch (e) {
      developer.log('Error searching symbol: $e', error: e);
      return [];
    }
  }
}