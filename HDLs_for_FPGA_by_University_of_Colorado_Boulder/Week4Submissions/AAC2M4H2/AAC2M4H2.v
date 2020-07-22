//  ------------------------------------------------------------------------------
//   Author               : Bimalka Piyaruwan Thalagala
//   GitHub               : https://github.com/bimalka98
//   Last Modified        : 22.07.2020
//   Project              : First-in, First-out FIFO Memory

//   Functional Description :

//   Memoty is 8-deep(8 memory locations), 9 bits wide (9 bit registers)

//   When a read signal is asserted, the output of the FIFO should be enabled
//   Otherwise it should be high impedance(ZZZZZZZZZ)

//   When the write signal is asserted, write to one of the 9 bit registers

//   Use RdInc(Read Increment) and WrInc(Write Increment) as input signals
//   To increment the pointers that indicate which register to read or write

//   Use RdPtrClr and WrPtrClr as input signals
//   Which reset the pointers to point to the first register in the array

//  ============================================================================--
module FIFO8x9
  (// Port definition
  input clk, rst,
  input RdPtrClr, WrPtrClr,
  input RdInc, WrInc,
  input [8:0] DataIn,
  output reg [8:0] DataOut,
  input rden, wren
	);

  //signal declarations

	reg [8:0] fifo_array[7:0]; // 8-deep 9 bits wide FIFO array
	reg [2:0] wrptr, rdptr; // Variables to store read/write pointers
  integer i; // To use in the loop

always@*
begin
// To reset all memory cells in FIFO array
  if (rst == 1)
    for(i=0; i<8; i=i+1)
      fifo_array[i] = 9'b000000000;

 //To reset the read pointer
  else if (RdPtrClr == 1) rdptr = 3'b000;

//To reset the write pointer
  else if (WrPtrClr == 1) wrptr = 3'b000;

//Read pointer incrementing
  else if (RdInc== 1) rdptr = rdptr + 1;

//Write pointer incrementing
  else if (WrInc== 1) wrptr = wrptr + 1;

//write memory
  else if (wren == 1) fifo_array[wrptr] = DataIn;

//  Read memory
  else if (rden == 1) DataOut = fifo_array[rdptr];

// High impedance state if Read enable signal is not given
  else DataOut = "ZZZZZZZZZ";
end

endmodule
