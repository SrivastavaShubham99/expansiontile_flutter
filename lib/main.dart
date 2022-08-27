
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test4/bloc/bloc.dart';
import 'package:test4/bloc/event.dart';
import 'package:test4/bloc/state.dart';
import 'package:test4/loader_skeleton.dart';
import 'package:test4/timming_slots_response.dart';
import 'costants.dart';
import 'images.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>(HiveConstant.cached_json_response);
  runApp(MultiBlocProvider(providers: [
    BlocProvider<TimingSlotBloc>(
        create: (BuildContext context) =>
            TimingSlotBloc(TimingSlotInitialState())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TimingSlotBloc timingSlotBloc;
  TimingSlotsResponse? timingSlotsResponse;
  bool isLoading = false;
  bool expansionIconManager = false;
  bool expansionIconManager2=false;
  bool expansionIconManager3=false;

  late Box<String> cachedData;


  @override
  void initState() {
    timingSlotBloc = BlocProvider.of(context);
    cachedData=Hive.box<String>(HiveConstant.cached_json_response);
    if(cachedData.get(HiveConstant.cached_key)!=null){
      timingSlotsResponse=TimingSlotsResponse.fromJson(jsonDecode(cachedData.get(HiveConstant.cached_key)!));
    }
    timingSlotBloc.add(TimingSlotEvent());
    super.initState();
  }

  handleApiResponse(Object? apiState) {
    if (apiState is TimingSlotState) {
      if (apiState.apiResponse!.isSuccess!) {
        cachedData.put(HiveConstant.cached_key, jsonEncode(apiState.apiResponse!.dataResponse));
        TimingSlotsResponse timingSlotsResponse2 =
            TimingSlotsResponse.fromJson(apiState.apiResponse!.dataResponse);
        timingSlotsResponse = timingSlotsResponse2;
        isLoading = false;
      } else {
        isLoading = false;
        Fluttertoast.showToast(msg: "something went wrong");
      }
    }
  }

  int getSlotsAvailableCount(List<Response> responseList) {
    int count = 0;
    responseList.forEach((element) {
      if (element.status == 1) {
        count++;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: ScreenWithLoader(
          isLoading: isLoading,
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: BlocListener(
              bloc: timingSlotBloc,
              listener: (BuildContext context, state) {
                handleApiResponse(state);
              },
              child: BlocBuilder(
                bloc: timingSlotBloc,
                builder: (BuildContext context, state) {
                  return timingSlotsResponse != null
                      ? Column(
                          children: [
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Morning",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18)),
                                  const Spacer(),
                                  Text(
                                      "${getSlotsAvailableCount(timingSlotsResponse!.response!.sublist(0, 24))} Slots available",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.redAccent,
                                          fontSize: 14))
                                ],
                              ),
                              trailing: expansionIconManager
                                  ? const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.red)
                                  : const Icon(Icons.keyboard_arrow_up_outlined,
                                      color: Colors.red),
                              leading: const CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.orangeAccent,
                                child: Image(
                                  image: AssetImage(Images.day_slots),
                                ),
                              ),
                              onExpansionChanged: (val) {
                                setState(() {
                                  expansionIconManager = val;
                                });
                              },
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: timingSlotsResponse == null
                                        ? 0
                                        : timingSlotsResponse!.response!
                                            .sublist(0, 24)
                                            .length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          color: timingSlotsResponse!.response!.sublist(0, 24)[index].status==1 ?
                                          Colors.green[200] : Colors.red[200],
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            title: Text(
                                              "${timingSlotsResponse!.response!.sublist(0, 24)[index].slotStartTime} AM - "
                                              "${timingSlotsResponse!.response!.sublist(0, 24)[index].slotEndTime} AM",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("AfterNoon",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18)),
                                  const Spacer(),
                                  Text(
                                      "${getSlotsAvailableCount(timingSlotsResponse!.response!.sublist(24, 36))} Slots available",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.redAccent,
                                          fontSize: 14))
                                ],
                              ),
                              trailing: expansionIconManager2
                                  ? const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.red)
                                  : const Icon(Icons.keyboard_arrow_up_outlined,
                                      color: Colors.red),
                              leading: const CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.orangeAccent,
                                child: Image(
                                  image: AssetImage(Images.afternoon_slots),
                                ),
                              ),
                              onExpansionChanged: (val) {
                                setState(() {
                                  expansionIconManager2 = val;
                                });
                              },
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: timingSlotsResponse == null
                                        ? 0
                                        : timingSlotsResponse!.response!
                                            .sublist(24, 36)
                                            .length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color: timingSlotsResponse!.response!.sublist(24, 36)[index].status==1 ?
                                        Colors.green[200] : Colors.red[200],
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            title: Text(
                                              "${timingSlotsResponse!.response!.sublist(24, 36)[index].slotStartTime} PM - "
                                              "${timingSlotsResponse!.response!.sublist(24, 36)[index].slotEndTime} PM",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Evening",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18)),
                                  const Spacer(),
                                  Text(
                                      "${getSlotsAvailableCount(timingSlotsResponse!.response!.sublist(36,49))} Slots available",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.redAccent,
                                          fontSize: 14))
                                ],
                              ),
                              trailing: expansionIconManager3
                                  ? const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.red)
                                  : const Icon(Icons.keyboard_arrow_up_outlined,
                                      color: Colors.red),
                              leading: const CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.orangeAccent,
                                child: Image(
                                  image: AssetImage(Images.evening_slots),
                                ),
                              ),
                              onExpansionChanged: (val) {
                                setState(() {
                                  expansionIconManager3 = val;
                                });
                              },
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: timingSlotsResponse == null
                                        ? 0
                                        : timingSlotsResponse!.response!
                                            .sublist(
                                                36,
                                                49)
                                            .length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                         color: timingSlotsResponse!.response!.sublist(36,49)[index].status==1 ?
                                         Colors.green[200] : Colors.red[200],
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            title: Text(
                                              "${timingSlotsResponse!.response!.sublist(36,49)[index].slotStartTime} AM - "
                                              "${timingSlotsResponse!.response!.sublist(36, 49)[index].slotEndTime} AM",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("All",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18)),
                                  const Spacer(),
                                  Text(
                                      "${getSlotsAvailableCount(timingSlotsResponse!.response!)} Slots available",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.redAccent,
                                          fontSize: 14))
                                ],
                              ),
                              trailing: expansionIconManager3
                                  ? const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.red)
                                  : const Icon(Icons.keyboard_arrow_up_outlined,
                                  color: Colors.red),
                              leading: const CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.orangeAccent,
                                child: Image(
                                  image: AssetImage(Images.evening_slots),
                                ),
                              ),
                              onExpansionChanged: (val) {
                                setState(() {
                                  expansionIconManager3 = val;
                                });
                              },
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    itemCount: timingSlotsResponse == null
                                        ? 0
                                        : timingSlotsResponse!.response!.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          color: timingSlotsResponse!.response![index].status==1 ?
                                          Colors.green[200] : Colors.red[200],
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            title: Text(
                                              "${timingSlotsResponse!.response![index].slotStartTime} AM - "
                                                  "${timingSlotsResponse!.response![index].slotEndTime} AM",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
