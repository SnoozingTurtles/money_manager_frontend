import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() => _instance ??= SecureStorage._(const FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _emailKey = 'EMAIL';
  static const _idKey = 'Id';

  Future<void> persistEmailAndToken(String email, String token, String id) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _idKey, value: id);
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: _tokenKey);
    return value != null;
  }

  Future<bool> hasEmail() async {
    var value = await _storage.read(key: _emailKey);
    return value != null;
  }

  Future<bool> hasId() async {
    var value = await _storage.read(key: _idKey);
    return value != null;
  }

  Future<void> deleteToken() async {
    return await _storage.delete(key: _tokenKey);
  }

  Future<void> deleteEmail() async {
    return await _storage.delete(key: _emailKey);
  }

  Future<void> deleteId() async {
    return await _storage.delete(key: _idKey);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getId() async {
    return await _storage.read(key: _idKey);
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }
}
