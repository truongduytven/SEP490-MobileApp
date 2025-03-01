import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game_helper.dart';
import 'package:sep490/theme/colors_game.dart';

class DoBoomScreen extends StatefulWidget {

  @override
  State<DoBoomScreen> createState() => _DoBoomScreenState();
}

class _DoBoomScreenState extends State<DoBoomScreen> {
   MineSweeperGame game = MineSweeperGame();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.generateMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0.0,
        centerTitle: true,
         leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
       setState(() {
              game.resetGame();
              game.gameOver = false;
            });
      Navigator.pop(context);
    },
  ),
        title: Text(
          "Dò bom",
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                    decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.flag,
                      color: AppColor.accentColor,
                      size: 34.0,
                    ),
                    Text(
                      "10",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.lock_clock,
                      color: AppColor.accentColor,
                      size: 34.0,
                    ),
                    Text(
                      "10:32",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            )
            ],
          ),
          Container(
            width: double.infinity,
            height: 500.0,
            padding: EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MineSweeperGame.row,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0
                ),
              itemCount: MineSweeperGame.cells, 
              itemBuilder: (BuildContext ctx, index){
                Color cellColor = game.gameMap[index].reveal
                          ? AppColor.clickedCard
                          : AppColor.lightPrimaryColor;
                return GestureDetector(
                  onTap: game.gameOver
                      ? null
                      : (){
                        setState(() {
                          game.getClickedCell(game.gameMap[index]);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(6.0)
                        ),
                        child: Center(
                          child: Text(
                            game.gameMap[index].reveal
                              ? "${game.gameMap[index].content}"
                              :"",
                              style: TextStyle(
                                color: game.gameMap[index].reveal ? game.gameMap[index].content == "X" ? Colors.red : AppColor.letterColors[game.gameMap[index].content]
                                : Colors.transparent,
                                fontSize: 20.0
                              ),
                          ),
                        ),
                      ),
                );
              }),
          ),
          Text(game.gameOver ?"You lose": "",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32.0
          ),
          ),
          SizedBox(height: 20.0,),
          RawMaterialButton(onPressed: (){
            setState(() {
              game.resetGame();
              game.gameOver = false;
            });
          },
          fillColor: AppColor.lightPrimaryColor,elevation: 0,shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 18.0),
              child: Text("Repeat", style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),),
          ),
          SizedBox(height: 20.0,)
        ],
      ),
    );
  }
}
