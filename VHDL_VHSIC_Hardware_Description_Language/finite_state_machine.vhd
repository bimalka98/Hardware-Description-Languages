--------------------------------------------------------------------------------
-- Author               : Bimalka Piyaruwan Thalagala
-- GitHub               : https://github.com/bimalka98
-- Last Modified        : 06.07.2020

-- Functional Description : Comments are given with the code

--============================================================================--

library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------

entity FSM is

-- State encoding using gray codes
generic
   (
A : std_logic_vector(1 downto 0) := "00"; -- Initial State
B : std_logic_vector(1 downto 0) := "01"; -- Next State
C : std_logic_vector(1 downto 0) := "11"  -- Last State
    );

-- Interface declaration
port
   (
   In1  : in std_logic;
   RST  : in std_logic;
   CLK  : in std_logic;
   Out1 : inout std_logic
   );
end entity FSM;
--------------------------------------------------------------------------------

architecture FSM_arch of FSM is

signal CurrentState, NextState : std_logic_vector(1 downto 0);

begin

-- Initialization of finite state machine
reset_proc : process(RST, CLK)
  begin
    if (RST = '1')  then
      CurrentState <= A;
    elsif rising_edge(CLK) then
      CurrentState <= NextState;
    end if;
  end process reset_proc;

-- State transition of the state machine
transition_proc : process(CLK, In1, CurrentState)
  begin
    case(CurrentState) is
      when A =>
        Out1 <= '0';
        if (In1 = '1')  then NextState <= B;
        else NextState <= A;
        end if;
      when B =>
        Out1 <= '0';
        if (In1 = '0')  then NextState <= C;
        else NextState <= B;
        end if;
      when C =>
        Out1 <= '1';
        if (In1 = '1') then NextState <= A;
        else NextState <= C;
        end if;
      when others =>
        Out1 <= '0';
        NextState <= A;
    end case;
  end process transition_proc;

end architecture FSM_arch;
