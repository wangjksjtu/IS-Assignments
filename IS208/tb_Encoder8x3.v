`include "Encoder8x3.v"
`timescale 10ns/1ns

module tb_Encoder;
  reg [7:0] t_data;
  wire [2:0] t_code;
  
  Encoder8x3 test(.data(t_data), .code(t_code));
  
  initial begin
    t_data = 0;
    #10 t_data = 8'b0000_0001;
    #10 t_data = 8'b0000_0010;
    #10 t_data = 8'b0000_0100;
    #10 t_data = 8'b0000_1000;
    #10 t_data = 8'b0001_0000;
    #10 t_data = 8'b0010_0000;
    #10 t_data = 8'b0100_0000;
    #10 t_data = 8'b1000_0000;
    #10 $stop;  
  end
  
  initial begin
    $monitor("Current time %tns, ", $time, "<----> t_data:%b, t_code:%b", t_data, t_code);
  end
endmodule