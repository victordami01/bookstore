// auth_manager.dart
class AuthManager {
  static final Map<String, Map<String, String>> _users = {};
  static String? _currentUserEmail;

  static String? get currentUser => _currentUserEmail;
  static String? get currentUserName =>
      _users[_currentUserEmail]?['name'] ?? 'Book Lover';

  static bool register(String email, String password, {String? name}) {
    if (_users.containsKey(email)) return false;
    _users[email] = {'password': password, 'name': name ?? 'Book Lover'};
    return true;
  }

  static bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      _currentUserEmail = email;
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUserEmail = null;
  }

  static void updateUser({String? email, String? name}) {
    if (_currentUserEmail != null) {
      if (email != null && email != _currentUserEmail) {
        final userData = _users[_currentUserEmail]!;
        _users.remove(_currentUserEmail);
        _users[email] = userData;
        _currentUserEmail = email;
      }
      if (name != null) {
        _users[_currentUserEmail]!['name'] = name;
      }
    }
  }
}