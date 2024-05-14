import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:updat/theme/chips/floating_with_silent_download.dart';
import 'package:updat/updat_window_manager.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      title: 'updat_test',
      home: UpdatWindowManager(
          currentVersion:
              "1.0.0", // In this case we are importing it form a constants file.
          getLatestVersion: () async {
            // Github gives us a super useful latest endpoint, and we can use it to get the latest stable release
            final data = await http.get(Uri.parse(
              "https://api.github.com/repos/updat_test/nanos90/releases/latest",
            ));

            // Return the tag name, which is always a semantically versioned string.
            return jsonDecode(data.body)["tag_name"];
          },
          getBinaryUrl: (version) async {
            // Github also gives us a great way to download the binary for a certain release (as long as we use a consistent naming scheme)

            // Make sure that this link includes the platform extension with which to save your binary.
            // If you use https://exapmle.com/latest/macos for instance then you need to create your own file using `getDownloadFileLocation`
            return "https://github.com/updat_test/nanos90/releases/download/$version/updat-${Platform.operatingSystem}-$version.$platformExt";
          },
          appName:
              "Updat Example", // This is used to name the downloaded files.
          getChangelog: (_, __) async {
            // That same latest endpoint gives us access to a markdown-flavored release body. Perfect!
            final data = await http.get(Uri.parse(
              "https://api.github.com/repos/updat_test/nanos90/releases/latest",
            ));
            return jsonDecode(data.body)["body"];
          },
          updateChipBuilder: floatingExtendedChipWithSilentDownload,
          callback: (status) {},
          child: const Home()),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [Text('1.0.2')],
      ),
    );
  }
}

String get platformExt {
  switch (Platform.operatingSystem) {
    case 'windows':
      {
        return 'msix';
      }

    case 'macos':
      {
        return 'dmg';
      }

    case 'linux':
      {
        return 'AppImage';
      }
    default:
      {
        return 'zip';
      }
  }
}
