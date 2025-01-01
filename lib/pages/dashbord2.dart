
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../report_page.dart';
import 'expand.dart';


class Dashboard2 extends StatefulWidget {

  final int userId;
  Dashboard2({required this.userId, Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard2> {
  final Color TopBarColor = Color(0xFFF1F7EE);
  final Color MainColor = Color(0xFFC5E6A6);
  final Color SecondaryColor = Color(0xFFE0EDC5);
  final Color TertiaryColor = Color(0xFF92AA83);
  final Color OptionalColor = Color(0xFFBDC667);
  final Color BottomBarColor = Color(0xFF697268);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopBarColor,
      appBar: AppBar(
        backgroundColor: TopBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.9,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MainColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Profile Picture Container
                    Container(
                      margin: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[100],
                        border: Border.all(color: Colors.black54, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // child: Image.asset(
                      //   'assets/images/ProfilePic.png',
                      //   height: 100,
                      //   width: 100,
                      // ),
                    ),

                    //Information Container
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          info_container("Name: John Doe", Icons.person),
                          info_container("Status : Online", Icons.task_alt),
                          info_container("Location: New York", Icons.location_on),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(

                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.black54, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: graph(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: SecondaryColor,
                      border: Border.all(color: Colors.black54, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text("MAP"),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.black54, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text("Fun Fact About Environments"),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: TertiaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buttonsContainers("Completed", Icons.check,"1"),

                            buttonsContainers("Reported", Icons.report,"2"),

                            buttonsContainers("Eco-Friendly Activities", Icons.hourglass_empty,"3"),

                            //ADDD
                          ]),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(

                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(27),
                                    bottomLeft: Radius.circular(27),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.lime.shade200,
                              ),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  small_button_containers(
                                      Icons.notifications_active_rounded),
                                  small_button_containers(
                                      Icons.now_widgets_rounded),
                                ],
                              ))),
                    ])),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Report(userId: widget.userId),
                      ),
                    );
                  },
                  child: Text(
                    "Report",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.red.shade300),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50),
                    ),
                  )),
            )
          ],
        ),
      ),

    );
  }

  Container small_button_containers(IconData icon) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ]),
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }

  GestureDetector buttonsContainers(String title, IconData icon, String uniqueId) {
    return GestureDetector(
      onTap: () {
        if(title == "Completed"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedContainer1(
                title: title,
                icon: icon,
              ),
            ),
          );
        }
        else if(title == "Reported"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedContainer2(
                title: title,
                icon: icon,
              ),
            ),
          );
        }
        else if(title == "Eco-Friendly Activities"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedContainer3(
                title: title,
                icon: icon,
              ),
            ),
          );
        }

      },
      child: Hero(
        tag: '$title-container-$uniqueId',  // Ensure this tag is unique
        child: Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, color: Colors.black54),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container info_container(String info, IconData icon) {
    return Container(
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 0),
          Text(
            info,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black54, width: 2),
        ),
      ),
    );
  }
}

LineChart graph() {
  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.black12,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(
          axisNameWidget: Text(
            "No of Tasks",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(
                "W${value.toInt() + 1}",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              return Text(
                "${value.toInt()}",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.black12, width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: const [
            FlSpot(0, 2),
            FlSpot(1, 2.5),
            FlSpot(2, 3),
            FlSpot(3, 2.5),
            FlSpot(4, 4),
            FlSpot(5, 4),
          ],
          color: Colors.green.shade600,
          barWidth: 3,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.3),
          ),
        ),
      ],
    ),
  );
}