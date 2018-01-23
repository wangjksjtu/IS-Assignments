`timescale 10ns/1ns
`include "comb_Y2.v"

module tb_comb_Y2;
  
  wire Y;
  reg A, B, C, D;
  wire Y;
  
  comb_Y2 m_comb_Y2(Y, A, B, C, D);
  initial begin
    #10 {A, B, C, D} = 4'b0000;
    #10 {A, B, C, D} = 4'b0001;
    #10 {A, B, C, D} = 4'b0010;
    #10 {A, B, C, D} = 4'b0011;
    #10 {A, B, C, D} = 4'b0100;
    #10 {A, B, C, D} = 4'b0101;
    #10 {A, B, C, D} = 4'b0110;
    #10 {A, B, C, D} = 4'b0111;
    #10 {A, B, C, D} = 4'b1000;
    #10 {A, B, C, D} = 4'b1001;
    #10 {A, B, C, D} = 4'b1010;
    #10 {A, B, C, D} = 4'b1011;
    #10 {A, B, C, D} = 4'b1100;
    #10 {A, B, C, D} = 4'b1101;
    #10 {A, B, C, D} = 4'b1110;
    #10 {A, B, C, D} = 4'b1111;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->A = %b, B = %b, C = %b, D = %b, Y2 = %b",
              A, B, C, D, Y);
  end
  
endmodule


