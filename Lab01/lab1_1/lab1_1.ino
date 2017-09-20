// The potentiometers are connected to A0, A1, A2
int sensorPinR = A0;    
int sensorPinG = A1;
int sensorPinB = A2;   

int sensorPin = 3;
         
//LED RGB
int ledPinR = 9;      
int ledPinG = 10;
int ledPinB = 11;

//set RGB values
int red;
int green;
int blue;

//check RGB sensor values
int sensorValueR;
int sensorValueG;
int sensorValueB;

void setup(){  
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
  red = map(sensorValueR, 0, 1023, 0, 255);
  green = map(sensorValueG, 0, 1023, 0, 255);
  blue = map(sensorValueB, 0, 1023, 0, 255);
  analogWrite(ledPinR, red);
  analogWrite(ledPinG, green);
  analogWrite(ledPinB, blue);

  int sensorValue=analogRead(sensorPin);
  int Value = map(sensorValue, 0, 1023, 0, 255);
  Serial.println(Value);
}

