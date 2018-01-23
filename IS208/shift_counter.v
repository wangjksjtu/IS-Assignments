module shift_counter(output reg [7:0] count,
                     input clk,
                     input reset);
  
  reg LEFT = 1'b1;
  
  initial begin
    count = 1;  
  end
         
  always @(posedge clk) begin
    if (reset) begin
      LEFT = 1'b1;
      count = 1;
    end
    else begin
      if (LEFT) begin
        count <= {count[6:0], 1'b0};
        if (count == 8'b0100_0000) LEFT = 1'b0;
      end
      else begin
        count <= {1'b0, count[7:1]};
        if (count == 8'b0000_0010) LEFT = 1'b1;
      end
    end
  end
              
endmodule
