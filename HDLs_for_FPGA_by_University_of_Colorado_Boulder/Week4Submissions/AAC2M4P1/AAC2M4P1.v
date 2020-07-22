//  -----------------------------------------------------------------------------
//  Author         : Bimalka Piyaruwan Thalagala
//  GitHub         : https://github.com/bimalka98
//  Date Created   : 21.07.2020
//  Last Modified  : 21.07.2020

//  74LS163 binary counter
//  In default counting from 0 to 15

//  Parallel Input(D) is used to load a 4-bit number.
//  First give the 4-bit number to the Parallel Input(D).
//  Then make LOAD_n pin LOW.
//  From the next rising edge counting will begin from this number D.

//  Asynchronous Reset (CLR_n) input overrides all other control inputs.
//  But is active only during the rising clock edge.
//  First make CLR_n LOW.
//  Reset will happen in the next immmediate rising edge of the clock.
//  Counter will reset to 0.

//  ENP,ENT and LOAD_n  all must be set to 1 for counting to happen.
//  OTHERWISE there will be an ERROR in INCREMENTING of counter.

//  [Reference](https://www.youtube.com/watch?v=dXECRzDUYgE)
//  [Reference](The datasheet provided by the MOTOROLA)
//  ===========================================================================--

module LS161a
(
    input [3:0] D,        // Parallel Input
    input CLK,            // Clock
    input CLR_n,          // Active Low Asynchronous Reset
    input LOAD_n,         // Enable Parallel Input
    input ENP,            // Count Enable Parallel
    input ENT,            // Count Enable Trickle
    output reg [3:0]Q,    // Parallel Output
    output RCO            // Ripple Carry Output (Terminal Count)
);
//------------------------------------------------------------------------------
assign RCO = &Q && ENT; //  Logical expression taken from the datasheet.

always@(posedge CLK, CLR_n, D, LOAD_n, ENP, ENT)
  begin

    if (((CLR_n == 1'b0)||(&Q == 1'b1)) && CLK == 1'b1)
      Q = 4'b0000;
    else if ((LOAD_n == 1'b0) && CLK == 1'b1)
      Q = D;
    else if ((ENP == 1'b1) && (ENT == 1'b1) && (LOAD_n == 1'b1) && CLK == 1'b1)
      Q = Q +1;

  end

endmodule
