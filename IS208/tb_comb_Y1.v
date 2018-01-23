`timescale 10ns/1ns
`include "comb_Y1.v"

module tb_comb_Y1;
  
  wire Y;
  reg A, B, C;
  
  comb_Y1 m_comb_Y1(.Y(Y), .A(A), .B(B), .C(C));
  
  initial begin
    #10 {A, B, C} = 3'b000;
    #10 {A, B, C} = 3'b001;
    #10 {A, B, C} = 3'b010;
    #10 {A, B, C} = 3'b011;
    #10 {A, B, C} = 3'b100;
    #10 {A, B, C} = 3'b101;
    #10 {A, B, C} = 3'b110;
    #10 {A, B, C} = 3'b111;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->A = %b, B = %b, C = %b, Y1 = %b",
              A, B, C, Y);
  end
  
endmodule
