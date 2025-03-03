import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class LoadingDialog {
  static void show(BuildContext context, String imgPath, String title) {
    showDialog(
      barrierColor: Colors.white,
      barrierDismissible: false,
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GifView.asset(
                imgPath,
                width: 150,
                height: 150,
                frameRate: 60,
              ),
              Text(title, style: 
                TextStyle(
                  fontSize: 27,
                  fontFamily: 'LeagueSpartan',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )
              ,)
            ],
          ),
        ),
      ),
    );
  }
}
