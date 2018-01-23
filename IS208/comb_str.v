module comb_str(output Y,
                input A, B, C, D);
  wire [4:0] tmp;
  or U3(tmp[0], A, D);
  not U2(tmp[1], tmp[0]);
  not U1(tmp[2], D);
  and U4(tmp[3], B, C, tmp[2]);
  and U5(Y, tmp[3], tmp[1]);
  
endmodule
