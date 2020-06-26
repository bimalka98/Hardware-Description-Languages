# Digital-Designs-with-FPGA

## Process of digital system designing
* Making a conceptual idea of the logical system to be built.
* Define a set of constraints that the final design should have.
* Choosing a set of primitive components from which the design is implemented.(This can be achieved by sub-dividing the design until the most primitive components are revealed.)

## Hardware Description Languages(HDLs) for FPGA Design

Hardware Description Languages are used to describe digital systems. Projects based on  `V-HDL(VHSIC-HDL)` and `Verilog-HDL`  languages are included in  this repository. Some basic concepts need to write codes in these languages are described below.

# WEEK 1

# VHDL (An IEEE standard / V = very high speed integrated circuit(VHSIC) / HDL = hardware description Language)

* More structured Language than verilog, therefore suitable for beginners who are interested in hardware description languages.
* VHDL is not case sensitive
* VHDL is not sensitive to white space and therefore no indentation rules.(spaces and tabs)
* Every statement ends with a semicolon. `This statement ends with a semicolon;`
* Comments are represented by two consecutive dashes in the beginning, and no block-type comments. `-- This is a comment.`
* No strict requirement of parentheses.
* Identifiers in VHDL are variable names, signal names and port names. And can only contain letters(a-z), numbers(0-9), underscores(-). Can only starts with a letter and can not contain 2 consecutive underscores and also can not end with an underscore.
* As every programming language Reserved words can not be used in naming of objects and some reserved words are as follows.
* Code is executed concurrently, NOT sequentially as in usual computer programs.

```
access   after    alias    all      attribute block
body     buffer   bus      constant exit      file
for      function generic  group    in        is
label`   loop     mod      new      next      null
of       on       open     out      range     rem
return   signal   shared   then     to        type
until    use      variable wait     while     with
```

## VHDL Assignments, Operators, Types

### VHDL assignments, signals, and variables.

In VHDL there are several objects types. As `signal`(to represent a wire), `variable`(to store local information), `constant`(to represent a constant)

#### Signals assignment operators (`<=`)
* signals wire to the entity
* Scheduled update (needs some time to update to the new value after the operator is executed.)
* To assign new value to a signal type object this operator is used.

```
Z <= A AND B;
Z <= D after 5ns;
```

#### Variables (`:=`)

* variables can be used only within the `process construct`(what is inside the process construct is executed top to bottom sequentially, NOT concurrently)
* Immediate update(right after the operator is executed new value takes the place of previous value.)
* To assign new value to a variable type object this operator is used.

```
count   := count +1;  -- simulation loop counter
a       := 27;        -- variable assignment
```

### Operators such as adders, subtractors, multipliers,...

```
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

#### Order Precedence of operators

1. Left to right,  Parenthesis
2. Unary, Single operand on right (mod A)
3. Binary, operands on both sides (A + B)

### Data Types

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

## `if - elsif - end if`, `case - end case`, `loop - end loop` environments




## VHDL design files has three main parts,

1. Standard logic Definition IEEE (IEEE_std_logic_1164)

* IEEE.std_logic_1164 library contains definitions for logical functions(and, or, not,...) and standard types and so on.
* std_ulogic has 9 different value settings and when a variable is declared as std_ulogic it may take any of these 9 values.
* Default value for std_ulogic is the left most value i.e. 'U'. Abstract from the IEEE.std_logic_1164 standard is given below.
```
type STD_ULOGIC is ( 'U',             -- Uninitialized
                     'X',             -- Forcing  Unknown
                     '0',             -- Forcing  0
                     '1',             -- Forcing  1
                     'Z',             -- High Impedance
                     'W',             -- Weak     Unknown
                     'L',             -- Weak     0
                     'H',             -- Weak     1
                     '-'              -- Don't care
                     );
```

2. Entity

* Interface(ports) with the outside world is defined by the entity.
* Inputs, outputs, inouts (bidirectional) ports may have one of the modes from `in`, `out` and `inout`
* The types of data that will be handled by `port` can be,

 `std_logic_vector(i downto 0)`-->(bundle- a set of similar signals)[`i downto 0` ===> MSB is at the left of the signal/ `0 to i` ===> MSB is at the right of the signal]

 `std_logic(bit)`--->(Single signal)

 `unsigned(127 downto 0)`

3. Architecture (Design  implementation)
Actual circuit implementation is done in this part and this can be achieved in four different ways and they are explained below.

