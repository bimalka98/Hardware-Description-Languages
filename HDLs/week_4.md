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
## Test bench for a counter
<!--
[1] Pong P. Chu, “Regular Sequential Circuit” in Embedded SOPC Design with NIOS II Processor and Verilog Examples, Hoboken, NJ, Wiley, 2012, ch. 5, sec. 5.2, pp. 107-110

[2]  D. Smith, “Test Harnesses” in HDL Chip Design, A practical guide for designing, synthesizing and simulating ASICs and FPGAs using VHDL or Verilog, Madison, AL, Doone Publications, 1996, ch. 11, pp. 323-344.  

---->
```
timescale 1 ns / 1 ps   // set timescale to nanoseconds, ps precision Testbench entity declaration

module Counter_tb();  // top level, no external ports

//constant declarations   
  parameter delay = 10; //ns  defines the wait period.
  localparam n = 4;     // width of counter in bits
  localparam T = 20;    // clock period

----------------------------------------------------------------
//  signal declarations
  reg clock = 0;    //clock if needed, from generator model
  reg reset = 0;    // reset if needed  
  reg [n-1:0] data_tb = 4'b0000;  // data input stimulus
  reg load = 0, en = 0;   // input stimulus
  wire [3:0] q;  // output to check
  reg [n-1:0] checkcount= 4'b0000;// variable to compare to count
----------------------------------------------------------------
// Component Instances
// instantiate the device under test
Counter DUT (     // Device under Test
        // Inputs
       .d(data_tb),
       .clk(clock),
       .reset(reset),
       .load(load),
       .en(en),
         // Outputs
       .q(q)
        );  
-----------------------------------------------------------------
// External Device Simulation Processes

// clock driver continuously executed during simulation
  always
  begin
    clock = 1'b1;
    #(T/2);
    clock = 1'b0;
    #(T/2);
  end  
 
// reset driver executed only once at the beginning of the simulation
  initial
  begin
    reset = 1'b1; // Active for a half of the period T
    #(T/2);
    reset = 1'b0; // Inactive forever
  end
----------------------------------------------------------------
// Test Process
  initial    // test generation process
  begin
    @(negedge reset) // wait for reset inactive
    @(negedge clock) // wait for one clock

  // *****************Test load*****************
    load = 1'b1;
    en = 1'b0;
    data_tb = 4'b1010;

    @(negedge clock) // wait for one clock
    if (q != 4'b1010)
      $display("Load failure %b", q);

  // *****************Test count******************
    checkcount = 4'b1010;  // compare variable
    load = 1'b0;   
    en = 1'b1;

    repeat (2**n)
    begin
      checkcount = checkcount + 1;   // count
      @(negedge clock) // wait for one clock
      if (q != checkcount)
      $display("Count failure at time %g/t at count %b", $time, q);      
    end
----------------------------------------------------------------                 
    $stop;   // end simulation
  end
endmodule
```
# Memory Implementation in Verilog
<!--
[1]  D. Smith, “Test Harnesses” in HDL Chip Design, A practical guide for designing, synthesizing and simulating ASICs and FPGAs using VHDL or Verilog, Madison, AL, Doone Publications, 1996, ch. 11, pp. 323-344.  

[2] Pong P. Chu, “Regular Sequential Circuit” in Embedded SOPC Design with NIOS II Processor and Verilog Examples, Hoboken, NJ, Wiley, 2012, ch. 5, sec. 5.2, pp. 100-102

[3] Pong P. Chu, “Regular Sequential Circuit” in Embedded SOPC Design with NIOS II Processor and Verilog Examples, Hoboken, NJ, Wiley, 2012, ch. 5, sec. 5.7, pp. 124-131

