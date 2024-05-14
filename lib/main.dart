import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:updat/updat.dart';

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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          UpdatWidget(
            currentVersion: "1.0.0",
            getLatestVersion: () async {
              // Here you should fetch the latest version. It must be semantic versioning for update detection to work properly.
              return "1.0.1";
            },
            getBinaryUrl: (latestVersion) async {
              // Here you provide the link to the binary the user should download. Make sure it is the correct one for the platform!
              return "https://github.com/latest/release/bin.exe";
            },
            // Lastly, enter your app name so we know what to call your files.
            appName: "Updat Example",
          ),
        ],
      ),
    );
  }
}
