`timescale 10ns/1ns
`include "comb_dataflow.v"
`include "comb_str.v"
`include "comb_behavior.v"
`include "comb_prim.v"

module testbench_comb;
  reg A, B, C, D;
  wire Y1, Y2, Y3, Y4;
  
  comb_dataflow test1(.Y(Y1), .A(A), .B(B), .C(C), .D(D));
  comb_str test2(.Y(Y2), .A(A), .B(B), .C(C), .D(D));
  comb_behavior test3(.Y(Y3), .A(A), .B(B), .C(C), .D(D));
  comb_prim test4(.Y(Y4), .A(A), .B(B), .C(C), .D(D));
  
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
    #10 {A, B, C, D} = 4'b1x11;
    #10 {A, B, C, D} = 4'b10x1;
    #10 {A, B, C, D} = 4'b101x;
    #10 {A, B, C, D} = 4'bxx11;
    #10 {A, B, C, D} = 4'bxxx1;
    #10 {A, B, C, D} = 4'bxxxx;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->A = %b, B = %b, C = %b, D = %b, Y1 = %b, Y2 = %b, Y3 = %b",
              A, B, C, D, Y1, Y2, Y3);
  end
endmodule
