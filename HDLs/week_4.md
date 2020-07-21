# Combinatorial Circuits

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
## Registers
Registers are used to store some value. In this implementation in verilog although there is no `else` statement associated with the `if block`, no unnecessary latch will be synthesized. Because according to the rule in Verilog, if there is no `active assignment` to the output of some circuit, output will remain in its previous value(memory state).
 ```
// Data Register
//
module Dreg (
  input wire [3:0] d, //width of the register is defined here as 4 bits.
  input wire clk, reset, load,
  output reg [3:0] q
  );

  always @(posedge clk or negedge reset)  
  begin
    if (!reset)   // Asynchronous reset
      q <= 0;
    else if (load == 1)
      q <= d;
  end             //Note  that there is no else statement!
endmodule

```
## Shift Registers
One method of creating a shift register is given below. But in addition to that the same desired circuit can be obtained by using a for loop and array indexing. In this example the purpose is served using left shift operator.
```
// Shift Register
//
module Shifter (clk, reset, D0, shift, Q);
  input clk, reset, D0, shift;
  output reg [3:0] Q;
  always @(posedge clk)  
  begin
    if (!reset)
      Q <= 4’b0000;

    else if (shift == 1)
    begin       
      Q <= Q << 1;
      Q[0] <= D0;
    end

    else ;   
  end
endmodule

```
## Counters
```
// Binary Counter
//
module Counter (
  input wire [3:0] d,
  input wire clk, reset, load, en,
  output reg [3:0] q
  );
  always @(posedge clk)  
  begin
    if (reset)  // synchronous reset
      q <= 0;
    else if (load == 1’b1)  // To initialize the count from a user defined value.
      q <= d;
    else if (en == 1’b1)    // Counter is incremented whenever there is the enable signal.
      q <= q + 1;
  end // Note there is no else statement. This implies that output will remain unchanged in every other possible Situation.
endmodule

```
## Register File Implementation
```
// Data Register File
// 4 x 8
module regFile #(
  parameter Dwidth = 8, // #bits in a word
            Awidth = 2  // #bits in an address
  )
  (
    input wire clk, wren,
    input wire [(Dwidth - 1):0] wdata,
    input wire [(Awidth1 - 1):0] waddr, raddr,
    output wire [(Dwidth - 1):0] rdata
  );
  // Signal Declaration
  reg [(Dwidth - 1):0] array_reg [(2**Awidth-1):0];

  always @(posedge clk)  
    if (wren)  // synchronous enable
      array_reg[waddr] <= wdata;
  assign rdata = array_reg[raddr];
endmodule

```
## Tri-state Buses
Both assign statements in the following code will generate the same circuit. However the first one will handle each possible input for `OE` pin and therefore will be ideal for simulation.
```
module Tri (
  input wire [3:0] Dout,
  input wire OE,
  output wire [3:0] Pinout
  );
  assign Pinout = (OE == 1) ? Dout : (OE == 0) ? 4'bz : 4'bx;
  // assign Pinout = OE ? Dout : 4'bz;
endmodule
```
## Bi-directional Buses
The I/O structure of the FPGA allows to create Bi-directional buses, in which the external pin can be treated as either an input or an output, depending on the state of the enable signal.

```
module BiDir (
  output wire [3:0] Din,
  input wire [3:0] Dout,
  input wire OE,
  inout wire [3:0] IOpin
  );
  assign Din = IOpin;
  assign IOpin = (OE == 1) ? Dout :
                 (OE == 0) ? 4'bz : 4'bx;
endmodule
```
## Joining and Splitting Buses
```
module BusMe (
  input wire [4:0] A,
  input wire [2:0] B,
  output wire X,Y,
  output wire [5:0] Dout
  );
  assign Dout = {B,A[2:0]}; // Joining buses
  assign X = A[3]; // Splitting buses
  assign Y = A[4];
endmodule

```
# Modular Design in Verilog
## Component Instantiation
A modular design in Verilog at the top level oftentimes consists only of component instantiations, the fundamental way to build hierarchy in a design can be given as follows.
```
module module_name_top (port list)

  template_name instance_name_1 (port connection list),
  template_name instance_name_2 (port connection list),
  .......
  template_name instance_name_n (port connection list);

endmodule
----------------------------------------------------------------
//  16-bit Adder built with 4 instantiations of 4-bit Adders
module Add16_top (
  input [15:0] A,
  input [15:0] B,
  input Cin,
  output Cout,
  output [15:0] Sum
);

  wire Cin2, Cin3, Cin4; // To make the connection between 4 instantiations.
  add4 add4_1 (.Data1(A[3:0]), .Data2(B[3:0]), .Cin(Cin), .Cout(Cin2), .Sum(Sum[3:0]));
  add4 add4_2 (.Data1(A[7:4]), .Data2(B[7:4]), .Cin(Cin2), .Cout(Cin3), .Sum(Sum[7:4]));
  add4 add4_3 (.Data1(A[11:8]), .Data2(B[11:8]), .Cin(Cin3), .Cout(Cin4), .Sum(Sum[11:8]));
  add4 add4_4 (.Data1(A[15:12]), .Data2(B[15:12]), .Cin(Cin4), .Cout(Cout), .Sum(Sum[15:12]));
endmodule
```
## Loops in VHDL
There are several different looping constructs in Verilog. Such as `for`, `while`, `repeat`, `forever`.
### 1. For loop
```
//  And scalar g with vector A

Module scalarAnd
 #(parameter N = 4);
  (input g,
   input [N-1:0] a,
   output [N-1:0] y);

  reg [N-1:0] tmp, y; // To use within the always block.

  integer i;   //loop index, not a signal

  always @(a or g)
  begin
    for(i=0; i<N; i=i+1)
      begin
        tmp[i] = a[i] & g;
      end
    y = tmp;
  end
endmodule
```
## Generate in Verilog
Although loops can be used to generate data or test patterns, in Verilog a common use of loops for synthesis is `replication of many identical circuits` within generate blocks.

