         ORG   0000H
         LJMP  MAIN					;����main ����

         ORG   0003H                ;�ⲿ�ж�0�жϵ�ַ�� key�������º󴥷��ж�	��ȡ��ǰʱ�����ݵ���Ƭ��
         LJMP  DS12887	           	

         ORG   000BH                ;��ʱ��T0����жϵ�ַ	
         LJMP  DISPLAY 	            ; �ж���ʾ���ӳ���	  �ó����ж�ʱ1ms�����ж�

         ORG   0013H                ;�ⲿ�ж�1�жϵ�ַ������ ADCæ�ź��ж�	INTT1�ӿ� �����źŴ����ж�
         LJMP  VOLTAGE              ; �ж϶���ѹ�ӳ���
 
;/********************************������**********************************/

MAIN:    LCALL DSINIT                ;DS12887ʱ�ӳ�ʼ��    ������Ծ DSINIT�ӳ���
  
         MOV   TMOD,#0D1H           ;0D1H=1101 0001 �鱾P79	����T0Ϊ16λ��ʱ����T1Ϊ16λ��GATEλ�ļ�����	

         MOV   TL0,#18H	            ;T0��ʱ����ֵ����ֵΪ65536-1000=0FC18H 16����	����ʱ1����  �鱾P80  
         MOV   TH0,#0FCH

         MOV   TL1,#0               ;T1��������
         MOV   TH1,#0                            
		                                                                                                                                                  
     MOV   SP,#20H              ;���ջ��ַ	   ���ں�����ʱ�洢����
     MOV   60H,#00H             ;��ʾ���ݱ�־λ,00H-ʱ�䣬08H-���ڣ�10H-��ѹ	60H����һ����־�� 
	                                   
	 MOV   61H,#00H             ;��˸���ʱ���־λ61H
	 MOV   62H,#00H             ;����״̬���Ʊ�־λ62H 

	 MOV   63H,#0FFH            ;��˸λ�ñ�־λ63H ����ʼֵΪ 1111 1111��
	 MOV   64H,#00H             ;����/�˳����ñ�־λ64H		00HΪ��������״̬ 01HΪ������״̬

         SETB  EA                   ;CPU���ж�		 �ж����ÿ��� �鱾P72
         SETB  EX1                  ;�����ⲿ�ж�1  
         SETB  EX0                  ;�����ⲿ�ж�0 
         SETB  IT1                  ;�����ⲿ�ж�1Ϊ���ش�����ʽ
         SETB  IT0                  ;�����ⲿ�ж�0Ϊ���ش�����ʽ
         SETB  ET0                  ;��ʱ��T0����ж�����
         SETB  TR0                  ;������ʱ��T0
         SETB  TR1                  ;����������T1
         SETB  PX1                  ;�ⲿ�ж�1����ж�����
         
KEY:     MOV   A,P1		            ;���θ�4λ���ж��Ƿ��м�����			
         ANL   A,#0FH              	; ANL Ϊ��ָ�� �鱾P48	  �ù���Ϊ��Aֵ�ĸ���λ���� 

         JNB   ACC.0,DD          ;��A�е�λ��Ԫ����������תDD	 JNB �����ǰ������Ϊ1 ����ת�������λ��	�鱾P57
         JNB   ACC.1,DD
         JNB   ACC.2,DD
         JNB   ACC.3,DD
         SJMP  KEY					 ;ѭ���ó���KEY

;/****************************DS12887��ʼ��**********************************/	  ;��ʱ��оƬ

