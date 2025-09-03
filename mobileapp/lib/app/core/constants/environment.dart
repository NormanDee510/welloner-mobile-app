// environment.dart
class Environment {
  static const String apiBaseUrl = 'https://localhost:44399/';
  
  // static const String baseUrl = String.fromEnvironment('https://localhost:64901',
  //     defaultValue: 'https://dev.example.com/');
  
  static const String googleApiKey = String.fromEnvironment('AIzaSyBvP7roViAVFI7PoRnlfp-J4FZhdJmO30k',
      defaultValue: 'dev_google_api_key_123');
  
  static const bool production = bool.fromEnvironment('PRODUCTION',
      defaultValue: false);
}