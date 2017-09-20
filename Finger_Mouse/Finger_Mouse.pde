import controlP5.*;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent;
import hypermedia.net.*;
import javax.swing.*;
ControlP5 cp5;

import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;

int myColorBackground = color(0, 0, 0);

ControlWindow controlWindow;

public int sliderValue = 40;

UDP udp;  // define the UDP object
int rx_buffer_size=100;
boolean   mouse_touch1 = false,  mouse_touch2 = false;
String messageReceive="2,0,0";
byte[] rx_byte=new byte[rx_buffer_size];
float []Title = new float[5];
int rx_byte_count=0;
int LocalPort = (int)random(200, 8080);
String LocalIp = " ";
int xx = 10, yy = 10;
Robot robby;
boolean gestureIsActive = true;
FloatList inventory;            //定义类，对象即数组名为inventory
FloatList peakx_n,peakx_p,peaky_n,peaky_p,peakz_n,peakz_p;       //定义X,Y,Z轴数据暂存数组（用于波峰数计算）
FloatList peakyaw_n,peakyaw_p,peakpit_n,peakpit_p,peakroll_n,peakroll_p;
int length_of_smooth = 120;     //存入数组中的有效数据长度（实际数据大于这个数值），共240个(平滑长度)
final String serialPort = "COM5"; // replace this with your serial port. On windows you will need something like "COM1".
float [] q = new float [11];      //用于 serialEvent(Serial myPort)子函数中，存九轴数据
int flag_rolling = 1;           //定义翻转动作触发初始值为1（画背景图部分），
int flag_tap = 1;               //敲击
int flag_huang = 1;             //晃动
int flag_shake = 1;             //甩动
int flag_cha = 1;              //画叉
int flag_gou = 1;               //打勾
int S = 2;
float []Delta_accN = new float [2];
float []Delta_agrN= new float [2];
float []Delta_acc= new float [2];
float []Delta_agr= new float [2], sumCarrier_a = new float [2], sumCarrier_g = new float [2], Eourl = new float[2];
float []ax= new float [2], ay= new float [2], az= new float [2], gx= new float [2], gy= new float [2], gz= new float [2];
float []yaw=new float[2], pit= new float [2],roll= new float [2];
boolean []touch1=new boolean[2],touch2=new boolean[2];
float factor, threshold_a = 2, threshold_g=5, carrier_a, carrier_g;
int begin_g, begin_a, end_g, end_a;
int [] size = new int[2];               //用于储存inventory链表的长度(数据个数)
int i=0, endpoint;
boolean active_flag = true, appended_flag = false;
float[] storeInventory;                  //备份数据到此数组
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;
int text = 0;
int test = 0;
int test01 = 0;
PFont myfont;
Table table;
float finalcursor_x = 0,finalcursor_y=0,sensitive= 10;
long t1,t2,auxdelay;


float[] gravity = new float[3];
float[] euler = new float[3];
float[] ypr = new float[3];

