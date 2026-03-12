import 'package:adhan_dart/adhan_dart.dart';
// import 'package:ramadan_tracker_app/conts/TEXT_STYLE.dart';
// import 'package:ramadan_tracker_app/tasbih_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:ramadan_tracker/tasbih_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'conts/TEXT_STYLE.dart';

// Future<Position> _qiblaDirection() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     return Future.error('Location permissions are permanently denied.');
//   }
//
//   return await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
//   );
// }
List<String> location = ["Dhaka", "Barisal", "Chittagong", "Khulna", "Rajshahi", "Rangpur"];

var selectedItem;

Map<String, dynamic> getPrayerTimesData() {
  // Position position = await _qiblaDirection();
  // final coordinates = Coordinates(position.latitude, position.longitude);

  tz.initializeTimeZones();
  final location = tz.getLocation('Asia/Dhaka');
  final now = tz.TZDateTime.now(location);

  double valueLet = 23.8103;
  double valueLon = 90.4125;

  if(selectedItem.toString() == "Dhaka"){
    valueLet = 23.8103;
    valueLon = 90.4125;
  } else if(selectedItem.toString() == "Barisal"){
    valueLet = 22.6859;
    valueLon = 90.3563;
  } else if(selectedItem.toString() == "Chittagong") {
    valueLet = 22.3569;
    valueLon = 91.7832;
  } else if(selectedItem.toString() == "Khulna") {
    valueLet = 22.8157;
    valueLon = 89.5686;
  } else if (selectedItem.toString() == "Rajshahi") {
    valueLet = 24.3637;
    valueLon = 88.6241;
  } else if (selectedItem.toString() == "Rangpur") {
    valueLet = 25.7456;
    valueLon = 89.2187;
  }

  Coordinates coordinates = Coordinates(valueLet, valueLon);
  CalculationParameters params = CalculationParameters(
    method: CalculationMethod.muslimWorldLeague,
    fajrAngle: 18.0,
    ishaAngle: 17.0,
  );
  params.madhab = Madhab.hanafi;

  PrayerTimes prayerTimes = PrayerTimes(
    coordinates: coordinates,
    date: now,
    calculationParameters: params,
    precision: true,
  );

  // সময় ফরম্যাট করার ফাংশন (HH:mm AM/PM)
  String formatTime(DateTime? time) {
    if (time == null) return "--:--";
    var localTime = tz.TZDateTime.from(time, location);

    int hour = localTime.hour > 12
        ? localTime.hour - 12
        : (localTime.hour == 0 ? 12 : localTime.hour);
    String h = hour.toString().padLeft(2, '0');
    String m = localTime.minute.toString().padLeft(2, '0');
    String period = localTime.hour >= 12 ? "PM" : "AM";

    return "$h:$m $period";
  }

  return {
    "Fajr": formatTime(prayerTimes.fajr),
    "Dhuhr": formatTime(prayerTimes.dhuhr),
    "Asr": formatTime(prayerTimes.asr),
    "Maghrib": formatTime(prayerTimes.maghrib),
    "Isha": formatTime(prayerTimes.isha),
  };
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _today = HijriCalendar.now();

  late final String _dayName = _today.getDayName();

  late final String _dateFormat =
      "${_today.hDay} ${_today.longMonthName} ${_today.hYear}";

  DateTime date = DateTime.now();

  late String today = DateFormat('d MMMM yyyy').format(date);


  Map<String, dynamic> prayerData = {};

  void updatePrayerData() {
    prayerData = getPrayerTimesData();
  }

  @override
  void initState() {
    super.initState();
    updatePrayerData();
  }

  @override
  Widget build(BuildContext context) {

    if (prayerData.isEmpty) updatePrayerData();

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text("Ramadan Tracker"),
        leading: Icon(Icons.menu),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFdad3e1),
                borderRadius: BorderRadius.circular(50),
              ),

              child: IconButton(
                onPressed: () {
                  _getSelectDivision(context);
                },
                icon: Icon(Icons.location_pin),
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/images/header_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_dayName, style: APP_TEXT_STYLE.textWhite16),

                  SizedBox(height: 6),

                  Text(_dateFormat, style: APP_TEXT_STYLE.textWhite14),

                  SizedBox(height: 6),

                  Text(today, style: APP_TEXT_STYLE.textWhite10),

                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 25,
                          ),
                          child: Text(
                            "Ifter time - ${prayerData['Maghrib']}",
                            style: APP_TEXT_STYLE.textPerpal10,
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Text(
                            "Sehri time - ${prayerData['Fajr']}",
                            style: APP_TEXT_STYLE.textPerpal10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/category_bg.png"),
                opacity: 0.2,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xFFe6ddf9).withOpacity(0.9),
                  BlendMode.darken,
                ),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text("Category", style: APP_TEXT_STYLE.textBlack16),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoryCard(
                      "assets/images/prayer_time.png",
                      "Prayer Time",
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasbihPage()),
                      ),
                      child: _categoryCard(
                        "assets/images/tasbih.png",
                        "Tasbih",
                      ),
                    ),
                    _categoryCard("assets/images/dua.png", "Dua"),
                    _categoryCard("assets/images/quran.png", "Quran"),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/images/tasbih_count.png"),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                  colorFilter: ColorFilter.mode(
                    Color(0xFF9373b6).withOpacity(1),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Start Your Day To Count",
                    style: APP_TEXT_STYLE.textWhite16,
                  ),

                  Text("Tasbih", style: APP_TEXT_STYLE.textWhite16),

                  SizedBox(height: 10),

                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasbihPage()),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Get Started",
                        style: APP_TEXT_STYLE.textPerpal12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Container(
              height: 220,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("assets/images/prayer_sec.png"),
                  fit: BoxFit.cover,
                  opacity: 0.25,
                  colorFilter: ColorFilter.mode(
                    Color(0xFF764CA5).withOpacity(0.85),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Prayer Time",
                      style: APP_TEXT_STYLE.textWhite16,
                    ),
                  ),

                  Center(child: Text(today, style: APP_TEXT_STYLE.textWhite10)),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                          child: Center(
                            child: Text(
                              "Today",
                              style: APP_TEXT_STYLE.textPerpal12,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Center(
                            child: Text(
                              "30Days",
                              style: APP_TEXT_STYLE.textWhite12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(height: 1, color: Color(0xFFFFFFFF)),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Next prayer: Asr in 2 hours, 17 minutes",
                      style: APP_TEXT_STYLE.textGray10,
                    ),
                  ),

                  SizedBox(height: 5),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("4:26 PM", style: APP_TEXT_STYLE.textWhite14),
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 5,
                    children: [
                      _prayerCard("Fajr", "${prayerData['Fajr']}"),
                      _prayerCard("Dhuhr", "${prayerData['Dhuhr']}"),
                      _prayerCard("Asr", "${prayerData['Asr']}"),
                      _prayerCard("Maghrib", "${prayerData['Maghrib']}"),
                      _prayerCard("Isha", "${prayerData['Isha']}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _categoryCard(String img, String text) {
    return Container(
      height: 75,
      width: 85,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Image.asset(img),
          SizedBox(height: 8),
          Text(text, style: APP_TEXT_STYLE.textBlack10),
        ],
      ),
    );
  }

  Widget _prayerCard(String title, String subTitle) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Text(title, style: APP_TEXT_STYLE.textPerpal12),
            SizedBox(height: 5),
            Text(subTitle, style: APP_TEXT_STYLE.textParpal10),
          ],
        ),
      ),
    );
  }

  _getSelectDivision(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hi ! There, Select Division"),
        content: StatefulBuilder(
          builder: (context, setDialogState){
            return DropdownButton(
                isExpanded: true,
                hint: Text("Choose Division"),
                items: location.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                value: selectedItem,
                onChanged: (val){
                  setDialogState(() {
                    selectedItem = val;
                  });
                  setState(() {
                    selectedItem = val;
                    updatePrayerData();
                  });
                  Navigator.pop(context);
                }
            );
          }
        ),
      ),
    );
  }



}
