--------------------------------------------------------------------------------
-- Author               : Bimalka Piyaruwan Thalagala
-- GitHub               : https://github.com/bimalka98
-- Last Modified        : 06.07.2020

-- Functional Description :
-- This can be easily done through a "case" structure.
-- Basically a look up table problem.
-- Define cases for each opcode.

--============================================================================--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------------------------------
ENTITY ALU IS
PORT(

Op_code   : IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
A, B      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
Y         : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ) );

END ALU;
--------------------------------------------------------------------------------
architecture ALU_arch of ALU is


signal A_in : std_logic_vector(31 downto 0);
signal B_in : std_logic_vector(31 downto 0);

begin

A_in <= A; --std_logic_vector(resize(signed(A),32));
B_in <= B; --std_logic_vector(resize(signed(B),32));

alu_proc : process(Op_code)
 begin
  case Op_code is
    when "000" => Y <= A_in;
    when "001" => Y <= A_in + B_in;
    when "010" => Y <= A_in - B_in;
    when "011" => Y <= A_in AND B_in;
    when "100" => Y <= A_in OR B_in;
    when "101" => Y <= A_in + 1;
    when "110" => Y <= A_in - 1;
    when "111" => Y <= B_in;
    when others => Y <= X"00000000";
  end case;
 end process alu_proc;

end architecture ALU_arch;
