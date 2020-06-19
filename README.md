# Digital-Designs-with-FPGA

## Process of digital system designing
* Making a conceptual idea of the logical system to be built.
* Define a set of constraints that the final design should have.
* Choosing a set of primitive components from which the design is implemented.(This can be achieved by sub-dividing the design until the most primitive components are revealed.)

# Hardware Description Languages for FPGA Design

Hardware Description Languages are used to describe digital systems.

# WEEK ONE

## VHDL (An IEEE standard / V = very high speed integrated circuit(VHSIC) / HDL = hardware description Language)
* A more structured Language( with Entity and Architecture) than verilog
* Faster than schematic  capture
* Language Based therefore designs created earlier can be reused. Designs created year back can be reused.

VHDL design file has three parts,

1. Standard logic Definition IEEE (IEEE_std_logic_1164)

2. Entity (Interface)---->(input, output)

3. Architecture (Design  implementation)

```
-- (VHDL comment)

```
```
-- Import std_logic library

library IEEE;
use IEEE_std_logic_1164.all;

-- Entity

entity ANDGATE is
        port(

A : in std_logic;
B : in std_logic;
Y : out std_logic;

            )
end entity ANDGATE;

-- Architecture

architecture  RTL of ANDGATE is
begin
Y <= A AND B;
end architecture RTL;
```
Gates are synthesized form the description of VHDL

## VHDL modeling


Consider four bit comparator. For all the modeling types the `Standard logic Definition` and `entity` are the same. Only the `architecture` differs.

```
-- Use standard IEEE library

library IEEE;
use IEEE_std_logic_1164.all;

-- Entity

entity comparator is port (
A,B     : in std_logic_vector(3 downto 0);
Result  : out std_logic);

end comparator;

```

### 1. Structured gate level modeling

library predefined primitives such as and, or and and2 and or2, Boolean logic bitwise and bitwise ors, or library user-defined functions

```
use work.gatespkg.all

-- architecture
-- structural gate description

architecture struct of comparator is
signal x : std_logic_vector(3 downto 0);

begin
u3: xnor2 port map (A(3), B(3), X(3));
u2: xnor2 port map (A(2), B(2), X(2));
u1: xnor2 port map (A(1), B(1), X(1));
u0: xnor2 port map (A(0), B(0), X(0));
u4: and4 port map (X(3), X(2), X(1), x(0), Result);
end struct;

-- architecture
-- Boolean logic description

architecture bool of comparator is
begin
Result <= not(A(3) xor B(3)) and
          not(A(2) xor B(2)) and
          not(A(1) xor B(1)) and
          not(A(0) xor B(0));
end bool;
```

### 2. Data Flow modeling

Use assignments and select statements

```
-- architecture
-- dataflow description

architecture dataflow of comparator is
begin
Result <= '1' when (A=B) else '0';
end dataflow;

```

### 3. Behavioral modeling

Have a `process statement`, where anytime A or B changes in the sensitivity list, we update the circuit.
```
-- architecture
-- Behavioral description

architecture Behavioral of comparator is
begin
  compareProcess : process(A, B) --process sensitivity list
  begin
  if (A=B) then
    Result <= '1';
  else
    Result <= '0';
  end if;

  end process compareProcess;
end behavioral;
```
## VHDL Assignments, Operators, Types

### VHDL assignments, signals, and variables.

#### Signals assignment operators (<=)
* signals wire to the entity: std_logic
* Scheduled update
```
Z <= A AND B;
Z <= D after 5ns; is a simulation
```

#### Variables (:=)
* Variable only within the process: integrated
* Immediate update   
```
count := count +1; --simulation loop counter
a :=27; variable assignment
```
variable updates immediately and does not need to wait for an event like a clock edge in the process.

### Operators such as adders, subtractors, multipliers

```
-- many of these are synthesized in to gates

**      exponent
abs     absolute value
not     complement
+ -     add/ subtract
*       multiply
/       divide
mod     modulo
rem     remainder
srl , sll     shift right/ left
rol , ror     rotate left/ right
=       equal
/=      not equal
<, <=, > , >=  greater, greater than or equal...
and , or , nand , nor , xor , xnor logical operators
```

#### Order Precedence

1. Left to right,  Parenthesis

2. Unary Single operand on right (mod A)

3. Binary operators on both sides (A + B)

##### Data Types
* Array

```
string              "abc"
bit_vector          "1010"
std_logic_vector    "101Z"

```

* Scalar

```
character         'a'
bit               '1' '0'
std_logic         '1', '0', 'X', 'Z'
Boolean           true, false
real, integer     3.87 ,1E+5, 4
time              fs, ps, ns. us, ms  
```

## FPGA logic cell


![FPGA logic cell](https://upload.wikimedia.org/wikipedia/commons/1/1c/FPGA_cell_example.png)
logic is concurrent, not sequential

FPGA gates are hardware and therefore executes in parallel. Not as software which are executed in sequential manner.
