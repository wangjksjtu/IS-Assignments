`timescale 10ns/1ns
`include "ALU.v"

module tb_ALU;

  wire [7:0] sum;
  wire c_out;
  reg [7:0] a, b;
  reg c_in;
  reg [8*10+1:0] oper;
  
  ALU m_ALU(c_out, sum, oper, a, b, c_in);
  
  
  initial begin
    a = 8'b0111_0111;
    b = 8'b1101_0000;
    c_in = 1;  
  end
  
  initial begin
    #10 oper = "and";
    #10 oper = "subtract";
    #10 oper = "subtract_a";
    #10 oper = "or_ab";
    #10 oper = "and_ab";
    #10 oper = "not_ab";
    #10 oper = "exor";
    #10 oper = "exnor";
  end
  
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->sum = %b, c_out = %b, oper = %s, a = %b, b = %b, c_in = %b, ", 
              sum, c_out, oper, a, b, c_in);
  end
    
endmodule




