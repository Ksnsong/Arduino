//shift register
int datapin = 2;          
int clockpin = 3;
int latchpin = 4;


byte data = 0;

//tilt sensors             
const int sensorR=8;
const int sensorB=6;
const int sensorF=5;
const int sensorL=7;


unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

int ledState = HIGH;         
int buttonState;             
int lastButtonStateL = LOW;
int lastButtonStateR = LOW;
int lastButtonStateF = LOW;
int lastButtonStateB = LOW;      


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
  pinMode(datapin, OUTPUT);
  pinMode(clockpin, OUTPUT);  
  pinMode(latchpin, OUTPUT); 
  }


 void loop() {  
  int readingR = digitalRead(sensorR);
  int readingL = digitalRead(sensorL);
  int readingF = digitalRead(sensorF);
  int readingB = digitalRead(sensorB);

  //Right
  if (readingR != lastButtonStateR) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (readingR == HIGH) {
      shiftWrite(0, ledState);
    }else{
      ledState=!ledState;
      shiftWrite(0, ledState);
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

void shiftWrite(int desiredPin, boolean desiredState){
  bitWrite(data,desiredPin,desiredState);
  shiftOut(datapin, clockpin, MSBFIRST, data);
  digitalWrite(latchpin, HIGH);
  digitalWrite(latchpin, LOW);
}


