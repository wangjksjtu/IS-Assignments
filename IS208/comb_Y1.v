module comb_Y1(output Y,
               input A, B, C);

wire Y1, Y2, Y3;

  assign Y1 = (~A & B & C);
  assign Y2 = (~A & ~B & C);
  assign Y3 = (A & ~B);
  
  assign Y = Y1 | Y2 | Y3;

endmodule
