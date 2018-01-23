`timescale 10ns/1ns
`include "dec_counter.v"
`define CLOCK_CYCLE 20

module tb_dec_counter;
  
  reg p_clk_in, p_rst;
  wire [3:0] count;
  
  dec_counter m_dec_counter(count, p_clk_in, p_rst);
  
  initial begin
    p_clk_in = 1'b0;
    forever #`CLOCK_CYCLE p_clk_in = ~p_clk_in;  
  end

  initial begin
    p_rst = 1'b0;
    
    #70 p_rst = 1'b1;
    #130 p_rst = 1'b0;
    #110 p_rst = 1;
    #200 p_rst = 0;
    #1000 $stop;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->count = %b, p_clk_in = %b, p_rst = %b", count, p_clk_in, p_rst);  
  end
  
endmodule
