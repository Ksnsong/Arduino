int mousex, mousey;
float [] distance = new float [2];
float [] p_reading=new float [2];
float []reading = new float [2];
float []Axis = new float[2];
int temp_flag2, temp_flag3;
void mouseMove(int x, int y)
{

  mousex = mousex + x;
  mousey = mousey + y;
  if (mousex>=displayWidth) {
    mousex = displayWidth;
  }
  if (mousex<0) {
    mousex = 0;
  }
  if (mousey>= displayHeight) {
    mousey = displayHeight ;
  }
  if (mousey<0) {
    mousey = 0;
  }
  robby.mouseMove(mousex, mousey);
}


void  mouseClick()
{
  if (mouse_touch1== true && touch1[0] == true) //按键按下之后抬起手指触发右键功能
  {    
    robby.mousePress(InputEvent.BUTTON1_MASK);
    robby.mouseRelease(InputEvent.BUTTON1_MASK);
  }

 else if (touch2[0] == true) {//左键触发之后执行左键单击操作，此处鼠标光标也跟随实现拖拽功能
     println("button pressed !!!!"+ i);

    robby.mousePress(InputEvent.BUTTON1_MASK);
    i++;
    if (Delta_agr[0]>=6&&Delta_acc[0]>=1) {
      mouseMove(-(int)(gz[1]/sensitive), -(int)(gy[1]/sensitive));
    }
  }
  else if (touch2[0]  == false)//释放左键，释放状态下鼠标光标也可以移动
  {
    
    if (Delta_agr[0]>=6&&Delta_acc[0]>=1) {
      mouseMove(-(int)(gz[1]/sensitive), -(int)(gy[1]/sensitive));
    }
    robby.mouseRelease(InputEvent.BUTTON1_MASK);
  }
}