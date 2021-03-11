// 第一次验收 点亮LED矩阵
//2020.11.15

module ARKLED_Switch_Keys(ROW,COL_RED,COL_GREEN,CLK,Switch,Key,Beep,SEG,SEG_Neg);
	//LED控制输出
	output wire [7:0] ROW,COL_RED,COL_GREEN;
	//蜂鸣器输出
	output wire Beep;
	//数位管阳极a~g
	output wire [6:0] SEG;
	//数位管共阴极
	output wire [7:0] SEG_Neg;
	//时钟信号 1MHz
	input CLK;
	//开关用于切换低中高音和自动演奏
	input [3:0] Switch;
	//按键用于发声控制
	input [6:0] Key;
	
	//信号输出
	wire [6:0] KeyState;
	//Counter 用于计数，实现模8计数功能
	wire [2:0] Counter;
	
	/*
	assign KeyState = Key;
	*/
	/*
	Debounce m1(CLK,Key,KeyState);
	*/
	AutoMode m1(CLK,Key,KeyState,Switch);
	Mod8Counter m2(Counter,CLK);
	ARKPrinter m3(ROW,COL_RED,COL_GREEN,Counter,Switch,KeyState);
	Beeper m4(CLK,KeyState,Beep,Switch);
	SEGPrinter m5(KeyState,SEG,SEG_Neg);
	
	
	
endmodule

/*
//按键消抖
module Debounce(CLK,Key,KeyState);
	input	CLK;
	input [6:0] Key;                        //输入的按键					
	output [6 :0] KeyState;                  //按键动作产生的脉冲	
 
	reg [6:0] Key_rst_pre;                //定义一个寄存器型变量存储上一个触发时的按键值
	reg [6:0] Key_rst;                    //定义一个寄存器变量储存储当前时刻触发的按键值
 
	wire [6:0] Key_edge;                   //检测到按键由高到低变化是产生一个高脉冲
 
	//利用非阻塞赋值特点，将两个时钟触发时按键状态存储在两个寄存器变量中
	always@(posedge CLK) begin
		Key_rst <= Key;                     //第一个时钟上升沿触发之后key的值赋给key_rst,同时key_rst的值赋给key_rst_pre
		Key_rst_pre <= Key_rst;             //非阻塞赋值。相当于经过两个时钟触发，key_rst存储的是当前时刻key的值，key_rst_pre存储的是前一个时钟的key的值   
	end
	assign Key_edge = Key_rst_pre & (~Key_rst);//脉冲边沿检测。当key检测到下降沿时，key_edge产生一个时钟周期的高电平
 
	reg [20:0] TimeCounter;                       //产生延时所用的计数器，系统时钟12MHz，要延时20ms左右时间，至少需要18位计数器     
 
	//产生20ms延时，当检测到key_edge有效是计数器清零开始计数
	always@(posedge CLK) begin
		if(Key_edge)
			TimeCounter <= 20'h0;
		else
			TimeCounter <= TimeCounter + 1'h1;
	end  
 
	reg     [6:0]   Key_sec_pre;                //延时后检测电平寄存器变量
	reg     [6:0]   Key_sec;                    
 
 
	//延时后检测key，如果按键状态变低产生一个时钟的高脉冲。如果按键状态是高的话说明按键无效
	always@(posedge CLK) begin
		if (TimeCounter==20'h3ffff)
			Key_sec <= Key;  
	end
	always@(posedge CLK) begin               
		Key_sec_pre <= Key_sec;             
	end      
	assign  KeyState = Key_sec_pre & (~Key_sec);
	
endmodule
*/

