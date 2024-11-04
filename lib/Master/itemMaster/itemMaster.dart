import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/itemMaster/buildingList.dart';
import 'package:ticket_management_system/Master/itemMaster/floorList.dart';
import 'package:ticket_management_system/Master/itemMaster/listOfAsset.dart';
import 'package:ticket_management_system/Master/itemMaster/roomList.dart';
import 'package:ticket_management_system/Master/itemMaster/worklist.dart';
import 'package:ticket_management_system/providers/screenChangeProvider.dart';
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
  Screenchangeprovider provider = Screenchangeprovider();

  @override
  void initState() {
    // provider = Provider.of<Screenchangeprovider>(context, listen: false);
    // _stream =
    //     FirebaseFirestore.instance.collection('buildingNumbers').snapshots();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(body:
        Consumer<Screenchangeprovider>(builder: (context, provider, child) {
      print('provider.isWorkScreen: ${provider.isWorkScreen}');
      // provider.setIsWorkScreen(true);
      return Container(
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
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              provider.isFloorScreen == true
                                  ? lightMarron
                                  : const Color.fromARGB(255, 177, 177, 177)),
                          minimumSize:
                              const WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {},
                      child: const Text(
                        'Floor List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              provider.isRoomScreen == true
                                  ? lightMarron
                                  : const Color.fromARGB(255, 177, 177, 177)),
                          minimumSize:
                              const WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return WorkListByAsset(
                        //       buildingId: '',
                        //       floorId: '',
                        //       roomId: '',
                        //       assetId: '',

                        //     );
                        //   },
                        // ));
                      },
                      child: const Text(
                        'Room List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              provider.isAssetScreen == true
                                  ? lightMarron
                                  : const Color.fromARGB(255, 177, 177, 177)),
                          minimumSize:
                              const WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {},
                      child: const Text(
                        'Assets List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              provider.isWorkScreen == true
                                  ? lightMarron
                                  : const Color.fromARGB(255, 177, 177, 177)),
                          minimumSize:
                              const WidgetStatePropertyAll(Size(220, 50))),
                      onPressed: () {},
                      child: const Text(
                        'Work List',
                        style: TextStyle(
                            color: marron,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
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
                    child: provider.isFloorScreen
                        ? FloorList(
                            buildingId: provider.buildingNumber,
                          )
                        : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: provider.isRoomScreen
                        ? RoomList(
                            buildingId: provider.buildingNumber,
                            floorId: provider.floorNumber)
                        : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: provider.isAssetScreen
                        ? ListOfAsset(
                            buildingId: provider.buildingNumber,
                            floorId: provider.floorNumber,
                            roomId: provider.roomNumber)
                        : Container(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width,
                    child: provider.isWorkScreen
                        ? WorkListByAsset(
                            buildingId: provider.buildingNumber,
                            floorId: provider.floorNumber,
                            roomId: provider.roomNumber,
                            assetId: provider.asset,
                            workList: provider.workList,
                          )
                        : Container(),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }));
  }
}
