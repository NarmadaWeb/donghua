import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:donghua/services/storage_service.dart';
import 'package:donghua/providers/auth_provider.dart';
import 'package:donghua/models/user.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');

  // Create a temporary directory for the test
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('StorageService initializeData creates default files', () async {
    final storage = StorageService();
    await storage.initializeData();

    final usersFile = File('${tempDir.path}/users.json');
    final donghuasFile = File('${tempDir.path}/donghuas.json');

    expect(await usersFile.exists(), true);
    expect(await donghuasFile.exists(), true);

    final usersJson = await storage.readData('users.json');
    expect(usersJson.length, 1);
    expect(usersJson[0]['username'], 'Admin');
    expect(usersJson[0]['role'], 'admin');
  });

  test('AuthProvider login works with seeded admin', () async {
    final storage = StorageService();
    await storage.initializeData(); // Ensure admin exists

    final auth = AuthProvider();
    // We need to wait a bit or just rely on the fact that AuthProvider reads from disk inside login/register
    // Actually AuthProvider reads inside login(), so it should work immediately after storage is initialized.

    final success = await auth.login('admin@donghua.com', 'admin123');
    expect(success, true);
    expect(auth.currentUser?.role, 'admin');

    final fail = await auth.login('admin@donghua.com', 'wrongpass');
    expect(fail, false);
  });

  test('AuthProvider register creates new user', () async {
    final storage = StorageService();
    await storage.initializeData();

    final auth = AuthProvider();
    final success = await auth.register('TestUser', 'test@test.com', 'password');
    expect(success, true);
    expect(auth.currentUser?.role, 'user');
    expect(auth.currentUser?.username, 'TestUser');

    // Verify persistence
    final usersJson = await storage.readData('users.json');
    expect(usersJson.length, 2); // Admin + TestUser
  });

  test('StorageService re-seeds empty files', () async {
    final storage = StorageService();
    // Manually create empty file
    final file = File('${tempDir.path}/donghuas.json');
    await file.writeAsString('');

    await storage.initializeData();

    final content = await storage.readData('donghuas.json');
    expect(content.isNotEmpty, true);
  });
}
