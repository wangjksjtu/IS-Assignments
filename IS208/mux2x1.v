module mux2x1(output dout,
              input sel,
              input [1:0] din);

bufif1 b2(dout, din[1], sel);
bufif0 b1(dout, din[0], sel);

endmodule
