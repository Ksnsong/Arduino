#include <TimedAction.h>
//shift register0
int datapin = 2;          
int clockpin = 3;
int latchpin = 4;

//shift register1
int datapin1 = A5;          
int clockpin1 = A4;
int latchpin1 = A3;


byte data = 0;
byte data1 = 0;

//buttons
int buttonGreen = 9;
int buttonYellow = 10;
int buttonWhite = 11;

//tilt sensors             
const int sensorR=8;
const int sensorB=6;
const int sensorF=5;
const int sensorL=7;


unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

int strobeBlinkCycle = 0;
int beaconBlinkCycle = 0;

boolean beaconLights_turnedOn = false;
boolean strobeLights_turnedOn = false;

//for tilt sensors LEDs
int ledState = HIGH;                     
int lastButtonStateL = LOW;
int lastButtonStateR = LOW;
int lastButtonStateF = LOW;
int lastButtonStateB = LOW;      

//Green button
int ledStateGreen = HIGH; 
int buttonStateGreen;
int lastButtonStateGreen = LOW;

//Yellow button
int ledStateYellow = HIGH; 
int buttonStateYellow;
int lastButtonStateYellow = LOW;

//White button
int ledStateWhite = HIGH; 
int buttonStateWhite;
int lastButtonStateWhite = LOW;

const int SENSOR_PIN = 0; 

//testing
boolean ledStateG = false;
boolean ledStateY = false;
boolean ledStateW = false;

//testing
void blinkG(){
  ledStateG ? ledStateG=false : ledStateG=true;
  shiftWrite1(1, ledStateG);
  shiftWrite1(2, ledStateG);
}

//testing
void blinkW(){
  ledStateW ? ledStateW=false : ledStateW=true;
  shiftWrite1(4, ledStateW);
  shiftWrite1(5, ledStateW);
  shiftWrite1(6, ledStateW);
}

TimedAction timedActionG = TimedAction(50,blinkBeacons);
TimedAction timedActionW = TimedAction(50,blinkStrobes);

void setup() {  
  Serial.begin(9600);
  pinMode (sensorR, INPUT);
  pinMode (sensorB, INPUT);
  pinMode (sensorF, INPUT);
  pinMode (sensorL, INPUT);  
  digitalWrite (sensorR, HIGH);
  digitalWrite (sensorB, HIGH);
  digitalWrite (sensorF, HIGH);
  digitalWrite (sensorL, HIGH);
  //shift register0
  pinMode(datapin, OUTPUT);
  pinMode(clockpin, OUTPUT);  
  pinMode(latchpin, OUTPUT); 
  //shift register1
  pinMode(datapin1, OUTPUT);
  pinMode(clockpin1, OUTPUT);  
  pinMode(latchpin1, OUTPUT);
  //buttons
  pinMode(buttonGreen, INPUT);
  pinMode(buttonYellow, INPUT);
  pinMode(buttonWhite, INPUT);
  }


 void loop() {  
  //reading tilt sensors 
  int sensorValue=analogRead(SENSOR_PIN);
  Serial.println(sensorValue);
  int readingR = digitalRead(sensorR);
  int readingL = digitalRead(sensorL);
  int readingF = digitalRead(sensorF);
  int readingB = digitalRead(sensorB);

  if(analogRead(SENSOR_PIN)<100){
    strobeLights_turnedOn=true;
    beaconLights_turnedOn=true;
    timedActionG.check();
    timedActionW.check();
  }else{
 ledStateGreen=!ledStateGreen;
    shiftWrite1(1, LOW);
    shiftWrite1(2, LOW);
    shiftWrite1(4, LOW);
    shiftWrite1(5, LOW);
    shiftWrite1(6, LOW);
    strobeLights_turnedOn=false;
    beaconLights_turnedOn=false;
  }
  //Right
  if (readingR != lastButtonStateR) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (readingR == HIGH) {
      shiftWrite(0, ledState);
      shiftWrite(4, ledState);
      shiftWrite1(3, ledState);
    }else{
      ledState=!ledState;
      shiftWrite(0, ledState);
      shiftWrite(4, ledState);
      shiftWrite1(3, ledState);
      ledState=!ledState;
    }
  }
  lastButtonStateR = readingR;

  //Left
  if (readingL != lastButtonStateL) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (readingL == HIGH) {
      shiftWrite(2, ledState);
    }else{
      ledState=!ledState;
      shiftWrite(2, ledState);
      ledState=!ledState;
    }
  }
  lastButtonStateL = readingL;

  //Front
  if (readingF != lastButtonStateF) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (readingF == HIGH) {
      shiftWrite(1, ledState);
    }else{
      ledState=!ledState;
      shiftWrite(1, ledState);
      ledState=!ledState;
    }
  }
  lastButtonStateF = readingF;

  //Back
  if (readingB != lastButtonStateB) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (readingB == HIGH) {
      shiftWrite(3, ledState);
    }else{
      ledState=!ledState;
      shiftWrite(3, ledState);
      ledState=!ledState;
    }
  }
  lastButtonStateB = readingB;
}

