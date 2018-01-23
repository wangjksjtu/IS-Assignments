module comb_str(output y,
                input sel, A, B, C, D);

  wire [3:0] tmp;
  nand (tmp[0], A, B);
  nand (tmp[1], C, D);
  and (tmp[2], ~sel, tmp[0]);
  and (tmp[3], sel, tmp[1]);
  or (y, tmp[2], tmp[3]);
  
endmodule
