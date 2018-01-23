module comb_Y2(output Y,
               input A, B, C, D);

  assign Y = (~A & B) | (A & B & ~C) | (A & ~B & C & D);

endmodule
