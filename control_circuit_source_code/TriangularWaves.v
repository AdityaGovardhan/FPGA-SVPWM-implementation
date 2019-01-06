/*This module is used for generating triangular waves.
Input is a clock enable signal to switch on the clock,
clock input signal and a active high reset signal to 
power down the control circuit
Output are triangular waves of 4KHz waves
*/

`timescale 1 ns / 1 ns

module TriangularWaves
          (
           clk,
           reset,
           clk_enable,
           ce_out,
           Out5
          );


  input   clk;
  input   reset;
  input   clk_enable;
  output  ce_out;
  output  signed [15:0] Out5;  // int16


  wire enb;
  wire signed [15:0] Constant_out1;  // int16
  reg [15:0] Counter_Limited_count;  // ufix16
  wire [15:0] Counter_Limited_out1;  // uint16
  wire signed [15:0] Add_out1;  // int16
  wire switch_compare_1;
  wire signed [15:0] Counter_Limited_out1_dtc;  // int16
  wire signed [15:0] Switch_out1;  // int16
  wire signed [15:0] Constant1_out1;  // int16
  wire signed [15:0] Add1_out1;  // int16


  assign Constant_out1 = 16'sd12499;



  assign enb = clk_enable;

  // Count limited, Unsigned Counter
  //  initial value   = 0
  //  step value      = 1
  //  count to value  = 12499
  always @(posedge clk or posedge reset)
    begin : Counter_Limited_process
      if (reset == 1'b1) begin
        Counter_Limited_count <= 16'b0000000000000000;
      end
      else begin
        if (enb) begin
          if (Counter_Limited_count == 16'b0011000011010011) begin
            Counter_Limited_count <= 16'b0000000000000000;
          end
          else begin
            Counter_Limited_count <= Counter_Limited_count + 16'b1;
          end
        end
      end
    end

  assign Counter_Limited_out1 = Counter_Limited_count;


  //counter value instantenously subtracted from constant value 12499
  assign Add_out1 = Constant_out1 - $signed({1'b0, Counter_Limited_out1});


  //output of the two opposing counters is selected as per the following
  assign switch_compare_1 = (Add_out1 >= 16'sb0001100001101001 ? 1'b1 :
              1'b0);



  assign Counter_Limited_out1_dtc = Counter_Limited_out1;


  //output is selected from previous comparison
  assign Switch_out1 = (switch_compare_1 == 1'b0 ? Counter_Limited_out1_dtc :
              Add_out1);



  assign Constant1_out1 = 16'sd9374;


  //constant value is subtracted to create properly biased output
  assign Add1_out1 = Switch_out1 - Constant1_out1;



  assign Out5 = Add1_out1;

  assign ce_out = clk_enable;

endmodule  // TriangularWaves

