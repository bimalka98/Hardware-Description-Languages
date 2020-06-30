# Digital-Designs-with-FPGA

## Process of digital system designing
* Making a conceptual idea of the logical system to be built.
* Define a set of constraints that the final design should have.
* Choosing a set of primitive components from which the design is implemented. (This can be achieved by sub-dividing the design until the most primitive components are revealed.)

## Hardware Description Languages(HDLs) for FPGA Design

Hardware Description Languages are used to describe digital systems. Projects based on  `V-HDL(VHSIC-HDL)` and `Verilog-HDL`  languages are included in this repository. Some basic concepts need to write codes in these languages are described below.

# WEEK 1

# VHDL (An IEEE standard / V = very high speed integrated circuit(VHSIC) / HDL = hardware description Language)

* More structured Language than Verilog, therefore suitable for beginners who are interested in hardware description languages.
* VHDL is not case sensitive
* VHDL is not sensitive to white space and therefore no indentation rules. (spaces and tabs)
* Every statement ends with a semicolon. `This statement ends with a semicolon;`
* Comments are represented by two consecutive dashes at the beginning and no block-type comments. `-- This is a comment.`
* No strict requirement of parentheses.
* Identifiers in VHDL are variable names, signal names and port names. And can only contain letters(a-z), numbers(0-9), underscores(-). Can only starts with a letter and can not contain 2 consecutive underscores and also can not end with an underscore.
* As every programming language Reserved words can not be used in the naming of objects and some reserved words are as follows.
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
* To assign a new value to a signal type object this operator is used.

```
Z <= A AND B;
Z <= D after 5ns;
```

#### Variables (`:=`)

* variables can be used only within the `process construct`(what is inside the process construct is executed top to the bottom sequentially, NOT concurrently)
* Immediate update(right after the operator is executed new value takes the place of the previous value.)
* To assign a new value to a variable type object this operator is used.

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
2. Unary, Single operand on the right (mod A)
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




## VHDL design files have three main parts,

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

## VHDL modelling


Consider four-bit comparator. For all the modelling types the `Standard logic Definition` and `entity` are the same. Only the `architecture` differs. Here in this comparator output is one only when the inputs are equal and zero otherwise.

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

### 1. Structured gate-level modelling

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

### 2. Data Flow modelling

Use assignments and select statements

```
-- architecture
-- dataflow description

architecture dataflow_arc of comparator is

begin
Result <= '1' when (A=B) else '0';

end dataflow_arc;

```

### 3. Behavioural modelling

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
### 4. Hybrid modelling

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

<!------------------------------------------------ New section -->
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
## Sequential Logic Designs

In combinational logic, there are not any feedback loops in the design. But in sequential logic, there are feedback loops(cycles) in the design. Therefore they can be used to store logical state(o or 1). To analyze the behaviour of such circuit propagation delay must be taken into account.

## Synchronous Logic: Latches and Flip Flops

* Latches and Flip Flops are included in this synchronous logic.
* Logic path is synchronized with a clock.
* In a D latch there is no clock signal. But in a D Flip Flop, there is a clock signal.

### Note that
### Q_n: Present state of latch/Flip Flop
### Q_n+1: Next state of latch/Flip Flop


## Implementation of SR latch

* SR - implies set and reset
* SR latch can be implemented using either nor gates or NAND gates.

#### 1. When implementing using NOR gates, Configuration must be as follows:

