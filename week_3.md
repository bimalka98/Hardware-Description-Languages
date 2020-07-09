# Verilog = `Veri`fying `Log`ic

* Verilog, standardized as IEEE 1364-1995(Verilog 95), is a hardware description language (HDL) used to model electronic systems.
* Extended versions of Verilog,

1. Verilog-2001 (IEEE Standard 1364-2001)
2. Verilog-2005
3. SystemVerilog 2009 (IEEE Standard 1800-2009), a merged version of SystemVerilog and Verilog language
4. Current version - IEEE standard 1800-2017

* It is most commonly used in the design and verification of digital circuits at the register-transfer level of abstraction.
* In Verilog, a design consists of modules.
A simple AND gate in Verilog would look something like the following:
```
// comments in verilog starts with two slashes

// And gate
module andgate (x1, x2, f);
	input x1, x2;
	output f;
	assign f = x1 & x2;
endmodule
```
## Three Modeling Styles in Verilog

### 1. Structural modeling (Gate-level)
* Use predefined or user-defined primitive gates.
* Using basic gates such as AND, OR, XOR and etc.
* It uses library modules for the gates inserted into the comparator module.
* The act of inserting the library modules is known as `instantiation`.
* Each instance of the gate model is wired to different signals
```
//  Example: 4-bit comparator
// Verilog-2001 Syntax

module comparator(input[3:0] a,b, output out);   
wire n0, n1, n2, n3;

xnor xnor0( n0, a[0], b[0] ); // gate | label |(wired_signal, bit_in_vectroA, bit_in_vectroB)
xnor xnor1( n1, a[1], b[1] );
xnor xnor2( n2, a[2], b[2] );
xnor xnor3( n3, a[3], b[3] );
and and0( out, n0, n1,n2, n3 );

endmodule

```
### 2. Dataflow modeling
* Use assignment statements (assign)
* Require output can be obtained easily with very few lines of code. Therefore efficiency is higher than structural modeling.
* synthesize the exact same logic circuit as previous case.
```
//  Example: 4-bit comparator
// Verilog-1995 Syntax

module COMPARATOR(A, B, Y);

	input [3:0] A, B, output Y;

	assign Y = &((A~^B)); // vectors A and B are XNORed bitwisely and then the resul is ANDed together to produce the output

endmodule

```

### 3. Behavioral modeling
* Use procedural assignment statements (always)
* This is like process structure in VHDL
* What is in always block executed sequentially not concurrently. Therefore order matters.
* This model also creates the exact same logic circuit as previous.
```
module COMPARATOR(input [3:0] A, B; output Y);
	integer N;
	reg Y;

	always @(A or B)
		begin: COMPARE
			Y = 0;
			if (A == B)
				Y = 1;
		end
endmodule
```
## Verilog Rules and Syntax; Keywords and Identifiers; Sigasi/Quartus editing

### Verilog Syntax

* Whitespace is ignored
* Comments are either `//…comment here or /* comment here… */`
* Identifiers are,
1. words for variables
2. function names, etc.
* An identifier can begin with `_` or a letter and can include letters, digits, and underscores and are `CASE SENSITIVE`.
* Keywords can’t be used as identifiers, as instances `assign, case, while, wire, reg, and, or, nand, and module`
* Number literals are expressed this way: `3’b001`, a 3-bit number, `5’d30`, (=5’b11110), and `16‘h5ED4`, (=16’d24276).
* In general: `size_in_bits` then `’` then `base` then `Number`
* Underscores can be added for improved readability as in `32’h1234_5678` and will be ignored in the compilation.

### Verilog values

* Verilog consists of only four basic values. Almost all Verilog data types store all these values.
1. 0 (logic zero, or false condition)
2. 1 (logic one, or true condition)
3. x (unknown logic value or contention) // `Represents in red color in the simulation`
4. z (high impedance state, floating) // Allows creating tri-state buffers
x and z have limited use for synthesis.

### Verilog Data Types
wire - A signal on a wire driven continuously by some driver
reg - A storage element
integer
real
time - Use to represent time
parameter
event - Something that happens in particular moment of time which can be used as a flag to launch another activity. Ex: clock edge is an event.

### Verilog Assignments
* The fundamental statement in Verilog is the assignment statement.
* `All assignment statements outside of an always block are concurrent – they happen at the same time, and are not sequential`.
* The output of the operation on the right hand side of the = symbol is continuously assigned to the variable on the left hand side, as in
`assign A = B & C;  // an and gate`.
* The variable on the LHS must be a net(like a wire), not a reg when outside of an always block.
* Generally should not mix blocking and non-blocking assignment operators in the same procedure.


