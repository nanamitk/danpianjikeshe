         ORG   0000H
         LJMP  MAIN					;跳到main 程序

         ORG   0003H                ;外部中断0中断地址， key按键按下后触发中断	读取当前时钟数据到单片机
         LJMP  DS12887	           	

         ORG   000BH                ;定时器T0溢出中断地址	
         LJMP  DISPLAY 	            ; 中断显示的子程序	  该程序中定时1ms触发中断

         ORG   0013H                ;外部中断1中断地址，用于 ADC忙信号中断	INTT1接口 接收信号触发中断
         LJMP  VOLTAGE              ; 中断读电压子程序
 
MAIN:    LCALL DSINIT                ;DS12887时钟初始化    即长跳跃 DSINIT子程序
  
         MOV   TMOD,#0D1H           ;0D1H=1101 0001 书本P79	设置T0为16位定时器，T1为16位带GATE位的计数器	

         MOV   TL0,#18H	            ;T0定时赋初值，初值为65536-1000=0FC18H 16进制	即定时1毫秒  书本P80  
         MOV   TH0,#0FCH

         MOV   TL1,#0               ;T1计数清零
         MOV   TH1,#0                            
		                                                                                                                                                  
     MOV   SP,#20H              ;设堆栈地址	   用于后面暂时存储数据
     MOV   60H,#00H             ;显示内容标志位,00H-时间，08H-日期，10H-电压	60H存了一个标志数 
	                                   
	 MOV   61H,#00H             ;闪烁间隔时间标志位61H
	 MOV   62H,#00H             ;亮灭状态控制标志位62H 

	 MOV   63H,#0FFH            ;闪烁位置标志位63H （初始值为 1111 1111）
	 MOV   64H,#00H             ;进入/退出设置标志位64H		00H为不在设置状态 01H为在设置状态

         SETB  EA                   ;CPU开中断
         SETB  EX1                  ;允许外部中断1  
         SETB  EX0                  ;允许外部中断0 
         SETB  IT1                  ;设置外部中断1为边沿触发方式
         SETB  IT0                  ;设置外部中断0为边沿触发方式
         SETB  ET0                  ;定时器T0溢出中断允许
         SETB  TR0                  ;启动定时器T0
         SETB  TR1                  ;启动计数器T1
         SETB  PX1                  ;外部中断1溢出中断优先
         
KEY:     MOV   A,P1		            ;屏蔽高4位，判断是否有键按下			
         ANL   A,#0FH              	;将A值的高四位过滤 

         JNB   ACC.0,DD          ;判A中的位单元，按下则跳转DD
         JNB   ACC.1,DD
         JNB   ACC.2,DD
         JNB   ACC.3,DD
         SJMP  KEY					 ;循环该程序KEY

;/****************************DS12887初始化**********************************/	  ;即时钟芯片

DSINIT:  MOV   DPTR,#7F0BH          ;初始化寄存器B，禁止芯片内部的更新周期操作
	 MOV   A,#82H					;82为1000 0010
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F00H          ;7F00H 为芯片秒设置的地址
	 MOV   A,#00H				;初始化秒为00
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F02H          ;初始化分为00
	 MOV   A,#00H
	 MOVX  @DPTR,A

     MOV   DPTR,#7F04H          ;初始化时为15
	 MOV   A,#15H
     MOVX  @DPTR,A


     MOV   DPTR,#7F06H          ;初始化星期为03
	 MOV   A,#03H
     MOVX  @DPTR,A

     MOV   DPTR,#7F07H          ;初始化日为17
	 MOV   A,#17H
     MOVX  @DPTR,A


     MOV   DPTR,#7F08H          ;初始化月为06
	 MOV   A,#06H
     MOVX  @DPTR,A


     MOV   DPTR,#7F09H          ;初始化年低位为22
	 MOV   A,#22H
     MOVX  @DPTR,A 


     MOV   DPTR,#7F0EH          ;初始化年高位为20
	 MOV   A,#20H
     MOVX  @DPTR,A              

         MOV   DPTR,#7F0AH          ;寄存器A设置      7F0AH为寄存器A的地址 书本P164
	     MOV   A,#20H				; 20H为0010 0000   书本P165看说明
         MOVX  @DPTR,A  			 
		        
         MOV   DPTR,#7F0CH          ;读寄存器C（中断组合判断）
         MOVX  A,@DPTR

         MOV   DPTR,#070DH          ;读寄存器D
         MOVX  A,@DPTR

         MOV   DPTR,#7F0BH          ;设置寄存器B，芯片开始工作，更新中断允许
         MOV   A,#12H               ;12H 为0001 0010	 即只打开更新中断 为24h制 书本P166
         MOVX  @DPTR,A

         RET		; 回到跳转时的位置 即main


