import 'package:final_project/Screen/place_blog_screen.dart';
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
    [
      //탭1
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
      // 탭2
      {
        'title': '2',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/school2.jpg',
      },
    ],
    [
      {
        'title': '3',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/school3.jpg',
      },
    ],
    [
      {
        'title': '4',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/friend1.jpg',
      }
    ],
    [
      {
        'title': '5',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/friend2.jpg',
      }
    ],
    [
      {
        'title': '6',
        'location': '서울, 영등포구',
        'category': '카페',
        'imagePath': 'asset/img/friend3.jpg',
      }
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // 6개의 탭
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('최신 피드', style: TextStyle(color: Colors.white)),
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
        ),
        body: TabBarView(
          children: List.generate(
            tabInfo.length,
                (tabIndex) => GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                mainAxisExtent: 320,
                childAspectRatio: 0.5,
                mainAxisSpacing: 0.0,
              ),
              itemCount: tabInfo[tabIndex].length,
              itemBuilder: (BuildContext context, int index) {
                var info = tabInfo[tabIndex][index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceBlogScreen(), // Replace with your desired screen
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 3,
                        margin: EdgeInsets.symmetric(horizontal: 0.5),
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
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
