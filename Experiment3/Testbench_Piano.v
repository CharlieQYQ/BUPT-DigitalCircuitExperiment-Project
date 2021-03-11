//电子琴测试文件
`timescale 10ns/1ns

module PianoTest();
	
	//输出信号
	wire [7:0] ROW,COL_RED,COL_GREEN;
	wire Beep;
	wire [6:0] SEG;
	wire [7:0] SEG_Neg;
	
	//输入信号
	reg CLK;
	reg [3:0] Switch;
	reg [6:0] Key;
	
	//初始化
	initial begin
		CLK = 1'b0;
		Switch = 4'b0000;
		Key = 7'b0000000;
	end
	
	//实例化程序
	Piano m1(
				.ROW(ROW),
				.COL_RED(COL_RED),
				.COL_GREEN(COL_GREEN),
				.CLK(CLK),
				.Switch(Switch),
				.Key(Key),
				.Beep(Beep),
				.SEG(SEG),
				.SEG_Neg(SEG_Neg)
				);
	
	//10MHz时钟
	always #50 CLK = ~CLK;
	
	//仿真建议分块进行，进行一个模块仿真时将其余模块注释掉
	initial begin
		//等待
		#100
		
		
		//切换低音
		Switch = 4'b0001;
		#2000
		//弹奏
		Key = 7'b1000000;
		#2000
		Key = 7'b0100000;
		#2000
		Key = 7'b0010000;
		#2000
		Key = 7'b0001000;
		#2000
		Key = 7'b0000100;
		#2000
		Key = 7'b0000010;
		#2000
		Key = 7'b0000001;
		#2000
		Key = 7'b0000000;
		#2000
		
		//切换中音
		Switch = 4'b0010;
		#200
		//弹奏
		Key = 7'b1000000;
		#2000
		Key = 7'b0100000;
		#2000
		Key = 7'b0010000;
		#2000
		Key = 7'b0001000;
		#200
		Key = 7'b0000100;
		#2000
		Key = 7'b0000010;
		#2000
		Key = 7'b0000001;
		#2000
		Key = 7'b0000000;
		#2000
		
		//切换高音
		Switch = 4'b0100;
		#200
		//弹奏
		Key = 7'b1000000;
		#2000
		Key = 7'b0100000;
		#2000
		Key = 7'b0010000;
		#2000
		Key = 7'b0001000;
		#2000
		Key = 7'b0000100;
		#2000
		Key = 7'b0000010;
		#1000
		Key = 7'b0000001;
		#2000
		Key = 7'b0000000;
		#100
		
		/*
		//自动演奏
		Switch = 4'b1000;
		#3000000000
		Switch = 4'b0000;
		#100
		*/
		
		/*
		//蜂鸣器测试
		Switch = 4'b0010;
		#200
		Key = 7'b1000000;
		#200000000
		Key = 7'b0000000;
		Switch = 4'b0000;
		#20
		*/
		
		$stop;
	end
endmodule

