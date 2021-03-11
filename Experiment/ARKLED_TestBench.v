`timescale 1ms/1ms

module ARKLED_TestBench;
	
	reg CLK;
	
	wire [7:0] ROW;
	wire [7:0] COL_RED;
	wire [7:0] COL_GREEN;
	
	ARKLED u1(
		.ROW(ROW),
		.COL_RED(COL_RED),
		.COL_GREEN(COL_GREEN),
		.CLK(CLK)
		);
 
	initial begin
		CLK = 1'b0;
	end
	always begin
		#100
		CLK = ~CLK;
	end
	
endmodule
