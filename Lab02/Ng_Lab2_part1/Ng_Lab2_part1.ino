//speaker
const int sensorPin = A0;  // analog pin of the sensor 
const int THRESHOLD = 15;

//shift register
int datapin = 2;          
int clockpin = 3;
int latchpin = 4;

int alternative=0;

byte data = 0;
void setup(){
  pinMode(datapin, OUTPUT);
  pinMode(clockpin, OUTPUT);  
  pinMode(latchpin, OUTPUT);
}


void loop(){
shiftWrite(0, HIGH);
}

void shiftWrite(int desiredPin, boolean desiredState){
  bitWrite(data,desiredPin,desiredState);
  shiftOut(datapin, clockpin, MSBFIRST, data);
  digitalWrite(latchpin, HIGH);
  digitalWrite(latchpin, LOW);
}
 
/*
greenLine()
*/
void greenLine()
{
  int index;
  int delayTime = 500;
  for(index = 4; index <= 7; index++){
    shiftWrite(index, HIGH);
    delay(delayTime);
    shiftWrite(index, LOW);
  }
}

/*
redLine()
*/
void redLine()
{
  int index;
  int delayTime = 500;
  for(index = 3; index >= 0; index--){
    shiftWrite(index, HIGH);
    delay(delayTime);
    shiftWrite(index, LOW);
  }
}
 

