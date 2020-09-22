module clk_div(
	input sys_rst_n,
	input clk_i,
	output reg clk_o
);

localparam 						HALF_CYCLE			=	6250000;
integer 						counter;

always @ (posedge clk_i or negedge sys_rst_n) begin
	
	if (~sys_rst_n) begin
		clk_o				<= 1'b0;
		counter				<= 0;
	end
	
	else begin
		counter 			<= counter + 1;
		if (counter == HALF_CYCLE) begin
			counter 		<= 0;
			clk_o			<= ~clk_o;			
		end
	end
end

endmodule
