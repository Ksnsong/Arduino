int gesture_leng = 0; //手势长度
int tmp_gesture_leng = 0;  //手势长度临时变量
int X_energy = 0;  //手势X轴角速度,加速度能量
int Y_energy = 0;  //手势Y轴角速度,加速度能量
int Z_energy = 0;  //手势Z轴角速度,加速度能量
int gyro_x_energy = 0;  //手势X轴角速度能量
int gyro_y_energy = 0;  //手势Y轴角速度能量
int gyro_z_energy = 0;  //手势Z轴角速度能量
int delta_temp_ypr=0;
/**********************************************************************
 ** 函数名称: gesture_energy_calculate
 ** 功能描述: 计算手势中角速度及加速度信号的能量，对于两次以上敲击而言只计算第一次敲击的能量
 ** 输入参数：无
 ** 输出参数：手势角速度及加速度能量
 ** 杨赫修改
 ***********************************************************************/
int gesture_energy_calculate(  )
{
  int X_tmp_energy = 0;
  int Y_tmp_energy = 0;
  int Z_tmp_energy = 0;
  int counter = 0;

  //GestNodePtr ScanPtr = gest_head;  //定mouseX义手势数据结点指针并使其指向表头

  /*计算手势能量，如果两次以上的敲击则只计算第一次敲击的能量，
   该功能通过counter <= gesture_leng实现，因为gesture_leng
   实际上是记录手势单次峰的长度，对于rotation、shake、flip三类
   手势，单次峰便是其手势长度，而对于敲击则是其第一个峰的长度*/
  //String  lik =  ;
  while ( Float.toString (inventory.get (1)) != null && counter <= inventory.size())
  {
    /*分别计算三轴能量，除以100是为了防止原始数据太大而溢出*/
    X_tmp_energy += (abs(inventory.get(counter+3))+abs(inventory.get(counter+0)))/100;//gx+ax
    Y_tmp_energy += (abs(inventory.get(counter+4))+abs(inventory.get(counter+1)))/100;
    Z_tmp_energy += (abs(inventory.get(counter+5))+abs(inventory.get(counter+2)))/100;
    //ScanPtr = ScanPtr->next;
    // println(inventory.get(counter+3)+"    "+inventory.size());

    counter = counter + 11;
  }
  X_energy = X_tmp_energy;
  Y_energy = Y_tmp_energy;
  Z_energy = Z_tmp_energy;
  // println(X_energy + Y_energy + Z_energy);

  return (X_energy + Y_energy + Z_energy);
}

/**********************************************************************
 ** 函数名称: X,Y,Z peaks_calculate
 ** 功能描述: 计算手势X,Y,Z 轴加速度信号的波峰数
 ** 输入参数：无
 ** 输出参数：X,Y,Z 轴加速度波峰数
 ** 杨赫修改
 ***********************************************************************/
int Acc_xpeaks_calculate()
{
  int Peakx = 50;   //阈值
  int counter = 0;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int Acc_xpeaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (1)) != null && counter <= inventory.size()+1)
  {

    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0)//|| current <= 0 && latter >= 0)
    {

      peakx_p.clear();
      peakx_n.append(inventory.get(counter));
      if (Float.toString(peakx_n.get(0)) != null)
      {
          if (abs(peakx_n.max()) >Peakx)
          Acc_xpeaks_num++;
      }
    }
    else if (current - next <= 0)
   {
      peakx_n.clear();
      peakx_p.append(inventory.get(counter));
      if (Float.toString(peakx_p.get(0)) != null)
      {
          if (abs(peakx_p.max()) >Peakx)
          Acc_xpeaks_num++;
      }
    }
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return Acc_xpeaks_num;
}

