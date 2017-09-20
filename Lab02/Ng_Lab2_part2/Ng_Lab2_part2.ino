//speaker
const int sensorPin = A0;  // analog pin of the sensor 
const int THRESHOLD = 15;

//shift register1, red and yellow
int datapin = 2;          
int clockpin = 3;
int latchpin = 4;

//yellow LEDs
int ledPin=13;

int alternative=0;
int val =0;

byte data = 0;
void setup(){
  pinMode(datapin, OUTPUT);
  pinMode(clockpin, OUTPUT);  
  pinMode(latchpin, OUTPUT);
  pinMode(ledPin, OUTPUT);
}


void loop(){
  val = analogRead(sensorPin);  
  if (val >= THRESHOLD && alternative==0){ 
        digitalWrite(ledPin, HIGH);
        delay(500); 
        digitalWrite(ledPin, LOW);
        greenLine() ;
        alternative=1;
        val=0;
  }  
  if (val >= THRESHOLD && alternative==1 ){ 
        digitalWrite(ledPin, HIGH);
        delay(500); 
        digitalWrite(ledPin, LOW);
        redLine() ;
        alternative=0;
        val=0;
   } 
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
 

