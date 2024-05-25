import 'package:flutter/material.dart';

class ExportSettings extends StatelessWidget {
  const ExportSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.ios_share_outlined,
              color: Colors.black,
              size: 30,
            ),
            SizedBox(width: 15,),
            Icon(
              Icons.settings,
              color: Colors.black,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
