import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "추천",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 텍스트들을 왼쪽과 오른쪽에 정렬
                children: [
                  Text(
                    "최근 피드",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  GestureDetector(
                    onTap: (){},
                    child:Text("전체보기>",
                    style: TextStyle(
                    fontSize: 15,
                    ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 10),
              // 이미지 슬라이드
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                ),
                items: [
                  'asset/img/school1.jpg',
                  'asset/img/school2.jpg',
                  'asset/img/school3.jpg',
                  // Add more image paths as needed
                ].map((String imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(imagePath),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 텍스트들을 왼쪽과 오른쪽에 정렬
                children: [
                  Text(
                    "다가오는 전시 ∙ 행사 일정",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  GestureDetector(
                    onTap: (){},
                    child:Text("전체보기>",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼 사이 간격 균등하게
                children: [
                  GestureDetector(
                    onTap: (){},
                    child:Text("일",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("월",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("화",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("수",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("목",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("금",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child:Text("토",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