int Acc_ypeaks_calculate()
{
  int Peaky = 50;   //阈值
  int counter = 1;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int Acc_ypeaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (1)) != null && counter <= inventory.size()+1)
  {
    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0 )//|| current <= 0 && latter >= 0)
    {
      peaky_p.clear();
      peaky_n.append(inventory.get(counter));
      if (Float.toString(peaky_n.get(0)) != null)
      {
        if (abs(peaky_n.max()) >Peaky)
        Acc_ypeaks_num++;
      }
    } 
    else if (current - next <= 0)
    {

      peaky_n.clear();
      peaky_p.append(inventory.get(counter));
      if (Float.toString(peaky_p.get(0)) != null)
      {
        if (abs(peaky_p.max()) >Peaky)
        Acc_ypeaks_num++;
      }
    }
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return Acc_ypeaks_num;
}

int Acc_zpeaks_calculate()
{
  int Peakz = 50;   //阈值
  int counter = 2;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int Acc_zpeaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (1)) != null && counter <= inventory.size()+1)
  {

    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0 )//|| current <= 0 && latter >= 0)
    {

      peakz_p.clear();
      peakz_n.append(inventory.get(counter));
      if (Float.toString(peaky_n.get(0)) != null)
      {
        if (abs(peakz_n.max()) >Peakz)
        Acc_zpeaks_num++;
      }
    }
    else if (current - next <= 0)
    {
      peakz_n.clear();
      peakz_p.append(inventory.get(counter));
      if (Float.toString(peakz_p.get(0)) != null)
      {
        if (abs(peakz_p.max()) >Peakz)
        Acc_zpeaks_num++;
      }
    }
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return Acc_zpeaks_num;
}
/**********************************************************************
 ** 函数名称: Acc_peaks_calculate
 ** 功能描述: 计算手势加速度信号的三轴波峰数之和
 ** 输入参数：无
 ** 输出参数：手势波峰数
 ** 杨赫修改
 ***********************************************************************/
int Acc_peaks_calculate()
{
  /*分别计算三轴波峰数*/
  int peaks_x = Acc_xpeaks_calculate() ;
  int peaks_y = Acc_ypeaks_calculate() ;
  int peaks_z = Acc_zpeaks_calculate() ;

  /*返回三轴中波峰数最大者*/
  /*if(peaks_x >= peaks_y && peaks_x >= peaks_z) return peaks_x ;
   if(peaks_y >= peaks_x && peaks_y >= peaks_z) return peaks_y ;
   if(peaks_z >= peaks_x && peaks_z >= peaks_y) return peaks_z ;*/
  return peaks_x + peaks_y + peaks_x ;
}


/**********************************************************************
 ** 函数名称: gyro_maxpoint_length_calculate
 ** 功能描述: 计算手势X轴角速度信号达到最大值的数据
 ** 输入参数：无
 ** 输出参数：三轴中最大角速度所在轴数据
 ** 杨赫修改
 ***********************************************************************/
int gyro_maxpoint_length_calculate()
{
  int gyro_x_temp_energy = 0;
  int gyro_y_temp_energy = 0;
  int gyro_z_temp_energy = 0;
  int gyro_max_energy = 0;
  int counter=0;
  while (Float.toString (inventory.get (1)) != null && counter <= inventory.size()+1)
  {
    gyro_x_temp_energy += abs(inventory.get(counter+3));
    gyro_y_temp_energy += abs(inventory.get(counter+4));
    gyro_z_temp_energy += abs(inventory.get(counter+5));
    counter=counter+11;  
  }
  
    gyro_x_energy = gyro_x_temp_energy;
    gyro_y_energy = gyro_y_temp_energy;
    gyro_z_energy = gyro_z_temp_energy;
    
    gyro_max_energy = max(gyro_x_energy, gyro_y_energy, gyro_z_energy);
    
//  if (gyro_max_energy==gyro_x_energy)
//  {
//    println("ROLL");
//  }
// if (gyro_max_energy==gyro_y_energy)
//  {
//    println("Y");
//  }
//   if (gyro_max_energy==gyro_z_energy)
//  {
//    println("Z");
//  }
    return gyro_max_energy;
}

/**********************************************************************
 ** 函数名称: yaw,pitch,roll_peaks_calculate
 ** 功能描述: 计算手势yaw,pitch,roll三轴加速度信号的波峰数
 ** 输入参数：无
 ** 输出参数：yaw,pitch,roll三轴加速度波峰数
 ** 杨赫添加
 ***********************************************************************/
