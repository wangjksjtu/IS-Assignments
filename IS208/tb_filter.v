`timescale 10ns/1ns
`include "filter.v"
`define CLOCK_CYCLE 20

module tb_filter;
  
  wire sig_out;
  reg p_clk_in, p_rst, sig_in;
  
  filter m_filter(sig_out, p_clk_in, p_rst, sig_in);
  
  initial begin
    sig_in = 0;
    #20 sig_in = 1;
    #100 sig_in = 0;
    #180 sig_in = 1;
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
    $monitor("Current time: %tns", $time, "<---->clk = %b, reset = %b, sig_in = %b, sig_out = %b, q = %b, J = %b, K = %b", 
              p_clk_in, p_rst, sig_in, sig_out, m_filter.q, m_filter.J, m_filter.K);
  end
    
endmodule
