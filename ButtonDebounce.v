/****************
*Author:Clouds42*
*Date:2019-10-06*
****************/
 
//ButtonDebounce_v1.1
 
module debounce (clk,rst,key,key_pulse);
 
	input clk;//时钟.
	input rst;//复位.
	input key;//输入的按键.
	output key_pulse;//按键动作产生的脉冲.
 
	reg key_rst_pre;//存储上一时刻触发的按键值.
	reg key_rst_now;//存储当前时刻触发的按键值.
 
	wire key_edge;//检测到按键由高到低变化时产生一个高脉冲.
 
	always @(posedge clk or negedge rst)
		begin
			if (!rst)//复位操作.
				begin
					key_rst_pre <= 1'b1;//初始化为1.
					key_rst_now <= 1'b1;//初始化为1.
				end
			else
				begin
					key_rst_now <= key;//第一个时钟上升沿触发之后key的值赋给key_rst_now,同时key_rst_now的值赋给key_rst_pre.
					key_rst_pre <= key_rst_now;//非阻塞赋值.相当于经过两个时钟触发,key_rst_now存储的是当前时刻key的值，key_rst_pre存储的是前一个时钟的key的值.
				end
		end
 
	assign key_edge = key_rst_pre & (~key_rst_now);//脉冲边沿检测.当key检测到下降沿时,key_edge产生一个时钟周期的高电平.
 
	reg [17:0] cnt;//产生延时所用的计数器.系统时钟12MHz,要延时20ms左右时间,至少需要18位计数器.
 
	//产生20ms延时,当检测到key_edge有效时计数器清零开始计数.
	always @(posedge clk or negedge rst)
		begin
			if(!rst)
				cnt <= 18'h0;
			else if(key_edge)
				cnt <= 18'h0;
			else
				cnt <= cnt + 1'h1;
		end  
 
	reg key_sec_pre;//延时后检测电平寄存器变量.
	reg key_sec_now;
 
	//延时后检测key,如果按键状态变低产生一个时钟的高脉冲.如果按键状态是高的话说明按键无效.
	always @(posedge clk  or  negedge rst)
		begin
			if (!rst) 
				key_sec_now <= 1'b1;
			else if (cnt==18'h3ffff)
				key_sec_now <= key;  
		end
 
	always @(posedge clk or negedge rst)
		begin
			if (!rst)
				key_sec_pre <= 1'b1;
			else
				key_sec_pre <= key_sec_now;
		end
 
	assign key_pulse = key_sec_pre & (~key_sec_now);//消抖完毕,u输出有效脉冲.
 
endmodule
