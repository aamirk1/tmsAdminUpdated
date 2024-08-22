import 'package:flutter/material.dart';
import 'package:ticket_management_system/Master/itemMaster/buildingList.dart';
import 'package:ticket_management_system/Master/itemMaster/floorList.dart';
import 'package:ticket_management_system/Master/itemMaster/listOfAsset.dart';
import 'package:ticket_management_system/Master/itemMaster/roomList.dart';
import 'package:ticket_management_system/utils/colors.dart';

// ignore: must_be_immutable
class AllItemMaster extends StatefulWidget {
  AllItemMaster({super.key, required this.adminId});
  String adminId;
  @override
  State<AllItemMaster> createState() => _AllItemMasterState();
}

class _AllItemMasterState extends State<AllItemMaster> {
  bool isBuildingScreen = false;
  bool isFloorScreen = false;
  bool isRoomScreen = false;
  bool isAssetScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(4),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(lightMarron),
                          minimumSize: WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {
                        setState(() {
                          isBuildingScreen = !isBuildingScreen;
                        });
                      },
                      child: const Text(
                        'Building List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(lightMarron),
                          minimumSize: WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {
                        setState(() {
                          isFloorScreen = !isFloorScreen;
                        });
                      },
                      child: const Text(
                        'Floor List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(lightMarron),
                          minimumSize: WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {
                        setState(() {
                          isRoomScreen = !isRoomScreen;
                        });
                      },
                      child: const Text(
                        'Room List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(lightMarron),
                          minimumSize: WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {
                        setState(() {
                          isAssetScreen = !isAssetScreen;
                        });
                      },
                      child: const Text(
                        'Assets List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child:
                        isBuildingScreen ? const BuildingList() : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: isFloorScreen ? const FloorList() : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: isRoomScreen ? const RoomList() : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: isAssetScreen ? const ListOfAsset() : Container(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
