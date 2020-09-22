module ring_counter_top(
  input 	clk_i,          // clock signal
  input sys_rst_n,        //reset signal
  output[7:0] counter_o   //counter o/p values
  );
// declaration of internal wires
wire w_q0, w_q1, w_q2, w_q3, w_q4, w_q5, w_q6, w_q7;
wire sys_rst_i;

// Inverting the reset signal
assign sys_rst_i = ~sys_rst_n;

// First FF instantiation
d_ff d_ff_1_inst(
  .clk_i(clk_i),
  .pr_i(sys_rst_i),
  .clr_i(),
  .d_i(w_q7),
  .q_o(w_q0)
  );

// Second FF instantiation
d_ff d_ff_2_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q0),
  .q_o(w_q1)
  );

// Third FF instantiation
d_ff d_ff_3_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q1),
  .q_o(w_q2)
  );

// Fourth FF instantiation
d_ff d_ff_4_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q2),
  .q_o(w_q3)
  );

// Fifth FF instantiation
d_ff d_ff_5_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q3),
  .q_o(w_q4)
  );

//Sixth FF instantiation
d_ff d_ff_6_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q4),
  .q_o(w_q5)
  );

//Seventh FF instantiation
d_ff d_ff_7_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q5),
  .q_o(w_q6)
  );

//Eighth FF instantiation
d_ff d_ff_8_inst(
  .clk_i(clk_i),
  .pr_i(),
  .clr_i(sys_rst_i),
  .d_i(w_q6),
  .q_o(w_q7)
  );

//Directing the output pins of each Flipflop to the output pins
assign counter_o = {w_q7,w_q6,w_q5,w_q4,w_q3,w_q2,w_q1,w_q0};
endmodule
