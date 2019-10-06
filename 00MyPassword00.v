/**********
*作者:Clouds42
*日期:2019-10-06
*功能描述:
*代码特色:
**********/

//MySafe_v1.1
 
module pwd(clk,rst,key_cfm,sw_pwd,led);
 
	input clk;//时钟.
	input rst;//复位.
	input key_cfm;//确认键.
	input [3:0] sw_pwd;//四路拨动开关对应四位二进制密码.
	output [1:0] led;//解锁指示灯.
 
	parameter password = 4'b1001;//设置密码.
 
	reg sgna,sgnb;//指示灯信号.
	
	wire cfm_dbs;//消抖后的确认脉冲.
 
	always @ (posedge clk)//时钟边沿触发.
	begin
		if(!rst)begin//复位操作.
			sgna <= 1'b1;//绿灯灭信号.
			sgnb <= 1'b1;//红灯灭信号.
			end
		else if(cfm_dbs)begin//按下确认键,此处用的消抖后的确认脉冲信号.
			if(sw_pwd==password)begin//密码正确.
				sgna <= 1'b0;//绿灯亮信号.
				sgnb <= 1'b1;//红灯灭信号.
				end
			else begin
				sgna <= 1'b1;//绿灯灭信号.
				sgnb <= 1'b0;//红灯亮信号.
				end
			end
	end
 
	assign led[0] = sgna;//绿灯亮或灭.
	assign led[1] = sgnb;//红灯亮或灭.
 
	debounce u1 (//调用消抖模块.
		.clk (clk),
		.rst (rst),
		.key (key_cfm),
		.key_pulse (cfm_dbs)
	);
 
endmodule
