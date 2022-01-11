import 'package:client/inGame/inGame.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/utils/socketManager.dart';
import 'package:client/models/Room.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:client/main.dart';
import 'package:client/provider/userID.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Lobby extends StatefulWidget {
  const Lobby({ Key? key }) : super(key: key);

  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  
  List<Room> rooms = [];
  final provider = getIt.get<UserID>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    pullToReFresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
    
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   if(mounted)
  //   setState(() {

  //   });
  //   _refreshController.loadComplete();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    // disconnectSocket();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initSocket();
    _initSocketListener();
    // connectSocket();
  }

  _initSocketListener() async{
    // on
    await roomExistenceCheck(_showToastMessage);
    await setRoomData(_updateRoomData);
    await failToJoin(_showToastMessage);
  }

  @override
  Widget build(BuildContext context) {


    
    return ScreenUtilInit(
      designSize: Size(1080, 2280),
      minTextAdapt: true,
      builder: () =>  
        SafeArea(
          child: WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Scaffold(
            floatingActionButton: FloatingButton(),
            body: 
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text('방만들기'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => roomModal()
                            );
                          },
                        ),
                        ElevatedButton(
                          child: Text('빠른입장'),
                          onPressed: () {
                            quickEntry(provider.myName);
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 130.0.sp,
                      child: SmartRefresher(
                        enablePullDown: true,
                        // enablePullUp: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        // onLoading: _onLoading,
                        child: GridView.count(
                          crossAxisCount: 2,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: List.generate(rooms.length, (index) {
                            return Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Text('${index+1}'),
                                    title: Text('${rooms[index].roomName}'),
                                    subtitle: Text('개발중'),
                                    trailing: Text('${rooms[index].currentNum}/${rooms[index].totalNum}'),
                                  ),
                                  ButtonBar(
                                    children: <Widget>[
                                      TextButton(
                                        child: Text('참가하기'),
                                        onPressed: () {
                                          joinRoom({
                                            "roomName": rooms[index].roomName,
                                            "name": provider.myName,
                                            "img": provider.myImage
                                          });
                                          Navigator.push(context, 
                                            MaterialPageRoute(builder: (BuildContext context) => InGame(roomName: rooms[index].roomName)));
                                        },
                                      )
                                    ]
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      rooms[index].isLock ? Icon(Icons.lock_open_sharp) : Icon(Icons.lock_sharp),
                                      rooms[index].isGameStart ? Text("게임 중") : Text("게임 전")
                                    ],
                                  )
                                ]
                              )
                            );
                          }),
                        ),
                      ),
                    ) 
                  ]
                ),
              )
          ),
              ),
        ),
    );
  }

  _updateRoomData(data){
    if (mounted){
      setState(() {
        List<Room> initRooms = [];
        print(data);
        data.forEach((k, v){
          late int totalNum;
          late int currentNum;
          String roomName=k;
          late bool isLock;
          late bool isGameStart;
          v.forEach((kk, vv){

            if(kk == 'totalNum') totalNum = vv;
            else if(kk == 'currentNum') currentNum = vv;
            else if(kk == 'isLock') isLock = vv;
            else if(kk == 'isGameStart') isGameStart = vv;

          });

          Room roomInstance = new Room(
            roomName,
            totalNum,
            currentNum,
            isLock,
            isGameStart
          );

          initRooms.add(roomInstance);
          rooms = initRooms;
        });
      });
    }
  }

  _showToastMessage(data){
    Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16,
      textColor: Colors.black,
      gravity: ToastGravity.CENTER
    );
  }

// 방만들기
  _updateInfo(data){

    late int totalNum;
    late int currentNum;
    late bool isLock;
    late bool isGameStart;
    String roomName = data.keys[0]; 
    print(data.runtimeType);
    data.forEach((name, value){
      if(name == 'totalNum') totalNum = value;
      else if(name == 'currentNum') currentNum = value;
      else if(name == 'isLock') isLock = value;
      else if(name == 'isGameStart') isGameStart = value;
    });
    
    Room newRoom = new Room(
      roomName,
      totalNum,
      currentNum,
      isLock,
      isGameStart
    );
    
    setState(() {
      rooms.add(newRoom);
    });
  }

// 방 전체 업데이트
  

}

class roomModal extends StatefulWidget {
  const roomModal({ Key? key }) : super(key: key);

  @override
  _roomModalState createState() => _roomModalState();
}

class _roomModalState extends State<roomModal> {

  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  final provider = getIt.get<UserID>();

  bool _lock = true;
  String? gameType = "인물";

  @override
  Widget build(BuildContext context) {


    
    return ScreenUtilInit(
      designSize: Size(1080, 2280),
      minTextAdapt: true,
      builder: () =>  
        AlertDialog(
        title: Text("방 이름을 입력해주세요"),
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _roomNameController,
                  decoration: InputDecoration(
                    hintText: "나랑 게임하자"
                  ),
                ),
                DropdownButton(
                  value:gameType,
                  icon: Icon(Icons.add),
                  items: <String>['인물', '영화', '노래'].map
                    <DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value)
                      );
                    }).toList(),
                
                  onChanged: (String? newValue){
                    setState(() {
                      gameType = newValue;
                    });
                  }),
                Container(
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child:TextField(
                          controller: _pwController,
                          decoration: InputDecoration(
                            hintText: "비밀번호"
                          ),
                        )
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            _lock = !_lock;
                          });
                        },
                        icon: _lock ? Icon(Icons.lock_open_sharp) : Icon(Icons.lock_sharp)
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              makeRoom(_roomNameController.text, _lock, provider.myName, provider.myImage);
              Navigator.push(context, 
                MaterialPageRoute(builder: (BuildContext context) => InGame(
                  roomName: _roomNameController.text,
    
                  )));
            },
            child: Text('방 만들기')),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              print("취소");
            },
            child: Text("취소")
          )
        ],
      ),
    );
  }
}

