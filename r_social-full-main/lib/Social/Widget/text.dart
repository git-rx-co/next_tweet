import 'package:flutter/material.dart';

class text extends StatelessWidget {
  var data;
  var size;
  var color;
  text({this.data, this.size, this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(color: color, fontSize: size != null ? size : 14.0),
    );
  }
}
