/*This module is used to compare the input modulating signals
and triangular carrier waves to generate the required IGBT
gate control signals*/



`timescale 1 ns / 1 ns

module Comparator
          (
           In1, //Modulating Signals
           In2, //Triangular waves
           Out1 //IGBT gate control signals
          );


  input   signed [15:0] In1;  // int16
  input   signed [15:0] In2;  // int16
  output  Out1;


  wire Relational_Operator_relop1;


  assign Relational_Operator_relop1 = (In1 > In2 ? 1'b1 :
              1'b0);



  assign Out1 = Relational_Operator_relop1;

endmodule  // Comparator