-->
## Dual port RAM
```
module DPRAM
#(
  parameter Data_width = 8,  // # of bits in word
            Addr_width = 10  // # of address bits
  )
  (  //ports
    input wire clk,
    input wire we,
    input wire [(Addr_width-1):0] w_addr, r_addr,
    input wire [(Data_width-1):0] d,
    output wire [(Data_width-1):0] q
  );

  // signal declarations
    reg [Data_width-1:0] ram [2**Addr_width-1:0]; // 2 dimensional array for RAM storage
    reg [Data_width-1:0] data_reg; // read output reg.
     
    // RAM initialization from an external file
    initial
    $readmemh(“initalRAM.txt”, ram);

    //  write operation
    always @(posedge clk)
    begin
      if (we)
        ram[w_addr] <= d;    // write data
        data_reg <= ram[r_addr]; // read data to reg
    end
         
    // read operation
    assign q = data_reg;

endmodule
```
## ROM
```
module ROM
#(
  parameter Data_width = 8, // # of bits in word
            Addr_width = 3  // # of address bits
  )
  (  //ports
    input wire clk,
    input wire [Addr_width-1:0] addr,
    output wire [Data_width-1:0] data
  );
 
// signal declarations
reg [Data_width-1:0] rom_data, data_reg;

// body
 always @(posedge clk)  // output register
   data_reg <= rom_data;
 
 always @*  // * indicates that all the inputs are in the sensitivity list
  case(addr)  // lookup table
        3’b000:  rom_data = 8’b1000_0000;
        3’b001:  rom_data = 8’b1010_1010;
        3’b010:  rom_data = 8’b0101_0101;
        3’b011:  rom_data = 8’b1000_0011;
        3’b100:  rom_data = 8’b0000_0000;
        3’b101:  rom_data = 8’b1001_1001;
        3’b110:  rom_data = 8’b1000_0001;
        3’b111:  rom_data = 8’b1111_0000;
  endcase
 
 assign data = data_reg;
endmodule

```
## Finite State Machines
Finite State Machines (FSM) are a very important part of digital design (and software design, too!). The state machine concept provides a highly reliable, maintainable, and methodical way to design circuits that perform a sequence of operations with great predictability. Because state machines are always in a known state.

FSMs are categorized in to two main categories.
1. Moore: Output only depends on the state
2. Mealy: Inputs and the state drive the output

### Implementation of a FSM with Binary Encoding
For more information about Encoding Types [visit](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/HDLs/week_2.md#state-encoding-types)
* If there is more than twenty states then `One-Hot encoding` will be the best.
* Otherwise `gray`, `Johnson` encodings will be ideal as there is only one bit change in two adjacent states, its less error prone.
```
module AngleFSM
#(  // Binary encoding of states
  parameter State_width = 3,
            An0 = 3'b000,  
            An45 = 3'b001,
            An90 = 3'b010,
            An135 = 3'b011,
            An180 = 3'b100,
            An225 = 3'b101,
            An270 = 3'b110,
            An315 = 3'b111)
  (  //ports
    input wire clk, reset, MoveCW, MoveCCW,
    input wire [(State_width-1):0] PhysicalPosition,
    output wire [(State_width-1):0] DesiredPosition, PosError
  );
  reg [(State_width-1):0] CurrentState, NextState;
------------------------------------------------------------------------------

// body of FSM is  a case statement
// Next State Logic

  always @(MoveCW or MoveCCW or PhysicalPosition or CurrentState)
    begin: Combinational
      case (CurrentState)

        An0:
          if (MoveCW ==1)
            NextState = An45;
          else if (MoveCCW == 1)
            NextState = An315;
          else
            NextState = An0;

        An45:
            if (MoveCW ==1)
              NextState = An90;
            else if (MoveCCW == 1)
              NextState = An0;
            else
              NextState = An45;

        ...  //states An90 to An270 here

        An315:
            if (MoveCW ==1)
              NextState = An0;
            else if (MoveCCW == 1)
              NextState = An270;
            else
              NextState = An315;
        default: // To make sure there will be no unwanted latches
          NextState = PhysicalPosition;
      endcase
    end
------------------------------------------------------------------------------

// Current State Register
  always @(posedge clk or negedge reset)
    begin: Sequential
      if (!reset)
        CurrentState = PhysicalPosition;
      else
        CurrentState = NextState;
    end
------------------------------------------------------------------------------

// Output Logic ( Given circuit may have Moore, Mealy or both.)

  assign DesiredPosition = CurrentState; // Moore Outputs
  assign PosError = DesiredPosition - PhysicalPosition; // Mealy Outputs
 
endmodule

```
<!--[1]  D. Smith, “Modeling Finite State Machines” in HDL Chip Design, A practical guide for designing, synthesizing and simulating ASICs and FPGAs using VHDL or Verilog, Madison, AL, Doone Publications, 1996, ch. 8, pp. 195-201.  -- >
