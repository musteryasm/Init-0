import 'package:flutter/material.dart';
import 'package:lta/rive_assets.dart';
import 'package:rive/rive.dart';
import 'animated_bar.dart';
import 'rive_utils.dart';
import 't_to_t.dart';
import 's_to_s.dart';
import 'ocr.dart';
import 'dict.dart';
import 'learn.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  int currentTab = 2;
  final List<Widget> screens = [
    s_to_s(),
    ocr(),
    t_to_t(),
    dict(),
    learn(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentScreen;

  late SMIBool searchTrigger1,
      searchTrigger2,
      searchTrigger3,
      searchTrigger4,
      searchTrigger5;

  RiveAsset selectedBottomNav = bottomNavs[2];
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  @override
  void initState() {
    currentScreen = screens[currentTab];

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
      setState(() {});
    });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4b2b2),
        centerTitle: true,
        title: Text(
          "LingoAssist",
          style: TextStyle(
            fontFamily: "Belanosima",
            fontWeight: FontWeight.bold,
              fontSize: 25
          ),
        ),
      ),
      backgroundColor: Color(0xfff4f4f4),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value / 100),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: PageStorage(
                    child: currentScreen,
                    bucket: bucket,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xfff4b2b2),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavs.length,
                      (index) => GestureDetector(
                    onTap: () {
                      currentScreen = bottomNavs[index].name as Widget;
                      bottomNavs[index].input!.change(true);
                      if (bottomNavs[index] != selectedBottomNav) {
                        setState(() {
                          selectedBottomNav = bottomNavs[index];
                        });
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        bottomNavs[index].input!.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(
                            isActive: bottomNavs[index] == selectedBottomNav),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity:
                            bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              bottomNavs.first.src,
                              artboard: bottomNavs[index].artboard,
                              onInit: (artboard) {
                                StateMachineController controller =
                                RiveUtils.getRiveController(artboard,
                                    stateMachineName:
                                    bottomNavs[index].stateMachineName);

                                bottomNavs[index].input =
                                controller.findSMI("active") as SMIBool;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
