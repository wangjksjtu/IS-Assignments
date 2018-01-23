`timescale 10ns/1ns
`include "mux4x1.v"

module tb_mux4x1;
  reg [3:0] t_din;
  reg [1:0] t_sel;
  wire t_dout;
  
  mux4x1 m_mux4x1(.dout(t_dout),
                  .sel(t_sel),
                  .din(t_din));
  
  initial begin
    t_sel = 2'b11; t_din = 4'b0000;
    #10 t_din = 4'b1000;
    #10 t_din = 4'b1110;
    #10 t_din = 4'b0101;
    #10 t_sel = 2'b10;
    #10 t_din = 4'b0010;
    #10 t_din = 4'b1011;
    #10 t_din = 4'b0101;
    #10 t_sel = 2'b01;
    #10 t_din = 4'b0001;
    #10 t_din = 4'b0110;
    #10 t_din = 4'b0100;
    #10 t_sel = 2'b00;
    #10 t_din = 4'b1000;
    #10 t_din = 4'b1110;
    #10 t_din = 4'b0101;    
  end
endmodule


