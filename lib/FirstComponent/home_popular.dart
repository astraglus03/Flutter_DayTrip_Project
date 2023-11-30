import 'package:flutter/material.dart';

class HomePopular extends StatefulWidget {
  const HomePopular({Key? key}) : super(key: key);

  @override
  _HomePopularState createState() => _HomePopularState();
}

class _HomePopularState extends State<HomePopular> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostTab(), // DayLog 위젯을 여기에 추가
    );
  }
}

// 전체적인 포스트 탭 보여주기
class PostTab extends StatefulWidget {
  const PostTab({Key? key}) : super(key: key);

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  int _currentIndex = 0;

  final List<List<Map<String, dynamic>>> tabInfo = [
    [//탭1
      {
        'title': '강변서재',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/school1.jpg',
      },
      {
        'title': '예시',
        'location': '광주',
        'category': '카페',
        'imagePath': 'asset/img/school2.jpg',

      },
      {
        'title': '3',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/school1.jpg',
      },
      {
        'title': '4',
        'location': '광주',
        'category': '카페',
        'imagePath': 'asset/img/school2.jpg',

      },
      {
        'title': '강변서재',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/school1.jpg',
      },
      {
        'title': '예시',
        'location': '광주',
        'category': '카페',
        'imagePath': 'asset/img/school2.jpg',

      },

    ],
    [
    {
      'title': '2',
      'location': '서울, 영등포구',
      'category': '카페',
      'imagePath': 'asset/img/school2.jpg',

    },
    ],
  [{
      'title': '3',
      'location': '서울, 영등포구',
      'category': '카페',
      'imagePath': 'asset/img/school3.jpg',
    },
  ], [{
      'title': '4',
      'location': '서울, 영등포구',
      'category': '카페',
      'imagePath': 'asset/img/friend1.jpg',
    }], [{
      'title': '5',
      'location': '서울, 영등포구',
      'category': '카페',
      'imagePath': 'asset/img/friend2.jpg',
    }],
    [{
      'title': '6',
      'location': '서울, 영등포구',
      'category': '카페',
      'imagePath': 'asset/img/friend3.jpg',
    }],

  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // 6개의 탭
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('인기 피드', style: TextStyle(color:Colors.black)),
          //backgroundColor: Colors.black,
          bottom: TabBar(
            tabs: [
              Tab(text: '전체'),
              Tab(text: '태그1'),
              Tab(text: '태그2'),
              Tab(text: '태그3'),
              Tab(text: '태그4'),
              Tab(text: '태그5'),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },

          ),
        ), body: TabBarView(
        children: List.generate(
          tabInfo.length, // 탭 6개
              (tabIndex) => GridView.builder( //GridView.builder는 동적으로 무한히 가져옴. GridView.Count는 정적으로 가져옴
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2, // 한 줄에 2개의 이미지가 꽉 차게
              mainAxisExtent: 320, // 컬럼 높이
              childAspectRatio: 0.5, // 아이템 비율 조절 // 오버플로우 방지 // 1보다 작으면 높이 비율이 더 큼. 높이2:너비1
              mainAxisSpacing: 0.0, // 세로 간격 조절
            ),
            itemCount: tabInfo[tabIndex].length, // 탭 6개
            itemBuilder: (BuildContext context, int index) { // 탭1, 탭2.. index별로 가져오기
              var info = tabInfo[tabIndex][index];
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2, // 사진 2장. 2장의 너비가 화면 꽉 차게
                    height: MediaQuery.of(context).size.height/3,
                    margin: EdgeInsets.symmetric(horizontal: 0.5), // 이미지 간 간격
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(info['imagePath']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(info['title']),
                  Text(info['location']),
                ],
              );

            },
          ),
        ),
      )
      )

    );
  }
}
