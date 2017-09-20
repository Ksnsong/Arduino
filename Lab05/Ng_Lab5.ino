#include <TimedAction.h>
#include <Servo.h>
bool switchFront,switchBack,switchLeft,switchRight;
bool switchFrontLast=false;
bool switchBackLast=false;
bool switchLeftLast=false;
bool switchRightLast=false;
unsigned long timeFront,timeBack,timeLeft,timeRight;
bool button1,button2,button3,button4;
bool button1Last=false;
bool button2Last=false;
bool button3Last=false;
bool button4Last=false;
bool flapsUp=false;
const int flapsUpAngle = 90;
const int flapsDownAngle = 30;
boolean beaconLights_turnedOn = false;
boolean strobeLights_turnedOn = false;
bool light3=false;
int strobeBlinkCycle = 0;
int beaconBlinkCycle = 0;
const int tiltFrontPin = 0;
const int tiltBackPin = 1;
const int tiltLeftPin = 2;
const int tiltRightPin = 3;
const int beaconLights_LEDpin = 4;
const int strobeLights_LEDpin = 5;
const int landingLightsPin = 6;
const int button1Pin = 7;
const int button2Pin = 8;
const int button3Pin = 12;
const int button4Pin = 13;
const int motorPin = 11;
const int servo1Pin = 10;
const int servo2Pin = 9;
const int tiltFrontAnalogPin = 0;
const int tiltBackAnalogPin = 1;
const int tiltLeftAnalogPin = 2;
const int tiltRightAnalogPin = 3;
const int motorDialAnalogPin = 4;
Servo servo1;
Servo servo2;



void blinkStrobes()
{
 if (strobeLights_turnedOn == true) {
   // Strobe blink pattern courtesy of youtube user BRADHblackdragon in video here:
   // http://www.youtube.com/watch?v=nnGQ9kB8JG4  at the 3 minute mark
   // Blink is on at 0 and 2 tenths, off at 1 tenth and 3 through 9 tenths
   switch (strobeBlinkCycle) {
     case 0:
       digitalWrite(strobeLights_LEDpin,HIGH);
       strobeBlinkCycle ++;
       break;
     case 1:
       digitalWrite(strobeLights_LEDpin,LOW);
       strobeBlinkCycle ++;
       break;
     case 2:
       digitalWrite(strobeLights_LEDpin,HIGH);
       strobeBlinkCycle ++;
       break;
     default:
       digitalWrite(strobeLights_LEDpin,LOW);
       strobeBlinkCycle ++;
       if (strobeBlinkCycle == 10){
         strobeBlinkCycle = 0;
       }
   }
 }
}

void blinkBeacons()
{
 if (beaconLights_turnedOn == true) {
   // Beacon blink pattern courtesy of youtube user BRADHblackdragon in video here:
   // http://www.youtube.com/watch?v=nnGQ9kB8JG4  at the 3 minute mark
   switch (beaconBlinkCycle) {
     case 0:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       break;
     case 1:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       break;
     case 2:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       break;
     case 3:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       break;
     case 4:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       break;
     case 5:
       digitalWrite(beaconLights_LEDpin,HIGH);
       beaconBlinkCycle ++;
       break;
     default:
       digitalWrite(beaconLights_LEDpin,LOW);
       beaconBlinkCycle ++;
       if (beaconBlinkCycle == 10){
         beaconBlinkCycle = 0;
       }
   }
 }
}
TimedAction beaconAction=TimedAction(100,blinkBeacons);
TimedAction strobeAction=TimedAction(100,blinkStrobes);



void setup(){
  for(int a=0;a<14;a++)
    pinMode(a,OUTPUT);
  servo1.attach(servo1Pin);
  servo2.attach(servo2Pin);
}
void loop(){
  beaconAction.check();
  strobeAction.check();
  switchFront=(analogRead(tiltFrontAnalogPin)>512);
  switchBack=(analogRead(tiltBackAnalogPin)>512);
  switchLeft=(analogRead(tiltLeftAnalogPin)>512);
  switchRight=(analogRead(tiltRightAnalogPin)>512);
  analogWrite(motorPin,analogRead(motorDialAnalogPin)/4);
  button1=digitalRead(button1Pin);
  button2=digitalRead(button2Pin);
  button3=digitalRead(button3Pin);
  button4=digitalRead(button4Pin);
  if(button1!=button1Last&&button1==true){
    if(beaconLights_turnedOn==true){
      beaconLights_turnedOn=false;
    }else{
      beaconLights_turnedOn=true;
    }
  }
  button1Last=button1;
  if(button2!=button2Last&&button2==true){
    if(strobeLights_turnedOn==true){
      strobeLights_turnedOn=false;
    }else{
      strobeLights_turnedOn=true;
    }
  }
  button2Last=button2;
  if(button3!=button3Last&&button3==true){
    if(light3==true){
      digitalWrite(landingLightsPin,LOW);
      light3=false;
    }else{
      digitalWrite(landingLightsPin,HIGH);
      light3=true;
    }
  }
  button3Last=button3;
  if(button4!=button4Last&&button4==true){
    if(flapsUp==true){
      //servo1.write(flapsUpAngle);
      //servo2.write(flapsUpAngle);
      flapsUp=false;
    }else{
      //servo1.write(flapsDownAngle);
      //servo2.write(flapsDownAngle);
      flapsUp=true;
    }
  }
  button4Last=button4;
  if(flapsUp==true){
    servo1.write(flapsUpAngle);
    servo2.write(flapsUpAngle);
  }else{
    servo1.write(flapsDownAngle);
    servo2.write(flapsDownAngle);
  }
  if(switchFront!=switchFrontLast)
    timeFront=millis();
  if ((millis()-timeFront)>100){
    if(switchFront)
      digitalWrite(tiltFrontPin,HIGH);
    else
      digitalWrite(tiltFrontPin,LOW);
  }
  switchFrontLast=switchFront;
  if(switchBack!=switchBackLast)
    timeBack=millis();
  if ((millis()-timeBack)>100){
    if(switchBack)
      digitalWrite(tiltBackPin,HIGH);
    else
      digitalWrite(tiltBackPin,LOW);
  }
  switchBackLast=switchBack;
  if(switchLeft!=switchLeftLast)
    timeLeft=millis();
  if ((millis()-timeLeft)>100){
    if(switchLeft)
      digitalWrite(tiltLeftPin,HIGH);
    else
      digitalWrite(tiltLeftPin,LOW);
  }
  switchLeftLast=switchLeft;
  if(switchRight!=switchRightLast)
    timeRight=millis();
  if ((millis()-timeRight)>100){
    if(switchRight)
      digitalWrite(tiltRightPin,HIGH);
    else
      digitalWrite(tiltRightPin,LOW);
  }
  switchRightLast=switchRight;
}
