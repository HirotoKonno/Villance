import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'item_count_view.dart';

class OnionView extends StatelessWidget {
  const OnionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[140],
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            "淡路島産の玉ねぎはお土産にいががでしょう!?\n"
            "\n瀬戸内海特有の温暖な気候と風土で育つ淡路島産玉ねぎは「"
            "甘い・やわらかい・みずみずしい」と全国的にも有名です。\n"
            "是非、ご注文お待ちしております！\n※お帰りの際にお渡しすることも可能です。\n",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const Text(
            "1玉 : 150円",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const OnionList(),
          const ItemCountView(),
          SizedBox(
            width: 200, //横幅
            height: 50, //高さ
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.orange[300],
              ),
              onPressed: () {},
              child: const Text('確定'),
            ),
          ),
        ],
      ),
    );
  }
}

class OnionList extends StatefulWidget {
  const OnionList({super.key});

  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<OnionList> {
  final images = [
    'images/onion1.png',
    'images/onion2.png',
    'images/onion3.png',
    'images/onion4.png',
    'images/onion5.png',
  ];
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 400,
                  initialPage: 0,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) => setState(() {
                    activeIndex = index;
                  }),
                ),
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final path = images[index];
                  return buildImage(path, index);
                },
              ),
              const SizedBox(height: 20),
              buildIndicator()
            ],
          ),
        ),
      );

  Widget buildImage(path, index) => Container(
        //画像間の隙間
        margin: const EdgeInsets.symmetric(horizontal: 13),
        color: Colors.grey,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: images.length,
        //エフェクトはドキュメントを見た方がわかりやすい
        effect: const JumpingDotEffect(
            dotHeight: 20,
            dotWidth: 20,
            activeDotColor: Colors.green,
            dotColor: Colors.black12),
      );
}