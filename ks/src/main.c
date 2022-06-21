#include"reg51.h"
#include<stdio.h>
#include<math.h>
#include<ABSACC.H>
#define uint unsigned int
#define uchar unsigned char
uchar a;
sfr biaozhi = 0x60; //显示内容标志位,00H-时间，08H-日期，10H-电压
sfr sptime = 0x61; //闪烁间隔时间
sfr settings = 0x62;//亮灭状态控制标志位
sfr splo = 0x63;//闪烁位置标志位
sfr inen = 0x64;//进入，推出设置标志位
sfr second = 0x30;
sfr minute = 0x31;
sfr hour = 0x32;
sfr week = 0x33;
sfr day = 0x34;
sfr month = 0x35;
sfr year1 = 0x36;
sfr year2 = 0x37;
sfr R0 = 0x40;
sfr R1 = 0x50;
sfr R3 = 0x30;
sfr R4 = 0x60;
sfr R6 = 0x70;
sfr R7 = 0x80;
a = ACC;
void dsinit() //初始化ds12887
{
    XBYTE[0x7F0B] = 0x82;
    XBYTE[0x7F00] = 0x00;
    XBYTE[0x7F02] = 0x15;
    XBYTE[0x7F04] = 0x15;
    XBYTE[0x7F06] = 0x03;
    XBYTE[0x7F07] = 0x17;
    XBYTE[0x7F08] = 0x06;
    XBYTE[0x7F09] = 0x22;
    XBYTE[0x7F0E] = 0x20;
    XBYTE[0x7F0A] = 0x20;
    ACC = XBYTE[0x7F0C];
    ACC = XBYTE[0x070D];
    XBYTE[0x7f0b] = 0x12;

}

void delayxms(int t) //延时xms
{
    for (int i = 0; i < t; i++)
    {
        for (int j = 0; j < 110; j++);
        
    }
}
void key1();
void key2();
void key3();
void key4();
void newtime();
void judge();
void key()
{
    delayxms(10); //消抖
    if (P1 ^ 0 == 0 || P1 ^ 1 == 0 || P1 ^ 2 == 0 || P1 ^ 3 == 0)
    {
        while (1) //循环，等到按钮弹起时执行接下来的程序，并退出循环
        {
            if (P1 ^ 0 == 1 || P1 ^ 1 == 1 || P1 ^ 2 == 1 || P1 ^ 3 == 1)
            {
                delayxms(10);
                if (P1^0==1)
                {
                    key1();
                }
                else if (P0 ^ 1 == 1)
                {
                    key2();
                }
                else if (P0^2==1)
                {
                    key3();
                }
                else if (P0 ^ 3 == 1)
                {
                    key4();
                }
                break;
            }
        }
    }
}
void key1()
{
    if (biaozhi!=0x10)
    {
        if (inen == 0x00)
        {
            inen = 0x1;
            EX0 = 0;
            splo = 0b00111111;
        }
        else if(inen==0x01)
        {
            inen = 0x0;
            newtime();
            EX0 = 0;
            splo = 0b11111111;
        }
        
    }
}
void key2()
{
    if (inen==0x1)
    {
        if (splo==0b00111111)
        {
            splo = 0b11001111;
        }
        else if (splo==0b11001111)
        {
            splo = 0b11110011;
        }
        else if (splo==0b11110011)
        {
            splo = 0b11111100;
        }
        else if (splo==0x11111100)
        {
            splo = 0x00111111;
        }
    }
}
void key3()
{
    if (inen==0x1)
    {
        judge();
    }
}
void key4()
{
    if (biaozhi == 0)
    {
        biaozhi = 0x8;
    }
    else if (biaozhi==0x8)
    {
        biaozhi = 0x10;
        splo = 0xff;
    }
    else if (biaozhi==0x10)
    {
        biaozhi == 0x0;
    }
}
void judge()
{
    if (biaozhi==0x0)
    {
        if (splo == 0b00111111)
        {
            second();
        }
        else if(splo==0b11001111)
        {
            minute();
        }
        else if (splo == 0b11110011)
        {
            hour();
        }
        else
        {
            week();
        }
    }
    else if(biaozhi==0x08)
    {
        if (splo == 0b00111111)
        {
            day();
        }
        else if (splo == 0b11001111)
        {
            month();
        }
        else
        {
            year();
        }
    }
}
void second();
void minute();
void hour()
void week();
void day();
void month();
void year();
void second()
{
    second++;
    if (second >59) second = 0;
}
void minute()
{
    minute++;
    if (minute >59) minute = 0;
}
void hour()
{
    hour++;
    if (hour >23) hour = 0;
}
void week()
{
    week++;
    if (weeek >7) weeek = 0;
}
void day()
{
    day++;
    switch (month)
    {
        case 1 || 3 || 5 || 7 || 8 || 10 || 12: if (day >31) day = 0;
        case 2:if (day > 29) day = 0;
        case 4 || 6 || 9 || 11:if (day > 30) day = 0;
    }
}
void month()
{
    month++;
    if (month > 7) month = 0;
}
void year()
{
    year++;
}
void newtime()
{
    XBYTE[0x7F0B] = 0x82;
    XBYTE[0x7F00] = second;
    XBYTE[0x7F02] = minute;
    XBYTE[0x7F04] = hour;
    XBYTE[0x7F06] = week;
    XBYTE[0x7F07] = day;
    XBYTE[0x7F08] = month;
    XBYTE[0x7F09] = year1;
    XBYTE[0x7F0E] = year2;
    XBYTE[0x7F0A] = 0x20;
    ACC = XBYTE[0x7F0C];
    ACC = XBYTE[0x7F0D];
    XBYTE[0x7F0B] = 0x12;
}

