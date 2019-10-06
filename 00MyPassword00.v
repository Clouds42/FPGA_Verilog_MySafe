/**********
*作者:Clouds42
*日期:2019-10-06
*功能描述:
*代码特色:
**********/

//MySafe_v1.2
 
module pwd(clk,rst,key_cfm,sw_pwd,led,sega,segb);
 
	input clk;//时钟.
	input rst;//复位.
	input key_cfm;//确认键.
	input [3:0] sw_pwd;//四路拨动开关对应四位二进制密码.
	output [1:0] led;//解锁指示灯.
	output [8:0] sega;//第一根数码管(右).
	output [8:0] segb;//第二根数码管(左).
 
	parameter password = 4'b1001;//设置密码.
 
	reg [1:0] sgn;//两位指示灯信号,对应两路指示灯.
	reg [8:0] seg [1:0];//9位宽信号.
	reg cnt;//计数器,用以统计错误次数.
	reg lock;
 
	wire cfm_dbs;//消抖后的确认脉冲.
 
	initial begin//初始化.
	seg[0] <= 9'h3f;//数码管初始为0.
	seg[1] <= 9'h3f;
	cnt <= 9'h4f;//计数器初始为3.
	end
 
	always @ (posedge clk)//时钟边沿触发.
	begin
		if(!rst)begin//复位操作.
			sgn <= 2'b11;//两灯均灭.
			seg[0] <= 9'h4f;//第一根显示数字3.
			seg[1] <= 9'h3f;//第二根显示数字0.
			cnt <= 3;//计数器归零为3.
			lock <= 1'b1;//开锁.
			end
		else if(cfm_dbs&&lock)begin//按下确认键,此处用的消抖后的脉冲信号.
			seg[0] <= 9'h5b;//数码管显示数字2.
			cnt <= cnt - 1;//计数器减1.
			if(sw_pwd==password)begin//密码正确.
				sgn <= 2'b10;//绿灯亮.
				seg[0] <= 9'h40;//密码输入正确后两根数码管显示两根横线.
				seg[1] <= 9'h40;
				lock <= 0;//程序锁死,除非复位.
				end
			else begin
				sgn <= 2'b01;//红灯亮.
				end
			end
	end
 
	assign led = sgn;//绿灯亮代表密码正确,红灯反之.
	assign sega = seg[0];//第一根数码管通过输入信号变化改变数值
	assign segb = seg[1];//第二根数码管一直显示数字0
 
	debounce u1 (//调用消抖模块.
		.clk (clk),
		.rst (rst),
		.key (key_cfm),
		.key_pulse (cfm_dbs));
 
endmodule
