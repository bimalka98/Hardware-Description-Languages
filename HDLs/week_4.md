qfd# Combinatorial Circuits

## Gate level modeling using bitwise operators and  concurrent assignments

Bitwise operators are binary operators. Therefore need two operands to perform the operation. An operand may be single bit or a bit vector. Output is generated accordingly.

```
module gates (            // module and name
  input A, B, C, D,
  input [3:0] vA, vB,     // Input buses

  output W, U, X, Y, Z,
  output [3:0] vX, vY);   // Output buses

  assign W = A & B;       // scalar AND Gate
  assign U = ~(A | B);    // scalar NOR Gate
  assign X = C ^ D;       //scalar XOR Gate
  assign Y = C ~^ D;      //scalar XNOR Gate
  assign Z = (A & B) | (C & D);     // AND-OR gates

  assign vX = vA & vB; // Vector bitwise AND
  assign vY = vA | vB; // Vector bitwise OR (vA[i] | vB[i])

endmodule
```
## Gate level modeling using reduction operators

Operators are the same but there is only one operand, when the operator is used as a vector reduction operator.
```
module gates ( 	// module and name
  input [3:0] vA, vB, vC, vD,
  output W, U, X, Y, Z);  // All the outputs are single bit.

  assign W = & vA; // Vector Reduction AND Gate
  assign U = ~| vB; // Vector reduction NOR Gate
  assign X = ^ vD; // Vector reduction XOR Gate

  assign Y = | vA & vB ; // bitwise or reduction.?
  /*
  Here fist the Vector A is reduced by OR operator and then the result is bitwise ANDed with vB. Result is still a bit.
  Y = "reduced(A) & vB[0]" rest of the bits of the vector B are not used.!
  */

  assign Z = | (vA & vB); // bitwise AND, then Vector  reduction OR
  /*
  Order of the operation matters.! Use proper parentheses
  */
endmodule
```
## Procedural Combinational Logic with Always Procedures

* When if- else if block is used declarations of an `else` statement is essential in order to eliminate the generation of unwanted latches(refer following figure). That is outputs must be defined for each possible input.

![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/unintentional_latch.jpg)

* `always` block is executed whenever there is a change in the signals  in the sensitivity list.
* In the following example non-blocking assignment operators are used. Blocking assignment operators could have been used.
* But mix of non-blocking and blocking assignment operators is not allowed.
```
module always_combo (             
   input A, B, C, D,
   output reg Y);
   /*
   Note that reg is different from wire! The signals of type reg hold
their values between the simulation deltas. This is necessary, as the
always construct is executed only after an event on any of the signals
in its sensitivity list. Verilog was developed for simulation and as
interpreter language.
   */

   always @(A or B or C or D)
   begin
     if ((C==1) && (D==1))
       Y <= 0;
     else if ((A==1) || (B==1))
       Y <= 1;
     else
       Y <= 0;
   end   
endmodule

```
[Reference](https://www.physi.uni-heidelberg.de/~angelov/VHDL/VHDL_SS09_Teil10.pdf)

# Synchronous Circuits
Naming Convention
* q   : output
* ldc : latch; d type; clear
* fda : flip flop; d type; asynchronous
* fds : flip flop; d type; synchronous
* fd  : flip flop; d type;

## D Latch
```
// D latches
//
module DLatches ( d, clk, aclr, qldc, qld);
   input d, clk, aclr;
   output reg qldc, qld; // outputs must be registers.

   /* Synchronous D latch */
   always @(clk or d)   // no posedge!.Therefore this program generates a level sensitive circuit.
   begin
      if (clk == 1) qld <= d;
   end

   /* Asynchronous D latch */
   always @(clk or d or aclr)   // "or" in between items doesn't imply any logical operation. They are used only to separate the items.
   // note d is on the sensitivity list
   begin
      if (aclr == 1) qldc <= 0; // Check if the asynchronous clear signal is given.
      else if (clk == 1) qldc <= d;
   end
endmodule

```
## D Flip Flops
```
// D Flip Flops
//
module DFF (d, clk, clr, reset, qfd, qfda, qfds);
   input d, clk, clr, reset;
   output reg qfd, qfda, qfds; // Output registers for Normal; Asynchronous; Synchronous Flip Flops.
   ----------------------------------
   always @(posedge clk)   // with posedge!
   begin
    qfd <= d;  //standard FF

    if (reset == 0) qfds <= 0;
    else qfds <= d;  // FF with sync reset  
   end
   ---------------------------------
   always @(posedge clk or negedge clr)   //Operate at the negative edge of the clear
   begin
      if (clr == 0) qfda <= 0;
      else qfda <= d; // FF with async reset
   end
endmodule

```
## D Flip Flops with clock Enable
```
// D Flip Flops with clock enable
//
module DFFe (d, clk, ce, clr, reset, qfda, qfds);
   input d, clk, ce, clr, reset;
   output reg qfd, qfda, qfds;
   ---------------------------------
   always @(posedge clk)   // FF with sync reset & clk enable
   begin
    if (reset == 1) qfds <= 0;
    else if (ce == 1) qfds <= d;
   end
   ---------------------------------
   always @(posedge clk or posedge clr)   // FF with async reset & clk enable.
   begin                                  // Operate at positive edge of the clear
      if (clr == 1) qfda <= 0;
      else if (ce == 1) qfda <= d;
   end
endmodule

```
