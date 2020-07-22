//   ------------------------------------------------------------------------------
//    Author               : Bimalka Piyaruwan Thalagala
//    GitHub               : https://github.com/bimalka98
//    Last Modified        : 22.07.2020

//    Functional Description :

//    This is a single port memory.
//    Therefore there is only one port for both READ and WRITE.
//    RAM is a synchronous device. Therefore R/W depends on the clock state.
//    When an address is given,
//    First check whether the WRITE_ENABLE signal is HIGH.
//    If WRITE_ENABLE is HIGH,
//    Then what is in the DATA must be written into the MEMORY.
//    Data will be written in to the MEMORY at the rising_edge of the CLOCK.
//    Otherwise,
//    DATA in the given address must be READ from the MEMORY,
//    And should be loaded in to OUTPUT path.
// ----------------------------------------------------------------
module RAM128x32
#(
  parameter Data_width = 32,  //# of bits in word
            Addr_width = 7    // # of address bits
  )
  (  //ports
    input wire clk,
    input wire we,
    input wire [(Addr_width-1):0] address,
    input wire [(Data_width-1):0] d,
    output wire [(Data_width-1):0] q
  );
//----------------------------------------------------------------
  // signal declarations 2 dimensional array for RAM storage
  reg [(Data_width-1):0] ram [(2**Addr_width-1):0];
  // reg variable to store data temporarily
  reg [(Data_width-1):0] data_reg;

  always@ (posedge clk)
    begin
      if (we == 1'b1)
        ram[address] = d; // Writing data in to the memory
      else
        data_reg = ram[address]; // Reading data from the memory
    end

  assign q = data_reg; // Assign what is in the data register to the output q.

endmodule
