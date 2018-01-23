module counter8b_updown(output reg [7:0] count,
                        input clk,
                        input reset,
                        input dir);

  always @(posedge clk or negedge reset) begin
    if (~reset) begin
      count = 0;
    end  
    else begin
      if (dir == 1) count = count + 1;
      else count = count - 1;  
    end
  end
endmodule
