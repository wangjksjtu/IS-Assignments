`timescale 10ns/1ns
`include "shift_counter.v"
`define CLOCK_CYCLE 20

module tb_shift_counter;
  
  reg p_clk_in, p_rst;
  wire [7:0] count;
  
  shift_counter m_shift_counter(count, p_clk_in, p_rst);
  
  initial begin
    p_clk_in = 1'b0;
    forever #`CLOCK_CYCLE p_clk_in = ~p_clk_in;  
  end
  
  initial begin
    p_rst = 1'b1;
    #70 p_rst = 1'b0;
    #130 p_rst = 1'b1;
    #110 p_rst = 0;
    
    #1000 $stop;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->clk = %b, reset = %b, count = %b", 
              p_clk_in, p_rst, count);
  end
    
endmodule