DD:      LCALL DL10MS		          ;延时10ms消除抖动	 即跳转到延时小程序

         MOV   A,P1                       ;屏蔽高4位，再次判断
         ANL   A,#0FH                     

         JNB   ACC.0,TQ1    ;ACC.0是按键1，若按下则为低电平，跳转TQ1  JNB ：如果前参数不为1 则跳转到后参数位置	书本P57
         JNB   ACC.1,TQ2
         JNB   ACC.2,TQ3
         JNB   ACC.3,TQ4
         SJMP  KEY

TQ1:     MOV   A,P1	                  ;判断按键1是否弹起   一直循环 等到按键弹起
         ANL   A,#0FH
         JB    ACC.0,DD1    ;弹起则为高电平，跳转消抖程序DD1   JB ：如果前参数为1 则跳转到后参数位置  书本P57
         SJMP  TQ1

TQ2:     MOV   A,P1	                  ;判断按键2是否弹起
         ANL   A,#0FH
 	     JB    ACC.1,DD2			  ;若按键弹起则ACC.1为1  跳转至DD2
         SJMP  TQ2
TQ3:     MOV   A,P1	                  ;判断按键3是否弹起
         ANL   A,#0FH
         JB    ACC.2,DD3
         SJMP  TQ3
TQ4:     MOV   A,P1	                  ;判断按键4是否弹起
         ANL   A,#0FH
 	     JB    ACC.3,DD4 
         SJMP  TQ4

DD1:     LCALL DL10MS	                ;按键1延时消除抖动
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.0,KEY1  ;若仍然为高电平，则确实按键已弹起，跳转KEY1功能程序
         LJMP  KEY
DD2:     LCALL DL10MS	                ;按键2延时消除抖动
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.1,KEY2
         LJMP  KEY
DD3:     LCALL DL10MS	                ;按键3延时消除抖动
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.2,KEY3
         LJMP  KEY
DD4:     LCALL DL10MS	                ;按键4延时消除抖动
         MOV   A,P1
         ANL   A,#0FH
	 JB    ACC.3,KEY4
         LJMP  KEY


;/**********************进入/退出设置***********************/

KEY1:    MOV   A,60H                 ;读显示内容标志位60H,里面的内容:00H-时间，08H-日期，10H-电压
	 CJNE  A,#10H,USE            ;若此时显示的是电压，因为电压不用设置，只有日期时间要设置，重新判断 书本P52 CJNE：两参数相等 执行下一行 不相等则跳转
	 LJMP  KEY 					 ;若此时显示的是电压，直接回到KEY子程序


USE:	 MOV   A,64H                 ;读 进入/退出设置标志位
	 CJNE  A,#00H,OUT            ;若为00H，则向下执行in子程序进入设置（第一次该标志位里为00H 即不在设置状态中）
								 ;若不为00H，则跳转到OUT子程序

IN:	 MOV   A,#01H                ;将进入/退出设置标志位置1（64H为进入/退出设置标志位）
	 MOV   64H,A				 
	 CLR   EX0                   ;关外部中断0，使其不能在设置时进入DISPLAY中       
	 MOV   63H,#00111111B        ;63H为闪烁位置标志位,选中头两位。
        LJMP  KEY

OUT: MOV   A,#00H            ;退出设置，并将进入/退出设置标志位置0（为下一次判定做准备）
	 MOV   64H,A
	 LCALL NEW                   ;将修改后的新时间写入时钟芯片
	 SETB  EX0                   ;重新开启外部中断0
	 MOV   63H,#11111111B        ;不闪烁
	 LJMP  KEY

