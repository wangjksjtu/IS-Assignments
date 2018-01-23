module LFSR(output reg [1:26] q,
            input clk,
            input rst_n,
            input load,
            input [1:26] din);

  reg out;
  always @(posedge clk) begin
    if (~rst_n)
      q <= 26'b0;
    else begin
      if (load)
        q <= (!din) ? din : 26'b1;
      else begin
        if (q == 26'b0)
          q <= 26'b1;
        else begin
          q[10:26] <= q[9:25];
          q[9] <= q[8] ^ q[26];
          q[8] <= q[7] ^ q[26];
          q[3:7] <= q[2:6]; 
          q[2] <= q[1] ^ q[26];
          q[1] <= q[26];
        end
      end
    end
  end

endmodule
