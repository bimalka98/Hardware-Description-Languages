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
