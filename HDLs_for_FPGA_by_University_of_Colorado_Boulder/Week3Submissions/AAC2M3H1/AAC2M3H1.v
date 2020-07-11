// Last Modified By         : Bimalka Piyaruwan Thalagala
// GitHub                   : https://github.com/bimalka98
// Last Modified            : 11.07.2020

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//               Application Assignment Problem 5 Module 3 Course 2           //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//
//
// @file AAC2M3H1.v
// @brief Application Assignment 2-007 4-bit full adder
// @version: 1.0
// Date of current revision:  @date 2019-07-01
// Target FPGA: [Intel Altera MAX10]
// Tools used: [Quartus Prime 16.1 or Sigasi] for editing and/or synthesis
//             [Modeltech ModelSIM 10.4a Student Edition] for simulation
//             [Quartus Prime 16.1]  for place and route if applied
//
//  Functional Description:  This file contains the Verilog which describes the
//               FPGA implementation of 4-bit adder with carry. The inputs are 2
//               3-bit vectors A and B, and a scalar carry in Cin.  Outputs are
//               Sum and Cout.
//
//  Hierarchy:  There is only one level in this simple design.
//
//  Designed by:  @author [your name]
//                [Organization]
//                [email]
//
//      Copyright (c) 2019 by Tim Scherr
//
// Redistribution, modification or use of this software in source or binary
// forms is permitted as long as the files maintain this copyright. Users are
// permitted to modify this and use it to learn about the field of HDl code.
// Tim Scherr and the University of Colorado are not liable for any misuse
// of this material.
//////////////////////////////////////////////////////////////////////////////
//


module FullAdd4( A,B,Cin,Sum,Cout);
    input   [3:0]A, B;
    input   Cin;
    output  [3:0]Sum;
    output  Cout;

// Defining register variables to store values inside the always block.
reg [3:0]temp_sum;
reg temp_cout;

// Register to store the sum of A, B and Cin.
reg [4:0]temporary;

// Assignment of results to output wires
assign Cout = temp_cout;
assign Sum = temp_sum;

always@(A,B,Cin)
begin
temporary =   A + B + Cin; //{1'b0 , A} + {1'b0 , B} + {3'b000, Cin};
temp_sum = temporary[3:0];
temp_cout = temporary[4];
end

endmodule
