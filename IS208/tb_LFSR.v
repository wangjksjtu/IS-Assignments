`timescale 10ns/1ns
`include "LFSR.v"
`define CLOCK_CYCLE 20

module tb_LFSR;
  reg p_clk_in, p_rst, p_load;
  reg [1:26] p_din;
  wire [1:26] q;
  
  wire tmp;
  
  LFSR m_LFSR(q, p_clk_in, p_rst, p_load, p_din);

  initial begin
    p_clk_in = 1'b0;
    forever #`CLOCK_CYCLE p_clk_in = ~p_clk_in;  
  end
  
  assign tmp = q[26] ^ q[8] ^ q[7] ^ q[1];

  initial begin
    p_din = 26'h3ffff_ff; p_load = 1;    
    #40 p_din = 26'h2ffff_ff; p_load = 0;
    #150 p_din = 26'h1ffff_ff; p_load = 1;
    #180 p_load = 0; 
  end

  initial begin
    p_rst = 1'b1;
    
    #70 p_rst = 1'b0;
    #130 p_rst = 1'b0;
    #110 p_rst = 1;
    #1000 $stop;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->q = %b, p_din = %b, p_load = %b, p_rst = %b, tmp = %b",
              q, p_din, p_load, p_rst, tmp);
  end
endmodule