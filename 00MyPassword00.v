module pwd (rst,sw_pwd,LED_right,LED_wrong,clk,key_confirm);
 
	input rst;
	input [3:0] sw_pwd;
	input key_confirm;
	input clk;
	output LED_right;
	output LED_wrong;
 
	parameter password = 4'b1001;
 
	reg alert;
	reg key_pressed;
 
	always@(posedge clk)
	begin
		if(!rst)
		begin
			alert<=1'b0;
			key_pressed<=1'b0;
		end
		else if(key_confirm && ~key_pressed)
		begin
			key_pressed<=1'b1;
			if(sw_pwd==password)
				alert<=1'b0;
			else
				alert<=1'b1;
		end
	end
 
		assign LED_wrong=~(alert&key_pressed);
		assign LED_right=~((~alert)&key_pressed);
 
endmodule
