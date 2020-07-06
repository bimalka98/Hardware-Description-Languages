# Digital-Designs-with-FPGA

## Process of digital system designing
* Making a conceptual idea of the logical system to be built.
* Define a set of constraints that the final design should have.
* Choosing a set of primitive components from which the design is implemented. (This can be achieved by sub-dividing the design until the most primitive components are revealed.)

## Hardware Description Languages(HDLs) for FPGA Design

Hardware Description Languages are used to describe digital systems. Projects based on  `V-HDL(VHSIC-HDL)` and `Verilog-HDL`  languages are included in this repository. Some basic concepts need to write codes in these languages are described below.

# Build and simulate in ModelSim

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

#### logic is concurrent, not sequential

#### FPGA gates are hardware and therefore executes in parallel. Not as software which is executed sequentially.


## References:

* Wikipedia: https://en.wikipedia.org/wiki/Flip-flop_(electronics)
* Images: https://learnabout-electronics.org ; https://dcaclab.com/
* Course content can be found at Coursera: https://www.coursera.org/learn/fpga-hardware-description-languages