DSINIT:  MOV   DPTR,#7F0BH          ;��ʼ���Ĵ���B����ֹоƬ�ڲ��ĸ������ڲ�������SETλ��1	 ��7F0BΪоƬ�мĴ���B�ĵ�ַ��
	 MOV   A,#82H					;82Ϊ1000 0010 �鱾P166 �Ĵ���B��˵��
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F00H          ;7F00H ΪоƬ�����õĵ�ַ
	 MOV   A,#00H				;��ʼ����Ϊ00
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F02H          ;��ʼ����Ϊ00
	 MOV   A,#00H
	 MOVX  @DPTR,A

     MOV   DPTR,#7F04H          ;��ʼ��ʱΪ15
	 MOV   A,#15H
     MOVX  @DPTR,A


     MOV   DPTR,#7F06H          ;��ʼ������Ϊ05
	 MOV   A,#05H
     MOVX  @DPTR,A

     MOV   DPTR,#7F07H          ;��ʼ����Ϊ18
	 MOV   A,#18H
     MOVX  @DPTR,A


     MOV   DPTR,#7F08H          ;��ʼ����Ϊ06
	 MOV   A,#06H
     MOVX  @DPTR,A


     MOV   DPTR,#7F09H          ;��ʼ�����λΪ21
	 MOV   A,#22H
     MOVX  @DPTR,A 


     MOV   DPTR,#7F0EH          ;��ʼ�����λΪ20
	 MOV   A,#20H
     MOVX  @DPTR,A              

         MOV   DPTR,#7F0AH          ;�Ĵ���A����      7F0AHΪ�Ĵ���A�ĵ�ַ �鱾P164
	     MOV   A,#20H				; 20HΪ0010 0000   �鱾P165��˵��
         MOVX  @DPTR,A  			 
		        
         MOV   DPTR,#7F0CH          ;���Ĵ���C���ж�����жϣ�
         MOVX  A,@DPTR

         MOV   DPTR,#070DH          ;���Ĵ���D
         MOVX  A,@DPTR

         MOV   DPTR,#7F0BH          ;���üĴ���B��оƬ��ʼ�����������ж�����
         MOV   A,#12H               ;12H Ϊ0001 0010	 ��ֻ�򿪸����ж� Ϊ24h�� �鱾P166
         MOVX  @DPTR,A

         RET		; �ص���תʱ��λ�� ��main

;/************************����ȷ��**************************/

DD:      LCALL DL10MS		          ;��ʱ10ms��������	 ����ת����ʱС����

         MOV   A,P1                       ;���θ�4λ���ٴ��ж�
         ANL   A,#0FH                     

         JNB   ACC.0,TQ1    ;ACC.0�ǰ���1����������Ϊ�͵�ƽ����תTQ1  JNB �����ǰ������Ϊ1 ����ת�������λ��	�鱾P57
         JNB   ACC.1,TQ2
         JNB   ACC.2,TQ3
         JNB   ACC.3,TQ4
         SJMP  KEY

TQ1:     MOV   A,P1	                  ;�жϰ���1�Ƿ���   һֱѭ�� �ȵ���������
         ANL   A,#0FH
         JB    ACC.0,DD1    ;������Ϊ�ߵ�ƽ����ת��������DD1   JB �����ǰ����Ϊ1 ����ת�������λ��  �鱾P57
         SJMP  TQ1

TQ2:     MOV   A,P1	                  ;�жϰ���2�Ƿ���
         ANL   A,#0FH
 	     JB    ACC.1,DD2			  ;������������ACC.1Ϊ1  ��ת��DD2
         SJMP  TQ2
TQ3:     MOV   A,P1	                  ;�жϰ���3�Ƿ���
         ANL   A,#0FH
         JB    ACC.2,DD3
         SJMP  TQ3
TQ4:     MOV   A,P1	                  ;�жϰ���4�Ƿ���
         ANL   A,#0FH
 	     JB    ACC.3,DD4 
         SJMP  TQ4

DD1:     LCALL DL10MS	                ;����1��ʱ��������
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.0,KEY1  ;����ȻΪ�ߵ�ƽ����ȷʵ�����ѵ�����תKEY1���ܳ���
         LJMP  KEY
DD2:     LCALL DL10MS	                ;����2��ʱ��������
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.1,KEY2
         LJMP  KEY
DD3:     LCALL DL10MS	                ;����3��ʱ��������
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.2,KEY3
         LJMP  KEY
DD4:     LCALL DL10MS	                ;����4��ʱ��������
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.3,KEY4
         LJMP  KEY


