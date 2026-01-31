import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/donghua.dart';
import '../models/comment.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<void> initializeData() async {
    // Initialize Users
    final usersFile = await _getFile('users.json');
    bool shouldInitUsers = false;
    if (!await usersFile.exists()) {
      shouldInitUsers = true;
    } else {
      final content = await usersFile.readAsString();
      if (content.trim().isEmpty || content == '[]') {
        shouldInitUsers = true;
      }
    }

    if (shouldInitUsers) {
      final adminUser = User(
        id: 'admin_001',
        username: 'Admin',
        email: 'admin@donghua.com',
        password: 'admin123',
        role: 'admin',
      );
      await writeData('users.json', [adminUser.toJson()]);
    }

    // Initialize Donghuas
    final donghuasFile = await _getFile('donghuas.json');
    bool shouldInitDonghuas = false;
    if (!await donghuasFile.exists()) {
      shouldInitDonghuas = true;
    } else {
      final content = await donghuasFile.readAsString();
      if (content.trim().isEmpty || content == '[]') {
        shouldInitDonghuas = true;
      }
    }

    if (shouldInitDonghuas) {
      final sampleDonghuas = [
        Donghua(
          id: 'dh_001',
          title: 'Soul Land: Dual God',
          description: 'Tang San is one of Tang Sect martial arts clan\'s most prestigious disciples and peerless in the use of hidden weapons.',
          coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAEanxY-YChna5jYd_yeylE4RAuxRb7iZLDasz3XjetydRt1kX6EdvOyMzUY8bDFz4HqToLVt6wJTzEsy0SNkCLvMDd91K10NjUivz252LIJfRWfyhJ1lEThSr0hsF7Gm9RySMyEnH0A9rukc3TMgo1PisrnBCVOrSi_n4YiFAuL0KlwQxiSbDQlHQDeAPRq93-eO7YKtGDO2VdmdcJrWDL6M2ViETxehrhZUN_hFMfal8wYlqtncSvNec0r79eYc1c9YSvnF0hbUoj',
          videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          status: 'Ongoing',
          genres: ['Action', 'Fantasy', 'Cultivation'],
          rating: 4.9,
          episodes: 254,
          releaseTime: '2 hours ago',
        ),
        Donghua(
          id: 'dh_002',
          title: 'Link Click: Season 2',
          description: 'A Chinese animated series produced by Studio LAN and Haoliners Animation League.',
          coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCQTH13DSRibC14j6fCHZVIhg4O-JvGBq8dnpEoN8GJGAmlHuUv37AwvfjeGkWWoSS8PlJwxbP8k3LkvLNLqlt0kPjdjYYTcUEfs1Tc6U6saRg4SAYCQlwhDIFmdNodKA6gXC86Q2C3M6mZLG2bC5Tk5FGtxYpwCkrihZHrBiQmDzFxLmVIfuxyRjKF_N3kC2z8bVrFFL6U5brLtRM8EEF2B1mzNoG-XKgvW7wy0_iJMOzOokOXch4GhcQXPxl6hx61O2NK3vRKQ6ZS',
          videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          status: 'Completed',
          genres: ['Mystery', 'Thriller'],
          rating: 4.8,
          episodes: 12,
          releaseTime: '1 day ago',
        ),
        Donghua(
          id: 'dh_003',
          title: 'Throne of Seal',
          description: 'In the age where demons are rising, six temples form an alliance to fight against them.',
          coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD4vZhSBTsqmOuw_UjVusMiy0S9lCNiod5ZkPe46UXFtQPSvTRvKFi2XgGp6IYWs_e2U0K6eKuhBoisB8Pdw9Q_PxC0ugitQchEjWUZ5mxJ_z9CNckU6uPJ3_ijtQAaxEfQFnWq14te1sp3FnU9lAxzBuiddO_uv7r1zT34h6H4sOG3q4wLOgyPbelpNp1UR0DabK-2irLoDATsiZ3qC0oOeyPQqw4K1T8jYZ5rESzQVU23c1q2D1zBuNWcCMOpmdhTMpOFpEGOTGw_',
          videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          status: 'Ongoing',
          genres: ['Action', 'Fantasy'],
          rating: 4.9,
          episodes: 108,
          releaseTime: '2 hours ago',
        ),
         Donghua(
          id: 'dh_004',
          title: 'Battle Through Heavens',
          description: 'In a land where no magic is present. A land where the strong make the rules and weak have to obey.',
          coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuACJEhM73_ZdNWUTjaHnIBU5DKP8gM2jtQ3VD4n-zN8YiIJdE2uJdroFes1Q0HHWI4A8pQQeTq6BvTLP__EODkFWTRUTrYrRC7JmukFmHO9y04uTYzXg8QZNNWZND69TxM9RoR23104SBtoxFvSGbkdl7rWLXt-on0lEZpl44zMZYCotXLY4h9b4eL7lU0WJ0JkMYzOTsMHIdaNK9Tiy419-LpiJ6j3NgkPvzlonY82VXpmIX5161afazpr9xtaOEAOm_couG47rMjt',
          videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          status: 'Ongoing',
          genres: ['Action', 'Cultivation'],
          rating: 4.8,
          episodes: 94,
          releaseTime: '5 hours ago',
        ),
      ];
      await writeData('donghuas.json', sampleDonghuas.map((e) => e.toJson()).toList());
    }

    // Initialize Comments (Optional: Empty list)
    final commentsFile = await _getFile('comments.json');
    if (!await commentsFile.exists()) {
      await writeData('comments.json', []);
    }
  }

  Future<List<dynamic>> readData(String filename) async {
    try {
      final file = await _getFile(filename);
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) return [];

      final data = jsonDecode(contents);
      if (data is List) {
        return data;
      }
      return [];
    } catch (e) {
      print('Error reading $filename: $e');
      return [];
    }
  }

  Future<void> writeData(String filename, List<dynamic> data) async {
    try {
      final file = await _getFile(filename);
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error writing $filename: $e');
    }
  }
}
