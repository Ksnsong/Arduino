void drawbox()
{
  pushMatrix();                        //绘制3D图形
  translate(VIEW_SIZE_X/2+50, VIEW_SIZE_Y/2+50, 0);              //控制3D图形位置，处于中央
  scale(5,5,5);                       //将图形扩大500%
 
try{
  rotateY(-q[6]/57.29);               //控制3D模块跟随三轴角度变化而变化
  rotateX(-q[7]/57.29);               //try，catch函数用于可能出现的错误处理
  rotateZ(q[8]/57.29);               

  }
  catch (Exception e) {             //如果代码异常，则catch运行
    e.printStackTrace();
  println("发现错误");                 //打印发现错误
  }

  noFill();
  //box(180);
  noStroke();
  beginShape(QUADS);

  //Z+ (to the drawing area)
  fill(#00ff00);
  vertex(-30, -5, 20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  //Z-
  fill(#0000ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, 5, -20);
  vertex(-30, 5, -20);
  
  //X-
  fill(#ff0000);
  vertex(-30, -5, -20);
  vertex(-30, -5, 20);
  vertex(-30, 5, 20);
  vertex(-30, 5, -20);
  
  //X+
  fill(#ffff00);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(30, 5, -20);
  
  //Y-
  fill(#ff00ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(-30, -5, 20);
  
  //Y+
  fill(#00ffff);
// fill(factor*10,20,100);
  vertex(-30, 5, -20);
  vertex(30, 5, -20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  endShape();                       //绘图结束
  popMatrix();                      //3D绘制结束
  /***以下显示为为校准显示！可以根据实际情况加以校准，此处修改数据不会影响到计算结果（在text()函数内修改）***/
  final float offset = 0;    //???????????
  fill(0);
  textSize(25);
  text("ACC:",16,40);
  text("Ax:"+(q[0]-offset),16,70);     //???????????
  text("Ay:"+(q[1]-offset),16,100);
  text("Az:"+(q[2]-offset),16,130);
  text("GYRO:",16,180);
  text("Gx:"+q[3],16,210);
  text("Gy:"+q[4],16,240);
  text("Gz:"+q[5],16,270);
  text("EULER:",16,320);
  text("Yall:"+q[6],16,350);
  text("Pitch:"+q[7],16,380);
  text("Roll:"+q[8],16,410);
  
}