`include "mux2x1.v"

module mux4x1(output dout,
              input [1:0] sel,
              input [3:0] din);
  
  wire dout1;
  wire dout2;
  
  mux2x1 m1_mux2x1(.dout(dout1),
                   .sel(sel[0]),
                   .din(din[3:2]));

  mux2x1 m2_mux2x1(.dout(dout2),
                   .sel(sel[0]),
                   .din(din[1:0]));
  
  assign dout = (sel[1] & dout1) | (~sel[1] & dout2);
                

endmodule


