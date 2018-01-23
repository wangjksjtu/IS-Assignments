module filter(output reg sig_out,
              input clock,
              input reset,
              input sig_in);
         
  reg [3:0] q;
  wire J, K;
  
  always @(posedge clock or negedge reset) begin
    if (!reset) q[0] <= 0;
    else q[0] <= sig_in;
  end

  always @(posedge clock or negedge reset) begin
    if (!reset) q[1] <= 0;
    else q[1] <= q[0];
  end

  always @(posedge clock or negedge reset) begin
    if (!reset) q[2] <= 0;
    else q[2] <= q[1];
  end  

  always @(posedge clock or negedge reset) begin
    if (!reset) q[3] <= 0;
    else q[3] <= q[2];
  end
  
  assign J = q[1] & q[2] & q[3];
  assign K = ~q[1] & ~q[2] & ~q[3];
  
  always @(posedge clock or negedge reset) begin
    if (!reset) sig_out <= 0;
    else begin
      sig_out <= J & ~sig_out | ~K & sig_out;
    end
  end
  
endmodule
