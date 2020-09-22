module ring_counter_top_wrapper(
	input 	clk,
	input 	sys_rst_n,
	output 	[7:0] led
);

wire clk_int;

clk_div clk_div_1(
	.sys_rst_n(sys_rst_n),
	.clk_i(clk),
	.clk_o(clk_int)
);

ring_counter_top ring_counter_1(
	.clk_i(clk_int),
	.sys_rst_n(sys_rst_n),
	.counter_o(led)
);
endmodule
