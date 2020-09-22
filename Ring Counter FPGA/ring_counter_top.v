module ring_counter_top(
  input 	clk_i,               // clock signal
  input sys_rst_n,            //reset signal
  output reg[7:0] counter_o   //counter o/p values
  );

always @ (posedge clk_i or negedge sys_rst_n)
begin

  if(~sys_rst_n) counter_o <= 8'b00000001;
  else
    begin
    counter_o[1] <= counter_o[0];
    counter_o[2] <= counter_o[1];
    counter_o[3] <= counter_o[2];
    counter_o[4] <= counter_o[3];
    counter_o[5] <= counter_o[4];
    counter_o[6] <= counter_o[5];
    counter_o[7] <= counter_o[6];
    counter_o[0] <= counter_o[7];
    end

end
endmodule