//shift register0
void shiftWrite(int desiredPin, boolean desiredState){
  bitWrite(data,desiredPin,desiredState);
  shiftOut(datapin, clockpin, MSBFIRST, data);
  digitalWrite(latchpin, HIGH);
  digitalWrite(latchpin, LOW);
}
//shift register1
void shiftWrite1(int desiredPin1, boolean desiredState1){
  bitWrite(data1,desiredPin1,desiredState1);
  shiftOut(datapin1, clockpin1, MSBFIRST, data1);
  digitalWrite(latchpin1, HIGH);
  digitalWrite(latchpin1, LOW);
}

void blinkStrobes(){
 if (strobeLights_turnedOn == true) {
   // Strobe blink pattern courtesy of youtube user BRADHblackdragon in video here:
   // http://www.youtube.com/watch?v=nnGQ9kB8JG4  at the 3 minute mark
   // Blink is on at 0 and 2 tenths, off at 1 tenth and 3 through 9 tenths
   switch (strobeBlinkCycle) {
     case 0:
        shiftWrite1(4, HIGH);
        shiftWrite1(5, HIGH);
        shiftWrite1(6, HIGH);
        strobeBlinkCycle ++;
       break;
     case 1:
        shiftWrite1(4, LOW);
        shiftWrite1(5, LOW);
        shiftWrite1(6, LOW);
       strobeBlinkCycle ++;
       break;
     case 2:
        shiftWrite1(4, HIGH);
        shiftWrite1(5, HIGH);
        shiftWrite1(6, HIGH);
       strobeBlinkCycle ++;
       break;
     default:
        shiftWrite1(4, LOW);
        shiftWrite1(5, LOW);
        shiftWrite1(6, LOW);
       strobeBlinkCycle ++;
       if (strobeBlinkCycle == 10){
         strobeBlinkCycle = 0;
       }
   }
 }
}

void blinkBeacons(){
 if (beaconLights_turnedOn == true) {
   // Beacon blink pattern courtesy of youtube useyyr BRADHblackdragon in video here:
   // http://www.youtube.com/watch?v=nnGQ9kB8JG4  at the 3 minute mark
   switch (beaconBlinkCycle) {
     case 0:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       break;
     case 1:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       break;
     case 2:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       break;
     case 3:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       break;
     case 4:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       break;
     case 5:
       shiftWrite1(1,HIGH);
       shiftWrite1(2,HIGH);
       beaconBlinkCycle ++;
       break;
     default:
       shiftWrite1(1,LOW);
       shiftWrite1(2,LOW);
       beaconBlinkCycle ++;
       if (beaconBlinkCycle == 10){
         beaconBlinkCycle = 0;
       }
   }
 }
}


