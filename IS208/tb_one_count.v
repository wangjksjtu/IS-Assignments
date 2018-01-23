`timescale 10ns/1ns
`include "ones_count.v"

module tb_ones_count;
  reg [7:0] t_dat_in;
  wire [3:0] t_count;
  
  ones_count m_ones_count(.dat_in(t_dat_in),
                          .count(t_count));
  
  initial begin
    #10 t_dat_in = 8'b1000_1011;
    #10 t_dat_in = 8'b1000_1001;
    #10 t_dat_in = 8'b1110_1011;
    #10 t_dat_in = 8'b0000_1010;
    #10 t_dat_in = 8'b0000_1000;
    #10 t_dat_in = 8'b0000_0000;
    #10 t_dat_in = 8'b1111_1011;
    #10 t_dat_in = 8'b1111_1111;
    #10 t_dat_in = 8'b1011_1011;
    #10 t_dat_in = 8'b0000_1111;  
  end
  
  initial begin
    $monitor("Current time: %tns", $time, "<---->count = %b, dat_in = %b", t_dat_in, t_count);
  end

endmodule