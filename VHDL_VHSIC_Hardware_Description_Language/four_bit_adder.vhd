
-- First Project in modelsim
-- 20.06.2020
-- copied
-- 4- bit adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity declaration

entity Add4 is

port (	Data1, Data2  : 	in std_logic_vector(3 downto 0);
  	Cin           : 	in std_logic;
  	Cout          : 	out std_logic;
  	Sum           : 	out std_logic_vector(3 downto 0)
	);

end entity Add4;

-- architecture
-- defined here

architecture RTL of Add4 is
    signal out5bit : std_logic_vector(4 downto 0);
begin

  out5bit <= ('0' & Data1) + ('0' & Data2) + Cin;
  Sum 	<= out5bit(3 downto 0); --4 bits
  Cout 	<= out5bit(4); --5th bits

end architecture RTL;
