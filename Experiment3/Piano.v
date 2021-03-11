//乔毅 2019210472

module Piano(ROW,COL_RED,COL_GREEN,CLK,Switch,Key,Beep,SEG,SEG_Neg);
	//LED控制输出
	output wire [7:0] ROW,COL_RED,COL_GREEN;
	//蜂鸣器输出
	output wire Beep;
	//数位管阳极a~g
	output wire [6:0] SEG;
	//数位管共阴极
	output wire [7:0] SEG_Neg;
	//时钟信号 10MHz
	input CLK;
	//开关用于切换低中高音和自动演奏
	input [3:0] Switch;
	//按键用于发声控制
	input [6:0] Key;
	//中间变量——自动演奏输出
	wire [6:0] KeyState_Au;
	//控制信号
	wire [6:0] KeyState;
	//Counter 用于计数，实现模8计数功能
	wire [2:0] Counter;
	
	//自动演奏和手动演奏切换
	assign KeyState = (Switch == 4'b1000)? KeyState_Au : Key;
	
	AutoMode m1(CLK,Key,KeyState_Au,Switch);
	Mod8Counter m2(Counter,CLK);
	ARKPrinter m3(ROW,COL_RED,COL_GREEN,Counter,Switch,KeyState);
	Beeper m4(CLK,KeyState,Beep,Switch);
	SEGPrinter m5(KeyState,SEG,SEG_Neg);
endmodule

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
	
	//LED状态数组
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
	
	
	//按下按钮时改变LED状态数组值
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
	
	
	
	//行扫描成像
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
		//Mid and Auto
		else if(Switch == 4'b0010 || Switch == 4'b1000) begin
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
		//Low
		else if(Switch == 4'b0001) begin
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

endmodule

//蜂鸣器
module Beeper(CLK,KeyState,Beep,Switch);
	input CLK;
	input [6:0] KeyState;
	input [3:0] Switch;
	
	output reg Beep;
	
	reg [19:0] f;
	reg [19:0] Counter;
	
	initial begin
		Beep <= 1'b0;
		f <= 19'h0;
		Counter <= 19'h0;
	end
	
	//计数
	always@(posedge CLK) begin
	
	//信号输出
		if(f == 1'b0) begin
			Beep = 1'b0;
			Counter = 19'b0;
		end
		else if(Counter == f) begin
			Counter <= 19'b0;
			Beep <= ~Beep;
		end
		else begin
			Counter <= Counter + 1'b1;
			Beep <= Beep;
		end
	end
	
	always@(KeyState,Switch) begin
		//低音
		if(Switch == 4'b0001) begin
			case(KeyState)
				7'b1000000 : f <= 19'h4aa6;
				7'b0100000 : f <= 19'h4281;
				7'b0010000 : f <= 19'h3b40;
				7'b0001000 : f <= 19'h37ed;
				7'b0000100 : f <= 19'h31d3;
				7'b0000010 : f <= 19'h2c63;
				7'b0000001 : f <= 19'h278b;
				default : f <= 19'b0;
			endcase
		end
		//中音和自动演奏
		else if(Switch == 4'b0010 || Switch == 4'b1000) begin
			case(KeyState)
				7'b1000000 : f <= 19'h2553;
				7'b0100000 : f <= 19'h2141;
				7'b0010000 : f <= 19'h1da0;
				7'b0001000 : f <= 19'h1bf6;
				7'b0000100 : f <= 19'h18e9;
				7'b0000010 : f <= 19'h1631;
				7'b0000001 : f <= 19'h13c5;
				default : f <= 19'b0;
			endcase
		end
		//高音
		else if(Switch == 4'b0100) begin
			case(KeyState)
				7'b1000000 : f <= 19'h12a9;
				7'b0100000 : f <= 19'h10a0;
				7'b0010000 : f <= 19'hed0;
				7'b0001000 : f <= 19'hdfb;
				7'b0000100 : f <= 19'hc74;
				7'b0000010 : f <= 19'hb18;
				7'b0000001 : f <= 19'h9e2;
				default : f <= 19'b0;
			endcase
		end
		else begin
			f <= 19'h0;
		end
	end
endmodule

//数码管显示
module SEGPrinter(KeyState,SEG,SEG_Neg);
	input [6:0] KeyState;
	
	output reg [6:0] SEG;
	output reg [7:0] SEG_Neg;
	
	always@(KeyState) begin
			case(KeyState)
				7'b1000000 : SEG <= 7'b0110000;//1
				7'b0100000 : SEG <= 7'b1101101;//2
				7'b0010000 : SEG <= 7'b1111001;//3
				7'b0001000 : SEG <= 7'b0110011;//4
				7'b0000100 : SEG <= 7'b1011011;//5
				7'b0000010 : SEG <= 7'b1011111;//6
				7'b0000001 : SEG <= 7'b1110000;//7
				default : SEG <= 7'b0000000;//无
			endcase
		//阴极只有7号数位管为低电平
		SEG_Neg <= 8'b01111111;
	end
endmodule

//自动演奏
module AutoMode(CLK,Key,KeyState,Switch);
	input CLK;
	input [3:0] Switch;
	input [6:0] Key;
	
	output reg [6:0] KeyState;
	
	//计拍
	reg [4:0] BeatsCounter;
	initial BeatsCounter = 5'b00000;
	//计时
	reg [29:0] Timer;
	
	//计时0.25s一拍（包括空拍）
	always@(posedge CLK) begin
		if(Timer == 30'h2625A0) begin
			Timer <= 30'h0;
			if(BeatsCounter == 5'b11111) begin
				BeatsCounter = 5'b00000;
			end
			else begin
				BeatsCounter = BeatsCounter + 1'b1;
			end
		end
		else begin
			Timer <= Timer + 1'b1;
		end
	end
	
	
	//自动演奏
	always@(*) begin
		if(Switch == 4'b1000) begin
			case(BeatsCounter)
				5'b00000 : KeyState <= 7'b1000000;
				5'b00001 : KeyState <= 7'b0000000; 
				5'b00010 : KeyState <= 7'b1000000; 
				5'b00011 : KeyState <= 7'b0000000; 
				5'b00100 : KeyState <= 7'b0000100; 
				5'b00101 : KeyState <= 7'b0000000; 
				5'b00110 : KeyState <= 7'b0000100; 
				5'b00111 : KeyState <= 7'b0000000; 
				5'b01000 : KeyState <= 7'b0000010; 
				5'b01001 : KeyState <= 7'b0000000;
				5'b01010 : KeyState <= 7'b0000010; 
				5'b01011 : KeyState <= 7'b0000000; 
				5'b01100 : KeyState <= 7'b0000100; 
				5'b01101 : KeyState <= 7'b0000100; 
				5'b01110 : KeyState <= 7'b0000000; 
				5'b01111 : KeyState <= 7'b0000000;
				5'b10000 : KeyState <= 7'b0001000;
				5'b10001 : KeyState <= 7'b0000000;
				5'b10010 : KeyState <= 7'b0001000;
				5'b10011 : KeyState <= 7'b0000000;
				5'b10100 : KeyState <= 7'b0010000;
				5'b10101 : KeyState <= 7'b0000000;
				5'b10110 : KeyState <= 7'b0010000;
				5'b10111 : KeyState <= 7'b0000000;
				5'b11000 : KeyState <= 7'b0100000;
				5'b11001 : KeyState <= 7'b0000000;
				5'b11010 : KeyState <= 7'b0100000;
				5'b11011 : KeyState <= 7'b0000000;
				5'b11100 : KeyState <= 7'b1000000;
				5'b11101 : KeyState <= 7'b1000000;
				5'b11110 : KeyState <= 7'b0000000;
				5'b11111 : KeyState <= 7'b0000000;
				default : KeyState <= 7'b0000000;
			endcase
		end
	end
endmodule

