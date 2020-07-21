--------------------------------------------------------------------------------
-- Author         : Bimalka Piyaruwan Thalagala
-- GitHub         : https://github.com/bimalka98
-- Date Created   : 05.07.2020
-- Last Modified  : 06.07.2020

-- 74LS163 binary counter
-- In default counting from 0 to 15

-- Parallel Input(P) is used to load a 4-bit number.
-- First give the 4-bit number to the Parallel Input(P).
-- Then make PE pin LOW.
-- From the next rising edge counting will begin from this number P.

-- Synchronous Reset (SR) input overrides all other control inputs.
-- But is active only during the rising clock edge.
-- First make SR LOW.
-- Reset will happen in the next immmediate rising edge of the clock.
-- Counter will reset to 0.

-- CEP,CET and PE  all must be set to 1 for counting to happen.
-- OTHERWISE there will be an ERROR in INCREMENTING of counter.

-- [Reference](https://www.youtube.com/watch?v=dXECRzDUYgE)
-- [Reference](The datasheet provided by the MOTOROLA)
--============================================================================--


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;      -- normal
USE ieee.numeric_std.ALL;         -- normal
use ieee.std_logic_unsigned.all;  -- For the operation of incrementing
use ieee.STD_LOGIC_MISC.all;      -- In order to use vector reduction functions


--------------------------------------------------------------------------------
entity bin_counter is port (
   CP     : in std_logic;                     -- clock input
   SR     : in std_logic;                     -- Active low, synchronous reset
   P      : in std_logic_vector(3 downto 0);  -- Parallel input
   PE     : in std_logic;                     -- Parallel Enable (Load)
   CEP    : in std_logic;                     -- Count enable parallel input
   CET    : in std_logic;                     -- Count enable trickle input
   Q      : out std_logic_vector(3 downto 0); -- Parallel output
   TC     : out std_logic                     -- Terminal Count
                        );
end bin_counter;
--------------------------------------------------------------------------------
architecture sync_bin_counter of bin_counter is
begin

TC <=  and_reduce(Q) and CET;    -- Logical expression taken from the datasheet.

sync_counter : process(CP, SR, P, PE, CEP, CET)
  begin

    if ((SR = '0') or (and_reduce(Q) = '1')) and (rising_edge(CP)) then Q <= "0000";
    elsif ((PE = '0') and rising_edge(CP)) then Q <= P;
    elsif (CEP = '1' and CET = '1' and PE = '1')  and rising_edge(CP) then Q <= Q + 1;
    end if;
    
  end process sync_counter;
end sync_bin_counter;
--------------------------------------------------------------------------------