;/**********************闪烁位选择（KEY2功能是移动闪烁位置）***********************/

KEY2:    MOV   A,64H                 ;读 进入/退出设置标志位
	 CJNE  A,#01H,VAIN1          ;判断是否处于设置状态，01H表示在设置状态，若其为O1H则向下运行，若其不为01H跳转到VAIN1
	 MOV   A,63H                 ;63H为闪烁位置标志位，若在设置状态，闪烁位置   左移   两位
	 RR    A
	 RR    A
	 MOV   63H,A
	 LJMP  KEY
VAIN1:   LJMP  KEY                   ;若不在设置状态，无效按键

;/**********************调整时间**************************/

KEY3:    MOV   A,64H		  ;读 进入/退出设置标志位
	 CJNE  A,#01H,VAIN2     ;判断是否设置状态（KEY1按下则设置状态为01H）,若在设置状态，因为要通过KEY3对参数进行修改，
	 LCALL JUDGE            ;若在设置状态，则判断修改内容并修改，即跳转JUDGE
	 LJMP  KEY
VAIN2:   LJMP  KEY          ;若不在设置状态，无效按键,回到主程序

;/**********************切换显示内容**********************/
       
KEY4:    MOV   A,60H                    ;按键4处理，切换显示内容   60H为显示内容标志位
DAT: 	 CJNE  A,#00H,VOL               ;切换至日期
	 MOV   60H,#08H
	 LJMP  KEY
VOL:     CJNE  A,#08H,TIM               ;切换至电压  
	 MOV   60H,#10H
         MOV   63H,#11111111B           ;切换到电压时末两位不闪烁	 闪烁位置标志位63H （初始值为 1111 1111）
	 LJMP  KEY
TIM:     CJNE  A,#10H,DAT               ;切换至时间
	 MOV   60H,#00H
         LJMP  KEY


;/********************判断修改的内容**********************/

JUDGE:   MOV   A,60H                 ;判断显示的内容:00H-时间，08H-日期，10H-电压
	 CJNE  A,#00H,JD             ;显示内容标志位60H中内容为00H，则修改时间 书本P52 CJNE：两参数相等 执行下一行 不相等则跳转	
TIME:    MOV   A,63H                 ;读闪烁位置标志位63H
	 CJNE  A,#00111111B,TIME56   ;末两位闪烁时，修改秒
	 LCALL SECOND
	 RET                   ;弹回LCALL JUDGE的下一句LJMP KEY重新判断按键，所以KEY3每按一次，秒加1
TIME56:  CJNE  A,#11001111B,TIME34   ;五、六闪烁时，修改分
	 LCALL MINUTE
	 RET
TIME34:  CJNE  A,#11110011B,TIME12   ;三、四闪烁时，修改小时
	 LCALL HOUR
	 RET
TIME12:  LCALL WEEK                  ;一、二闪烁时，修改星期	 
	 RET 


JD:      CJNE  A,#08H,VAIN3          ;60H中内容为08H时，则修改日期
DATE:    MOV   A,63H
	 CJNE  A,#00111111B,DATE56   ;末两位闪烁时，修改日
	 LCALL DAY
	 RET
DATE56:  CJNE  A,#11001111B,DATE34    ;五、六闪烁时，修改月
	 LCALL MONTH
	 RET
DATE34:  CJNE  A,#11110011B,DATE12    ;三、四闪烁时，修改年低位
	 LCALL YEARL
	 RET
DATE12 : LCALL YEARH                  ;一、二闪烁时，修改年高位	 
	 RET
VAIN3:   RET                          ;60H中内容不为00H也不为08H时，则当前显示为电压，无效按键

;/**************************加1修改************************/

SECOND:  MOV   A,30H                 ;秒(30H)加1;   30H-37H依次存放秒、分、时、星期、日、月、年

         ADDC  A,#1 			     ;ADDC于DA 共同实现加法运算 书本P44
         DA    A

         CJNE  A,#60H,SECOV          ;秒不能超出60
         MOV   A,#00H
