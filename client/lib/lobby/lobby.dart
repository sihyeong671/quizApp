import 'package:client/inGame/inGame.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/utils/socketManager.dart';
import 'package:client/models/Room.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:client/main.dart';
import 'package:client/provider/userID.dart';

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
    // 이게 맞나?
    print("리프레쉬");
    getRoomData();
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
  void initState() {
    super.initState();
    initSocket();
    _initSocketListener();
    connectSocket();
  }

  _initSocketListener(){
    roomExistenceCheck(_showToastMessage);
    setRoomData(_updateRoomData);
    failToJoin(_showToastMessage);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        // backgroundColor: Colors.amber,
        floatingActionButton: FloatingButton(),
        body: 
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30.0)),
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
                  height: 1000,
                  child: SmartRefresher(
                    enablePullDown: true,
                    // enablePullUp: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    // onLoading: _onLoading,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(rooms.length, (index) {
                        return Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Text('${index+1}'),
                                title: Text('${rooms[index].gameTitle}'),
                                subtitle: Text('${rooms[index].gameType}'),
                                trailing: Text('${rooms[index].currentNum}/${rooms[index].totalNum}'),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  TextButton(
                                    child: Text('참가하기'),
                                    onPressed: () {
                                      joinRoom({
                                        "roomName": rooms[index].gameTitle,
                                        "name": provider.myName,
                                        "img": provider.myImage
                                      });
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => InGame(gameTitle: rooms[index].gameTitle)));
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
    );
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

  _updateInfo(data){

    late int totalNum;
    late int currentNum;
    late String gameType;
    late String gameTitle;
    late bool isLock;
    late bool isGameStart;

    data.forEach((name, value){
      if(name == 'totalNum') totalNum = value;
      else if(name == 'currentNum') currentNum = value;
      else if(name == 'gameType') gameType = value;
      else if(name == 'gameTitle') gameTitle = value;
      else if(name == 'isLock') isLock = value;
      else if(name == 'isGameStart') isGameStart = value;
    });
    
    Room newRoom = new Room(
      totalNum,
      currentNum,
      gameType,
      gameTitle,
      isLock,
      isGameStart
    );
    print(newRoom);
    
    setState(() {
      rooms.add(newRoom);
    });
  }

  _updateRoomData(data){
    List<Room> initRooms = [];

    data.forEach((k, v){
      late int totalNum;
      late int currentNum;
      late String gameType;
      late String gameTitle;
      late bool isLock;
      late bool isGameStart;
      v.forEach((kk, vv){

        if(kk == 'totalNum') totalNum = vv;
        else if(kk == 'currentNum') currentNum = vv;
        else if(kk == 'gameType') gameType = vv;
        else if(kk == 'gameTitle') gameTitle = vv;
        else if(kk == 'isLock') isLock = vv;
        else if(kk == 'isGameStart') isGameStart = vv;

      });

      Room roomInstance = new Room(
          totalNum,
          currentNum,
          gameType,
          gameTitle,
          isLock,
          isGameStart
        );

      initRooms.add(roomInstance);

    });

    setState(() {
      rooms = initRooms;
    });
  }

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
  String? gameTitle = "인물";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                value:gameTitle,
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
                    gameTitle = newValue;
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
            makeRoom(_roomNameController.text, gameTitle, _lock, provider.myName, provider.myImage);
            print("방만들기");
            Navigator.push(context, 
              MaterialPageRoute(builder: (BuildContext context) => InGame(gameTitle: _roomNameController.text)));
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
    );
  }
}