int yaw_peaks_calculate()
{
  int Peakx = 50;   //阈值
  int counter = 6;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int yaw_peaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (6)) != null && counter <= inventory.size()+1)
  {
    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0)//|| current <= 0 && latter >= 0)
    {
      peakyaw_p.clear();
      //println(inventory.get(counter));
      peakyaw_n.append(inventory.get(counter));
      //println("Setp narmal!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      if (Float.toString(peakyaw_n.get(1)) != null)
      {
          if (abs(peakyaw_n.max()) >Peakx)
          yaw_peaks_num++;
      }
    }
    else if (current - next <= 0)
   {
      peakyaw_n.clear();
      peakyaw_p.append(inventory.get(counter));
      if (Float.toString(peakyaw_p.get(1)) != null)
      {
          if (abs(peakyaw_p.max()) >Peakx)
          yaw_peaks_num++;
      }
  }
   // println(peakyaw_n.get(counter));
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return yaw_peaks_num;
}
int pit_peaks_calculate()
{
  int Peaky = 20;   //阈值
  int counter = 7;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int pit_peaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (6)) != null && counter <= inventory.size()+1)
  {
    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0)//|| current <= 0 && latter >= 0)
    {
       peakpit_p.clear();
       //println(inventory.get(counter));
       peakpit_n.append(inventory.get(counter));
       //println("Setp narmal!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
       if (Float.toString(peakpit_n.get(1)) != null)
       {
          if (abs(peakpit_n.max()) >Peaky)
          pit_peaks_num++;
       }
    }
    else if (current - next <= 0)
   {
      peakpit_n.clear();
      peakpit_p.append(inventory.get(counter));
      if (Float.toString(peakpit_p.get(1)) != null)
      {
          if (abs(peakpit_p.max()) >Peaky)
          pit_peaks_num++;
      }
  }
   // println(peakyaw_n.get(counter));
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return pit_peaks_num;
}
int roll_peaks_calculate()
{
  int Peakz = 20;   //阈值
  int counter = 8;  //数据链表的数据位置
  float  current;       //当前点加速度值
  float  next;        //下一点加速度值
  int roll_peaks_num = 0;  //正的波峰数
  while ( Float.toString (inventory.get (6)) != null && counter <= inventory.size()+1)
  {
    current = inventory.get(counter+0);
    next  = inventory.get(counter+11);
    if (current - next >= 0)//|| current <= 0 && latter >= 0)
    {
       peakroll_p.clear();
       //println(inventory.get(counter));
       peakroll_n.append(inventory.get(counter));
       //println("Setp narmal!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
       if (Float.toString(peakroll_n.get(1)) != null)
       {
          if (abs(peakroll_n.max()) >Peakz)
          roll_peaks_num++;
       }
    }
    else if (current - next <= 0)
   {
      peakroll_n.clear();
      peakroll_p.append(inventory.get(counter));
      if (Float.toString(peakroll_p.get(1)) != null)
      {
          if (abs(peakroll_p.max()) >Peakz)
          roll_peaks_num++;
      }
  }
   // println(peakyaw_n.get(counter));
    counter = counter + 11;
  }
  /*返回正波峰数和负波峰数中较大的一个*/
  return roll_peaks_num;
}
/**********************************************************************
 ** 函数名称: ypr_peaks_calculate
 ** 功能描述: 计算三轴手势姿态角的波峰数之和
 ** 输入参数：无
 ** 输出参数：手势波峰数
 ** 杨赫添加
 ***********************************************************************/
 int ypr_peaks_calculate()
{
  /*分别计算三轴波峰数*/
 // int peaks_yaw = yaw_peaks_calculate() ;
  int peaks_pit = pit_peaks_calculate() ;
  int peaks_roll = roll_peaks_calculate() ;

  /*返回三轴波峰数总和*/
  
  return  peaks_pit + peaks_roll ;
}
 
