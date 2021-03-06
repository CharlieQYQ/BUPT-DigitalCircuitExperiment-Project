// 第一次验收 点亮LED矩阵
//2020.11.15

module ARKLEDWithSwitchAndKeys(ROW,COL_RED,COL_GREEN,CLK,Switch,Key);
	output wire [7:0] ROW,COL_RED,COL_GREEN;
	input CLK;
	//开关用于切换低中高音和自动演奏
	input [3:0] Switch;
	//按键用于发声控制
	input [6:0] Key;
	//消抖后信号输出
	wire [7:0] KeyState;
	
	//Counter 用于计数，实现模8计数功能
	wire [2:0] Counter;
	
	Debounce m1(CLK,Key,KeyState);
	Mod8Counter m2(Counter,CLK);
	ARKPrinter m3(ROW,COL_RED,COL_GREEN,Counter,Switch,KeyState);
endmodule

module Debounce(CLK,Key,KeyState);
	input CLK;
	input [6:0] Key;
	
	output wire [6:0] KeyState;
	
	reg TimeCounter_Full;
	reg [19:0] TimeCounter;
	
	//计时器循环
	always@(posedge CLK) begin
		if(TimeCounter == 20'd999_999) begin
			TimeCounter <= 20'd0;
		end
		else begin
			TimeCounter <= TimeCounter + 1'b1;
		end
	end
	//计时器满判断
	always@(posedge CLK) begin
		if(TimeCounter == 20'd999_999) begin
			TimeCounter_Full <= 1'b1;
		end
		else begin
			TimeCounter_Full <= 1'b0;
		end
	end
	//取前后信号
	reg [6:0] Key_State;
	reg [6:0] Key_State_Next;
	always@(posedge CLK) begin
		if(TimeCounter_Full == 1'b1) begin
			Key_State_Next <= Key;
		end
		else begin
			Key_State_Next <= Key_State_Next;
		end
	end
	always@(posedge CLK) begin
		Key_State <= Key_State_Next;
	end
	
	assign KeyState = Key_State & (~Key_State_Next);
	
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
		//Auto
		if(Switch == 4'b1000) begin
			
		end
		//High
		else if(Switch == 4'b0100) begin
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