### A simple AND gate implementation in VHDL.
```
-- Import std_logic library

library IEEE;
use IEEE.std_logic_1164.all;

-- Entity

entity AND_GATE is
port  (

A : in  std_logic;   -- input port declaration/ mode is `in` and type is `std_logic`
B : in  std_logic;   -- input port declaration
Y : out std_logic);  -- output port declaration

end AND_Gate;        --VHDL is not case sensitive. Therefore AND_GATE is the same as AND_Gate.

-- Architecture

architecture  this_arch of AND_Gate is

begin
Y <= A AND B;

end this_arch;

```
Gates are synthesized form the description of VHDL.

## VHDL modeling


Consider four bit comparator. For all the modeling types the `Standard logic Definition` and `entity` are the same. Only the `architecture` differs. Here in this comparator output is one only when the inputs are equal and zero otherwise.

```
-- Use standard IEEE library

library IEEE;
use IEEE.std_logic_1164.all;

-- Entity

entity comparator4 is port (

A,B     : in std_logic_vector(3 downto 0);
Result  : out std_logic   );

end comparator4;

```

### 1. Structured gate level modeling

library predefined primitives such as and, or and and2 and or2, Boolean logic bitwise and bitwise ors, or library user-defined functions

```
use work.gatespkg.all

-- architecture
-- structural gate description

architecture struct_arch of comparator4 is

signal x : std_logic_vector(3 downto 0); -- objects declaration

begin
u3: xnor2 port map (A(3), B(3), X(3));
u2: xnor2 port map (A(2), B(2), X(2));
u1: xnor2 port map (A(1), B(1), X(1));
u0: xnor2 port map (A(0), B(0), X(0));
u4: and4 port map (X(3), X(2), X(1), x(0), Result);

end struct_arch;

-- architecture
-- Boolean logic description

architecture bool_arch of comparator is
begin
Result <= not(A(3) xor B(3)) and
          not(A(2) xor B(2)) and
          not(A(1) xor B(1)) and
          not(A(0) xor B(0));
end bool_arch;
```

### 2. Data Flow modeling

Use assignments and select statements

```
-- architecture
-- dataflow description

architecture dataflow_arc of comparator is

begin
Result <= '1' when (A=B) else '0';

end dataflow_arc;

```

### 3. Behavioral modeling

Have a `process statement`, where anytime A or B changes in the sensitivity list, we update the circuit.
```
-- architecture
-- Behavioral description

architecture Behavioral_arc of comparator is
begin
  compareProcess : process(A, B) --process sensitivity list
  begin
  if (A=B) then
    Result <= '1';
  else
    Result <= '0';
  end if;

  end process compareProcess;
end behavioral_arc;
```
### 4. Hybrid modeling

A combination of the above three models is used to implement this.

# WEEK 2

### Vector Reduction in VHDL

* Bitwise operation over two vectors can be done simply as (`std_logic_vector_A  <operator> std_logic_vector_B`)

* Using `<operator>_REDUCE(std_logic_vector)` or `<operator>(std_logic_vector)`, we can reduce the std_logic_vector into a single std_logic. As an example, OR_REDUCE(V_A) will give the output, which was generated through bitwise OR over all the V_A elements.
```
-- Entity :  Note:  use IEEE.std_logic_misc.all;
entity gates is port (
  vA, vB, vC, vD  : in  std_logic_vector(3 downto 0);
  W,U,X,Y,Z       : out std_logic  );
end entity gates;
 
-- Architecture : reduction after VHDL-2008 tools
architecture RTL of gates is
begin
  W  <=  AND_REDUCE(vA);  -- Vector Reduction AND
  U  <=  NOR_REDUCE(vB);  -- Vector Reduction NOR
  X  <=  XOR_REDUCE(vD);  -- Vector Reduction XOR
  Y  <=  OR_REDUCE(vA) and vB(0);  -- OR Red, bit AND
  Z  <=  OR_REDUCE(vA and vB);     -- Bit AND, OR Red
end architecture RTL;

```
using VHDL-2008 you can use either of the following as an XOR reduction for bus A = "1011" :

1. z_out <= XOR( A );
2. z_out <= XOR_REDUCE( A );

<!-- New section -->
# Synchronous and Combinational logic in VHDL.

## Combinational Logic

* AND, OR, NOT gates are included in this combinational logic.
* Finite amount of time is taken to produce output when the inputs are given.
* Asynchronous path(No clock is involved).
* Can make synchronous by connecting a DLatche at the output.(output + D terminal)

