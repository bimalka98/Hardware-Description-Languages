--------------------------------------------------------------------------------
-- Author               : Bimalka Piyaruwan Thalagala
-- GitHub               : https://github.com/bimalka98
-- Last Modified        : 06.07.2020
-- Project              : First-in, First-out FIFO Memory

-- Functional Description :

-- Memoty is 8-deep(8 memory locations), 9 bits wide (9 bit registers)

-- When a read signal is asserted, the output of the FIFO should be enabled
-- Otherwise it should be high impedance(ZZZZZZZZZ)

-- When the write signal is asserted, write to one of the 9 bit registers

-- Use RdInc(Read Increment) and WrInc(Write Increment) as input signals
-- To increment the pointers that indicate which register to read or write

-- Use RdPtrClr and WrPtrClr as input signals
-- Which reset the pointers to point to the first register in the array

--============================================================================--

library ieee;
USE ieee.std_logic_1164.ALL;      -- normal
USE ieee.numeric_std.ALL;         -- normal
use ieee.std_logic_unsigned.all;  -- For the operation of incrementing
--------------------------------------------------------------------------------

entity FIFO8x9 is
port(
    clk      : in std_logic; --  Clock
    rst      : in std_logic; --  Reset all
    RdPtrClr : in std_logic; --  Read Pointer Clear,  to reset the read pointer
    WrPtrClr : in std_logic; --  Write Pointer Clear, to reset the write pointer
    rdinc    : in std_logic; --  Read pointer increment signal
    wrinc    : in std_logic; --  Write pointer increment signal
    DataIn   : in std_logic_vector(8 downto 0);   --  Data input bus
    DataOut  : out std_logic_vector(8 downto 0);  --  Data Output bus
    rden     : in std_logic; --  read (output) enable
    wren     : in std_logic --  write (input) enable
    );
end entity FIFO8x9;
--------------------------------------------------------------------------------

architecture RTL of FIFO8x9 is

-- makes use of VHDL’s enumerated type
type fifo_array is array(7 downto 0) of std_logic_vector(8 downto 0);

-- signal declarations
signal fifo         : fifo_array;
signal wrptr        : unsigned(2 downto 0);
signal rdptr        : unsigned(2 downto 0);
--signal en           : std_logic_vector(7 downto 0);
--signal dmuxout      : std_logic_vector(8 downto 0);

begin
-------------------------------------------

reset_all : process(rst) -- To reset all
 begin
  if (rst = '1') AND rising_edge(clk) then
    for i in 0 to 7 loop
      fifo(i) <= "000000000";
    end loop;
  end if;
end process reset_all;
-------------------------------------------

reset_rdptr : process(RdPtrClr) -- To reset the read pointer
 begin
  if (RdPtrClr = '1') AND rising_edge(clk) then
    rdptr <= "000";
  end if;
 end process reset_rdptr;
-------------------------------------------

reset_wrptr : process(WrPtrClr) -- To reset the write pointer
 begin
  if (WrPtrClr = '1') AND rising_edge(clk) then
    wrptr <= "000";
  end if;
 end process reset_wrptr;
-------------------------------------------

increment_rdptr : process(rdinc, clk) -- Read pointer incrementing
 begin
  if (rdinc = '1') AND rising_edge(clk) then
    rdptr <= rdptr + 1;
  end if;
 end process increment_rdptr;
-------------------------------------------

increment_wrptr : process(wrinc, clk) --  Write pointer incrementing
 begin
  if (wrinc = '1') AND rising_edge(clk) then
    wrptr <= wrptr + 1;
  end if;
 end process increment_wrptr;
-------------------------------------------

mem_write : process(wren) --  write memory
 begin
  if (wren = '1') then
    fifo(to_integer(wrptr)) <= DataIn;
  end if;
 end process mem_write;

-------------------------------------------

mem_read : process(rden) -- Read memory
 begin
  if (rden = '1') then
    DataOut <= fifo(to_integer(rdptr));
  else
    DataOut <= "ZZZZZZZZZ";
  end if;
 end process mem_read;
-------------------------------------------

end architecture RTL;
