import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerapp/screens/timer.dart';
import 'package:battery_plus/battery_plus.dart';
import '../utils/text_container.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  late String period; // AM o PM
  late int displayHour;
  late DateTime now;
  late int hour;
  late int minute;
  Timer? _timer;
  final Battery _battery = Battery();
  int batteryLevel = 0;
  bool isCharging = false;



  void _updateTime() {
    final now = DateTime.now();
    hour = now.hour;
    minute = now.minute;

    // Conversión a formato 12h
    if (hour == 0) {
      displayHour = 12;
      period = 'am';
    } else if (hour < 12) {
      displayHour = hour;
      period = 'am';
    } else if (hour == 12) {
      displayHour = 12;
      period = 'pm';
    } else {
      displayHour = hour - 12;
      period = 'pm';
    }

  }

  Future<void> _updateBattery() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;

    setState(() {
      batteryLevel = level;
      isCharging = state == BatteryState.charging;
    });
  }

  @override
  void initState() {
    super.initState();

    _updateTime();
    _updateBattery();

    // FULLSCREEN
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    // Timer que se actualiza cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateTime();
      });
    });

    // Actualizar batería cada 30 segundos
    Timer.periodic(const Duration(seconds: 1), (_) {
      _updateBattery();
    });

  }

  @override
  void dispose() {

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double wwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            // IZQUIERDA
            const Text(
              'Clock',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),

            // CENTRO (batería)
            Expanded(
              child: Center(
                child: isCharging
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$batteryLevel%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ),

            // DERECHA
            const Text(
              'Designed by Raul Ventura',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Esta es la primera fila donde se muestran las horas, minutos y segundos
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.red)
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //TextContainer(text: _hours, width: 250, fontsize: 190)

                  //Estas son las horas, estara visible o no dependiendo si las horas
                  //son mayores a 0
                  Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.green)
                    ),

                    child: Text(
                      displayHour.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: wwidth / 3.8,
                        fontWeight: FontWeight.w100,
                        height: 1.2
                        //letterSpacing: 2,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.white)
                    ),
                    width: 50,
                    child: Text(
                      ":",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: wwidth / 5,
                        fontWeight: FontWeight.w100,
                        height: 1.0
                      ),
                    ),
                  ),


                  // contiene los minutos
                  Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.white)
                      ),
                      child: TextContainer(text: minute, width: (wwidth*0.9),fontsize: (wwidth/3.8))
                  ),

                  //const SizedBox(height: 10),

                  Text(
                    period,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: wwidth / 15,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 2,
                    ),
                  ),


                ],
              ),
            ),

            //const SizedBox(height: 20),

            //Esta es la segunda fila donde se encuentran los botones
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.blue),
              ),
              //height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyTimer(),
                        ),
                      );
                    },
                    child: const Text(
                      'Timer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
