import 'package:flutter/material.dart';
import 'package:sep490/common/utils/game.dart';
import 'package:sep490/presentation/pages/ultility/game/keobuabao/screens/game_screen.dart';
import 'package:sep490/presentation/pages/ultility/game/keobuabao/widgets/game_button.dart';
import 'package:sep490/presentation/pages/ultility/game/screens/game_card_screen.dart';
import 'package:sep490/theme/color.dart';

class KeoBuaBaoScreen extends StatefulWidget {
  @override
  State<KeoBuaBaoScreen> createState() => _KeoBuaBaoScreenState();
}

class _KeoBuaBaoScreenState extends State<KeoBuaBaoScreen> {
  late int gamePoint = Game.score;
  @override
  Widget build(BuildContext context) {
    double btnWidth = MediaQuery.of(context).size.width /2 -40;
    return WillPopScope(
        onWillPop: () async {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => GameCardScreen()),
        // );
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Kéo búa bao")),
         backgroundColor: AppColors.secondaryColor,
        body: Padding
        (
          padding:EdgeInsets.symmetric(vertical: 34.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SCORE", style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(gamePoint.toString(), style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: MediaQuery.of(context).size.width / 2 - btnWidth / 2 -20,
      
                        child: Hero(
                          tag: "Rock",
                          child: gameButton(() {
                            print("Tou choosed Rock!");
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context)=>GameScreen(
                                  Choice("Rock")
                                ),
                              )).then((newPoint) {
                                if(newPoint != null && newPoint > gamePoint) {
                                  setState(() {
                                    gamePoint = newPoint;
                                  });
                                }
                              });
                          },"assets/img/rock.png",btnWidth),
                        ),
                      ),
      
                      Positioned(
                        top: btnWidth, 
                        left: MediaQuery.of(context).size.width / 2 -btnWidth -40,
                        child: Hero(
                          tag: "Paper",
                          child: gameButton(() {
                          print("Tou choosed paper!");
                           Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context)=>GameScreen(
                                  Choice("Paper")
                                ),
                              )).then((newPoint) {
                                if(newPoint != null && newPoint > gamePoint) {
                                  setState(() {
                                    gamePoint = newPoint;
                                  });
                                }
                              });
                                              },"assets/img/paper.png",btnWidth),
                        ),
                      ),
                      Positioned(
                        top: btnWidth,
                        right: MediaQuery.of(context).size.width / 2 -btnWidth -40,
                        child: Hero(
                          tag: "Scissors",
                          child: gameButton(() {
                          print("Tou choosed scissors!");
                           Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context)=>GameScreen(
                                  Choice("Scissors")
                                ),
                              )).then((newPoint) {
                                if(newPoint != null && newPoint > gamePoint) {
                                  setState(() {
                                    gamePoint = newPoint;
                                  });
                                }
                              });
                                              },"assets/img/scissors.png",btnWidth),
                        ),
                      ),
                  ],
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                width: double.infinity,
      
                child: RawMaterialButton(
                  onPressed: (){},
                  padding: EdgeInsets.all(16.0),
                  shape: StadiumBorder(side: BorderSide(color: Colors.white,width: 5.0)),
                  child: Text(
                    "Rules",
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
              )
      
            ],
          ), 
        ),
      ),
    );
  }
}
