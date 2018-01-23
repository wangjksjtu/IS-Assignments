`timescale 10ns/1ns
`include "sram.v"
`define CLOCK_CYCLE 20

module tb_sram;
  
  wire [7:0] dout;
  reg [7:0] din, addr; 
  reg wr, rd, cs;
  
  sram sram(dout, din, addr, wr, rd, cs);
  
  initial begin
    cs = 0; rd = 0; wr = 0; din = 0; addr =0;
    #10 cs = 1; din = 8'b1011_0101;
    #10 wr = 1; addr = 8'b11;
    #10 cs = 0; addr = 8'b10; wr = 0; din = 8'b0001_0001;
    #10 cs = 1; wr = 1; rd = 1;
    #10 rd = 0;
    #10 addr = 3;
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->dout = %b, din = %b, addr = %b, wr = %b, rd = %b, cs = %b", 
              dout, din, addr, wr, rd, cs);
  end
    
endmodule