The `generate  … end generate block` specifies how an object is to be repeated.  Variables used to specify the repetition are called `genvars`.  The index variable of a for loop in a generate block must be a genvar.
```
//  Generate n XOR gates
//   
module XorGen
 #(parameter width = 4,delay = 10)

  (output [1:width] xout,
   input [1:width] xin1, xin2
  );
  generate
    genvar i;
    for (i=1; i<=width; i=i+1)
    begin
      assign #delay // delay is ignored in synthesis but useful for simulation.
        xout[i] = xin1[i] ^ xin2[i];  // This is not executed sequentially. Instead this generates (width-1) number of xor gates in parallel.
    end
  endgenerate    
endmodule

```
# Test Benches(test fixture or test harness) in Verilog

<!----
[1]  D. Smith, “Test Harnesses” in HDL Chip Design, A practical guide for designing, synthesizing and simulating ASICs and FPGAs using VHDL or Verilog, Madison, AL, Doone Publications, 1996, ch. 11, pp. 323-344.  

[2] J. Wawrzynek, (2007, Oct 17).  Verilog Tutorial. [Online]. Available: www-inst.eecs.berkeley.edu/~cs61c/resources/verilog.pdf

[3] J. Lee, “Test Benches and Test Management” in Verilog Quickstart, A Practical Guide to Simulation and Synthesis in Verilog, 3rd ed.  Norwell, MA, Kluwer Academic, 2002, ch. 18, p. 243.
--->
Test benches are used to verify the `functional correctness` of the hardware model as coded. A testbench can have several functional sections, including:
1. Top-level testbench declaration
2. Stimulus and Response Signal declarations
3. Component declarations
4. Component (Device Under Test-DUT) instantiations
5. External Stimulation Device Models
6. Test Process which applies the stimulus to the DUT/UUT(Unit under Test)
7. Test Monitor which reports results
```
`timescale 1 ns / 1 ps  // set timescale to nanoseconds, ps precision
------------------------------------------------------------------
module Adder_tb();     //  no sensitivity list!
// signal declarations

reg [3:0] a_tb, b_tb;  // data input stimulus
reg Cin;               // data input stimulus
wire [3:0] y_tb;       // data output response
wire Co_tb;            // data output response
reg [3:0] expected;    // expected sum result
-------------------------------------------------------------------

// DUT instantiation       
add4 DUT(.A(a_tb), .B(b_tb), .Cin(Cin), .Sum(y_tb), .Cout(Co_tb));
-------------------------------------------------------------------

//Test stimulus generation
******************* Method 01 - Manual *******************
initial
  begin
    #0 a_tb=2; b_tb=2; Cin=0; expected=4;
    #10 a_tb=15; b_tb=0; Cin=1; expected=0;
    #10 a_tb=2; b_tb=4; Cin=1; expected=7;
    #10 $stop;
  end

******************* Method 02 - Using loops***************
integer i, j, k;
initial

  begin // loop over number of inputs possible
    for(i = 0; i<16; i = i+1) begin
      a_tb <= i;
      for(j=0; j<16; j = j+1) begin
        b_tb <= j;
        for (k=0; k<2; k=k+1) begin
          Cin <= k;
          #(10);

          /***************** For manual checking *****************/

          expected <= a_tb + b_tb + Cin;  //Expected value corresponding to the generated test case.

          /**************** For self checking ********************/

          if (y_tb !== a_tb + b_tb + Cin) // If the produced output of the code is not equal to the expected output.
            begin
              $display(“Error - sum is wrong”);
              $stop
            end

        end
      end
    end
  end
------------------------------------------------------------------  

// Test Results
initial
  $monitor("time=%d, a=%b, b=%b, Cin=%b, sum=%b, cout=%b, expected sum=%b", $time, a_tb, b_tb, Cin, y_tb, Co_tb, expected);

endmodule
```
### Test Bench with Assertions
```
assert_label:
  assert (y_tb == a_tb + b_tb + Cin)
    begin
      $display("Test passed");
    end

    else

    begin
      $error("Error - sum is wrong");
      $stop;
     end

```
