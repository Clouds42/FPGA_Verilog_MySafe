module pwd(clk,rst,key_cfm,sw_pwd,led,sega,segb);
 
	input clk;//时钟.
	input rst;//复位.
	input key_cfm;//确认键.
	input [3:0] sw_pwd;//四路拨动开关对应四位二进制密码.
	output [1:0] led;//解锁指示灯.
	output [8:0] sega;//第一根数码管(右).
	output [8:0] segb;//第二根数码管(左).
 
	parameter password = 4'b1001;//设置密码.
	
	reg [1:0] sgn;//两位指示灯信号,对应两路6指示灯(一红一绿).
	reg [8:0] seg [3:0];//9位宽信号,用来储存数码管数字显示数据.
	reg [8:0] seg_data [1:0];//数码管显示信号寄存器.
	reg [1:0] cnt;//计数器,用以统计错误次数.
	reg lock;//程序锁,以避免次数用完后或者密码正确之后的误操作.
 
	wire cfm_dbs;//消抖后的确认脉冲.
 
	initial begin//初始化.
	seg[0] <= 9'h3f;//数码管显示数字0信号.
	seg[1] <= 9'h06;//数字1信号.
	seg[2] <= 9'h5b;//数字2信号.
	seg[3] <= 9'h4f;//数字3信号.
	seg_data[0] <= 9'h3f;//数码管初始显示数字0.
	seg_data[1] <= 9'h3f;
	cnt <= 2'b11;//计数器初始值为3.
	end
 
	always @ (posedge clk or negedge rst)//时钟边沿触发或复位按键触发.
	begin
		if(!rst)begin//复位操作.
			sgn <= 2'b11;//两灯均灭.
			seg_data[0] <= seg[3];//第一根显示数字3.
			seg_data[1] <= seg[0];//第二根显示数字0.
			cnt <= 2'b11;//计数器复位到3.
			lock <= 1'b1;//开锁.
			end
		else if(cfm_dbs && lock)begin//按下确认键,此处用的消抖后的脉冲信号.若程序锁已锁,此下代码均不会再被执行.
			if(sw_pwd == password)begin//密码正确.
				sgn <= 2'b10;//绿灯亮.
				seg_data[0] <= 9'h40;//密码输入正确后两根数码管显示两根横线.
				seg_data[1] <= 9'h40;//因为横线显示只在此处使用,故没有写入seg数组中.
				lock <= 0;//程序锁死,防止解锁成功后还能进行操作.
				end
			else if(cnt == 2'b11)begin
				sgn <= 2'b01;//红灯亮.
				seg_data[0] <= seg[2];//数码管显示数字2.
				cnt <= 2'b10;//计数器移至2.
				end
			else if(cnt == 2'b10) begin
				sgn <= 2'b01;//红灯亮.
				seg_data[0] <= seg[1];//数码管显示数字1.
				cnt <= 2'b01;//计数器移至1.
				end
			else if(cnt == 2'b01)begin
				sgn <= 2'b00;//红灯和绿灯同时亮
				seg_data[0] <= seg[0];//数码管显示数字0.
				lock <= 0;//程序锁死.
				end
			end
	end
 
	assign led = sgn;//绿灯亮代表密码正确,红灯反之.
	assign sega = seg_data[0];//第一根数码管通过输入信号变化改变数值
	assign segb = seg_data[1];//第二根数码管其实一直显示数字0
 
	debounce key_cfm_dbs (//调用消抖模块,用以消抖确认键.
		.clk (clk),
		.rst (rst),
		.key (key_cfm),
		.key_pulse (cfm_dbs));
 
endmodule