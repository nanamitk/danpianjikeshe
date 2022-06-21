#include"reg51.h"
#include<stdio.h>
#include<math.h>
#include<ABSACC.H>
#define uint unsigned int
#define uchar unsigned char
uchar a;
sfr biaozhi = 0x60; //��ʾ���ݱ�־λ,00H-ʱ�䣬08H-���ڣ�10H-��ѹ
sfr sptime = 0x61; //��˸���ʱ��
sfr settings = 0x62;//����״̬���Ʊ�־λ
sfr splo = 0x63;//��˸λ�ñ�־λ
sfr inen = 0x64;//���룬�Ƴ����ñ�־λ
sfr second = 0x30;
sfr minute = 0x31;
sfr hour = 0x32;
sfr week = 0x33;
sfr day = 0x34;
sfr month = 0x35;
sfr year = 0x36;
void dsinit() //��ʼ��ds12887
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

void delayxms(int t) //��ʱxms
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
    delayxms(10); //����
    if (P1 ^ 0 == 0 || P1 ^ 1 == 0 || P1 ^ 2 == 0 || P1 ^ 3 == 0)
    {
        while (1) //ѭ�����ȵ���ť����ʱִ�н������ĳ��򣬲��˳�ѭ��
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
    if (second >= 24) second = 0;
}
void minute()
{
    second++;
    if (second >= 24) second = 0;
}
void second()
{
    second++;
    if (second >= 24) second = 0;
}
void second()
{
    second++;
    if (second >= 24) second = 0;
}
void main() //������
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