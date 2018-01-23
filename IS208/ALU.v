module ALU(output reg c_out,
           output reg [7:0] sum,
           input reg [8*10+1:0]oper,
           input [7:0] a, b,
           input c_in);
  
  always @(oper, a, b) begin
    case (oper)
      "and":         begin tmp = a + b + c_in; end
      "subtract":    begin tmp = a + ~b + c_in; end
      "subtract_a":  begin tmp = b + ~a + ~c_in;  end  
      "or_ab":       {c_out, sum} = {1'b0, a | b};
      "and_ab":      {c_out, sum} = {1'b0, a & b};
      "not_ab":      {c_out, sum} = {1'b0, ~a & b};
      "exor":        {c_out, sum} = {1'b0, a ^ b};
      "exnor":       {c_out, sum} = {1'b0, a ~^ b};
    endcase
  end
    
endmodule
