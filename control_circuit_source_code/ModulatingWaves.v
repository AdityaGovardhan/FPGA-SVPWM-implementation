/*This module is used for generating moudulating signals.
Input is a clock enable signal to switch on the clock,
clock input signal and a active high reset signal to 
power down the control circuit
Output are modulating waves
*/

`timescale 1 ns / 1 ns

module ModulatingWaves
          (
           clk,
           reset,
           clk_enable,
           ce_out,
           Out1_0,
           Out1_1,
           Out1_2
          );


  input   clk;
  input   reset;
  input   clk_enable;
  output  ce_out;
  output  signed [15:0] Out1_0;  // int16
  output  signed [15:0] Out1_1;  // int16
  output  signed [15:0] Out1_2;  // int16


  wire enb;
  reg signed [12:0] Sine_Wave_out1;  // sfix13
  reg signed [12:0] Sine_Wave1_out1;  // sfix13
  reg signed [12:0] Sine_Wave2_out1;  // sfix13
  wire signed [12:0] Mux_out1 [0:2];  // sfix13 [3]
  wire signed [15:0] Data_Type_Conversion_out1 [0:2];  // int16 [3]
  wire signed [15:0] MinMax_out1;  // int16
  wire signed [15:0] MinMax1_out1;  // int16
  wire signed [15:0] Add2_out1;  // int16
  wire signed [31:0] Gain_out1;  // sfix32_En15
  wire signed [15:0] Add3_v;  // sfix16
  wire signed [15:0] Add3_out1 [0:2];  // int16 [3]
  reg [14:0] address_cnt;  // ufix15
  reg [14:0] address_cnt_1;  // ufix15
  reg [14:0] address_cnt_2;  // ufix15
  
  reg [4:0] count;
  reg [4:0] count1;
  reg [4:0] count2;
  reg flip_bit;
  reg flip_bit1;
  reg flip_bit2;


  assign enb = clk_enable;
  
/* This counter is used to take in a 50MHz
clock and output a 1MHz clock*/
  always @(posedge clk or posedge reset)
    begin
      if (reset == 1'b1) begin
        count <= 5'b00000;
        flip_bit <= 1'b0;
      end
      else begin
        if (enb == 1'b1) begin
          if (count == 5'b11001) begin
            count <= 5'b00000;
            flip_bit <= ~flip_bit;
          end
          else begin
            count <= count + 5'b1;
          end
        end
      end
    end

/* ADDRESS COUNTER
    used to iterate through the look up table values using
    an address register which is updated at a rate of 1MHz
*/
  always @ (posedge flip_bit or posedge reset)
    begin: Sine_Wave_addrcnt_temp_process1
      if (reset == 1'b1) begin
        address_cnt <= 15'b000000000000000;
      end
      else begin
        if (enb == 1'b1) begin
          if (address_cnt == 15'b100111000011111) begin
            address_cnt <= 15'b000000000000000;
          end
          else begin
            address_cnt <= address_cnt + 15'b1;
          end
        end
      end
    end // Sine_Wave_addrcnt_temp_process1
    

// FULL WAVE LOOKUP TABLE - example shown, acutal 20,000 samples
  always @(address_cnt)
  begin
    case(address_cnt)
      15'b000000000000000 : Sine_Wave_out1 = 13'b0000000000000;
      15'b000000000000001 : Sine_Wave_out1 = 13'b0000000000001;
      15'b000000000000010 : Sine_Wave_out1 = 13'b0000000000010;
      15'b000000000000011 : Sine_Wave_out1 = 13'b0000000000011;
      15'b000000000000100 : Sine_Wave_out1 = 13'b0000000000101;
      15'b000000000000101 : Sine_Wave_out1 = 13'b0000000000110;
      15'b000000000000110 : Sine_Wave_out1 = 13'b0000000000111;
      ...
      ...
      ...
      default : Sine_Wave_out1 = 13'b1111111111111;
    endcase
  end

/* This counter is used to take in a 50MHz
clock and output a 1MHz clock*/
  always @(posedge clk or posedge reset)
    begin
      if (reset == 1'b1) begin
        count1 <= 5'b00000;
        flip_bit1 <= 1'b0;
      end
      else begin
        if (enb == 1'b1) begin
          if (count1 == 5'b11001) begin
            count1 <= 5'b00000;
            flip_bit1 <= ~flip_bit1;
          end
          else begin
            count1 <= count1 + 5'b1;
          end
        end
      end
    end
  
/* ADDRESS COUNTER
    used to iterate through the look up table values using
    an address register which is updated at a rate of 1MHz,
    120 degree shifted sine wave
*/
  always @ (posedge flip_bit1 or posedge reset)
    begin: Sine_Wave1_addrcnt_temp_process2
      if (reset == 1'b1) begin
        address_cnt_1 <= 15'b000000000000000;
      end
      else begin
        if (enb == 1'b1) begin
          if (address_cnt_1 == 15'b100111000011111) begin
            address_cnt_1 <= 15'b000000000000000;
          end
          else begin
            address_cnt_1 <= address_cnt_1 + 15'b1;
          end
        end
      end
    end // Sine_Wave1_addrcnt_temp_process2



// FULL WAVE LOOKUP TABLE - example shown, acutal 20,000 samples
  always @(address_cnt_1)
  begin
    case(address_cnt_1)
      15'b000000000000000 : Sine_Wave1_out1 = 13'b0110000110100;
      15'b000000000000001 : Sine_Wave1_out1 = 13'b0110000110011;
      15'b000000000000010 : Sine_Wave1_out1 = 13'b0110000110011;
      15'b000000000000011 : Sine_Wave1_out1 = 13'b0110000110010;
      15'b000000000000100 : Sine_Wave1_out1 = 13'b0110000110001;
      15'b000000000000101 : Sine_Wave1_out1 = 13'b0110000110001;
      ...
      ...
      ...
      default : Sine_Wave1_out1 = 13'b0110000110100;
    endcase
  end



/* This counter is used to take in a 50MHz
clock and output a 1MHz clock*/
  always @(posedge clk or posedge reset)
    begin
      if (reset == 1'b1) begin
        count2 <= 5'b00000;
        flip_bit2 <= 1'b0;
      end
      else begin
        if (enb == 1'b1) begin
          if (count2 == 5'b11001) begin
            count2 <= 5'b00000;
            flip_bit2 <= ~flip_bit2;
          end
          else begin
            count2 <= count2 + 5'b1;
          end
        end
      end
    end

/* ADDRESS COUNTER
    used to iterate through the look up table values using
    an address register which is updated at a rate of 1MHz,
    240 degree shifted sine wave
*/
  always @ (posedge flip_bit2 or posedge reset)
    begin: Sine_Wave2_addrcnt_temp_process3
      if (reset == 1'b1) begin
        address_cnt_2 <= 15'b000000000000000;
      end
      else begin
        if (enb == 1'b1) begin
          if (address_cnt_2 == 15'b100111000011111) begin
            address_cnt_2 <= 15'b000000000000000;
          end
          else begin
            address_cnt_2 <= address_cnt_2 + 15'b1;
          end
        end
      end
    end // Sine_Wave2_addrcnt_temp_process3


    

// FULL WAVE LOOKUP TABLE - example shown, acutal 20,000 samples
  always @(address_cnt_2)
  begin
    case(address_cnt_2)
      15'b000000000000000 : Sine_Wave2_out1 = 13'b1001111001100;
      15'b000000000000001 : Sine_Wave2_out1 = 13'b1001111001100;
      15'b000000000000010 : Sine_Wave2_out1 = 13'b1001111001011;
      15'b000000000000011 : Sine_Wave2_out1 = 13'b1001111001011;
      15'b000000000000100 : Sine_Wave2_out1 = 13'b1001111001010;
      15'b000000000000101 : Sine_Wave2_out1 = 13'b1001111001001;
      ...
      ...
      ...
      default : Sine_Wave2_out1 = 13'b1001111001101;
    endcase
  end



  assign Mux_out1[0] = Sine_Wave_out1;
  assign Mux_out1[1] = Sine_Wave1_out1;
  assign Mux_out1[2] = Sine_Wave2_out1;

  assign Data_Type_Conversion_out1[0] = Mux_out1[0];
  assign Data_Type_Conversion_out1[1] = Mux_out1[1];
  assign Data_Type_Conversion_out1[2] = Mux_out1[2];


  //Instantenous values are compared using min and max submodules

  MinMax   u_MinMax   (.in0_0(Data_Type_Conversion_out1[0]),  // int16
                       .in0_1(Data_Type_Conversion_out1[1]),  // int16
                       .in0_2(Data_Type_Conversion_out1[2]),  // int16
                       .out0(MinMax_out1)  // int16
                       );

  MinMax1   u_MinMax1   (.in0_0(Data_Type_Conversion_out1[0]),  // int16
                         .in0_1(Data_Type_Conversion_out1[1]),  // int16
                         .in0_2(Data_Type_Conversion_out1[2]),  // int16
                         .out0(MinMax1_out1)  // int16
                         );


  //obtained min and max values are added
  assign Add2_out1 = MinMax_out1 + MinMax1_out1;


  //addition output is divided by 2 
  assign Gain_out1 = {{2{Add2_out1[15]}}, {Add2_out1, 14'b00000000000000}};


  //obtained output is subtracted from sine waves, modulating signals obtained
  assign Add3_v = Gain_out1[30:15];
  assign Add3_out1[0] = Data_Type_Conversion_out1[0] - Add3_v;
  assign Add3_out1[1] = Data_Type_Conversion_out1[1] - Add3_v;
  assign Add3_out1[2] = Data_Type_Conversion_out1[2] - Add3_v;



  assign Out1_0 = Add3_out1[0];

  assign Out1_1 = Add3_out1[1];

  assign Out1_2 = Add3_out1[2];

  assign ce_out = clk_enable;

endmodule  // ModulatingWaves

