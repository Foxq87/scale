import 'package:cal/constants.dart';
import 'package:cal/pages/testPage.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:unicons/unicons.dart';

class Tests extends StatefulWidget {
  String previousPageTitle;
  Tests({super.key, required this.previousPageTitle});

  @override
  State<Tests> createState() => _TestsState();
}

List lessons = [
  ["Literature", UniconsLine.book_alt, true],
  ["History", Icons.account_balance_rounded, false],
  ["Geography", UniconsLine.globe, false],
  ["Math", UniconsLine.calculator, false],
  ["Physics", UniconsLine.atom, false],
  ["Chemistry", CupertinoIcons.lab_flask_solid, false]
];

List topics = [
  [
    1,
    [
      [
        1,
        "Türk Dili ve Edebiyatına Giriş",
        [
          ["Edebiyat nedir?", 1, true],
          ["Edebiyatın bilimle ve güzel sanatlarla ilişkisi", 2, false],
          ["Metinlerin sınıflandırılması", 3, false, false],
          ["İletişim ve ögeleri", 4, false],
          ["Düşünceyi geliştirme yolları", 5, false],
          ["Standart dil, ağız, şive, lehçe ile argo, jargon", 6, false]
        ],
        false
      ],
      [
        2,
        "Hikaye",
        [
          ["Cumhuriyet Dönemi’nden bir olay hikâyesi", 1, false],
          ["Cumhuriyet Dönemi’nden bir durum hikâyesi", 2, false],
          [
            "Hikâyenin tanımı ve unsurları (kişiler, olay örgüsü, mekân, zaman, çatışma, konu, tema, anlatıcı ve bakış açısı)",
            3,
            false
          ],
          [
            "Olay hikâyesi (Maupassant tarzı) ve durum hikâyesinin (Çehov tarzı) farkları",
            4,
            false
          ],
          ["Sunu hazırlamanın temel ilkeleri", 5, false],
          ["İsim", 6, false],
          ["Yazım (İmlâ) Kuralları", 7, false],
          ["Noktalama İşaretleri", 8, false]
        ],
        false
      ],
    ]
  ],
  [
    2,
    [
      [
        1,
        "Tarih ve Zaman",
        [
          ["Tarih Bilimi", 1, false],
          ["Neden Tarih Öğreniyoruz?", 2, false],
          ["Tarihe Nereden Bakılmalı?", 3, false],
          ["Zaman ve İnsan", 4, false],
        ],
        false
      ],
      [
        2,
        "İnsanlığın İlk Dönemleri",
        [
          ["İnsanlığın İlk Dönemleri", 1, false],
          ["Tarih Öncesinde Sözlü Kültür", 2, false],
          ["Yazının İcadı ve Önemi", 3, false],
          ["Kadim Dünyada Bilimler", 4, false],
          ["İlk Çağ Medeniyetleri", 5, false],
          ["İnsan ve Çevre", 6, false],
          ["İlk Çağ’da Göçler", 7, false],
          ["İlk Çağ’ın Tüccar Kavimleri", 8, false],
          ["Devletler Doğuyor", 9, false],
          ["İlk Çağ’da Hukuk", 10, false],
        ],
        false
      ],
    ]
  ]
];
int currentLesson = 0;
double sliderValue = 20;
double sliderValue2 = 25;
String lesson = "Literature";

String subtopic = "Edebiyat nedir?";

