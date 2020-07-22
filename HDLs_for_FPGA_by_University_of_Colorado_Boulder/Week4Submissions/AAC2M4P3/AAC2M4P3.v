//   ----------------------------------------------------------------
//    Author               : Bimalka Piyaruwan Thalagala
//    GitHub               : https://github.com/bimalka98
//    Last Modified        : 22.07.2020

//    Functional Description : Idea of the initialization was taken from
//    lectue notes.
//   ----------------------------------------------------------------

module FSM
#( // State encoding using gray codes.
  parameter state_width = 2,
            A = 2'b00,
            B = 2'b01,
            C = 2'b11
  )

 ( //Interface(ports) declaration
  input In1,
  input RST,
  input CLK,
  output reg Out1
  );
// reg variable declaration to keep the states
reg [(state_width -1):0] CurrentState, NextState;

// Initialization of finite state machine
always @ (negedge RST or posedge CLK)
  begin
    if (RST == 1'b0) CurrentState = A;
    else CurrentState = NextState;
  end

// State transition of the state machine
always @(posedge CLK or In1 or CurrentState)
  begin
    case (CurrentState)
      A:begin
        Out1 = 1'b0;
        if (In1 == 1'b1) NextState = B;
        else NextState = A;
      end
      B:begin
        Out1 = 1'b0;
        if (In1 == 1'b0) NextState = C;
        else NextState = B;
      end
      C:begin
        Out1 = 1'b1;
        if (In1 == 1'b1) NextState = A;
        else NextState = C;
      end
      default:begin
        Out1 = 1'b0;
        NextState = A;
      end
    endcase
  end


endmodule
