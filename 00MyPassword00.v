module pwd (key_refresh,sw_pwd,LED_right,LED_wrong,clk);
 
	input clk;//时钟.
	input key_refresh;//状态刷新.
	input [3:0] sw_pwd;//开关.
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