![SR latch](https://upload.wikimedia.org/wikipedia/commons/5/53/RS_Flip-flop_%28NOR%29.svg)

```
The truth table for NOR gate
A B     A nor B
0 0        1
0 1        0
1 0        0
1 1        0

Note: NOT gate can be implemented using NOR, consider first and last lines of the truth table.
when A = B = 0 ==> OUT =1, When A = B = 1 ==> OUT = 0.
```

* R input goes with upper nor gate. S input goes with lower nor gate.
* R --> goes with Normal path (Q)
* S --> goes with complement path (Q')
* If S and R both 0; State will be preserved.
* If Set is 1; the state will be set to 1.
* If reset is 1; the state will be set to 0.
* There is no both S and R are 1 state. It is an invalid input.

* Consider only the Q when defining the Truth table. Because Q' is always the complement of the Q.
```
The truth table for SR latch
S R Q_n   Q_n+1

-- First Consider the normal path to take the Q_n+1
0 0 0     Q_n    -- Q_n+1 = (R=0 + Q_n')' ==> ((R=0)'.Q_n) = 1.Q_n = Q_n
0 0 1     Q_n    -- When R = 0 and S = 0, Q_n+1 = Q_n ; State Preserved.

0 1 0      0     -- Q_n+1 = (R=1 + Q_n')' ==> (1)' = 0; Therefore when R=1
0 1 1      0     -- Regardless of the present value of Q_n;  Q_n+1 = 0.

-- Now consider the complement path to take the Q_n+01
1 0 0      1     -- Consider complement path- (Q_n+1)' = (S=1 + Q_n)' = 0
1 0 1      1     -- Regardless of the present value of Q_n;  Q_n+1 = 1.

1 1 0     Invalid
1 1 1     Invalid
```

#### 2. When implementing using NAND gates, Configuration must be as follows:

![nand sr latch](https://upload.wikimedia.org/wikipedia/commons/9/92/SR_Flip-flop_Diagram.svg)

* Due to less power consumption than the NOR gate implementation this NAND gate implementation is preferred over NOR gate implementation.
* S and R interchanged.
* S upper and goes with Q.
* R lower and goes with Q'.

```
A B A nand B
0 0    1
0 1    1
1 0    1
1 1    0
```

```
The truth table for SR latch with NAND gates.

* Everything found in the NOR gate implementation is now in the other way round. (NOR implementation eke thiyena properties okkoma anith paththata)

S R Q_n   Q_n+1

0 0 X     Invalid
0 1 X        1   -- When Reset is given Q_n+1 = 1 (R ==> Set to 1)
1 0 X        0   -- When Set is given Q_n+1 =  0 (S ==> Reset to 0)
1 1 X       Q_n  -- Memory state. State is preserved.

```


### Implementation of a `D latch` in VHDL

![D latch](https://upload.wikimedia.org/wikipedia/commons/c/cb/D-type_Transparent_Latch_%28NOR%29.svg)

* D latch has two inputs(D-data, E-enable) and two outputs (Q and its complement Q')
* Whenever the Enable = 0 regardless of the D input, state of the SR latch will be preserved. (Memory state)
* When the Enable = 1, Q will be equal to the  input D, (when D = 1 --> Q = 1, when D = 0 --> Q = 0)


```
-- Entity
entity DLatches is port (
  d, enable, clr        : in  std_logic;  
  q                   : out std_logic    );
end entity DLatches;


-- Architecture
architecture LArch of DLatches is begin
  latch_proc_1 : process (enable, d)
  begin
      if  (enable ='1') then  q <= d;  -- No rising_edge()/Asynchronous logic
      end if;                          -- No enable = 0 value, so latch inferred
  end process latch_proc_1;
end LArch;

-- another Latch example
architecture LArch of DLatches is begin
  latch_proc_2 : process (enable, d, clr)
  begin
      if    (clr ='1')    then  q <= '0';
      elsif (enable ='1') then  q <= d;   
      end if;
  end process latch_proc_2;
end architecture LArch;

```

<!--------------------------------------------- Flip Flops-->

### Implementation of SR Flip Flop

* Implementation of an SR Flip Flop using NAND gates is given below.


![SR Flip Flop](https://learnabout-electronics.org/Digital/images/Clocked-SR-ff-high-activated.gif)
```
The truth table of an SR Flip Flop (Extended version of NAND SR latch)

* Truth table is the same as `NOR gate implementation of SR latch`.
* NOR SR latch == NAND SR Flip Flop

CLK S R Q_n  Q_n+1
1   0 0  X    Q_n(State Preserved)
1   0 1  X     0 (Reset Condition)
1   1 0  X     1 (Set Condition)
1   1 1  X   Invalid

```



### Implementation of D Flip Flop(DFF) with Sync & Reset

![DFF](https://electronicsforu.com/wp-contents/uploads/2017/08/d-flip-flop.png)

* Extended version of SR Flip Flop with additional NOT gate.
* When the clock is LOW(0), both inputs to the NAND SR latch will be HIGH and therefore the state of the latch will be preserved. Q_n+1 = Q_n(Memory state)
* When clock is HIGH(1), Q_n+1 = D(Memory write state set/reset)

```
-- Entity
entity DFF is port (
  d, clk, reset          : in  std_logic;  
  q                      : out std_logic    );
end entity DFF;


-- Architecture,

architecture DFF_Arch of DFF is
  begin dff_proc_1 : process (clk)
    begin
      if (rising_edge(clk))  then     -- could use (clk'event and clk='1')
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

<!-- New section ---------------------------------->
## Counters and Registers

### Data register Implementation

![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/data_reg.PNG)
```
-- Entity
entity Data_Reg is port (
  clk, reset, load : in  std_logic;  
  d        : in  std_logic_vector(3 downto 0);
  q        : out std_logic_vector(3 downto 0));
end entity Data_Reg;

-- Architecture
architecture Reg_Arch of Data_Reg is
  begin dreg_proc : process (clk, reset, load)
    begin
      if    (reset='0')        then  q <= "0000";
      elsif (rising_edge(clk)) then
        if (load='1')          then  q <= d;
        end if;
      end if;
  end process dreg_proc;
end architecture Reg_Arch;a

```
### Shift Registers Implementation

![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/shift_reg.PNG)
```
-- Entity
entity Shift_Reg is port (
  clk, reset, shift, d0 : in  std_logic;  
  q    : out std_logic_vector(3 downto 0));
end entity Shift_Reg;

-- Architecture, could SLL or shift_left(q,1)
architecture SREG_Arch of Data_Reg is begin
  sreg_proc : process (clk, reset)
  begin
      if    (reset='0')        then  q <= "0000";
      elsif (rising_edge(clk)) then
        if  (shift='1')        then  
                 q(0) <= d0;  
                 q(1) <= q(0);
                 q(2) <= q(1);
                 q(3) <= q(2);
        end if;
      end if;
  end process sreg_proc;
end architecture SREG_Arch;

```
## Binary Counter Implementation

![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/bin_counter.PNG)
```
-- Entity
entity Counter is port (
  clk, reset, load, en : in  std_logic;  
  d         : in  std_logic_vector(3 downto 0);
  q         : out std_logic_vector(3 downto 0));
end entity Counter;

-- Architecture
architecture Counter_Arch of Counter is begin
  count_proc : process (clk, reset, load, en)
  begin
      if    (reset='1')      then  q  <= "0000";
      elsif (rising_edge(clk)) then
         if (load='1')       then  q  <= d;
         elsif (en='1')      then  q  <= q + 1;

                -- To enable this feature, right click on the ModelSim vhd file
                -- Then click Properties
                -- Enable "Use 1076 - 2008"

         end if;
      end if;
  end process count_proc;
end architecture Counter_Arch;

```
### Register File Implementation

Register Files are useful constructs that allow addressing of registers. Each flop is assumed as an n-bit register.

* New code portion called `generic` is declared in the entity in addition to the port.
* What defined in this `generic` part will be used throughout the design. In both entity and architecture.

![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/reg_file.PNG)
```
-- Entity --  use IEEE.numeric_std.all; integer conversion
entity regFile is
  generic (Dwidth : integer := 8;
           Awidth : integer := 2 );
  port (
   clk, wren    : in  std_logic;  -- Clock and Write enable
   wdata        : in  std_logic_vector(Dwidth-1 downto 0);   -- Write data
   waddr, raddr : in  std_logic_vector(Awidth-1 downto 0);   -- Write address, Read address
   rdata        : out std_logic_vector(Dwidth-1 downto 0) ); -- Read data
end entity regFile;

-- Architecture
architecture RFile_Arch of regFile is

    -- Declaration of a new data type.
    type array_type (0 to 2**Awidth-1) of std_logic_vector (Dwidth-1 downto 0);

    -- Making an object under the type declared.
    signal array_reg : array_type;

  begin rf_proc : process (clk, wren, wdata, waddr, raddr)
    begin
      if    (rising_edge(clk))      then
         if (wren='1')              then  
               array_reg(to_integer(unsigned(waddr)))  <= wdata; -- Type conversion
         end if;
         rdata <= array_reg(to_integer(unsigned(raddr)));
     end if;
  end process rf_proc;
end architecture RFile_Arch;

```

## Buses and Tristate Buffers

### Tri-state Buses
External connections on FPGA pins are often in a group of related signals known as a `bus`. The I/O structure of FPGAs often  allow the bus to be tri-stated, so that multiple drivers can be attached to the IO at the same time, with only one driver active.
```
-- Entity
entity y_tri is port (
  OE        : in  std_logic;
  Dout      : in  std_logic_vector(3 downto 0);
  Pinout    : out std_logic_vector(3 downto 0) );
end entity y_tri;
 
-- Architecture
architecture tri_arch of y_tri is
begin
      Pinout <= Dout when (OE='1'),
                (others  => "ZZZZ") when others ;
end architecture tri_arch;

```
When driving external tri-stated buses, some protocol should be used to assure that only one drive is active on the bus at a time. VHDL code can define tri-state buses, but tri-state buses are typically not implemented inside of an FPGA but rather as a mux/multiplexer.

Tri stating the output of an IO pin allows for external devices to safely drive the shared pin as an input. Driving an pin as output '0' or ground while and external device is driving a high voltage '1' value onto the IO pin could burn out the driver on either device. Setting the IO to high impedance or 'Z' will remove the voltage conflict.


### Bi-directional Buses
The I/O structure of the FPGA will also allow us to create Bi-directional buses, in which the external pin can be treated as either an input or an output, depending on the state of the enable signal.
```
-- Entity
entity bidir is port (
 OE    : in    std_logic;
 Dout  : in    std_logic_vector(3 downto 0);
 Din   : out   std_logic_vector(3 downto 0);
 IOpin : inout std_logic_vector(3 downto 0) );
end entity bidir;

-- Architecture
architecture bidir_arch of bidir is
  begin bi_proc : process (OE, Dout)
    begin
      Din <= IOpin;
      if    (OE='1') then IOpin <= Dout;
      elsif (OE='0') then IOpin <= "ZZZZ";
      else                IOpin <= "XXXX";
      end if;
    end process bi_proc;
end architecture bidir_arch;

```
### Joining and Splitting Buses
VHDL includes the concatenation operator which allows buses to be combined.  Splitting buses can be done using indexing.  

```
-- Entity
entity bus_js is port (
  A     : in    std_logic_vector(4 downto 0);
  B     : in    std_logic_vector(2 downto 0);
  X, Y  : out   std_logic;
  Dout  : out   std_logic_vector(5 downto 0) );
end entity bus_js;
-- Architecture
architecture js_arch of bus_js is
  begin js_proc : process (A,B)  begin
      Dout <= (B(2) & B(1) & B(0) &
               A(2) & A(1) & A(0));
      X <= A(3);    
      Y <= A(4);
  end process js_proc;
end architecture js_arch;
```

## Modular Designs: Components, Generate and Loops in VHDL

Tools provided in VHDl to make modular designs,
* component instantiations
* looping
* generate blocks
* tasks, and functions

### Component Instantiations
This is the fundamental way of building hierarchy in VHDL design.
```
architecture my_higher of my_upper is

  component my_lower_OR port (
    A,B : in  std_logic;
    Z :out std_logic);
  end component;

  begin
  my_instance_1 : my_lower_OR port map (
    A => A_upper, B => B_upper, Z => Z_upper);
  my_instance_2 : my_upper_OR port map ();
  my_instance_3 : my_lower_OR port map ();
  -- n number of instances can be used.

end architecture my_higher;
```


* Another example of component instantiation
```
architecture add16_arch of add16 is

  component add4 port (
    A,B : in std_logic_vector(3 downto 0);
    Cin : in std_logic;
    Cout : out std_logic;
    Sum : out std_logic_vector(3 downto 0)
    );
  end component;

begin
-- To create 16 bit adder we need to connect four 4 bit adders.

-- 1st 4 bit adder
add4_inst1 : add4 port map (
  A => A(3 downto 0), B => B(3 downto 0), Z => Cin(0), Sum(3 downto 0);

-- 2nd, 3rd 4 bit adders

-- 4th 4 bit adder
add4_inst4 : add4 port map (
  A => A(15 downto 12), B => B(15 downto 12), z => Cin(3), Sum(15 downto 12));

end architecture add16_arch;
```
### Loops in VHDL

* Use to generate data or test patterns
* In synthesis to replicate many identical circuits within `generate` block.

```
-- architecture

architecture loop_arch of my_loop is begin

  while (i <= 8) loop
    if (B = '1') then
      Z(i) <= A(i);
    end if;
    i := i +1;
  end loop;
end architecture;
```
### Generate block

Generate blocks specifies objects to be repeated. The index of the for loop sets the number of elements to be repeated.
```
-- architecture

architecture xorgen_arch of xorgen is begin

  -- Generation of an eight bit bus

  gen_process : for i in 0 to 7 generate
    xout(i) <= Ain(i) xor Bin(i);
  end generate gen_process;

end architecture xorgen_arch;  
```

# Build and simulate ModelSim


1. Open ModelSim and create a new project.
2. Create new source files as required.
3. To add additional new source files
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/new_source.png)
4. To changes the layout of the ModelSim simulation environment
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/change_layout.png)
5. To set the initial values of the Entity
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/set_initial_val.png)
6. To run the simulation
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/run.png)
7. To changes the radix of the entity.
![](https://github.com/bimalka98/Digital-Designs-with-FPGA/blob/master/Figures/radix.png)


## FPGA logic cell
![FPGA logic cell](https://upload.wikimedia.org/wikipedia/commons/1/1c/FPGA_cell_example.png)
logic is concurrent, not sequential

FPGA gates are hardware and therefore executes in parallel. Not as software which is executed sequentially.


## References:

* Wikipedia: https://en.wikipedia.org/wiki/Flip-flop_(electronics)
* Images: https://learnabout-electronics.org
* Course content can be found at Coursera: https://www.coursera.org/learn/fpga-hardware-description-languages