```
-- Entity
entity gates is port (
  vA, vB      : in  std_logic_vector(3 downto 0);
  A,B,C,D     : in  std_logic;  
  W,U,X,Y,Z   : out std_logic;
  vX, vY      : out std_logic_vector(3 downto 0) );
end entity gates;

-- Architecture
architecture RTL of gates is
begin
  W  <= A and B;     U <= A nor B;  --AND, NOR
  X  <= C xor D;     Y <= C xnor D; --XOR, XNOR
  Z  <= (A and B) or (C and D);     --AND-OR
  vX <= vA and vB;    -- Vector bitwise AND
  vY <= vA or  vB;    -- Vector bitwise OR
end architecture RTL;
```
## Synchronous Logic: Latches and Flip Flops

* Latches and Flip Flops are included in  this synchronous logic.
* Logic path is synchronized with a clock.

### Implementation of a `D latch` in VHDL

```
-- Entity
entity DLatches is port (
  d, gate, clr        : in  std_logic;  
  q                   : out std_logic    );
end entity DLatches;


-- Architecture
architecture LArch of DLatches is begin
  latch_proc_1 : process (gate, d)
  begin
      if    (gate='1') then  q <= d;  
               -- No rising_edge()
      end if;  
         -- No gate=0 value, so latch inferred
  end process latch_proc_1;
end LArch;

-- another Latch example
architecture LArch of DLatches is begin
  latch_proc_2 : process (gate, d, clr)
  begin
      if    (clr ='1') then  q <= '0';
      elsif (gate='1') then  q <= d;   
      end if;
  end process latch_proc_2;
end architecture LArch;

```
### implementation of D Flip Flop-Sync Reset

```
-- Entity
entity DFF is port (
  d, clk, reset          : in  std_logic;  
  q                      : out std_logic    );
end entity DFF;


-- Architecture,
-- could use (clk'event and clk='1')

architecture DFF_Arch of DFF is
  begin dff_proc_1 : process (clk)
    begin
       if (rising_edge(clk))  then  
         if (reset='1') then q <=  '0';  
                 --  Sync Reset
         else                q <= d;
         end if;
       end if;
  end process dff_proc_1;
end architecture DFF_Arch;

```
Either of the following constructs will create a Flip-Flop :

1.  if ( clk'event and clk='1' ) then
2.  if ( rising_edge(clk) ) then

### implementation of D Flip Flop-Async Reset
* Additional set input is here.
```
-- Entity
entity DFF is port (
  d, clk, set, reset     : in  std_logic;  
  q                      : out std_logic    );
end entity DFF;

-- Architecture
architecture DFF_Arch of DFF is
  begin dff_proc_2 : process (clk, set, reset)
    begin
       if    (reset='1')        then  q <= '0';  
              -- Async
       elsif (rising_edge(clk)) then
          if    (set='0')       then  q <=  '1';
              -- Sync
          else                        q <=   d;  
              -- Sync
          end if;
       end if;
  end process dff_proc_2;
end architecture DFF_Arch;

```
### Implementation of D Flip Flop – Clock Enable

```
-- Entity
entity DFF is port (
  d, clk, ce, reset      : in  std_logic;  
  q                      : out std_logic    );
end entity DFF;

-- Architecture
architecture DFF_Arch of DFF is
  begin dff_proc_3 : process (clk, ce, reset)
    begin
       if    (reset='1')        then  q <= '0';  
                -- Async
       elsif (rising_edge(clk)) then
          if    (ce='1')        then  q <=   d;  
                -- Sync
          end if;
       end if;
   end process dff_proc_3;
end architecture DFF_Arch;

```













# Build and run a simulation in ModelSim

1. Open ModelSim and create a new project.
2. Create  new source files as required.
3. To add additional new source files
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/new_source.png)
4. To changes the layout of the ModelSim simulation environment
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/change_layout.png)
5. To set the initial values of the Entity
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/set_initial_val.png)
6. To run the simulation
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/run.png)
7. To changes the radix of entity.
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/radix.png)


## FPGA logic cell


![FPGA logic cell](https://upload.wikimedia.org/wikipedia/commons/1/1c/FPGA_cell_example.png)
logic is concurrent, not sequential

FPGA gates are hardware and therefore executes in parallel. Not as software which are executed in sequential manner.

### Course content related to this page can be found at coursera : https://www.coursera.org/learn/fpga-hardware-description-languages
