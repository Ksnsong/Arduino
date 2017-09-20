//Button
int switchPinStop = 7;
int switchPinGo = 8;

// The potentiometers are connected to A0, A1, A2
int sensorPinR = 0;    
int sensorPinG = 1;
int sensorPinB = 2;      
         
//LED RGB
int ledPinR = 9;      
int ledPinG = 10;
int ledPinB = 11;

//set RGB values
int red=0;
int green=0;
int blue=0;

//check RGB sensor values
int sensorValueR;
int sensorValueG;
int sensorValueB;

void setup(){
  //Butons
  pinMode(switchPinGo, INPUT);
  pinMode(switchPinStop, INPUT);

    pinMode(switchPinGo, OUTPUT);
  pinMode(switchPinStop, OUTPUT);
  //LED  
  pinMode(ledPinR, OUTPUT);
  pinMode(ledPinG, OUTPUT);
  pinMode(ledPinB, OUTPUT);

  pinMode(red, INPUT);
  pinMode(green, INPUT);
  pinMode(blue, INPUT);
  Serial.begin(9600);
}

void loop(){
  sensorValueR = analogRead(sensorPinR);
  sensorValueG = analogRead(sensorPinG); 
  sensorValueB = analogRead(sensorPinB);  
  red = map(sensorValueR, 0, 1023, 255, 0);
  green = map(sensorValueG, 0, 1023, 255, 10);
  blue = map(sensorValueB, 0, 1023, 255, 0);
  
  if (digitalRead(switchPinGo)== HIGH){
    digitalWrite(switchPinGo, HIGH);
    if (digitalRead(switchPinStop)== HIGH){
      digitalWrite(switchPinGo, LOW);
      green = map(sensorValueG, 0, 1023, 255, 10);
    }
    analogWrite(ledPinG, 255);
    analogWrite(ledPinR, 0);
    analogWrite(ledPinB, 0);
  }else{
    analogWrite(ledPinR, red);
    analogWrite(ledPinG, green);
    analogWrite(ledPinB, blue);
  }
}