/**********************************************************************
 ** 函数名称: gyro_singleside_calculate
 ** 功能描述: 判断手势三轴中是否有一轴角速度信号具有单边性
 ** 输入参数：无
 ** 输出参数：单边性代表数据
 ** 杨赫添加
 ***********************************************************************/ 
 int gyro_singleside_calculate()
 {
     int counter = 3;   int i = 0;
     float  Cx,Nx,Cy,Ny,Cz,Nz;       //当前点X轴角速度值
     while ( Float.toString (inventory.get (6)) != null && counter <= inventory.size()+1)
     {
          Cx = inventory.get(counter+0);
          Nx = inventory.get(counter+11);
          Cy = inventory.get(counter+1);
          Ny = inventory.get(counter+12);
          Cz = inventory.get(counter+2);
          Nz = inventory.get(counter+13);
         if (Cx*Nx>=0 && Cy*Ny<0 && Cz*Nz<0 || Cx*Nx<0 && Cy*Ny>=0 && Cz*Nz<0 || Cx*Nx<0 && Cy*Ny<0 && Cz*Nz>=0)
         {
             i = 1;
         }
         else 
         {
             i = 0;
         }
         counter = counter + 11;
     }
     return i ;
 }
 
/**********************************************************************
 ** 函数名称: gesture_classifiy
 ** 功能描述: 总分类函数
 ** 输入参数：无
 ** 输出参数：各类手势
 ** 杨赫修改
 ***********************************************************************/
char gesture_classifiy()
{ 
  char gesture_result = 'N';
  // char NO gesture;
  /*计算手势分类所需特征*/
  int sum_energy = gesture_energy_calculate();
  int gyro_max_energy=gyro_maxpoint_length_calculate();
  int acc_three_bofeng = Acc_peaks_calculate();
  int delta_ypr = ypr_peaks_calculate();
  int i = gyro_singleside_calculate();
  //此处可添加根据手势特征去除误操作的代码，在手势分类前先去掉部分误操作
  //去除误操作的思想是先分析各类手势的特征量规律，如果该次特征不满足任何
  //手势特征规律，则去除

  /*分类器第一层：根据手势长度和手势能量区分敲击类*/
  if (inventory.size() < 280 && sum_energy < 100)
  {
      gesture_result = 'T';
      flag_tap = 10;
      flag_rolling = 1;
      flag_huang=1;
      flag_shake=1;
      flag_cha = 1;
      flag_gou = 1;
  } 
 else 
 {
    if (gyro_maxpoint_length_calculate()==gyro_x_energy)
    {
       gesture_result = 'R';
       flag_rolling = 10;
       flag_tap = 1;
       flag_huang=1;
       flag_shake=1;
       flag_cha = 1;
       flag_gou = 1;
    }  
    else 
    {
        if(3*inventory.size()+8*sum_energy+38*acc_three_bofeng-6874 > 0)
        {
           if(delta_ypr>80 && sum_energy>750 && acc_three_bofeng>120)
           {
              gesture_result = 'C';
              flag_cha = 10;
              flag_tap = 1;
              flag_rolling = 1;
              flag_huang=1;
              flag_shake=1;
              flag_gou = 1;
           }
          else //if(delta_ypr<=40)
          {
             gesture_result = 'H';
             flag_huang=10;
             flag_tap = 1;
             flag_rolling = 1;
             flag_shake=1;
             flag_cha = 1;
             flag_gou = 1;
          }
        }
        else //if(4*inventory.size()+3*sum_energy+55*acc_three_bofeng-5855 < 0)
        {
           if (i ==1)
           {
               gesture_result = 'S';
               flag_shake=10;
               flag_tap = 1;
               flag_rolling = 1;
               flag_huang=1;
               flag_cha = 1;
               flag_gou = 1;
           }
           else 
           {
               gesture_result = 'G';
               flag_gou = 10; 
               flag_tap = 1;
               flag_rolling = 1;
               flag_huang=1;
               flag_shake=1;
               flag_cha = 1;  
           }
        }
    }
    
 }
  
  return gesture_result;
}