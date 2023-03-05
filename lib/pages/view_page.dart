import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spellchecker/pages/home_page.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  final _carouselController = CarouselController();
  int _currentIndex = 0;
  List listIndicator = [1, 2];
  List<String> imgList = [
    'assets/welcome.svg',
    'assets/welcome2.svg'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(24),
              child: pageView(size))),
    );
  }

  Widget pageView(Size size) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 24),
            child: Image.asset(
              'assets/icon_app.png',
              width: 48,
            ),
          ),
          pageSlider(size),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.lightBlueAccent),
              child: Center(
                  child: Text(
                "Mulai",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget pageSlider(Size size) {
    return Container(
      width: size.width,
      height: size.height / 1.7,
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
              children: listIndicator.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList()),
          Container(
            width: size.width,
            height: size.height / 2,
            margin: const EdgeInsets.only(top: 24),
            child: CarouselSlider(
                items: imgList
                    .map(
                      (item) => Column(
                        children: [
                          if (item == 'assets/welcome.svg')
                          const Text("Selamat Datang Di Aplikasi iDetech", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          if (item == 'assets/welcome2.svg')
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: const Text("Deteksi Kesalahan Kata atau Typo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Saya sedang ", style: TextStyle(),),
                                  Container(
                                    color: Colors.red.shade100,
                                    child: Text("belajarr"),)
                                ],
                              )
                            ],
                          ),  
                          Expanded(
                              child: ClipRRect(
                                  child:
                                      SvgPicture.asset(item))),
                        ],
                      ),
                    )
                    .toList(),
                carouselController: _carouselController,
                options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 1,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    })),
          ),
        ],
      ),
    );
  }
}
