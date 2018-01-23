module comb_behavior(output Y,
                     input A, B, C, D);
  reg [4:0] tmp;
  reg Y_tmp;
  always @(*) begin
    tmp[0] =  A | D;
    tmp[1] =  ~tmp[0];
    tmp[2] = ~D;
    tmp[3] =  B & C & tmp[2];
    Y_tmp = tmp[3] & tmp[1];
  end
  assign Y = Y_tmp;
endmodule