Serial port;
String portName = "COM5";
int interval = 0;
String [] inputStringArr;  // Input string from serial port
String inString;
void setup() 
{
  port = new Serial(this, portName, 115200);
  size(800, 600, P3D);          //3D modle 
  inventory = new FloatList();                  //定义类的对象,数组名
  peakx_n = new FloatList();                    //数组名
  peakx_p = new FloatList();
  peaky_n = new FloatList();
  peaky_p = new FloatList();
  peakz_n = new FloatList();
  peakz_p = new FloatList();
  peakyaw_n= new FloatList();
  peakyaw_p= new FloatList();
  peakpit_n= new FloatList();
  peakpit_p= new FloatList();
  peakroll_n= new FloatList();
  peakroll_p = new FloatList();
  myfont = loadFont("MicrosoftYaHei-48.vlw");    //定义字体，下载字体
  textFont(myfont);
  udp = new UDP( this, (int)random(2000,8000) );
  udp.listen( true );
  table = new Table();
  try
  {
    robby = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
  cp5 = new ControlP5(this);
  cp5.addSlider("sliderValue")
     .setRange(0, 255)
     .setPosition(540, 40)
     .setSize(200, 29)
     //.moveTo(controlWindow)
     ;
  port.bufferUntil(10);   
}
void draw() {
  sensitive = map(sliderValue,0,255,4,10);//sliderValue/25F;
  //println(sensitive);
  mouseClick();
  background(230);
  drawbox();
  //drawbox2();
  //println(begin_a+"  "+begin_g);
  try{
  if (cutout_successed()) {
    
  }
  }
  catch (Exception e)
  {
    print("found error");
  }

  mouse_touch1 = touch1[0];
  mouse_touch2 = touch2[0];
}
boolean cutout_successed()
{
  boolean active = false;
  size[1] = inventory.size();             //长度赋值
  if (Delta_agr[0]>=30&&Delta_acc[0]>=8 )
  {
    inventory.append(ax[1]); //ax       //将读出的数据存入inventory链表
    inventory.append(ay[1]); //ay
    inventory.append(az[1]); //az
    inventory.append(gx[1]); //gx
    inventory.append(gy[1]); //gy
    inventory.append(gz[1]); //gz
    inventory.append(yaw[1]); //yaw
    inventory.append(pit[1]); //pit
    inventory.append(roll[1]); //roll
    inventory.append(q[9]); //左键触摸
    inventory.append(q[10]); //右键触摸
    //s=inventory.size();
    size[0] = inventory.size();          //长度赋值
    appended_flag = true;
  }

  else {
    active=false;
  }

  if (size[0]==size[1]&&appended_flag) //结束所有动作归为静止状态
  {
      appended_flag = false;
      //println(size[0]);
      if (size[0]<=length_of_smooth)
      {
        inventory.clear();//清空listfloat列表，以便新的数据进入
       // print("pre Cleared!!!");
      }
      if (size[0]>=length_of_smooth) //超过平滑长度范围的限制的数据才为有效数据
      {
       storeInventory = inventory.array(); //备份数据到storeInvebtory数组
        if (inventory.get(length_of_smooth-1) ==storeInventory[length_of_smooth-1])//校验数组是否存储成功
       {

         /******************在被清除之前做好运算工作-----手势分类开始**********************/         
          int maxvalue = Acc_zpeaks_calculate();
          if(gesture_classifiy() == 'N'){}
         /******************下一步便是清除工作-----手势分类至此结束**********************/
        }
        inventory.clear();//清空listfloat列表，以便新的数据进入
        active = true;
      }
   }
   return active;
}
void myTextfield(String theValue) {
  println(theValue);
}

void myWindowTextfield(String theValue) {
  println("from controlWindow: "+theValue);
}

void serialEvent(Serial port) {
  try {
     interval = millis();
    while (port.available() > 0) {
          inString = port.readString();
          inputStringArr = split(inString, ",");
                
           //  Float.parseFloat（）函数的意思是把字符串（String）转成Float型
           //被转换完成的数据依次存储在q[ ]的数组里面
           //  Float.parseFloat（）函数的意思是把字符串（String）转成Float型
           //被转换完成的数据依次存储在q[ ]的数组里面
              q[0] = Float.parseFloat(inputStringArr[0])*180/PI;
              q[1] = Float.parseFloat(inputStringArr[1])*180/PI;
              q[2] = Float.parseFloat(inputStringArr[2])*180/PI;
              q[3] = Float.parseFloat(inputStringArr[3])*180/PI;
              q[4] = Float.parseFloat(inputStringArr[4])*180/PI;
              q[5] = Float.parseFloat(inputStringArr[5])*180/PI;
              q[6] = Float.parseFloat(inputStringArr[6]);
              q[7] = Float.parseFloat(inputStringArr[7]);
              q[8] = Float.parseFloat(inputStringArr[8]);
              q[9] = Float.parseFloat(inputStringArr[9]);
              q[10] = Float.parseFloat(inputStringArr[10]);
              
              
              //把当前ax ay az gx gy gz 存储在 ax 【】.....中
              ax[0] = q[0];
              ay[0] = q[1];
              az[0] = q[2];
              gx[0] = q[3];
              gy[0] = q[4];
              gz[0] = q[5];
              yaw[0]= q[6];
              pit[0]=  q[7];
              roll[0]= q[8];
              //q[10] = 0;
              if(q[9] == 1){touch1[0] = true;}
              if(q[9] == 0){touch1[0] = false;}
              if(q[10] == 1){touch2[0] = true;System.currentTimeMillis();}
              if(q[10] == 0){touch2[0] = false;t2 = System.currentTimeMillis();}
    //          auxdelay = t1-t2;
    //          if(auxdelay<=0){auxdelay = 0;}
              //if(){}
    //          touch1[0]=q[9];
    //          touch2[0]=q[10];
            
              //当前值减去上一次的数值
              Delta_acc[0] = abs(ax[0]-ax[1]) + abs(ay[0]-ay[1]) + abs(az[0]-az[1]);
              Delta_agr[0] = abs(gx[0]-gx[1]) + abs(gy[0]-gy[1]) + abs(gz[0]-gz[1]);  
              
              //把上一次ax ay az gx gy gz 的数值赋值给ax【1】 ay【1】.......
              ax[1] = ax[0];
              ay[1] = ay[0];
              az[1] = az[0];
              gx[1] = gx[0];
              gy[1] = gy[0];
              gz[1] = gz[0];
              //*******************************角速度数据是否可以作为鼠标参数，此处做出尝试******************
    //          println(gx[1]+" "+gy[1]+" "+gz[1]);
              
              yaw[1]= yaw[0];
              pit[1]= pit[0];
              roll[1]= roll[0];
              touch1[1]=touch1[0];
              touch2[1]=touch2[0];
// 
        
      }
  }
  catch(RuntimeException e) {
    print("serial port error");
  }
   
}    