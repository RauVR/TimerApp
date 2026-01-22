import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerapp/utils/text_container.dart';

class MyTimer extends StatefulWidget {

  const MyTimer({super.key});

  @override
  State<MyTimer> createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {

  final number = '0';
  bool isenable=true;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _milliseconds  = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // FULLSCREEN
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  void startTimer() {

    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _seconds+=1;
        // _milliseconds += 10;
        // if (_milliseconds >= 1000) {
        //   _milliseconds = 0;
        //   _seconds++;
        // }
        if (_seconds >= 60) {
          _seconds = 0;
          _minutes++;
        }
        if (_minutes >= 60) {
          _minutes = 0;
          _hours++;
        };
        isenable = false;
      });
    });

  }

  void restartTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _milliseconds = 0;
      _hours=0;
      _minutes=0;
      _seconds=0;
      isenable=true;
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      isenable=true;
    });
  }

  @override
  void dispose() {

    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Cronometro',style: TextStyle(color: Colors.white,fontSize: 20),),
            Text('Designed by Raul Ventura',style: TextStyle(fontSize: 10,color: Colors.white),)
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
                  Visibility(
                    visible: (_hours > 0) ? true : false,
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.green)
                      ),
                      width: (width/2.6),
                      //height: (width/3.4),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_hours:',
                            style: TextStyle(
                                fontSize: (width/3.3),
                                fontWeight: FontWeight.w100,
                                color: Colors.white,
                                height: 0.9
                            ),
                          )
                      ),
                    ),
                  ),
              
              
                  Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.white)
                      ),
                      child: TextContainer(text: _minutes, width: width,fontsize: (width/3.3))
                  ),
              
                  // contiene los segundos
                  Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.white)
                    ),
                    width: (width/7),
                    child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Text(': ',style:
                              TextStyle(
                                  fontSize: (width/10.975),
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white
                              ),
                            ),
                            Visibility(
                                visible: (_seconds<10)?true:false,
                                child: Text(number,
                                  style: TextStyle(fontSize: (width/10.975),fontWeight: FontWeight.w100,color: Colors.white),)
                            ),
                            Text(
                              '$_seconds',
                              style: TextStyle(fontSize: (width/10.975),fontWeight: FontWeight.w100,color: Colors.white),
                            ),
                          ],
                        )
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
              height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: isenable? startTimer :null,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 20),

                  ElevatedButton(
                    onPressed: stopTimer,
                    child: const Text('Stop'),
                  ),
                  const SizedBox(width: 20),

                  ElevatedButton(
                    onPressed: restartTimer,
                    child: const Text('Restart'),
                  ),
                  const SizedBox(width: 40),
                  //Text('$width')
                ],
              ),
            ),
          ],
        ),
      ),


    );



  }
}
