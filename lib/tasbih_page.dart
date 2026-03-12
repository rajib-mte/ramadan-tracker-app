import 'dart:async';
// import '/conts/TEXT_STYLE.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conts/TEXT_STYLE.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _HomePageState();
}

class _HomePageState extends State<TasbihPage> {
  bool isRunning = false;
  Timer? _timer;
  int seconds = 0;
  int counter = 0;


  @override
  void initState() {
    super.initState();
    _getCounter();
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  String formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }


  void startTimer() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }


  void stopTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }


  Future<void> _saveCounter() async {
    final prefs =  await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }


  Future<void> _getCounter() async {
    final prefs =  await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Tasbih Counter", style: APP_TEXT_STYLE.titleBlack16),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFdad3e1),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(Icons.notifications_none, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 450,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage("assets/images/main_bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color(0xFF764CA5).withOpacity(0.85),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("الله أكبر", style: APP_TEXT_STYLE.textWhite20W700),

                    SizedBox(height: 24),

                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF).withOpacity(0.65),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        formatTime(seconds).toString(),
                        style: APP_TEXT_STYLE.timerParpal16W700,
                      ),
                    ),

                    SizedBox(height: 24),

                    Text("Tasbih Counter", style: APP_TEXT_STYLE.textWhite20W700),

                    SizedBox(height: 24),

                    Text(
                      counter.toString(),
                      style: APP_TEXT_STYLE.counterWhite20W700,
                    ),

                    SizedBox(height: 24),

                    GestureDetector(
                      onTap: () async {
                        if (isRunning) {
                          setState(() {
                            counter++;
                          });
                          await _saveCounter();
                        }
                      },
                      child: AnimatedContainer(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2D1D3F),
                              Color(0xFF764CA5),
                              Color(0xFF111B2B),
                            ],
                          ),
                        ),
                        duration: Duration(milliseconds: 300),
                        child: Align(
                          alignment: isRunning
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.all(6),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isRunning
                                  ? Color(0XFFFFFFFF)
                                  : Color(0xFFCEC5D8).withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _controlButton(Icons.refresh, () async {
                          setState(() {
                            counter = 0;
                            seconds = 0;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('counter', 0);
                        }),
                        _textButton("Stop", () {
                          stopTimer();
                        }),
                        _controlButton(isRunning ? Icons.pause : Icons.play_arrow, () {
                          startTimer();
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 26),

              Text("Add Theme", style: APP_TEXT_STYLE.titleBlack16),

              SizedBox(height: 26),

              Row(
                children: [
                  Expanded(
                    child: _themeThumbnail(
                      "assets/images/bg_2.png",
                      const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _themeThumbnail(
                      "assets/images/bg_3.png",
                      const Color(0xFF183282),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF764CA5).withOpacity(0.7),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: 0,
          onTap: null,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Color(0xFF764CA5), size: 30),
      ),
    );
  }

  Widget _textButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(text, style: APP_TEXT_STYLE.timerParpal16W700),
      ),
    );
  }

  Widget _themeThumbnail(String asset, Color overlay) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(overlay.withOpacity(0.8), BlendMode.darken,),
        ),
      ),
    );
  }
}