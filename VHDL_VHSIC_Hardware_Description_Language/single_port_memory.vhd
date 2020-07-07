--------------------------------------------------------------------------------
-- Author               : Bimalka Piyaruwan Thalagala
-- GitHub               : https://github.com/bimalka98
-- Last Modified        : 06.07.2020

-- Functional Description :

-- This is a single port memory.
-- Therefore there is only one port for both READ and WRITE.
-- RAM is a synchronous device. Therefore R/W depends on the clock state.
-- When an address is given,
-- First check whether the WRITE_ENABLE signal is HIGH.
-- If WRITE_ENABLE is HIGH,
-- Then what is in the DATA must be written into the MEMORY.
-- Data will be written in to the MEMORY at the rising_edge of the CLOCK.
-- Otherwise,
-- DATA in the given address must be READ from the MEMORY,
-- And should be loaded in to OUTPUT path.


-- Note           : Neglect the following error
--# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
--#    Time: 0 ps  Iteration: 0  Instance: /aac2m2p2_tb/RAM_Test

-- To make a text file for the RAM:
-- Include the following lines in the architecture

-- impure function read_file(txt_file : in string) return ram_type is
--  file ram_file       : text open read_mode is txt_file;
--  variable txt_line   : line;
--  variable txt_bit    : bit_vector(31 downto 0);
--  variable txt_ram    : ram_type;
--  begin
--    for i in ram_type'range loop
--      readline(ram_file, txt_line);
--      read(txt_line, txt_bit);
--      txt_ram(i) := to_stdlogicvector(txt_bit);
--    end loop;
--  return txt_ram;
-- end function;
-- signal ram : ram_type := read_file("initialRAM.txt");

--============================================================================--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;      -- normal
USE ieee.numeric_std.ALL;         -- normal

--------------------------------------------------------------------------------
ENTITY RAM128_32 IS

PORT
  (
  address	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);   -- Address Input
  clock		: IN STD_LOGIC  := '1';               -- clock
  data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);  -- Input data
  wren		: IN STD_LOGIC ;                      -- Write enable
  q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  -- Output data
  );

END RAM128_32;
--------------------------------------------------------------------------------
architecture SPR_Arch of RAM128_32 is

-- declaration of a new data type for the RAM as ram_type.
type ram_type is array (0 to 2**7 - 1) of std_logic_vector (31 downto 0);

signal ram : ram_type; -- Define a signal of type ram_type

begin

ram_proc : process(clock)
  begin

    if (rising_edge(clock) and (wren = '1')) then
      ram(to_integer(unsigned(address))) <= data; -- Writing in to the memory
    else
      q <= ram(to_integer(unsigned(address)));    -- Reading from the memory

    end if;
  end process ram_proc;
end architecture SPR_Arch;