SECOV:   MOV   30H,A 
         RET                         ;跳回 **判断修改的内容**部分 中，然后再重新跳回KEY

MINUTE:  MOV   A,31H                 ;分(31H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#60H,MINOV
         MOV   A,#00H
MINOV:   MOV   31H,A 
         RET 

HOUR:    MOV   A,32H                ;小时(32H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#24H,HOUROV
         MOV   A,#00H
HOUROV:  MOV   32H,A 
         RET
         
WEEK:    MOV   A,33H                ;星期(33H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#08H,WEEKOV
         MOV   A,#01H
WEEKOV:  MOV   33H,A 
         RET 

DAY:     MOV   A,35H                ;日(34H)加1，首先判断月份(35H)的大小M1程序
         CJNE  A,#04H,M1			;若该月为4月则往下执行 否则跳转M1
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV1
         MOV   A,#01H
DAYOV1:  MOV   34H,A 
         RET
 
M1:      CJNE  A,#06H,M2		    ;若该月为6月则往下执行 否则跳转M2
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV2        
         MOV   A,#01H
DAYOV2:  MOV   34H,A 
         RET
 
M2:      CJNE  A,#09H,M3			;若该月为9月则往下执行 否则跳转M3
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV3
         MOV   A,#01H
DAYOV3:  MOV   34H,A 
         RET
 
M3:      CJNE  A,#11H,M4		    ;若该月为11月则往下执行 否则跳转M4
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#31H,DAYOV4
         MOV   A,#01H
DAYOV4:  MOV   34H,A 
         RET                        
 
M4:      CJNE  A,#02H,M5             ;若该月为2月则往下执行 否则跳转M5	即不为2、4、6、9、11月 就执行M5
         MOV   A,34H                
         ADD   A,#1 
         DA    A
         CJNE  A,#30H,DAYOV5		  ;只默认了2月为29天，没考虑闰年
         MOV   A,#01H
DAYOV5:  MOV   34H,A 
         RET

M5:      MOV   A,34H                ;其余月份均不超过31天              
         ADD   A,#1 
         DA    A
         CJNE  A,#32H,DAYOV6
         MOV   A,#01H
DAYOV6:  MOV   34H,A 
         RET    
         
MONTH:   MOV   A,35H                 ;月(35H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#13H,MONTHOV
         MOV   A,#01H
MONTHOV: MOV   35H,A 
         RET

YEARL:   MOV   A,36H                 ;年低位(36H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#99H,YLOV
         MOV   A,#00H
YLOV:    MOV   36H,A 
         RET  
         
YEARH:   MOV   A,37H                 ;年高位(37H)加1
         ADDC  A,#1 
         DA    A
         CJNE  A,#99H,YHOV
         MOV   A,#00H
YHOV:    MOV   37H,A 
         RET 

;/***********************新时间保存到时钟芯片对应地址********************/

NEW:     PUSH  ACC
         PUSH  DPH
         PUSH  DPL

     MOV   DPTR,#7F0BH          ;设置寄存器B，时钟芯片停止工作
	 MOV   A,#82H				; 82H=1000 0010 
	 MOVX  @DPTR,A              ; 设置寄存器B


	 MOV   DPTR,#7F00H          ;新秒
	 MOV   A,30H
	 MOVX  @DPTR,A

	 MOV   DPTR,#7F02H          ;新分
	 MOV   A,31H
	 MOVX  @DPTR,A

         MOV   DPTR,#7F04H          ;新时
	 MOV   A,32H
         MOVX  @DPTR,A

         MOV   DPTR,#7F06H          ;新星期
	 MOV   A,33H
         MOVX  @DPTR,A

         MOV   DPTR,#7F07H          ;新日
	 MOV   A,34H
         MOVX  @DPTR,A

         MOV   DPTR,#7F08H          ;新月
	 MOV   A,35H
         MOVX  @DPTR,A

         MOV   DPTR,#7F09H          ;新年低位
	 MOV   A,36H
         MOVX  @DPTR,A  
		  
         MOV   DPTR,#7F0EH          ;新年高位
	 MOV   A,37H
         MOVX  @DPTR,A   


         MOV   DPTR,#7F0AH          ;寄存器A设置
	     MOV   A,#20H					;20H=0010 0000  书本165页
         MOVX  @DPTR,A

         MOV   DPTR,#7F0CH          ;读寄存器C
         MOVX  A,@DPTR
         MOV   DPTR,#070DH          ;读寄存器D
         MOVX  A,@DPTR

         MOV   DPTR,#7F0BH          ;重现设置寄存器B，使时钟芯片开始工作（SET位置0）
         MOV   A,#12H				;12H=0001 0010
         MOVX  @DPTR,A

         POP  DPL
         POP  DPH
         POP  ACC
         RET       ;回到进入退出中的OUT子程序


;/************************中断读时钟******************************/	 key按键按下后触发中断

DS12887: CLR   EX0                  ;关闭T0的1ms中断
         CLR   EA     
		              
         PUSH  ACC			  
         PUSH  PSW			  
         PUSH  DPH
         PUSH  DPL 	    
		        
         CLR   PSW.3			
         SETB  PSW.4      	    ;工作寄存器状态选择10，防止地址冲突

	 MOV   DPTR,#7F00H          ;读秒寄存器并存在30H单元
	 MOVX  A,@DPTR
	 MOV   30H,A
	 MOV   DPTR,#7F02H          ;读分寄存器并存在31H单元
	 MOVX  A,@DPTR
	 MOV   31H,A
	 MOV   DPTR,#7F04H          ;读小时寄存器并存在32H单元
	 MOVX  A,@DPTR
	 MOV   32H,A
	 MOV   DPTR,#7F06H          ;读星期寄存器并存在33H单元
	 MOVX  A,@DPTR
	 MOV   33H,A
     MOV   DPTR,#7F07H          ;读日寄存器并存在34H单元
	 MOVX  A,@DPTR
	 MOV   34H,A
	 MOV   DPTR,#7F08H          ;读月寄存器并存在35H单元
	 MOVX  A,@DPTR
	 MOV   35H,A	 
     MOV   DPTR,#7F09H          ;读年低位寄存器并存在36H单元
	 MOVX  A,@DPTR
	 MOV   36H,A
	 MOV   DPTR,#7F0EH          ;读年高位寄存器并存在37H单元
     MOVX  A,@DPTR
	 MOV   37H,A

	 MOV   DPTR,#7F0CH          ;读寄存器C（中断组合判断）
     MOVX  A,@DPTR    
		   
         SETB  EA                   ;允许中断
	     SETB  EX0

	     POP   DPL
         POP   DPH
         POP   PSW
         POP   ACC 	            
         RETI

;/************************中断显示******************************/ 
;定时器T0中断 一毫秒触发中断一次
DISPLAY: PUSH  ACC                  
         PUSH  PSW

         CLR   PSW.4
         SETB  PSW.3                ;选择工作状态01，防止地址冲突

	 CLR   EA                   ;关闭中断
	 CLR   TR0

	 MOV   TL0,#17H             ;定时器重新初始值
     MOV   TH0,#0FCH

     LCALL BUFFER               ;处理缓冲区内的内容，将八个地址30H-37H里的时间数据拆开存储在16个地址里40H-4FH，秒分时星期在40H-47H，日月年在48H-4FH

	 MOV   R0,#40H              ;显示内容段码的存放的首地址
	 MOV   A,60H                ;60H为显示标志位存储的地址
	 ADD   A,R0                 ;60H里的内容（00H-时间，08H-日期，10H-电压）和40H相加，找到首地址（即拆分后的地址）
	 MOV   R0,A                 ;40-47H在SBUFF中存放时间,48H-4F中存放日期，50H存放电压，这时R0存了 拆分后的 时分秒 地址

	 MOV   R7,#80H              ;通过R7设置位码，1为有效   80H=10000000B

	 MOV   A,61H                ;61H为闪烁间隔时间标志位（初始值为00H）
     INC   A
	 MOV   61H,A
     CJNE  A,#20H,SHINE        ;判断61H的值有没有到20H;若A不为20H则跳转到SHINE;间隔时间到，亮灭进行转换 
         
         MOV   A,62H                ;亮灭状态控制，存放在62H中（00H表示暗，FFH为亮）
         XRL   A,#0FFH              ;与1异或，按位取反，亮灭转换，即00H变为FFH,FFH变为00H（20次执行亮，20次执行暗）
         MOV   62H,A
         MOV   61H,#00H             ;将61H重新清零（为下一给20次准备）61H为闪烁间隔时间标志位（初始值为00H）

SHINE:   MOV   A,62H				;亮灭状态控制标志位62H 
	     CJNE  A,#00H,ON            ;62H不为00H时即为0FFH，跳转到ON
         CJNE  A,#0FFH,OFF          ;62H不为0FFH时即为00H，跳转到OFF 
         

ON:  MOV   A,R7              ;位码送A 这时R7存了位码

	 MOV   DPTR,#0DFFFH         ;位码寄存器0DFFFH 的地址
	 MOVX  @DPTR,A              ;位码输出到位码寄存器

	 MOV   A,@R0                ;段码送A 拆开后的内容 发送到A  这时R0存了 拆分后的 时分秒 地址
	 MOV   DPTR,#TAB            
	 MOVC  A,@A+DPTR			;查表得到显示时分秒内容的代码 即要要显示的断码

	 MOV   DPTR,#0BFFFH         ;段码寄存器0BFFFH
	 MOVX  @DPTR,A              ;段码输出到段码寄存器

	 LCALL DL1MS                ;调用1ms延迟
 
         MOV   A,R7
         RR    A                 ;改变位码，若R7本来是10000000则变成01000000，即选中第二位
         MOV   R7,A              ;指向下一个位码
		 INC   R0                ;显示内容换下一个

         CJNE  A,#80H,ON            ;一次循环未完成，则显示下一位。 80H= 10000000

         SETB  TR0
         SETB  EA
         POP   PSW
         POP   ACC
         RETI

OFF: MOV   A,R7              ;位码送A
	 ANL   A,63H                ;当未进入设置状态时，63H为1111 1111，这时与ON功能相同，进入设置时，63H有两位为0，在off程序中它不亮20ms最终实现闪烁功能；
	 MOV   DPTR,#0DFFFH         ;取位码口地址
	 MOVX  @DPTR,A              ;位码口输出位码
	 MOV   A,@R0                ;段码送A
	 MOV   DPTR,#TAB            ;查表得到显示段码
	 MOVC  A,@A+DPTR
	 MOV   DPTR,#0BFFFH         ;取段码口地址
	 MOVX  @DPTR,A              ;段码口输出段码
	 LCALL DL1MS                ;调用1ms延迟
	 INC   R0                   ;指向下一个显示单元 
         MOV   A,R7
         RR    A
         MOV   R7,A                 ;指向下一个位码
         CJNE  A,#80H,OFF           ;一次循环未完成，则显示下一位
         SETB  TR0               ;开T0，为下一个1ms准备
         SETB  EA
         POP   PSW
         POP   ACC
         RETI


;/**********************缓冲区数据处理**************************/ 把八个地址里的数据拆开存储在16个地址里

BUFFER:  MOV   R0,#40H              ;缓冲区的首地址
	 	 MOV   R1,#30H              ;拆字，将30H-37H的内容放到40H-47H时间，48H-4F日期中
	 	 MOV   R7,#08H              ;LOOP总共循环R7次

LOOP1:   MOV   A,@R1				;30H-37H  存储了秒分时星期日月年
	     ANL   A,#0FH				;屏蔽高四位
         MOV   @R0,A				;即实现把 存储内容地址的东西 转存在了40H开始之后的地址里
     
	 INC   R0
	 MOV   A,@R1
	 ANL   A,#0F0H					;屏蔽低四位
	 SWAP  A						;交换高低四位
	 MOV   @R0,A					;即实现把 存储内容地址的东西 转存在了40H开始之后的地址里

	 INC   R0
	 INC   R1
     DJNZ  R7,LOOP1             ;全部内容转换未完成，则继续循环
         RET

;/************************中断读电压值******************************/ 外部中断1 

VOLTAGE: CLR   TR1                            
         CLR   EA
         PUSH  ACC
         PUSH  PSW

         SETB  PSW.3                ;设置寄存器工作组为11，防止冲突
         SETB  PSW.4

         MOV   A,TL1				; 低位提取
         SUBB  A,#10H	            ;计数器1读取的计数值减10000（2710H）  书本P44 SUBB 减法指令
         MOV   R7,A					;低位结果存在R7

         MOV   A,TH1               	; 高位提取
         SUBB  A,#27H				; 减高位27H
         MOV   R6,A					;高位结果存在R6

         MOV   TL1,#0
         MOV   TH1,#0				;计时器清零

         LCALL CHANGE		 	    ;调用十六进制转十进制程序，即现在R3 4 5存了当前电压值
         LCALL VDISPLAY             ;对转换后的电压值进行处理
         POP   PSW
         POP   ACC
         SETB  EA
         SETB  TR1
         RETI

;/**********************十六进制转十进制程序********************/

CHANGE:  CLR   A	             ;十六进制转十进制BCD
         MOV   R3,A 
         MOV   R4,A
         MOV   R5,A
         MOV   R2,#10H			 ;循环10次
LOOP2:   MOV   A,R7				 ;R7电压低位结果
         RLC   A	             ;带位左移
         MOV   R7,A

         MOV   A,R6				 ;R6电压高位结果
         RLC   A				 ;带位左移
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

         DJNZ  R2,LOOP2			  ;循环10次
         RET 

;/**********************电压值的处理*****************************/

VDISPLAY:PUSH  PSW
         SETB  PSW.3                  ;设置寄存器工作组为11，防止冲突
         SETB  PSW.4   
		                 
         MOV   55H,#0BH               ;0BH=0000 1011B
         JB    P1.7,CHAIZI            ;判断电压是否为负（P1.7是POL）书本P171 连接到7135AD转换器的27脚
         MOV   55H,#0AH				  ;0BH=0000 1010B

CHAIZI:  MOV   57H,#0BH
	     MOV   56H,#0BH  	     ;从左到右，第一二位不显示 

         MOV   R1,#50H				 ;50H=40H+10H，即拆分后电压数据存储的首地址
		 ;将R5拆分 存到两个地址	
         MOV   A,R5                  ;末两位拆字处理						 
         ANL   A,#0FH	             ;除去R5中高四位       
         MOV   @R1,A				 ;剩下低四位存在 首地址及其之后的地址中
         INC   R1        
         MOV   A,R5
         ANL   A,#0F0H				 ;除去R5中低四位  
         SWAP  A
         MOV   @R1,A				 ;剩下高四位存在 首地址及其之后的地址中

         INC   R1
         MOV   A,R4                  ;将R4拆分 存到两个地址	五、六位拆字处理
         ANL   A,#0FH	                     
         MOV   @R1,A
         INC   R1 
         MOV   A,R4
         ANL   A,#0F0H
         SWAP  A
         MOV   @R1,A

         INC   R1
         MOV   A,R3                  ;从左到右，第三位、第四位不用拆字，直接查表   ？？？？            
         ADD   A,#0CH	           	 ;加上C后 数码管上的点就可以被点亮
         MOV   @R1,A 
         POP   PSW
         RET  

;/************************查表及延迟程序******************************/

DL1MS:   MOV   R6,#250              ;1ms延时程序
DLT:     NOP
	     NOP
         DJNZ  R6,DLT
         RET 

DL10MS:  MOV R6,#0FFH               ;10ms延时程序
DL41T:	 MOV R5,#8H
DL40T:   NOP
         NOP
         DJNZ R5,DL40T
         DJNZ R6,DL41T
         RET  

 
TAB:     DB 5FH,06H,3BH,2FH,66H     ;段码表
         DB 6DH,7DH,07H,7FH,6FH
         DB 20H,00H,0DFH,86H          
END  
 
                                           