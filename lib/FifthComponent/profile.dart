import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          // 카드 이미지
          CardImage(),

          SizedBox(width: 15,),

          // 이름, 친구수
          ProfileName(),

          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50)
      ),
      child: Container(
          child: Image.asset('asset/apple.jpg', fit: BoxFit.cover, width: 80, height: 80,)
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("astraglus", style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),),
        SizedBox(height: 5,),
        Text("팔로워 0 | 팔로잉 0"),
      ],
    );
  }
}
