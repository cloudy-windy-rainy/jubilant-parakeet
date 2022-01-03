`timescale 1ns / 1ps

module clock_divider(clk, divided_clk);

input wire clk;
output reg divided_clk;

localparam div_val = 1000;//1Hz? 

integer clk_value = 0;

always @(posedge(clk)) // rising edge 0-1

begin
	if(clk_value ==div_val)
		clk_value = 0;
	else
		clk_value = clk_value+1;


end
//divided clock

always@(posedge clk)
begin
	if(clk_value==div_val)
		divided_clk <=~divided_clk;
	else
		divided_clk <= divided_clk;
end


endmodule
