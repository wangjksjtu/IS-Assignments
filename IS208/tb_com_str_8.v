`timescale 10ns/1ns
`include "comb_str_8.v"

module tb_com_str;
  reg A, B, C, D;
  reg sel;
  wire p_y;
  wire in0, in1;
  
  comb_str m_comb_str(p_y, sel, A, B, C, D);
  
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
    sel = 1'b0;
    #70 sel = 1'b1;
    #130 sel = 1'b0;
    #110 sel = 1;
    #200 $stop;
  end
  
  assign in0 = ~(A & B);
  assign in1 = ~(C & D);
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->A = %b, B = %b, C = %b, D = %b, sel %b, y = %b",
              A, B, C, D, sel, p_y);
  end
    
endmodule
