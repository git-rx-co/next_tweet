import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String strTitle, disappearedBackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? "BuddiesGram" : strTitle,
      style: TextStyle(
        color: Colors.black,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 45.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
