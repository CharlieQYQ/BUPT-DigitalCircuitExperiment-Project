// 第一次验收 点亮LED矩阵
//2020.11.15

module ARKLED(ROW,COL_RED,COL_GREEN,CLK);
	output wire [7:0] ROW,COL_RED,COL_GREEN;
	input CLK;
	
	//Counter 用于计数，实现模8计数功能
	wire [2:0] Counter;
	
	/*
	initial begin
		SetLEDState m1(CLK);
	end
	*/
	
	Mod8Counter m2(Counter,CLK);
	ARKPrinter m3(ROW,COL_RED,COL_GREEN,Counter);
endmodule

/*
//LED状态数组（尝试链接之后的功能）
module SetLEDState(CLK);
	input CLK;
	
	parameter [7:0] LEDState_ROW [7:0];
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

	parameter [7:0] LEDState_COL_RED [7:0];
	initial begin
		LEDState_COL_RED[0] = 8'b0000_0000;
		LEDState_COL_RED[1] = 8'b0000_0010;
		LEDState_COL_RED[2] = 8'b0000_0110;
		LEDState_COL_RED[3] = 8'b0000_1110;
		LEDState_COL_RED[4] = 8'b0001_1110;
		LEDState_COL_RED[5] = 8'b0011_1110;
		LEDState_COL_RED[6] = 8'b0111_1110;
		LEDState_COL_RED[7] = 8'b1111_1110;
	end

	parameter [7:0] LEDState_COL_GREEN [7:0];
	initial begin
		LEDState_COL_GREEN[0] = 8'b0000_0000;
		LEDState_COL_GREEN[1] = 8'b0000_0010;
		LEDState_COL_GREEN[2] = 8'b0000_0110;
		LEDState_COL_GREEN[3] = 8'b0000_1110;
		LEDState_COL_GREEN[4] = 8'b0001_1110;
		LEDState_COL_GREEN[5] = 8'b0011_1110;
		LEDState_COL_GREEN[6] = 8'b0111_1110;
		LEDState_COL_GREEN[7] = 8'b1111_1110;
	end

	parameter [7:0] ZeroBits;
	initial begin
		ZeroBits = 8'b0000_0000;
	end
	
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
module ARKPrinter(ROW,COL_RED,COL_GREEN,Counter);
	output reg [7:0] ROW,COL_RED,COL_GREEN;
	
	input [2:0] Counter;
	
	/*
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
		LEDState_COL_RED[1] = 8'b0000_0010;
		LEDState_COL_RED[2] = 8'b0000_0110;
		LEDState_COL_RED[3] = 8'b0000_1110;
		LEDState_COL_RED[4] = 8'b0001_1110;
		LEDState_COL_RED[5] = 8'b0011_1110;
		LEDState_COL_RED[6] = 8'b0111_1110;
		LEDState_COL_RED[7] = 8'b1111_1110;
	end

	reg [7:0] LEDState_COL_GREEN [7:0];
	initial begin
		LEDState_COL_GREEN[0] = 8'b0000_0000;
		LEDState_COL_GREEN[1] = 8'b0000_0010;
		LEDState_COL_GREEN[2] = 8'b0000_0110;
		LEDState_COL_GREEN[3] = 8'b0000_1110;
		LEDState_COL_GREEN[4] = 8'b0001_1110;
		LEDState_COL_GREEN[5] = 8'b0011_1110;
		LEDState_COL_GREEN[6] = 8'b0111_1110;
		LEDState_COL_GREEN[7] = 8'b1111_1110;
	end

	reg [7:0] ZeroBits;
	initial begin
		ZeroBits = 8'b0000_0000;
	end
	
	always@(Counter)begin
		case(Counter)
		3'b111 : begin ROW <= LEDState_ROW[0]; COL_RED <=	LEDState_COL_RED[0]; COL_GREEN <= ZeroBits; end
		3'b110 : begin ROW <= LEDState_ROW[1]; COL_RED <=	LEDState_COL_RED[1]; COL_GREEN <= ZeroBits; end
		3'b101 : begin ROW <= LEDState_ROW[2]; COL_RED <=	LEDState_COL_RED[2]; COL_GREEN <= ZeroBits; end
		3'b100 : begin ROW <= LEDState_ROW[3]; COL_RED <=	LEDState_COL_RED[3]; COL_GREEN <= ZeroBits; end
		3'b011 : begin ROW <= LEDState_ROW[4]; COL_RED <=	LEDState_COL_RED[4]; COL_GREEN <= ZeroBits; end
		3'b010 : begin ROW <= LEDState_ROW[5]; COL_RED <=	LEDState_COL_RED[5]; COL_GREEN <= ZeroBits; end
		3'b001 : begin ROW <= LEDState_ROW[6]; COL_RED <=	LEDState_COL_RED[6]; COL_GREEN <= ZeroBits; end
		3'b000 : begin ROW <= LEDState_ROW[7]; COL_RED <=	LEDState_COL_RED[7]; COL_GREEN <= ZeroBits; end
		endcase
	end
	*/
	
	always@(Counter)begin
		case(Counter)
		3'b111 : begin ROW <= 8'b01111111; COL_RED <=	8'b00000000; COL_GREEN <= 8'b00000000; end
		3'b110 : begin ROW <= 8'b10111111; COL_RED <=	8'b00000010; COL_GREEN <= 8'b00000010; end
		3'b101 : begin ROW <= 8'b11011111; COL_RED <=	8'b00000110; COL_GREEN <= 8'b00000110; end
		3'b100 : begin ROW <= 8'b11101111; COL_RED <=	8'b00001110; COL_GREEN <= 8'b00001110; end
		3'b011 : begin ROW <= 8'b11110111; COL_RED <=	8'b00011110; COL_GREEN <= 8'b00011110; end
		3'b010 : begin ROW <= 8'b11111011; COL_RED <=	8'b00111110; COL_GREEN <= 8'b00111110; end
		3'b001 : begin ROW <= 8'b11111101; COL_RED <=	8'b01111110; COL_GREEN <= 8'b01111110; end
		3'b000 : begin ROW <= 8'b11111110; COL_RED <=	8'b11111110; COL_GREEN <= 8'b11111110; end
		endcase
	end
	
endmodule
