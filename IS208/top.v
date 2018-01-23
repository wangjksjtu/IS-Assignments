`timescale 10ns/1ns
`include "mealy.v"
`include "moore.v"
`define CLOCK_CYCLE 1

module top;
  wire flag1, flag2;
  reg din, clk, rst;
  
  mealy m_mealy(flag1, din, clk, rst);
  moore m_moore(flag2, din, clk, rst);
  
  initial begin
    clk = 1'b0;
    forever #`CLOCK_CYCLE clk = ~clk;   
  end
  
  initial begin
    din = 0;
    #2 din = 1;#2 din = 1;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 0;#2 din = 1;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 1;#2 din = 0;#2 din = 1;#2 din = 0;
    #2 din = 1;     
  end
  
  initial begin
    rst = 1'b1;
    #25 rst = 1'b0;
    #3 rst = 1'b1;
    #30 rst = 1'b0;  
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<----> flag1 = %b, flag2 = %b, din = %b, clk = %b, rst = %b",
            flag1, flag2, din, clk, rst);  
  end
  
endmodule 