#### 1. Assignments – Procedural(blocking)(`=`)
* Procedural (blocking) assignments (`=`) are `done sequentially` in the order the statements are written. A second assignment will not start until the preceding one is completed. Therefore the order of assignment statements matters.
* “=” best corresponds to what c/c++ code would do; use it for `combinational procedures`, within or outside of always blocks.

```
always @( posedge clk) // always at positive edge of the clock
	begin
	Q2=Q1; Q1=D; // shift register (What was in Q1 transfers to Q2 and then Q1 gets the new value at D.)
	Q1=D; Q2=Q1; //single or parallel ff. (Both Q1 and Q2 holds the same value as D.)
	end
```
#### 2. Assignments - Non blocking(`<=`)
* RTL (nonblocking) assignments (<=), which follow each other in the code, are `started in parallel`. The right hand side of nonblocking assignments is evaluated starting from the completion of the last blocking assignment or if none, the start of the procedure. The `transfer to the left hand side is made according to the delays`. An intra-assignment delay in a nonblocking statement will not delay the start of any subsequent statement blocking or nonblocking.
* “<=” best mimics what physical flip-flops do; use it only for “always @ (posedge clk ..) type procedures describing `sequential circuits`.
```
Using nonblocking statements, the intent of the previous example to create a shift register is preserved no matter the order.
always @( posedge clk)
	begin
	Q2<=Q1; Q1<=D; // shift register
	Q1<=D; Q2<=Q1; // shift register
	Q1<=D; Q2<=D;  // parallel ff
 	end
```
### Verilog Operators
[Reference](https://www.cs.upc.edu/~jordicf/Teaching/secretsofhardware/VerilogIntroduction_Nyasulu.pdf)
```
1. Arithmetic Operators

+ (addition)
- (subtraction)
* (multiplication)
/ (division)
% (modulus)

2. Relational Operators

< (less than)
<= (less than or equal to)
> (greater than)
>= (greater than or equal to)
== (equal to)
!= (not equal to)
= = =, != = (case equality, case inequality) not synthesizable

3. Bit-wise Operators

~ (bitwise NOT)
& (bitwise AND)
| (bitwise OR)
^ (bitwise XOR)
~^ or ^~ (bitwise XNOR)

4. Logical Operators

! (logical NOT)
&& (logical AND) // (3&&0) is (T&&F) = 0
|| (logical OR) // (7||0) is (T||F) = 1, (2||-3) is (T||T) =1

5. Reduction Operators

& (reduction AND)
| (reduction OR)
~& (reduction NAND)
~| (reduction NOR)
^ (reduction XOR)
~^ or ^~(reduction XNOR)

6. Shift Operators

<< (shift left)
>> (shift right)

7. Concatenation Operator "{}"
	combines two or more operands to form a larger vector.
	{3’B101, 3’B110} = 6’B101110;

8. Replication Operator "{n{item}}"
	makes multiple copies of an item
	assign y = {2{a}, 3{b}}; //Equivalent to y = {a,a,b,b}
	{3{3'B110}} = 9'B110110110

9. Conditional Operator: “?” // (cond) ? (result if condition is true):(result if condition is false)
	synthesize to a multiplexer (MUX)
```
### Making a multiplexer
1. Method 1
```
Using conditional statement : Very efficient:

module mux(y, a, b, sel);
output y;
input a, b, sel;
assign y = sel ? a : b; // If sel = 1 then y = a otherwise y = b
endmodule
```
2. Method 2
```
Using gate primitives

module mux(y, a, b, sel);
output y;
input a, b, sel;
and g1(y1, a, nsel), g2(y2, b, sel);
or  g3(y, y1, y2);
not g4(nsel, sel);
endmodule
```
3. Method 3
```
using an always combinational block

module mux(y, a, b, sel);
output y;
input a, b, sel;
reg y; // Wires can not be used to store a value. Therefore we need to use register.
always @(a or b or sel)
   if (sel) y = b;
   else y = a;
endmodule
```
4. Method 4
```
using a User-Defined Primitive (UDP): More robust

primitive mux(y, a, b, sel);
output y;
input a, b, sel;

table
   1?0 : 1; // ? indicates don't care terms
   0?0 : 0;
   ?11 : 1;
   ?01 : 0;
   11? : 1; // When a and b are equal then select is ignored.
   00? : 0;
endtable
endprimitive
```
