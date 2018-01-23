module dec_counter(output [3:0] count,
                   input clk, reset);
  
  reg [3:0] cnt = 0;

  always @(posedge clk) begin
    if (clk & ~reset) begin
      if (cnt == 4'b1010) cnt = 0;
      else cnt = cnt + 1;
    end
    else begin
        cnt = 0;
    end
  end
  
  assign count = cnt; 

endmodule