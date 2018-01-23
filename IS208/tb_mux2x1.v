`timescale 10ns/1ns
`include "mux2x1.v"

module tb_mux2x1;
  reg [1:0] t_din;
  reg t_sel;
  wire t_dout;
  
  mux2x1 m_mux2x1(.dout(t_dout),
                  .sel(t_sel),
                  .din(t_din));
  
  initial begin
    t_sel = 1'b1; t_din = 2'b00;
    #10 t_din = 2'b10;
    #10 t_din = 2'b11;
    #10 t_din = 2'b01;
    #10 t_din = 2'b00;
    #10 t_din = 2'b10;
    #10 t_din = 2'b01;
    #10 t_sel = 1'b0;
    #10 t_din = 2'b00;
    #10 t_din = 2'b01;
  end
endmodule
