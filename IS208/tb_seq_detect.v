`timescale 10ns/1ns
`include "seq_detect2.v"
`include "seq_detect.v"
`define CLOCK_CYCLE 20

module tb_seq_detect;
  
  wire flag1, flag2;
  reg p_clk_in, p_rst, din;
  
  seq_detect2 m_seq_detect2(flag2, din, p_clk_in, p_rst);
  seq_detect m_seq_detect1(flag1, din, p_clk_in, p_rst);
  
  initial begin
    din = 0;
    #30 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #20 din = 1;
    #20 din = 0;
    #20 din = 1;
    #40 din = 0;
    #40 din = 1;
    #40 din = 1;
    #40 din = 0;
    #40 din = 1;
    #40 din = 1;
    #40 din = 0;
    #40 din = 1;
  end
  
  initial begin
    p_clk_in = 1'b0;
    forever #`CLOCK_CYCLE p_clk_in = ~p_clk_in;  
  end
  
  initial begin
    p_rst = 1;
    #350 p_rst = 0;
    #50 p_rst = 1;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->clk = %b, reset = %b, din = %b, flag1 = %b, flag2 = %b, state = %b", 
              p_clk_in, p_rst, din, flag1, flag2, m_seq_detect2.state);
  end
    
endmodule