;/**********************����/�˳�����***********************/

KEY1:    MOV   A,60H                 ;����ʾ���ݱ�־λ60H,���������:00H-ʱ�䣬08H-���ڣ�10H-��ѹ
	 CJNE  A,#10H,USE            ;����ʱ��ʾ���ǵ�ѹ����Ϊ��ѹ�������ã�ֻ������ʱ��Ҫ���ã������ж� �鱾P52 CJNE����������� ִ����һ�� ���������ת
	 LJMP  KEY 					 ;����ʱ��ʾ���ǵ�ѹ��ֱ�ӻص�KEY�ӳ���


USE:	 MOV   A,64H                 ;�� ����/�˳����ñ�־λ
	 CJNE  A,#00H,OUT            ;��Ϊ00H��������ִ��in�ӳ���������ã���һ�θñ�־λ��Ϊ00H ����������״̬�У�
								 ;����Ϊ00H������ת��OUT�ӳ���

IN:	 MOV   A,#01H                ;������/�˳����ñ�־λ��1��64HΪ����/�˳����ñ�־λ��
	 MOV   64H,A				 
	 CLR   EX0                   ;���ⲿ�ж�0��ʹ�䲻��������ʱ����DISPLAY��       
	 MOV   63H,#00111111B        ;63HΪ��˸λ�ñ�־λ,ѡ��ͷ��λ��
        LJMP  KEY

OUT: MOV   A,#00H            ;�˳����ã���������/�˳����ñ�־λ��0��Ϊ��һ���ж���׼����
	 MOV   64H,A
	 LCALL NEW                   ;���޸ĺ����ʱ��д��ʱ��оƬ
	 SETB  EX0                   ;���¿����ⲿ�ж�0
	 MOV   63H,#11111111B        ;����˸
	 LJMP  KEY

;/**********************��˸λѡ��KEY2�������ƶ���˸λ�ã�***********************/

KEY2:    MOV   A,64H                 ;�� ����/�˳����ñ�־λ
	 CJNE  A,#01H,VAIN1          ;�ж��Ƿ�������״̬��01H��ʾ������״̬������ΪO1H���������У����䲻Ϊ01H��ת��VAIN1
	 MOV   A,63H                 ;63HΪ��˸λ�ñ�־λ����������״̬����˸λ��   ����   ��λ
	 RR    A
	 RR    A
	 MOV   63H,A
	 LJMP  KEY
VAIN1:   LJMP  KEY                   ;����������״̬����Ч����

;/**********************����ʱ��**************************/

KEY3:    MOV   A,64H		  ;�� ����/�˳����ñ�־λ
	 CJNE  A,#01H,VAIN2     ;�ж��Ƿ�����״̬��KEY1����������״̬Ϊ01H��,��������״̬����ΪҪͨ��KEY3�Բ��������޸ģ�
	 LCALL JUDGE            ;��������״̬�����ж��޸����ݲ��޸ģ�����תJUDGE
	 LJMP  KEY
VAIN2:   LJMP  KEY          ;����������״̬����Ч����,�ص�������

;/**********************�л���ʾ����**********************/
       
KEY4:    MOV   A,60H                    ;����4�����л���ʾ����   60HΪ��ʾ���ݱ�־λ
DAT: 	 CJNE  A,#00H,VOL               ;�л�������
	 MOV   60H,#08H
	 LJMP  KEY
VOL:     CJNE  A,#08H,TIM               ;�л�����ѹ  
	 MOV   60H,#10H
         MOV   63H,#11111111B           ;�л�����ѹʱĩ��λ����˸	 ��˸λ�ñ�־λ63H ����ʼֵΪ 1111 1111��
	 LJMP  KEY
TIM:     CJNE  A,#10H,DAT               ;�л���ʱ��
	 MOV   60H,#00H
         LJMP  KEY


;/********************�ж��޸ĵ�����**********************/

