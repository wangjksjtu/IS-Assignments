module ones_count(output reg [3:0] count, 
                  input [7:0] dat_in);
parameter BITS = 8;
integer i;

always @(dat_in) begin
  i = 0;
  count = 0;
  while(i < BITS) begin
    if (dat_in[i] == 1'b1)
      count = count + 1;
    i = i + 1;
  end
end

endmodule