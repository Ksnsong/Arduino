//speaker
const int sensorPin = A0;  // analog pin of the sensor 
const int THRESHOLD = 15;

//shift register1, yellow and red
int datapin = 2;          
int clockpin = 3;
int latchpin = 4;

//shift register2, green and blue
int datapin1 = 5;          
int clockpin1 = 6;
int latchpin1 = 7;

int alternative=0;

byte data = 0;
byte data1 = 0;
void setup(){
  pinMode(datapin, OUTPUT);
  pinMode(clockpin, OUTPUT);  
  pinMode(latchpin, OUTPUT);

  pinMode(datapin1, OUTPUT);
  pinMode(clockpin1, OUTPUT);  
  pinMode(latchpin1, OUTPUT);
}


void loop(){
  int val = analogRead(sensorPin);
  if (val >= THRESHOLD && alternative==0 ){   
        yellowLine() ;
        alternative=random(4);
        val=0; 
  }  
  if (val >= THRESHOLD && alternative==1){  
        redLine() ;
        alternative=random(4);
        val=0;
   }  
  if (val >= THRESHOLD && alternative==2){  
        greenLine() ;
        alternative=random(4);
        val=0;
   }  
  if (val >= THRESHOLD && alternative==3){  
        blueLine() ;
        alternative=random(4);
        val=0;
   }   
}

//R&Y
void shiftWrite(int desiredPin, boolean desiredState){
  bitWrite(data,desiredPin,desiredState);
  shiftOut(datapin, clockpin, MSBFIRST, data);
  digitalWrite(latchpin, HIGH);
  digitalWrite(latchpin, LOW);
}

//G & B
void shiftWrite1(int desiredPin1, boolean desiredState1){
  bitWrite(data1,desiredPin1,desiredState1);
  shiftOut(datapin1, clockpin1, MSBFIRST, data1);
  digitalWrite(latchpin1, HIGH);
  digitalWrite(latchpin1, LOW);
}
 
/*
yellowLine()
*/
void yellowLine()
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
 
/*
greenLine()
*/
void greenLine()
{
  int index;
  int delayTime = 500;
  for(index = 4; index <= 7; index++){
    shiftWrite1(index, HIGH);
    delay(delayTime);
    shiftWrite1(index, LOW);
  }
}

/*
blueLine()
*/
void blueLine()
{
  int index;
  int delayTime = 500;
  for(index = 3; index >= 0; index--){
    shiftWrite1(index, HIGH);
    delay(delayTime);
    shiftWrite1(index, LOW);
  }
}