JUDGE:   MOV   A,60H                 ;�ж���ʾ������:00H-ʱ�䣬08H-���ڣ�10H-��ѹ
	 CJNE  A,#00H,JD             ;��ʾ���ݱ�־λ60H������Ϊ00H�����޸�ʱ�� �鱾P52 CJNE����������� ִ����һ�� ���������ת	
TIME:    MOV   A,63H                 ;����˸λ�ñ�־λ63H
	 CJNE  A,#00111111B,TIME56   ;ĩ��λ��˸ʱ���޸���
	 LCALL SECOND
	 RET                   ;����LCALL JUDGE����һ��LJMP KEY�����жϰ���������KEY3ÿ��һ�Σ����1
TIME56:  CJNE  A,#11001111B,TIME34   ;�塢����˸ʱ���޸ķ�
	 LCALL MINUTE
	 RET
TIME34:  CJNE  A,#11110011B,TIME12   ;��������˸ʱ���޸�Сʱ
	 LCALL HOUR
	 RET
TIME12:  LCALL WEEK                  ;һ������˸ʱ���޸�����	 
	 RET 


JD:      CJNE  A,#08H,VAIN3          ;60H������Ϊ08Hʱ�����޸�����
DATE:    MOV   A,63H
	 CJNE  A,#00111111B,DATE56   ;ĩ��λ��˸ʱ���޸���
	 LCALL DAY
	 RET
DATE56:  CJNE  A,#11001111B,DATE34    ;�塢����˸ʱ���޸���
	 LCALL MONTH
	 RET
DATE34:  CJNE  A,#11110011B,DATE12    ;��������˸ʱ���޸����λ
	 LCALL YEARL
	 RET
DATE12 : LCALL YEARH                  ;һ������˸ʱ���޸����λ	 
	 RET
VAIN3:   RET                          ;60H�����ݲ�Ϊ00HҲ��Ϊ08Hʱ����ǰ��ʾΪ��ѹ����Ч����

;/**************************��1�޸�************************/

SECOND:  MOV   A,30H                 ;��(30H)��1;   30H-37H���δ���롢�֡�ʱ�����ڡ��ա��¡���

         ADDC  A,#1 			     ;ADDC��DA ��ͬʵ�ּӷ����� �鱾P44
         DA    A

         CJNE  A,#60H,SECOV          ;�벻�ܳ���60
         MOV   A,#00H
SECOV:   MOV   30H,A 
         RET                         ;���� **�ж��޸ĵ�����**���� �У�Ȼ������������KEY

