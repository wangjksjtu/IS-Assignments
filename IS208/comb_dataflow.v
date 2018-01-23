module comb_dataflow(output Y,
                     input A, B, C, D);
  wire [4:0] tmp;
  assign tmp[0] =  A | D;
  assign tmp[1] =  ~tmp[0];
  assign tmp[2] = ~D;
  assign tmp[3] =  B & C & tmp[2];
  assign Y = tmp[3] & tmp[1];
  
endmodule
