module sram(output [7:0] dout,
           input [7:0] din, addr,
           input wr, rd, cs);
    
  reg [7:0] mem [255:0];
  
  always @(posedge wr) begin
    if (cs == 1) begin
      mem[addr] = din;
    end  
  end
  
  assign dout = (cs & (~rd)) ? mem[addr] : dout;

  
endmodule
