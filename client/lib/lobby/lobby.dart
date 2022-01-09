import 'package:client/inGame/inGame.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/floatingButton.dart';
import 'package:client/utils/socketManager.dart';
import 'package:client/models/Room.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';

class Lobby extends StatefulWidget {
  const Lobby({ Key? key }) : super(key: key);

  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  
  Room Room1 = new Room(6, 3, '노래', '게임하자', false, false);
  Room Room2 = new Room(6, 1, '음악', '게임ㄱㄱ', false, false);

  List<Room> rooms = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)
    setState(() {

    });
    _refreshController.loadComplete();
  }


  @override
  void initState() {
    super.initState();
    initSocket();
    rooms.addAll({Room1, Room2});
    _initSocketListener();
    connectSocket();
  }

  _initSocketListener(){
    roomExistenceCheck(_showToastMessage);
    updateRoomInfo(_updateInfo);
    setRoomData(_initRoomData);
    removeRoom(_removeRoomData);
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
                        quickEntry();
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
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  TextButton(
                                    child: Text('참가하기'),
                                    onPressed: () {
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: (BuildContext context) => InGame()));
                                    },
                                  )
                                ]
                              ),
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



  _initRoomData(data){
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

  _removeRoomData(data){
    print(data);

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

  bool _lock = true;
  String? gameTitle = '노래';

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
            makeRoom(_roomNameController.text, gameTitle, _lock);
            print("방만들기");
            // Navigator.push(context, 
            //   MaterialPageRoute(builder: (BuildContext context) => InGame()));
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

