--------------------------------------------------------------------------------
--                                                                            --
--               Application Assignment 4 Module 1 Course 2                   --
--                                                                            --
--------------------------------------------------------------------------------
--
-- @file AAC2M1P4solved.vhd
-- @brief Application Assignment 2-001 Majority Vote Code
-- @version: 1.0
-- Date of current revision:  @date [2018-08-13]
-- Target FPGA: [Intel Altera MAX10]
-- Tools used: [Quartus Prime 16.1] for editing and synthesis
--             [Modeltech ModelSIM 10.4a Student Edition] for simulation
--             [Quartus Prime 16.1]  for place and route if applied
--
--  Functional Description:  This file contains the VHDL which describes the
--               FPGA implementation of a Majority Vote Circuit. The inputs are
--               signals A, B, C with one output Y that is true only if at
--               least 2 of the inputs are true.

--  Hierarchy:  There is only one level in this simple design.
--
--  Designed for: Coursera
--
--  Designed by:  @author Tim Scherr
--                University of Colorado
--
--      Copyright (c) 2018 by Tim Scherr
--
-- Redistribution, modification or use of this software in source or binary
-- forms is permitted as long as the files maintain this copyright. Users are
-- permitted to modify this and use it to learn about the field of HDl code.
-- Tim Scherr and the University of Colorado are not liable for any misuse
-- of this material.
------------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;

entity Majority is port (
    A, B, C: in std_logic;
    Y: out std_logic);
end Majority;

-- Behavioral Description architecture

architecture behavioral of Majority is
begin
MajorityProcess : process(A, B, C)
begin
    -- For output Y to be one at least two of the inputs must be equal to one.
    -- There are 3 different possibilities that this can happen.
    -- A and B are True, C is False. Then (A AND B) is '1'.
    -- A and C are True, B is False. Then (A AND C) is '1'.
    -- B and C are True, A is False. Then (B AND C) is '1'.
    -- According to this the following expression becomes true
    -- for any one of these three possibilities.

    if ((A and B ) or (B and C) or (A and C )) = '1' then
    Y <= '1';
    else
    Y <= '0';
    end if;
    end process MajorityProcess;
end behavioral;


-- Last Modified :Bimalka Piyaruwan Thalagala.
-- Date Modified :25.06.2020.

-- Boolean Description architecture (additional)

-- architecture bool of Majority is
-- begin
-- Y <=  (A and B ) or (B and C) or (A and C );
-- end bool;
