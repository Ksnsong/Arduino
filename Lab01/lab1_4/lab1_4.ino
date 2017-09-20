//Button
int switchPin = 8;

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
  //Buton
  pinMode(switchPin, INPUT);
  
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

  if (digitalRead(switchPin)== HIGH){
    analogWrite(ledPinG, 255);
    analogWrite(ledPinR, 0);
    analogWrite(ledPinB, 0);
  }else{
    analogWrite(ledPinR, red);
    analogWrite(ledPinG, green);
    analogWrite(ledPinB, blue);
  }
}