MINUTE:  MOV   A,31H                 ;��(31H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#60H,MINOV
         MOV   A,#00H
MINOV:   MOV   31H,A 
         RET 

HOUR:    MOV   A,32H                ;Сʱ(32H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#24H,HOUROV
         MOV   A,#00H
HOUROV:  MOV   32H,A 
         RET
         
WEEK:    MOV   A,33H                ;����(33H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#08H,WEEKOV
         MOV   A,#01H
WEEKOV:  MOV   33H,A 
         RET 

DAY:     MOV   A,35H                ;��(34H)��1�������ж��·�(35H)�Ĵ�СM1����
         CJNE  A,#04H,M1			;������Ϊ4��������ִ�� ������תM1
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV1
         MOV   A,#01H
DAYOV1:  MOV   34H,A 
         RET
 
M1:      CJNE  A,#06H,M2		    ;������Ϊ6��������ִ�� ������תM2
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV2        
         MOV   A,#01H
DAYOV2:  MOV   34H,A 
         RET
 
M2:      CJNE  A,#09H,M3			;������Ϊ9��������ִ�� ������תM3
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV3
         MOV   A,#01H
DAYOV3:  MOV   34H,A 
         RET
 
M3:      CJNE  A,#11H,M4		    ;������Ϊ11��������ִ�� ������תM4
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV4
         MOV   A,#01H
DAYOV4:  MOV   34H,A 
         RET                        
 
M4:      CJNE  A,#02H,M5             ;������Ϊ2��������ִ�� ������תM5	����Ϊ2��4��6��9��11�� ��ִ��M5
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#30H,DAYOV5		  ;ֻĬ����2��Ϊ29�죬û��������
         MOV   A,#01H
DAYOV5:  MOV   34H,A 
         RET

M5:      MOV   A,34H                ;�����·ݾ�������31��              
         ADD   A,#1 
         DA    A
         CJNE  A,#32H,DAYOV6
         MOV   A,#01H
DAYOV6:  MOV   34H,A 
         RET    
         
MONTH:   MOV   A,35H                 ;��(35H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#13H,MONTHOV
         MOV   A,#01H
MONTHOV: MOV   35H,A 
         RET

YEARL:   MOV   A,36H                 ;���λ(36H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#99H,YLOV
         MOV   A,#00H
YLOV:    MOV   36H,A 
         RET  
         
YEARH:   MOV   A,37H                 ;���λ(37H)��1
         ADDC  A,#1 
         DA    A
         CJNE  A,#99H,YHOV
         MOV   A,#00H
YHOV:    MOV   37H,A 
         RET 

;/***********************��ʱ�䱣�浽ʱ��оƬ��Ӧ��ַ********************/

NEW:     PUSH  ACC
         PUSH  DPH
         PUSH  DPL

     MOV   DPTR,#7F0BH          ;���üĴ���B��ʱ��оƬֹͣ����
	 MOV   A,#82H				; 82H=1000 0010 
	 MOVX  @DPTR,A              ; ���üĴ���B


	 MOV   DPTR,#7F00H          ;����
	 MOV   A,30H
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F02H          ;�·�
	 MOV   A,31H
	 MOVX  @DPTR,A

         MOV   DPTR,#7F04H          ;��ʱ
	 MOV   A,32H
         MOVX  @DPTR,A

         MOV   DPTR,#7F06H          ;������
	 MOV   A,33H
         MOVX  @DPTR,A

         MOV   DPTR,#7F07H          ;����
	 MOV   A,34H
         MOVX  @DPTR,A

         MOV   DPTR,#7F08H          ;����
	 MOV   A,35H
         MOVX  @DPTR,A

         MOV   DPTR,#7F09H          ;�����λ
	 MOV   A,36H
         MOVX  @DPTR,A  
		  
         MOV   DPTR,#7F0EH          ;�����λ
	 MOV   A,37H
         MOVX  @DPTR,A   


         MOV   DPTR,#7F0AH          ;�Ĵ���A����
	     MOV   A,#20H					;20H=0010 0000  �鱾165ҳ
         MOVX  @DPTR,A

         MOV   DPTR,#7F0CH          ;���Ĵ���C
         MOVX  A,@DPTR
         MOV   DPTR,#070DH          ;���Ĵ���D
         MOVX  A,@DPTR

         MOV   DPTR,#7F0BH          ;�������üĴ���B��ʹʱ��оƬ��ʼ������SETλ��0��
         MOV   A,#12H				;12H=0001 0010
         MOVX  @DPTR,A

         POP  DPL
         POP  DPH
         POP  ACC
         RET       ;�ص������˳��е�OUT�ӳ���


;/************************�ж϶�ʱ��******************************/	 key�������º󴥷��ж�

DS12887: CLR   EX0                  ;�ر�T0��1ms�ж�
         CLR   EA     
		              
         PUSH  ACC			  
         PUSH  PSW			  
         PUSH  DPH
         PUSH  DPL 	    
		        
         CLR   PSW.3			
         SETB  PSW.4      	    ;�����Ĵ���״̬ѡ��10����ֹ��ַ��ͻ

	 MOV   DPTR,#7F00H          ;����Ĵ���������30H��Ԫ
	 MOVX  A,@DPTR
	 MOV   30H,A
	 MOV   DPTR,#7F02H          ;���ּĴ���������31H��Ԫ
	 MOVX  A,@DPTR
	 MOV   31H,A
	 MOV   DPTR,#7F04H          ;��Сʱ�Ĵ���������32H��Ԫ
	 MOVX  A,@DPTR
	 MOV   32H,A
	 MOV   DPTR,#7F06H          ;�����ڼĴ���������33H��Ԫ
	 MOVX  A,@DPTR
	 MOV   33H,A
     MOV   DPTR,#7F07H          ;���ռĴ���������34H��Ԫ
	 MOVX  A,@DPTR
	 MOV   34H,A
	 MOV   DPTR,#7F08H          ;���¼Ĵ���������35H��Ԫ
	 MOVX  A,@DPTR
	 MOV   35H,A	 
     MOV   DPTR,#7F09H          ;�����λ�Ĵ���������36H��Ԫ
	 MOVX  A,@DPTR
	 MOV   36H,A
	 MOV   DPTR,#7F0EH          ;�����λ�Ĵ���������37H��Ԫ
     MOVX  A,@DPTR
	 MOV   37H,A

	 MOV   DPTR,#7F0CH          ;���Ĵ���C���ж�����жϣ�
     MOVX  A,@DPTR    
		   
         SETB  EA                   ;�����ж�
	     SETB  EX0

	     POP   DPL
         POP   DPH
         POP   PSW
         POP   ACC 	            
         RETI

;/************************�ж���ʾ******************************/ 
;��ʱ��T0�ж� һ���봥���ж�һ��
DISPLAY: PUSH  ACC                  
         PUSH  PSW

         CLR   PSW.4
         SETB  PSW.3                ;ѡ����״̬01����ֹ��ַ��ͻ

	 CLR   EA                   ;�ر��ж�
	 CLR   TR0

	 MOV   TL0,#17H             ;��ʱ�����³�ʼֵ
     MOV   TH0,#0FCH

     LCALL BUFFER               ;���������ڵ����ݣ����˸���ַ30H-37H���ʱ�����ݲ𿪴洢��16����ַ��40H-4FH�����ʱ������40H-47H����������48H-4FH

	 MOV   R0,#40H              ;��ʾ���ݶ���Ĵ�ŵ��׵�ַ
	 MOV   A,60H                ;60HΪ��ʾ��־λ�洢�ĵ�ַ
	 ADD   A,R0                 ;60H������ݣ�00H-ʱ�䣬08H-���ڣ�10H-��ѹ����40H��ӣ��ҵ��׵�ַ������ֺ�ĵ�ַ��
	 MOV   R0,A                 ;40-47H��SBUFF�д��ʱ��,48H-4F�д�����ڣ�50H��ŵ�ѹ����ʱR0���� ��ֺ�� ʱ���� ��ַ

	 MOV   R7,#80H              ;ͨ��R7����λ�룬1Ϊ��Ч   80H=10000000B

	 MOV   A,61H                ;61HΪ��˸���ʱ���־λ����ʼֵΪ00H��
     INC   A
	 MOV   61H,A
     CJNE  A,#20H,SHINE        ;�ж�61H��ֵ��û�е�20H;��A��Ϊ20H����ת��SHINE;���ʱ�䵽���������ת�� 
         
         MOV   A,62H                ;����״̬���ƣ������62H�У�00H��ʾ����FFHΪ����
         XRL   A,#0FFH              ;��1��򣬰�λȡ��������ת������00H��ΪFFH,FFH��Ϊ00H��20��ִ������20��ִ�а���
         MOV   62H,A
         MOV   61H,#00H             ;��61H�������㣨Ϊ��һ��20��׼����61HΪ��˸���ʱ���־λ����ʼֵΪ00H��

SHINE:   MOV   A,62H				;����״̬���Ʊ�־λ62H 
	     CJNE  A,#00H,ON            ;62H��Ϊ00Hʱ��Ϊ0FFH����ת��ON
         CJNE  A,#0FFH,OFF          ;62H��Ϊ0FFHʱ��Ϊ00H����ת��OFF 
         

ON:  MOV   A,R7              ;λ����A ��ʱR7����λ��

	 MOV   DPTR,#0DFFFH         ;λ��Ĵ���0DFFFH �ĵ�ַ
	 MOVX  @DPTR,A              ;λ�������λ��Ĵ���

	 MOV   A,@R0                ;������A �𿪺������ ���͵�A  ��ʱR0���� ��ֺ�� ʱ���� ��ַ
	 MOV   DPTR,#TAB            
	 MOVC  A,@A+DPTR			;���õ���ʾʱ�������ݵĴ��� ��ҪҪ��ʾ�Ķ���

	 MOV   DPTR,#0BFFFH         ;����Ĵ���0BFFFH
	 MOVX  @DPTR,A              ;�������������Ĵ���

	 LCALL DL1MS                ;����1ms�ӳ�
 
         MOV   A,R7
         RR    A                 ;�ı�λ�룬��R7������10000000����01000000����ѡ�еڶ�λ
         MOV   R7,A              ;ָ����һ��λ��
		 INC   R0                ;��ʾ���ݻ���һ��

         CJNE  A,#80H,ON            ;һ��ѭ��δ��ɣ�����ʾ��һλ�� 80H= 10000000

         SETB  TR0
         SETB  EA
         POP   PSW
         POP   ACC
         RETI

OFF: MOV   A,R7              ;λ����A
	 ANL   A,63H                ;��δ��������״̬ʱ��63HΪ1111 1111����ʱ��ON������ͬ����������ʱ��63H����λΪ0����off������������20ms����ʵ����˸���ܣ�
	 MOV   DPTR,#0DFFFH         ;ȡλ��ڵ�ַ
	 MOVX  @DPTR,A              ;λ������λ��
	 MOV   A,@R0                ;������A
	 MOV   DPTR,#TAB            ;���õ���ʾ����
	 MOVC  A,@A+DPTR
	 MOV   DPTR,#0BFFFH         ;ȡ����ڵ�ַ
	 MOVX  @DPTR,A              ;������������
	 LCALL DL1MS                ;����1ms�ӳ�
	 INC   R0                   ;ָ����һ����ʾ��Ԫ 
         MOV   A,R7
         RR    A
         MOV   R7,A                 ;ָ����һ��λ��
         CJNE  A,#80H,OFF           ;һ��ѭ��δ��ɣ�����ʾ��һλ
         SETB  TR0               ;��T0��Ϊ��һ��1ms׼��
         SETB  EA
         POP   PSW
         POP   ACC
         RETI


;/**********************���������ݴ���**************************/ �Ѱ˸���ַ������ݲ𿪴洢��16����ַ��

BUFFER:  MOV   R0,#40H              ;���������׵�ַ
	 	 MOV   R1,#30H              ;���֣���30H-37H�����ݷŵ�40H-47Hʱ�䣬48H-4F������
	 	 MOV   R7,#08H              ;LOOP�ܹ�ѭ��R7��

LOOP1:   MOV   A,@R1				;30H-37H  �洢�����ʱ����������
	     ANL   A,#0FH				;���θ���λ
         MOV   @R0,A				;��ʵ�ְ� �洢���ݵ�ַ�Ķ��� ת������40H��ʼ֮��ĵ�ַ��
     
	 INC   R0
	 MOV   A,@R1
	 ANL   A,#0F0H					;���ε���λ
	 SWAP  A						;�����ߵ���λ
	 MOV   @R0,A					;��ʵ�ְ� �洢���ݵ�ַ�Ķ��� ת������40H��ʼ֮��ĵ�ַ��

	 INC   R0
	 INC   R1
     DJNZ  R7,LOOP1             ;ȫ������ת��δ��ɣ������ѭ��
         RET

;/************************�ж϶���ѹֵ******************************/ �ⲿ�ж�1 

VOLTAGE: CLR   TR1                            
         CLR   EA
         PUSH  ACC
         PUSH  PSW

         SETB  PSW.3                ;���üĴ���������Ϊ11����ֹ��ͻ
         SETB  PSW.4

         MOV   A,TL1				; ��λ��ȡ
         SUBB  A,#10H	            ;������1��ȡ�ļ���ֵ��10000��2710H��  �鱾P44 SUBB ����ָ��
         MOV   R7,A					;��λ�������R7

         MOV   A,TH1               	; ��λ��ȡ
         SUBB  A,#27H				; ����λ27H
         MOV   R6,A					;��λ�������R6

         MOV   TL1,#0
         MOV   TH1,#0				;��ʱ������

         LCALL CHANGE		 	    ;����ʮ������תʮ���Ƴ��򣬼�����R3 4 5���˵�ǰ��ѹֵ
         LCALL VDISPLAY             ;��ת����ĵ�ѹֵ���д���
         POP   PSW
         POP   ACC
         SETB  EA
         SETB  TR1
         RETI

;/**********************ʮ������תʮ���Ƴ���********************/

CHANGE:  CLR   A	             ;ʮ������תʮ����BCD
         MOV   R3,A 
         MOV   R4,A
         MOV   R5,A
         MOV   R2,#10H			 ;ѭ��10��
LOOP2:   MOV   A,R7				 ;R7��ѹ��λ���
         RLC   A	             ;��λ����
         MOV   R7,A

         MOV   A,R6				 ;R6��ѹ��λ���
         RLC   A				 ;��λ����
         MOV   R6,A

         MOV   A,R5
         ADDC  A,R5
         DA    A
         MOV   R5,A

         MOV   A,R4
         ADDC  A,R4
         DA    A
         MOV   R4,A	

         MOV   A,R3
         ADDC  A,R3
         MOV   R3,A

         DJNZ  R2,LOOP2			  ;ѭ��10��
         RET 

;/**********************��ѹֵ�Ĵ���*****************************/

VDISPLAY:PUSH  PSW
         SETB  PSW.3                  ;���üĴ���������Ϊ11����ֹ��ͻ
         SETB  PSW.4   
		                 
         MOV   55H,#0BH               ;0BH=0000 1011B
         JB    P1.7,CHAIZI            ;�жϵ�ѹ�Ƿ�Ϊ����P1.7��POL���鱾P171 ���ӵ�7135ADת������27��
         MOV   55H,#0AH				  ;0BH=0000 1010B

CHAIZI:  MOV   57H,#0BH
	     MOV   56H,#0BH  	     ;�����ң���һ��λ����ʾ 

         MOV   R1,#50H				 ;50H=40H+10H������ֺ��ѹ���ݴ洢���׵�ַ
		 ;��R5��� �浽������ַ	
         MOV   A,R5                  ;ĩ��λ���ִ���						 
         ANL   A,#0FH	             ;��ȥR5�и���λ       
         MOV   @R1,A				 ;ʣ�µ���λ���� �׵�ַ����֮��ĵ�ַ��
         INC   R1        
         MOV   A,R5
         ANL   A,#0F0H				 ;��ȥR5�е���λ  
         SWAP  A
         MOV   @R1,A				 ;ʣ�¸���λ���� �׵�ַ����֮��ĵ�ַ��

         INC   R1
         MOV   A,R4                  ;��R4��� �浽������ַ	�塢��λ���ִ���
         ANL   A,#0FH	                     
         MOV   @R1,A
         INC   R1 
         MOV   A,R4
         ANL   A,#0F0H
         SWAP  A
         MOV   @R1,A

         INC   R1
         MOV   A,R3                  ;�����ң�����λ������λ���ò��֣�ֱ�Ӳ��   ��������            
         ADD   A,#0CH	           	 ;����C�� ������ϵĵ�Ϳ��Ա�����
         MOV   @R1,A 
         POP   PSW
         RET  

;/************************����ӳٳ���******************************/

DL1MS:   MOV   R6,#250              ;1ms��ʱ����
DLT:     NOP
	     NOP
         DJNZ  R6,DLT
         RET 

DL10MS:  MOV R6,#0FFH               ;10ms��ʱ����
DL41T:	 MOV R5,#8H
DL40T:   NOP
         NOP
         DJNZ R5,DL40T
         DJNZ R6,DL41T
         RET  

 
TAB:     DB 5FH,06H,3BH,2FH,66H     ;�����
         DB 6DH,7DH,07H,7FH,6FH
         DB 20H,00H,0DFH,86H          
END  
 
                                           