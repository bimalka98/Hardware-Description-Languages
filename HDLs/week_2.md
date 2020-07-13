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

* Consider only the Q when defining the Truth table. Because Q'(Q bar) is always the complement of the Q.
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

<!------------------------------- Flip Flops-------------------------------->

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
      if (rising_edge(clk))  then       -- could use (clk'event and clk='1'), wait for an event to happen
         if (reset='1') then q <= '0'; --  Sync Reset
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
       if    (reset='1')        then  q <= '0';    -- Asynchronous Reset
       elsif (rising_edge(clk)) then
          if    (set='0')       then  q <=  '1';   -- Synchronous --In NAND gate implementation
          else                        q <=   d;    -- Synchronous
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
       if    (reset='1')        then  q <= '0';  -- Asynchronous reset
       elsif (rising_edge(clk)) then
          if    (ce='1')        then  q <=   d;  -- Synchronous
          end if;
       end if;
   end process dff_proc_3;
end architecture DFF_Arch;
```

### Implementation of JK Flip Flop {\displaystyle Q_{\text{next}}=J{\overline {Q}}+{\overline {K}}Q}

* J ---> S
* K ---> R

![JK Flip Flop](https://i1.wp.com/s3.amazonaws.com/dcaclab.wordpress/wp-content/uploads/2020/01/20202426/JK1.png?zoom=1.25&resize=682%2C351&ssl=1)

Consider NAND gate implementation of an SR flip flop.
```
CLK S R Q_n  Q_n+1

1   0 0  X    Q_n(State Preserved)
1   0 1  X     0 (Reset Condition)
1   1 0  X     1 (Set Condition)
1   1 1  X   Invalid
```
There is one state in this SR flip flop where both S and R equal to 1, then next state of the flip flop is not defined.(Invalid). To make use of this invalid state JK Flip Flops had been introduced. First three combinations of JK Flip Flop is the same as SR flip flop.(IF THE INPUTS OF THE JK Flip Flop IS DIFFERENT THEN OUTPUT WILL BE THE VALUE OF "J") But when both J and K equal to 1, current state of the flop will be complemented.
```
CLK J(S) K(R)   Q_n                 Q_n+1

  1   0  0        X            Q_n(State Preserved)
  1   0  1        X            0 (Reset Condition)
  1   1  0        X            1 (Set Condition)
  1   1  1        X            complement(Q_n)
```
<!------------------------------ New section ---------------------------------->
##  Registers  and Counters

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

Counters can be divided into two categories.[Reference Video](https://www.youtube.com/watch?v=yqg1sqhZG3M)

1. Asynchronous Counters / Ripple Counters
* Clock is connected to only one Flip Flop and Output of the each preceding flop is connected to the clock of the next flop.
* Circuit operates slowly as some time is needed to propagate the clock from one flop to another.

2. Synchronous Counters
* Clock is connected to all the Flip Flops and therefore all the Flops receive the same clock signal.
* Circuit operates in the speed of the clock.

Counters can also be divided into three types as `Up counters`, `Down counters` and `Up-Down counters`.
1. [3 Bit Asynchronous Up Counter](https://www.youtube.com/watch?v=s1DSZEaCX_g)
2. [3-Bit Synchronous Up Counter](https://www.youtube.com/watch?v=6e8oV2blkGs)

JK Flip Flops can be used not only to store values but also to frequency division by cascading multiple flops through Q and clk(previous flop's Q and next flop's clk). In counters the property of toggling between states of a JK flip flop is used. Therefore all the J and K inputs are kept at HIGH(1) state. If there are n number of Flip Flops then the original clock frequency will be divided by 2**n.
Additionally counting can be done from 0 to 2**n. At the each falling edge of the clock the state of the Flip Flop is toggled. [Negative Edge Triggered JK Flip Flop](https://www.youtube.com/watch?v=iaIu5SYmWVM)

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

-- To enable this q  <= q + 1 feature, right click on the ModelSim vhd file
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
  generic (
    Dwidth : integer := 8;   -- Data Width
    Awidth : integer := 2 ); -- Address Width

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

## Test Benches in VHDL
* A test bench is a program written in any language for the purposes of exercising and verifying the functional correctness of the hardware model as coded.
* Also known as a test fixture or test harness.
* A test bench is a powerful tool for generating test stimulus and test results
* A test bench can have several functional sections, including:
1. Top-level test bench declaration
2. Stimulus, Response, and Component  Signal declarations
3. Component (Device Under Test) instantiations
4. Test Monitor which logs results and reports mis-compares

* Top-level test bench declaration and Component (Device Under Test) instantiations
```
-- Entity : no port list !
entity tb_adder is  end entity tb_adder;

----------------------------------------------------------------

-- Architecture
architecture test_arch of tb_adder is

----------------------------------------------------------------
  component Add4 port (
     Data1,Data2 : in  std_logic_vector(3 downto 0);
     Cin         : in  std_logic;  
     Cout        : out std_logic;
     Sum         : out std_logic_vector(3 downto 0) );
  end component Add4;

  signal a_tb, b_tb : std_logic_vector(3 downto 0); -- INPUT
  signal Cin        : std_logic;                    -- INPUT
  signal Sum_tb     : std_logic_vector(3 downto 0); -- OUTPUT
  signal Cout_tb    : std_logic;                    -- OUTPUT
  signal expect     : std_logic_vector(3 downto 0); --expected  


----------------------------------------------------------------
begin
    -- DUT(Device under test) Instantiation
    DUT : Add4 port map (
          Data1 => a_tb,   
          Data2 => b_tb,
          Cin   => Cin,    
          Cout  => Cout_tb,
          Sum => Sum_tb);
----------------------------------------------------------------
```
* Stimulus generating
1. By hand drawn waves
```
----------------------------------------------------------------          
    -- Stimulus by hand drawn waves, poor coverage
    stim_proc : process begin
     wait for 0ns;
       a_tb   <= "0010"; b_tb <= "0010"; Cin <= '0'; expect <= "0100";
     wait for 10ns;
       a_tb   <= "1111"; b_tb <= "0000"; Cin <= '1'; expect <= "0000";
     wait for 10ns;
       a_tb   <= "0010"; b_tb <= "0100"; Cin <= '1'; expect <= "0111";
     wait;
    end process stim_proc;
----------------------------------------------------------------
```

* Stimulus generating
2. By using loops
```
----------------------------------------------------------------
    -- Stimulus automation with loops
    -- Architecture : Generates coverage and expected stimulus
Loop_proc: process
    variable i, j, k : integer;
  begin
    for i in 0 to 15 loop  a_tb <= i;
      for j in 0 to 15 loop  b_tb <= j;
        for k in 0 to 1 loop   
          Cin <= k;
          wait for 10ns;
          expect <= a_tb + b_tb + Cin;
        end loop;
      end loo;
    end loop;
  end process Loop_proc;           
end architecture test_arch;

----------------------- For self checking--------------------------
Replace,
expect <= a_tb + b_tb + Cin;

with,
if (sum_tb /= a_tb + b_tb + Cin) then
    write(str_o, string'(“Error - Sum”));
    writeline(output, str_o);
    wait;
end if;
----------------------------------------------------------------
```
* Test Monitor which logs results and reports mis-compares
* time'image(now) is the current clock tick.
```
----------------------------------------------------------------
    -- Monitor, use ieee.std_logic_textio.all;   
    --          use std.textio.all;
    txt_out : process (Sum_tb, Cout_tb)
      variable str_o : line;
    begin
      write(str_o, string'(" a="));      write(str_o, a_tb);
      write(str_o, string'(" b="));      write(str_o, b_tb);
      write(str_o, string'(" cin="));    write(str_o, Cin);   
      write(str_o, string'(" sum="));    write(str_o, Sum_tb);   
      write(str_o, string'(" cout="));   write(str_o, Cout_tb);   
      write(str_o, string'(" expect=")); write(str_o, expect);
      assert false report time'image(now) & str_o.all  
             severity note;
    end process txt_out;
----------------------------------------------------------------               
end architecture test_arch;
```
* Output
```
(ModelSim : Time messages removed)
# ** Note: 0 ns  a=0010 b=0010 cin=0 sum=XXXX cout=X expect=0100
# ** Note: 0 ns  a=0010 b=0010 cin=0 sum=0100 cout=0 expect=0100
# ** Note: 10 ns a=1111 b=0000 cin=1 sum=0000 cout=1 expect=0000
# ** Note: 20 ns a=0010 b=0100 cin=1 sum=0111 cout=0 expect=0111
```










### Test Benches in VHDL: Synchronous

The clk_gen process presented here doesn't stop generating a clock signal after a few cycles due to the wait for T/2 statement. The clock process runs forever, independently and in parallel to other processes.

###  Counter Test Bench
```
-------------------------- Testbench Entity : No port list----------------------
entity Counter_tb is  end entity Counter_tb;  

---------------------------Testbench Architecture ------------------------------
architecture Counter_arch of Counter_tb is

  component Counter port (
    d                    : in std_logic_vector(3 downto 0);
    clk, reset, load, en : in std_logic;
    q                    : out std_logic_vector(3 downto 0));
  end component Counter;

-- Variables declarations

  constant delay : integer := 10; -- wait
  constant n     : integer := 4;  -- width counter
  constant T     : time   := 20 ns; -- clock period
  signal   clock : std_logic := '0';  -- clock generator
  signal   reset : std_logic := '0';  -- reset generator

  signal  data_tb : std_logic_vector(n-1 downto 0) := "0000";
  signal   load   : std_logic := '0';  -- stimulus
  signal   en     : std_logic := '0';  -- stimulus
  signal   q_tb   : std_logic_vector(3 downto 0);  -- output
  signal   check  : std_logic_vector(n-1 downto 0) := "0000"; -- compare to count


   begin
      -- Device Under Test Instantiation
      DUT : Counter port map (
            d      => data_tb,   
            clk    => clock,    
            reset  => reset,    
            load   => load,     
            en     => en,  
            q      => q_tb );

-- Clock declarations, this part runs forever parallel to all the processes(an infinite loop)
     clk_gen : process begin
        clock <= '0';   
        wait for T/2; --  10 nsec of 0
        clock <= '1';
        wait for T/2; --  10 nsec of 1, for 20 nsec period
      end process;  

-- Reset signal generation and releasing after 10 nanoseconds
      reset <= '1', '0' after 10 ns; --  10 nsec

      test_proc : process
        variable line_o : line;

      begin
        -- Wait until some events to happen.
        wait until falling_edge(reset); --  wait for the reset signal
        wait until falling_edge(clock); --  wait for a clock

        -- Assignment of values to variables
        load <= '1';
        en <= '0';
        data_tb <= "1010";

        wait until falling_edge(clock);

        -- Compare whether the Q output is not equal to the defined data_tb
        if (q_tb /= "1010") then
          write(line_o, string'("Load fail "));
          write(line_o, q_tb);
          writeline(output, line_o);
        end if;

        check <= "1010";
        load  <= '0';
        en    <= '1';  
        wait for 1 ns;

        for i in 1 to 2**n loop
          check <= check + 1;
          wait until falling_edge(clock);
          if (q_tb /= check ) then
            report "count fail at time count" & time'image(now) & integer'image(i); -- Report to the Screen.
          end if;
        end loop;
        wait;
        end process test_proc;
      end architecture Counter_arch;
```

## Memory in VHDL

### Implementation of a Dual Port RAM

```
--------------------------------Entity------------------------------------------
entity DPRAM is
  generic (
    D_Width : integer := 8; -- Data Width
    A_Width : integer := 10 ); -- 2**10 = 1024 different addresses

  port (
   clk, we      : in  std_logic;  --clock and Write enable
   d            : in  std_logic_vector(D_Width-1 downto 0); -- input data
   w_add, r_add : in  std_logic_vector(A_Width-1 downto 0); -- write address , read address
   q          : out std_logic_vector(D_Width-1 downto 0) ); -- data output
end entity DPRAM;

-----------------------Architecture---------------------------------------------

architecture DPR_Arch of DPRAM is
   type ram_type is array (0 to 2**A_Width-1) of std_logic_vector (D_Width-1 downto 0);

   impure function read_file(txt_file : in string) return ram_type is
     file ram_file : text open read_mode is txt_file;
     variable  txt_line  : line;
     variable  txt_bit   : bit_vector(D_Width-1 downto 0);
     variable  txt_ram   : ram_type;
     begin for i in ram_type'range loop
       readline(ram_file, txt_line);  
       read(txt_line, txt_bit);
       txt_ram(i)  :=  to_stdlogicvector(txt_bit);
     end loop;   return txt_ram;
   end function;

    -- Read the ram text file from the function

    signal ram      : ram_type :=  read_file("initialRAM.txt");
    signal data_reg : std_logic_vector (D_Width-1 downto 0);

    begin ram_proc : process (clk)
       begin
         if    (rising_edge(clk))   then  
           if (we='1')              then  
              ram(to_integer(unsigned(w_add)))  <= d;
              data_reg <= ram(to_integer(unsigned(r_add))) ;
           end if;
         end if;

         q <= data_reg ;
    end process ram_proc;
end architecture DPR_Arch;
```

### Implementation of ROM Memory
```
--------------------------------Entity------------------------------------------
entity ROM is

  generic (
    D_Width : integer := 8;
    A_Width : integer := 3 ); -- 2**3 = 8 addresses

  port (
   -- There is no write address since this is a Read-only-Memory
   clk       : in  std_logic;  
   addr      : in  std_logic_vector(A_Width-1 downto 0);
   data      : out std_logic_vector(D_Width-1 downto 0) );
end entity ROM;

-----------------------Architecture------------------------------

architecture ROm_Arch of ROM is

  signal rom_d, data_reg : std_logic_vector(D_Width-1 downto 0);
  signal addr_sel : std_logic_vector (2 downto 0); --address select

begin
   addr_sel <= addr;

   rom_proc : process (clk)  begin
      data_reg <= rom_d;    
   end process rom_proc;

------------------------- Lookup Table---------------------------------
   lookup_proc : process  begin  
     case(addr_sel) is
       when "000" => rom_d <= "10000000";  
       when "100" => rom_d <= "00000000";
       when "001" => rom_d <= "10101010";  
       when "101" => rom_d <= "10011001";
       when "010" => rom_d <= "01010101";  
       when "110" => rom_d <= "10000001";
       when "011" => rom_d <= "10000011";  
       when "111" => rom_d <= "11110000";
       -- when dealing with case structure "when others" case must be defined
       -- Because there are many other values which can be taken by a std_logic_vector (X, U, Z,...)
       when others => rom_d <= "00000000"; -- +700 cases possible, X, U
     end case;
   end process lookup_proc;

   data <= data_reg;

end architecture ROM;
```

## Finite State Machines in VHDL

Finite State Machines are always in a known state. Therefore operation of a circuit is predictable.

FSMs are categorized into 2 types
1. Moore  :  output depends on the state
2. Mealy  :  output depends on inputs and the state  

###    State Encoding Types

#### Encoding  with multiple transitions
* Binary : Binary representation corresponding to the given state, therefore there may be more than one transition between two adjacent states.

#### Encoding with single transition
* Gray : Only one bit is allowed to change in a given transition.
```          
state   Gray Encoding
0        000
1        001
2        011
3        010
4        110
5        111
6        101
7        100
```
* Johnson : Only one bit is allowed to change in a given transition and changed bit is not allowed to change again until all the bits are changed at least once.
```          
state   Johnson Encoding
0        0000
1        0001
2        0011
3        0111
4        1111
5        1110
6        1100
7        1000
```

* One-Hot : Like an decoder, only one bit is HIGH at a time and length of the representation is equal to the number of states

```
state   One-Hot Encoding
0        00000001
1        00000010
2        00000100
3        00001000
4        00010000
5        00100000
6        01000000
7        10000000
```

### Implementation of Finite State Machine using binary encoding
```
-------------------------------------Entity----------------------------------
entity AngleFSM is
generic (
   S_Width : integer := 3;   -- State Width
   An0   : std_logic_vector(3 downto 0) := "000";  
   An45  : std_logic_vector(3 downto 0) := "001";
   An90  : std_logic_vector(3 downto 0) := "010";
   An135 : std_logic_vector(3 downto 0) := “011";  
   An180 : std_logic_vector(3 downto 0) := “100";
   An225 : std_logic_vector(3 downto 0) := “101";
   An270 : std_logic_vector(3 downto 0) := “110";  
   An315 : std_logic_vector(3 downto 0) := “111"  );

port (
  clk, reset , MoveCw, MoveCCW  : in  std_logic;  
  PhyPosition                   : in  std_logic_vector(S_Width-1 downto 0);
  DesPosition, PosError         : out std_logic_vector(S_Width-1 downto 0));
end entity AngleFSM;

------------------------------Architecture-----------------------------------
architecture FSM_Arch of AngleFSM is

    signal CurrentState, NextState : std_logic_vector (S_Width-1 downto 0);

begin
  comb_proc : process (MoveCw, MoveCCW, PhyPosition, CurrentState)  
  begin
  case(CurrentState) is
      when An0 =>
        if    (MoveCW  = '1') then NextState <= An45;
        elsif (MoveCCW = '1') then NextState <= An315;
        else                       NextState <= An0;
      when An45 =>
        if    (MoveCW  = '1') then NextState <= An90;
        elsif (MoveCCW = '1') then NextState <= An0;
        else
                            |
                            |                
        -- Insert States An90 to An315 here
                            |
                            |
      when An315 =>  --   Last State, others states
        if    (MoveCW  = '1') then NextState <= An0;
        elsif (MoveCCW = '1') then NextState <= An270;
        else                       NextState <= An315;

      when others =>               NextState <= An0;
     end case;

  end process comb_proc;

   clk_proc : process (clk, reset)  
   begin
     if (reset = '1') then
      CurrentState <= PhyPosition;
     elsif (rising_edge(clk)) then
      CurrentState <= NextState;
   end process clk_proc;

---------------------------------Output Logic--------------------------------
   -- Moore Output     
   DesPosition <= CurrentState;
   -- Mealy Output     
   PosError <= DesPosition - PhyPosition;

end architecture FSM_Arch;
```
