import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/auth/sideBar.dart';
import 'package:ticket_management_system/providers/assetsProvider.dart';
import 'package:ticket_management_system/providers/buildingProvider.dart';
import 'package:ticket_management_system/providers/designationProvider.dart';
import 'package:ticket_management_system/providers/filteration_provider.dart';
import 'package:ticket_management_system/providers/floorProvider.dart';
import 'package:ticket_management_system/providers/image_upload_provider.dart';
import 'package:ticket_management_system/providers/menuUserPageProvider.dart';
import 'package:ticket_management_system/providers/role_page_totalNum_provider.dart';
import 'package:ticket_management_system/providers/roomProvider.dart';
import 'package:ticket_management_system/providers/userProvider.dart';
import 'package:ticket_management_system/providers/workProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB_fOQYy-vxioJGKb7xJddHAOSNAxojE-M",
        authDomain: "tmsupdated.firebaseapp.com",
        projectId: "tmsupdated",
        storageBucket: "tmsupdated.appspot.com",
        messagingSenderId: "540592045536",
        appId: "1:540592045536:web:d50bae1ff6323b8bc43f85",
        measurementId: "G-Y8QZ3ETK3Z"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AllBuildingProvider()),
        ChangeNotifierProvider(create: (context) => AllAssetProvider()),
        ChangeNotifierProvider(create: (context) => AllDesignationProvider()),
        ChangeNotifierProvider(create: (context) => AllFloorProvider()),
        ChangeNotifierProvider(create: (context) => AllRoomProvider()),
        ChangeNotifierProvider(create: (context) => AllWorkProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (context) => MenuUserPageProvider()),
        ChangeNotifierProvider(create: (context) => AllUserProvider()),
        ChangeNotifierProvider(
            create: (context) => RolePageTotalNumProviderAdmin()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TMS Admin',
        theme: ThemeData(
          scrollbarTheme: const ScrollbarThemeData(
            thumbColor: WidgetStatePropertyAll(
              Colors.deepPurple,
            ),
          ),
          primarySwatch: Colors.blue,
        ),
        home: customSide(),
        // TicketTableReport(),
        // CreateUser(adminId: 'ST8032')
        // Dashboard(adminId: 'ST8032'),
        // LoginPage(),
        // SplashScreen()
        // const LoginPage(),
      ),
    );
  }
}
