module debounce (clk,rst,key,key_pulse);
 
	input clk;//时钟.
	input rst;//复位.
	input key;//输入的按键.
	output key_pulse;//按键动作产生的脉冲.
 
	reg key_1st_pre;//存储上一时刻触发的按键值.
	reg key_1st_now;//存储当前时刻触发的按键值.
 
	wire key_edge;//检测到按键由高到低变化时产生一个高脉冲.
 
	always@(posedge clk or negedge rst)begin
		if(!rst)begin
			key_1st_pre <= 1'b1;//初始化为1.
			key_1st_now <= 1'b1;
		end
		else begin
			key_1st_now <= key;//key_1st_now一直存储当前时刻的key值.
			key_1st_pre <= key_1st_now;//key_1st_pre存储的是前一个时钟的key的值.
		end
	end
 
	assign key_edge = key_1st_pre & (~key_1st_now);//脉冲边沿检测.当key检测到下降沿时,key_edge产生一个时钟周期(1/12us)的高电平.
 
	reg [17:0] cnt;//产生延时所用的计数器.系统时钟12MHz,一个时钟周期1/12us,要延时20ms左右,需要240 000次周期,对应至少18位计数器.
 
	always@(posedge clk or negedge rst)begin
		if(!rst)
			cnt <= 18'h0;
		else if(key_edge)//当检测到key_edge有效时计数器清零.
			cnt <= 18'h0;
		else//开始计数.
			cnt <= cnt + 1'h1;
	end
 
	reg key_2nd_pre;//延时后检测电平寄存器变量.
	reg key_2nd_now;
 
	always@(posedge clk or negedge rst)begin
		if(!rst)
			key_2nd_now <= 1'b1;
		else if(cnt==18'h3ffff)//对应20ms左右.
			key_2nd_now <= key;//将延时后的按键状态赋值给key_2nd_now.
	end
 
	always@(posedge clk or negedge rst)begin
		if(!rst)
			key_2nd_pre <= 1'b1;
		else
			key_2nd_pre <= key_2nd_now;
	end
 
	assign key_pulse = key_2nd_pre & (~key_2nd_now);//如果按键状态变低产生一个时钟的高脉冲.如果按键状态是高的话说明按键无效.
 
endmodule
