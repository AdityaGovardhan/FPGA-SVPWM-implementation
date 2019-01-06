/*This module is a submodule of the modulating signal
generator. It compares the three sinusoidal signal
instantenously and the output is the the maximum value
of the three signals*/

`timescale 1 ns / 1 ns

module MinMax1
          (
           in0_0,
           in0_1,
           in0_2,
           out0
          );


  input   signed [15:0] in0_0;  // int16
  input   signed [15:0] in0_1;  // int16
  input   signed [15:0] in0_2;  // int16
  output  signed [15:0] out0;  // int16


  wire signed [15:0] in0 [0:2];  // int16 [3]
  wire signed [15:0] MinMax1_stage1_val [0:1];  // int16 [2]
  wire signed [15:0] MinMax1_stage2_val;  // int16


  assign in0[0] = in0_0;
  assign in0[1] = in0_1;
  assign in0[2] = in0_2;

  // ---- Tree max implementation ----
  // ---- Tree max stage 1 ----
  assign MinMax1_stage1_val[0] = (in0[0] >= in0[1] ? in0[0] :
              in0[1]);
  assign MinMax1_stage1_val[1] = in0[2];



  // ---- Tree max stage 2 ----
  assign MinMax1_stage2_val = (MinMax1_stage1_val[0] >= MinMax1_stage1_val[1] ? MinMax1_stage1_val[0] :
              MinMax1_stage1_val[1]);



  assign out0 = MinMax1_stage2_val;

endmodule  // MinMax1