void DS12887()
{
    EX0 = 0;
    EA = 0;
    PSW ^ 3 = 0;
    PSW ^ 4 = 1;
    second = XBYTE[0x7F00];
    minute = XBYTE[0x7F02];
    hour = XBYTE[0x7F04];
    week = XBYTE[0x7F06];
    day = XBYTE[0x7F07];
    month = XBYTE[0x7F08];
    year1 = XBYTE[0x7F09];
    year2 = XBYTE[0x7F0E];
    EA = 1;
    EX0 = 1;
}
void on();
void off();
void BUFFER() //缓冲区数据处理
{
    R0 = 0x40;
    R1 = 0x30;
    R7 = 0x08;
    while (R7>0)
    {
        *R0 = *R1 & 0b00001111;  //完全不知道怎么写
        R0++;
        *R0 = *R1 & 0b111100000;
        *R0 = *R0 / 0x10;
        R0++;
        R1++;
        R7--;
    }
}
void shine();
void DISPLAY()
{
    PSW^4 = 0;
    PSW^3 = 1;
    EA = 0;
    TR0 = 0;
    TL0 = 0x17;
    TH0 = 0xFC;
    BUFFER();
    R0 = 0x40;
    R0 = R0+0x60;
    R7 = 0x80;
    sptime++;
    if (sptime != 0x20) shine();
    setting = setting ^ 0xFF;
    sptime = 0x00;
}
void shine()
{
    if (setting == 0x00) off();
    else on();
}
void on()
{
    uchar array duanma = { 0x5f,0x06,0x3b,0x2f,0x66,0x6d,0x7d,0x7f,0x6f,0x20,0x00,0x0d,0x86 };
    while (R7 >= 1)
    {
        XBYTE[0x0dfff] = R7;
        XBYTE[0x0bfff] = duanma[R0];
        delayxms(1);
        R7 = R7 / 2;
        R0++;
    }
    TR0 = 1;
    EA = 1;
}
void off()
{
    uchar array duanma = { 0x5f,0x06,0x3b,0x2f,0x66,0x6d,0x7d,0x7f,0x6f,0x20,0x00,0x0d,0x86 };
    while (R7 >= 1)
    {
        a = splo & R7;
        XBYTE[0x0dfff] = R7;
        XBYTE[0x0bfff] = duanma[R0];
        delayxms(1);
        R7 = R7 / 2;
        R0++;
    }
    TR0 = 1;
    EA = 1;
}
void change();//没理解，写不出来
void vdisplay();
void voltage()
{
    TR1 = 0;
    EA = 0;
    PSW ^ 3 = 1;
    PSW ^ 4 = 1;
    R7 = TL1 - 0x10;
    R6 = TH1 - 0x27;
    TH1 = 0;
    TL1 = 0;
    change();
    vdisplay();
    EA = 1;
    TR1 = 1;

}
void vdisplay() //大概是电压值的处理
{
    sfr h55 = 0x55;
    sfr h57 = 0x57;
    sfr h56 = 0x56;
    PSW ^ 3 = 1;
    PSW ^ 4 = 1;
    h55 = 0x0b;
    if (P1^1==1)
    {
        h57 = 0x0b;
        h56 = 0x0b;
        sfr R1 = 0x50;
        R1 = R5 & 0b00001111;
        sfr R1 = 0x51;
        R1 = (R5 & 0b11110000)/0x10;
        sfr R1 = 0x51;
        R1 = (R5 & 0b11110000) / 0x10;
        sfr R1 = 0x52;
        R1 = R4 & 0b00001111;
        sfr R1 = 0x53;
        R1 = (R4 & 0b11110000) / 0x10;
        sfr R1 = 0x54;
        R1 = R3 + 0x0c;
    }
}
void main() //主程序
{
    dsinit();
    TMOD = 0xd1;
    TL0 = 0x18;
    TH0 = 0xfc;
    TL1 = 0;
    TH1 = 0;
    SP = 0x20;
    biaozhi = 0;
    sptime = 0;
    settings = 0;
    splo = 0xff;
    inen = 0;
    EA = 1;
    EX1 = 1;
    EX0 = 1;
    IT1 = 1;
    IT0 = 1;
    ET0 = 1;
    TR0 = 1;
    PX1 = 1;
    TR1 = 1;
    while (1)
    {
        if (P1^0==0||P1^1==0|| P1^2==0|| P1^3==0)
        {
            key();
        }
    }
}