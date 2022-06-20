#include"reg51.h"
#include<stdio.h>
#include<math.h>
#include<ABSACC.H>
#define uint unsigned int
#define uchar unsigned char
uchar a;
sfr time = 0x60;
sfr sptime = 0x61;
sfr settings = 0x62;
sfr inen = 0x64;
void dsinit() //初始化ds12887
{
    XBYTE[0x7F0B] = 0x82;
    XBYTE[0x7F00] = 0x00;
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
void main() //主程序
{
    dsinit();
    TMOD = 0xd1;
    TL0 = 0x18;
    TH0 = 0xfc;
    TL1 = 0;
    TH1 = 0;
    SP = 0x20;
    time = 0;
    sptime = 0;
    settings = 0;
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