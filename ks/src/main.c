#include"reg51.h"
#include<stdio.h>
#include<math.h>
#include<ABSACC.H>
#define uint unsigned int
#define uchar unsigned char
uchar a;
sbit aj1 = p1 ^ 0;
sbit aj2 = p1 ^ 1;
sbit aj3 = p1 ^ 2;
sbit aj4 = p1 ^ 3;
void dsinit() //≥ı ºªØds12887
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
    a = XBYTE[0x7F0C];
    a = XBYTE[0x070D];
    XBYTE[0x7f0b] = 0x12;

}
void delayxms(int t) //—” ±xms
{
    for (int i = 0; i < t; i++)
    {
        for (int j = 0; j < 110; j++);
        
    }
}
void dd()
{
    delayxms(10);
    if (aj1==1)
    {
        while (1)
        {
            if (aj1==0)
            {
                delayxms(10);
                if (aj1 == 1)
                {
                    if (DBYTE[0x60]!=0x10)
                    {
                        if (DBYTE[0x64] != 0x00)
                        {
                            DBYTE[0x64] = 0x00;

                        }
                    }
                }
                break       
            }
        }
    }
}
void main()
{
    dsinit();

}