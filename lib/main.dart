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
import 'package:ticket_management_system/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDtdY2LJ087ii1QTHCJpmTXnB7v8PshdBs",
        authDomain: "ticket-management-system-db0dc.firebaseapp.com",
        projectId: "ticket-management-system-db0dc",
        storageBucket: "ticket-management-system-db0dc.appspot.com",
        messagingSenderId: "974616957143",
        appId: "1:974616957143:web:92c96dbda395a5bab8e092",
        measurementId: "G-VVDZCNMFCC"),
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
              marron,
            ),
          ),
          primarySwatch: Colors.blue,
        ),
        home: customSide(),
        // TicketTableReport(),
      ),
    );
  }
}