class _TestsState extends State<Tests> {
  PageController pageController = PageController(initialPage: 1);
  bool isForYou = false;
  @override
  Widget build(BuildContext context) {
    List testScreens = [
      ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 20),
            child: Text(
              'Statics',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Lessons',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              scrollDirection: Axis.horizontal,
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                return buildLessonItem(
                  lessons[index][0],
                  lessons[index][1],
                  index,
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Topics',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                color: kDarkGreyColor,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(width: 2, color: Colors.grey[900]!)),
            child: ToggleList(
              innerPadding: const EdgeInsets.symmetric(horizontal: 15),
              scrollPhysics: const NeverScrollableScrollPhysics(),
              scrollPosition: AutoScrollPosition.end,
              shrinkWrap: true,
              toggleAnimationDuration: const Duration(milliseconds: 200),
              scrollDuration: const Duration(milliseconds: 20),
              trailing: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  CupertinoIcons.chevron_down,
                  color: Colors.white,
                ),
              ),
              children: List.generate(
                topics[currentLesson][1].length,
                (i) => ToggleListItem(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        topics[currentLesson][1][i][2].length,
                        (j) => Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: topics[currentLesson][1][i][2][j][2]
                                      ? Border.all(width: 2, color: kThemeColor)
                                      : Border.all(
                                          width: 2, color: Colors.grey[900]!),
                                  borderRadius: BorderRadius.circular(15)),
                              child: CupertinoButton(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${topics[currentLesson][1][i][2][j][1]} - ",
                                        style: const TextStyle(
                                            color: greenColor, fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Text(
                                          topics[currentLesson][1][i][2][j][0]
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      for (var lesson = 0;
                                          lesson < topics.length;
                                          lesson++) {
                                        for (var topicss = 0;
                                            topicss < topics[lesson].length;
                                            topicss++) {
                                          for (var element in topics[lesson][1]
                                              [topicss][2]) {
                                            element[2] = false;
                                          }
                                        }
                                      }

                                      topics[currentLesson][1][i][2][j][2] =
                                          true;
                                      subtopic =
                                          topics[currentLesson][1][i][2][j][0];
                                    });
                                  }),
                            )),
                  ),
                  title: Row(
                    children: [
                      Text(
                        "${topics[currentLesson][1][i][0]} - ",
                        style:
                            const TextStyle(color: kThemeColor, fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          topics[currentLesson][1][i][1],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  onExpansionChanged: (index, newValue) {},
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: floationActionButton(context),
      appBar: appBar(),
      body: PageView.builder(
          controller: pageController,
          itemCount: testScreens.length,
          itemBuilder: (context, index) {
            return testScreens[index];
          }),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
        preferredSize: Size(Get.width, 90),
        child: Column(
          children: [
            CupertinoNavigationBar(
              middle: const Text(
                'Tests',
                style: TextStyle(color: kThemeColor),
              ),
              backgroundColor:
                  const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.grey[900]!)),
                    color:
                        const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            isForYou = true;

                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              'Statics',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            isForYou == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 65,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 65,
                                  )
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            isForYou = false;
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              'Solve',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            isForYou
                                ? Container(
                                    height: 4.3,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                  )
                                : Container(
                                    height: 4.3,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                  )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  SizedBox floationActionButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: kThemeColor,
        child: const Text('Next'),
        onPressed: () {
          showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setModalState) => CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: CupertinoAlertDialog(
                  title: const Text(
                    'Testinde kaç soru bulunmasını istersin?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Slider(
                            thumbColor: Colors.white,
                            divisions: 120,
                            min: 5,
                            max: 120,
                            activeColor: kThemeColor,
                            value: sliderValue,
                            onChanged: (val) {
                              setModalState(() {
                                sliderValue = val;
                              });
                            }),
                        Text(
                          sliderValue.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Geri",
                          style: TextStyle(
                            color: kThemeColor,
                          ),
                        )),
                    CupertinoDialogAction(
                        onPressed: () {
                          Get.back();
                          showCupertinoDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setModalState) =>
                                  CupertinoTheme(
                                data: const CupertinoThemeData(
                                    brightness: Brightness.dark),
                                child: CupertinoAlertDialog(
                                  title: const Text(
                                    'Testinin kaç dakika olmasını istersin?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Slider(
                                            thumbColor: Colors.white,
                                            divisions: 240,
                                            min: 2,
                                            max: 240,
                                            activeColor: kThemeColor,
                                            value: sliderValue2,
                                            onChanged: (val) {
                                              setModalState(() {
                                                sliderValue2 = val;
                                              });
                                            }),
                                        Text(
                                          sliderValue2.toInt().toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          "Geri",
                                          style: TextStyle(
                                            color: kThemeColor,
                                          ),
                                        )),
                                    CupertinoDialogAction(
                                        onPressed: () {
                                          Get.back();

                                          Get.to(
                                            () => TestPage(
                                              lesson: lesson,
                                              questionCount:
                                                  sliderValue.toInt(),
                                              time: sliderValue2.toInt(),
                                              subtopic: subtopic,
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Başlat",
                                          style: TextStyle(
                                            color: greenColor,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Devam",
                          style: TextStyle(
                            color: greenColor,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildLessonItem(
    String title,
    IconData icon,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kDarkGreyColor,
              border: lessons[index][2]
                  ? Border.all(width: 2, color: kThemeColor)
                  : Border.all(width: 2, color: Colors.grey[900]!)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
        onPressed: () {
          for (var i = 0; i < lessons.length; i++) {
            setState(() {
              lessons[i][2] = false;
            });
          }
          setState(() {
            lesson = title;
            currentLesson = index;
            lessons[index][2] = true;
          });
        },
      ),
    );
  }
}