//模8计数模块
module Mod8Counter(Counter,CLK);
	output reg [2:0] Counter;
	
	input CLK;
	
	//实现模8计数器功能
	always@(posedge CLK)begin
		if(Counter == 3'b111)begin
			Counter <= 3'b000;
		end
		else begin
			Counter <= Counter + 1'b1;
		end
	end
endmodule

//LED点阵模块
module ARKPrinter(ROW,COL_RED,COL_GREEN,Counter,Switch,KeyState);
	output reg [7:0] ROW,COL_RED,COL_GREEN;
	
	input [2:0] Counter;
	input [3:0] Switch;
	
	input [6:0] KeyState;
	
	
	//LED状态数组（尝试链接之后的功能）
	reg [7:0] LEDState_ROW [7:0];
	initial begin
		LEDState_ROW[0] = 8'b0111_1111;
		LEDState_ROW[1] = 8'b1011_1111;
		LEDState_ROW[2] = 8'b1101_1111;
		LEDState_ROW[3] = 8'b1110_1111;
		LEDState_ROW[4] = 8'b1111_0111;
		LEDState_ROW[5] = 8'b1111_1011;
		LEDState_ROW[6] = 8'b1111_1101;
		LEDState_ROW[7] = 8'b1111_1110;
	end

	reg [7:0] LEDState_COL_RED [7:0];
	initial begin
		LEDState_COL_RED[0] = 8'b0000_0000;
		LEDState_COL_RED[1] = 8'b0100_0000;
		LEDState_COL_RED[2] = 8'b0110_0000;
		LEDState_COL_RED[3] = 8'b0111_0000;
		LEDState_COL_RED[4] = 8'b0111_1000;
		LEDState_COL_RED[5] = 8'b0111_1100;
		LEDState_COL_RED[6] = 8'b0111_1110;
		LEDState_COL_RED[7] = 8'b0111_1111;
	end

	reg [7:0] LEDState_COL_GREEN [7:0];
	initial begin
		LEDState_COL_GREEN[0] = 8'b0000_0000;
		LEDState_COL_GREEN[1] = 8'b0100_0000;
		LEDState_COL_GREEN[2] = 8'b0110_0000;
		LEDState_COL_GREEN[3] = 8'b0111_0000;
		LEDState_COL_GREEN[4] = 8'b0111_1000;
		LEDState_COL_GREEN[5] = 8'b0111_1100;
		LEDState_COL_GREEN[6] = 8'b0111_1110;
		LEDState_COL_GREEN[7] = 8'b0111_1111;
	end

	reg [7:0] ZeroBits;
	initial begin
		ZeroBits = 8'b0000_0000;
	end
	
	//Control LED When Pressing Keys
	always@(KeyState) begin
		//do
		if(KeyState == 7'b1000000) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0111_0000;
			LEDState_COL_RED[4] = 8'b0111_1000;
			LEDState_COL_RED[5] = 8'b0111_1100;
			LEDState_COL_RED[6] = 8'b0111_1110;
			LEDState_COL_RED[7] = 8'b0111_1110;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0111_0000;
			LEDState_COL_GREEN[4] = 8'b0111_1000;
			LEDState_COL_GREEN[5] = 8'b0111_1100;
			LEDState_COL_GREEN[6] = 8'b0111_1110;
			LEDState_COL_GREEN[7] = 8'b0111_1110;
		end
		//re
		else if(KeyState == 7'b0100000) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0111_0000;
			LEDState_COL_RED[4] = 8'b0111_1000;
			LEDState_COL_RED[5] = 8'b0111_1100;
			LEDState_COL_RED[6] = 8'b0111_1100;
			LEDState_COL_RED[7] = 8'b0111_1101;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0111_0000;
			LEDState_COL_GREEN[4] = 8'b0111_1000;
			LEDState_COL_GREEN[5] = 8'b0111_1100;
			LEDState_COL_GREEN[6] = 8'b0111_1100;
			LEDState_COL_GREEN[7] = 8'b0111_1101;
		end
		//mi
		else if(KeyState == 7'b0010000) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0111_0000;
			LEDState_COL_RED[4] = 8'b0111_1000;
			LEDState_COL_RED[5] = 8'b0111_1000;
			LEDState_COL_RED[6] = 8'b0111_1010;
			LEDState_COL_RED[7] = 8'b0111_1011;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0111_0000;
			LEDState_COL_GREEN[4] = 8'b0111_1000;
			LEDState_COL_GREEN[5] = 8'b0111_1000;
			LEDState_COL_GREEN[6] = 8'b0111_1010;
			LEDState_COL_GREEN[7] = 8'b0111_1011;
		end
		//fa
		else if(KeyState == 7'b0001000) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0111_0000;
			LEDState_COL_RED[4] = 8'b0111_0000;
			LEDState_COL_RED[5] = 8'b0111_0100;
			LEDState_COL_RED[6] = 8'b0111_0110;
			LEDState_COL_RED[7] = 8'b0111_0111;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0111_0000;
			LEDState_COL_GREEN[4] = 8'b0111_0000;
			LEDState_COL_GREEN[5] = 8'b0111_0100;
			LEDState_COL_GREEN[6] = 8'b0111_0110;
			LEDState_COL_GREEN[7] = 8'b0111_0111;
		end
		//so
		else if(KeyState == 7'b0000100) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0110_0000;
			LEDState_COL_RED[4] = 8'b0110_1000;
			LEDState_COL_RED[5] = 8'b0110_1100;
			LEDState_COL_RED[6] = 8'b0110_1110;
			LEDState_COL_RED[7] = 8'b0110_1111;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0110_0000;
			LEDState_COL_GREEN[4] = 8'b0110_1000;
			LEDState_COL_GREEN[5] = 8'b0110_1100;
			LEDState_COL_GREEN[6] = 8'b0110_1110;
			LEDState_COL_GREEN[7] = 8'b0110_1111;
		end
		//la
		else if(KeyState == 7'b0000010) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0100_0000;
			LEDState_COL_RED[3] = 8'b0101_0000;
			LEDState_COL_RED[4] = 8'b0101_1000;
			LEDState_COL_RED[5] = 8'b0101_1100;
			LEDState_COL_RED[6] = 8'b0101_1110;
			LEDState_COL_RED[7] = 8'b0101_1111;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0100_0000;
			LEDState_COL_GREEN[3] = 8'b0101_0000;
			LEDState_COL_GREEN[4] = 8'b0101_1000;
			LEDState_COL_GREEN[5] = 8'b0101_1100;
			LEDState_COL_GREEN[6] = 8'b0101_1110;
			LEDState_COL_GREEN[7] = 8'b0101_1111;
		end
		//xi
		else if(KeyState == 7'b0000001) begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0000_0000;
			LEDState_COL_RED[2] = 8'b0010_0000;
			LEDState_COL_RED[3] = 8'b0011_0000;
			LEDState_COL_RED[4] = 8'b0011_1000;
			LEDState_COL_RED[5] = 8'b0011_1100;
			LEDState_COL_RED[6] = 8'b0011_1110;
			LEDState_COL_RED[7] = 8'b0011_1111;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0000_0000;
			LEDState_COL_GREEN[2] = 8'b0010_0000;
			LEDState_COL_GREEN[3] = 8'b0011_0000;
			LEDState_COL_GREEN[4] = 8'b0011_1000;
			LEDState_COL_GREEN[5] = 8'b0011_1100;
			LEDState_COL_GREEN[6] = 8'b0011_1110;
			LEDState_COL_GREEN[7] = 8'b0011_1111;
		end
		//Reset
		else begin
			LEDState_COL_RED[0] = 8'b0000_0000;
			LEDState_COL_RED[1] = 8'b0100_0000;
			LEDState_COL_RED[2] = 8'b0110_0000;
			LEDState_COL_RED[3] = 8'b0111_0000;
			LEDState_COL_RED[4] = 8'b0111_1000;
			LEDState_COL_RED[5] = 8'b0111_1100;
			LEDState_COL_RED[6] = 8'b0111_1110;
			LEDState_COL_RED[7] = 8'b0111_1111;
			
			LEDState_COL_GREEN[0] = 8'b0000_0000;
			LEDState_COL_GREEN[1] = 8'b0100_0000;
			LEDState_COL_GREEN[2] = 8'b0110_0000;
			LEDState_COL_GREEN[3] = 8'b0111_0000;
			LEDState_COL_GREEN[4] = 8'b0111_1000;
			LEDState_COL_GREEN[5] = 8'b0111_1100;
			LEDState_COL_GREEN[6] = 8'b0111_1110;
			LEDState_COL_GREEN[7] = 8'b0111_1111;
		end
	end
	
	
	always@(Counter)begin
		//High
		if(Switch == 4'b0100) begin
			case(Counter)
			3'b111 : begin ROW <= LEDState_ROW[0]; COL_RED <= LEDState_COL_RED[0]; COL_GREEN <= LEDState_COL_GREEN[0]; end
			3'b110 : begin ROW <= LEDState_ROW[1]; COL_RED <= LEDState_COL_RED[1]; COL_GREEN <= LEDState_COL_GREEN[1]; end
			3'b101 : begin ROW <= LEDState_ROW[2]; COL_RED <= LEDState_COL_RED[2]; COL_GREEN <= LEDState_COL_GREEN[2]; end
			3'b100 : begin ROW <= LEDState_ROW[3]; COL_RED <= LEDState_COL_RED[3]; COL_GREEN <= LEDState_COL_GREEN[3]; end
			3'b011 : begin ROW <= LEDState_ROW[4]; COL_RED <= LEDState_COL_RED[4]; COL_GREEN <= LEDState_COL_GREEN[4]; end
			3'b010 : begin ROW <= LEDState_ROW[5]; COL_RED <= LEDState_COL_RED[5]; COL_GREEN <= LEDState_COL_GREEN[5]; end
			3'b001 : begin ROW <= LEDState_ROW[6]; COL_RED <= LEDState_COL_RED[6]; COL_GREEN <= LEDState_COL_GREEN[6]; end
			3'b000 : begin ROW <= LEDState_ROW[7]; COL_RED <= LEDState_COL_RED[7]; COL_GREEN <= LEDState_COL_GREEN[7]; end
			endcase
		end
		//Mid
		else if(Switch == 4'b0010) begin
			case(Counter)
			3'b111 : begin ROW <= LEDState_ROW[0]; COL_RED <= LEDState_COL_RED[0]; COL_GREEN <= ZeroBits; end
			3'b110 : begin ROW <= LEDState_ROW[1]; COL_RED <= LEDState_COL_RED[1]; COL_GREEN <= ZeroBits; end
			3'b101 : begin ROW <= LEDState_ROW[2]; COL_RED <= LEDState_COL_RED[2]; COL_GREEN <= ZeroBits; end
			3'b100 : begin ROW <= LEDState_ROW[3]; COL_RED <= LEDState_COL_RED[3]; COL_GREEN <= ZeroBits; end
			3'b011 : begin ROW <= LEDState_ROW[4]; COL_RED <= LEDState_COL_RED[4]; COL_GREEN <= ZeroBits; end
			3'b010 : begin ROW <= LEDState_ROW[5]; COL_RED <= LEDState_COL_RED[5]; COL_GREEN <= ZeroBits; end
			3'b001 : begin ROW <= LEDState_ROW[6]; COL_RED <= LEDState_COL_RED[6]; COL_GREEN <= ZeroBits; end
			3'b000 : begin ROW <= LEDState_ROW[7]; COL_RED <= LEDState_COL_RED[7]; COL_GREEN <= ZeroBits; end
			endcase
		end
		//Low and Auto
		else if(Switch == 4'b0001 || Switch == 4'b1000) begin
			case(Counter)
			3'b111 : begin ROW <= LEDState_ROW[0]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[0]; end
			3'b110 : begin ROW <= LEDState_ROW[1]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[1]; end
			3'b101 : begin ROW <= LEDState_ROW[2]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[2]; end
			3'b100 : begin ROW <= LEDState_ROW[3]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[3]; end
			3'b011 : begin ROW <= LEDState_ROW[4]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[4]; end
			3'b010 : begin ROW <= LEDState_ROW[5]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[5]; end
			3'b001 : begin ROW <= LEDState_ROW[6]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[6]; end
			3'b000 : begin ROW <= LEDState_ROW[7]; COL_RED <= ZeroBits; COL_GREEN <= LEDState_COL_GREEN[7]; end
			endcase
		end
		//Zero
		else begin
			case(Counter)
			3'b111 : begin ROW <= LEDState_ROW[0]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b110 : begin ROW <= LEDState_ROW[1]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b101 : begin ROW <= LEDState_ROW[2]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b100 : begin ROW <= LEDState_ROW[3]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b011 : begin ROW <= LEDState_ROW[4]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b010 : begin ROW <= LEDState_ROW[5]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b001 : begin ROW <= LEDState_ROW[6]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			3'b000 : begin ROW <= LEDState_ROW[7]; COL_RED <= ZeroBits; COL_GREEN <= ZeroBits; end
			endcase
		end
	end
	
	/*
	always@(Counter)begin
		case(Counter)
		3'b111 : begin ROW <= 8'b01111111; COL_RED <= 8'b00000000; COL_GREEN <= 8'b00000000; end
		3'b110 : begin ROW <= 8'b10111111; COL_RED <= 8'b01000000; COL_GREEN <= 8'b01000000; end
		3'b101 : begin ROW <= 8'b11011111; COL_RED <= 8'b01100000; COL_GREEN <= 8'b01100000; end
		3'b100 : begin ROW <= 8'b11101111; COL_RED <= 8'b01110000; COL_GREEN <= 8'b01110000; end
		3'b011 : begin ROW <= 8'b11110111; COL_RED <= 8'b01111000; COL_GREEN <= 8'b01111000; end
		3'b010 : begin ROW <= 8'b11111011; COL_RED <= 8'b01111100; COL_GREEN <= 8'b01111100; end
		3'b001 : begin ROW <= 8'b11111101; COL_RED <= 8'b01111110; COL_GREEN <= 8'b01111110; end
		3'b000 : begin ROW <= 8'b11111110; COL_RED <= 8'b01111111; COL_GREEN <= 8'b01111111; end
		endcase
	end
	*/
endmodule

//蜂鸣器
module Beeper(CLK,KeyState,Beep,Switch);
	input CLK;
	input [6:0] KeyState;
	input [3:0] Switch;
	
	output reg Beep;
	
	reg [19:0] f;
	reg [3:0] Counter;
	
	initial begin
		Beep <= 1'b0;
		f <= 19'h0;
		Counter <= 19'h0;
	end
	
	//计数
	always@(posedge CLK) begin
		if(Counter == f) begin
			Counter <= 19'b0;
		end
		else begin
			Counter <= Counter + 1'b1;
		end
	end
	
	//计数满翻转Beep
	always@(posedge CLK) begin
		if(Counter == f) begin
			Beep <= ~Beep;
		end
		else begin
			Beep <= Beep;
		end
	end
	
	always@(KeyState,Switch) begin
		//低音
		if(Switch == 4'b0001) begin
			case(KeyState)
				7'b1000000 : f <= 19'b11101110111;
				7'b0100000 : f <= 19'b11010100111;
				7'b0010000 : f <= 19'b10111101101;
				7'b0001000 : f <= 19'b10110011000;
				7'b0000100 : f <= 19'b10011111100;
				7'b0000010 : f <= 19'b10001110000;
				7'b0000001 : f <= 19'b1111110100;
				default : f <= 19'b0;
			endcase
		end
		//中音
		else if(Switch == 4'b0010) begin
			case(KeyState)
				7'b1000000 : f <= 19'b1110111100;
				7'b0100000 : f <= 19'b1110111100;
				7'b0010000 : f <= 19'b1011110110;
				7'b0001000 : f <= 19'b1011001100;
				7'b0000100 : f <= 19'b1001111110;
				7'b0000010 : f <= 19'b1000111000;
				7'b0000001 : f <= 19'b111111010;
				default : f <= 19'b0;
			endcase
		end
		//高音
		else if(Switch == 4'b0100) begin
			case(KeyState)
				7'b1000000 : f <= 19'b111011110;
				7'b0100000 : f <= 19'b110101010;
				7'b0010000 : f <= 19'b101111011;
				7'b0001000 : f <= 19'b101100110;
				7'b0000100 : f <= 19'b100111111;
				7'b0000010 : f <= 19'b100011100;
				7'b0000001 : f <= 19'b11111101;
				default : f <= 19'b0;
			endcase
		end
		//自动演奏
		else if(Switch == 4'b1000) begin
			case(KeyState)
				7'b1000000 : f <= 19'b11101110111;
				7'b0100000 : f <= 19'b11010100111;
				7'b0010000 : f <= 19'b10111101101;
				7'b0001000 : f <= 19'b10110011000;
				7'b0000100 : f <= 19'b10011111100;
				7'b0000010 : f <= 19'b10001110000;
				7'b0000001 : f <= 19'b1111110100;
				default : f <= 19'b0;
			endcase
		end
		else begin
			f <= 19'h0;
		end
	end
endmodule

//数位管显示
module SEGPrinter(KeyState,SEG,SEG_Neg);
	input [6:0] KeyState;
	
	output reg [6:0] SEG;
	output reg [7:0] SEG_Neg;
	
	always@(KeyState) begin
		case(KeyState)
			7'b1000000 : SEG <= 7'b0110000;
			7'b0100000 : SEG <= 7'b1101101;
			7'b0010000 : SEG <= 7'b1111001;
			7'b0001000 : SEG <= 7'b0110011;
			7'b0000100 : SEG <= 7'b1011011;
			7'b0000010 : SEG <= 7'b1011111;
			7'b0000001 : SEG <= 7'b1110000;
			default : SEG <= 7'b0000000;
		endcase
		SEG_Neg <= 8'b01111111;
	end
endmodule

//自动演奏
module AutoMode(CLK,Key,KeyState,Switch);
	input CLK;
	input [3:0] Switch;
	input [6:0] Key;
	
	output reg [6:0] KeyState;
	
	reg [3:0] BeatsCounter;
	
	initial BeatsCounter = 4'b0000;
	
	reg FullBeats;
	reg [19:0] Timer;
	
	//计时0.25s一拍
	always@(posedge CLK) begin
		if(Timer == 20'h3d090) begin
			Timer <= 20'h0;
			FullBeats <= 1'b1;
		end
		else begin
			FullBeats <= 1'b0;
			Timer <= Timer + 1'b1;
		end
	end

	//改变计数器值
	always@(FullBeats) begin
		if(FullBeats == 1'b1) begin
			if(BeatsCounter == 4'b1111) begin
				BeatsCounter = 4'b0000;
			end
			else begin
				BeatsCounter = BeatsCounter + 1'b1;
			end
		end
	end
	
	//是否自动演奏判断
	always@(*) begin
		if(Switch != 4'b1000)begin
			KeyState = Key;
		end
		else begin
			case(BeatsCounter)
				4'b0000 : KeyState <= 7'b1000000;
				4'b0001 : KeyState <= 7'b1000000; 
				4'b0010 : KeyState <= 7'b0000100; 
				4'b0011 : KeyState <= 7'b0000100; 
				4'b0100 : KeyState <= 7'b0000010; 
				4'b0101 : KeyState <= 7'b0000010; 
				4'b0110 : KeyState <= 7'b0000100; 
				4'b0111 : KeyState <= 7'b0000100; 
				4'b1000 : KeyState <= 7'b0001000; 
				4'b1001 : KeyState <= 7'b0001000;
				4'b1010 : KeyState <= 7'b0010000; 
				4'b1011 : KeyState <= 7'b0010000; 
				4'b1100 : KeyState <= 7'b0100000; 
				4'b1101 : KeyState <= 7'b0100000; 
				4'b1110 : KeyState <= 7'b1000000; 
				4'b1111 : KeyState <= 7'b1000000; 
				default : KeyState <= 7'b0000000;
			endcase
		end
	end
endmodule

