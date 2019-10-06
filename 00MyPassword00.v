/**********
*作者:Clouds42
*日期:2019-10-06
*功能描述:	1.密码可在代码中更改,默认密码为1001,对应四路拨动开关的状态.
			2.如果密码正确,按下状态刷新键(key_refresh),检测到密码正确,则亮绿灯(LED_right).
			3.如果密码不匹配,按下状态刷新键,则亮红灯(LED_wrong).
*代码特色:	1.在本代码中,只用到了一个状态刷新键,只要检测到按键按下即可,不需要对按键进行消抖处理.
			2.方便易用,代码简洁明了,便于维护.
**********/

module pwd (clk,key_refresh,sw_pwd,LED_right,LED_wrong);
 
	input clk;//时钟(clock).
	input key_refresh;//状态刷新.
	input [3:0] sw_pwd;//开关(switch_password).
	output LED_right;//密码正确指示灯.
	output LED_wrong;//密码错误指示灯.
 
	parameter password = 4'b1001;//密码为1001,对应四路拨动开关.
 
	reg flag;//储存密码是否正确,0或1.
 
	always@(posedge clk)//时钟边沿触发.
	begin
		if(!key_refresh)//状态刷新.
			begin
				if(sw_pwd==password)
					flag<=1'b0;//密码正确.
				else
					flag<=1'b1;//密码错误.
			end
	end
	
	assign LED_right=flag;//密码正确亮绿灯.
	assign LED_wrong=~flag;//密码错误亮红灯.
 
endmodule
