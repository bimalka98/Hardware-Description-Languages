//  ------------------------------------------------------------------------------
//   Author               : Bimalka Piyaruwan Thalagala
//   GitHub               : https://github.com/bimalka98
//   Last Modified        : 22.07.2020

//   Functional Description :
//   This can be easily done through a "case" structure.
//   Basically a look up table problem.
//   Define cases for each opcode.

//  ============================================================================--

module ALU
( //Port definition
  input [2:0] Op_code,
  input [31:0] A, B,
  output reg [31:0] Y
);
always@(Op_code or A or B )
 begin
  case(Op_code)
    3'b000: Y = A;
    3'b001: Y = A + B;
    3'b010: Y = A - B;
    3'b011: Y = A & B;
    3'b100: Y = A | B;
    3'b101: Y = A + 1;
    3'b110: Y = A - 1;
    3'b111: Y = B;
    default:  Y = 8'h00000000;
  endcase
 end
endmodule
