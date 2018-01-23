`timescale 10ns/1ns
`include "counter8b_updown.v"
`define CLOCK_CYCLE 20

module tb_counter8b_updown;
  
  wire [7:0] count;
  reg p_clk_in, p_rst, p_dir;
  
  counter8b_updown m_counter_updown(count, p_clk_in, p_rst, p_dir);
  
  initial begin
    p_dir = 0;
    #20 p_dir = 1;
    #100 p_dir = 0;
    #180 p_dir = 1;
  end
  
  initial begin
    p_clk_in = 1'b0;
    forever #`CLOCK_CYCLE p_clk_in = ~p_clk_in;  
  end
  
  initial begin
    p_rst = 1'b0;
    
    #70 p_rst = 1'b1;
    #130 p_rst = 1'b0;
    #110 p_rst = 1;
    #1000 $stop;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->clk = %b, reset = %b, p_dir = %b, count = %b", 
              p_clk_in, p_rst, p_dir, count);
  end
    
endmodule


