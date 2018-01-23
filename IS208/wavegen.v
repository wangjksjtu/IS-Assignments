`timescale 10ns/1ns

module wavegen(output reg wave);
  
  initial begin
    wave = 0;
    #2 wave = 1;
    #1 wave = 0;
    #9 wave = 1;
    #10 wave = 0;
    #2 wave = 1;
    #3 wave = 0;
    #5 wave = 1;
  end
  
  initial begin
    $monitor("Current Time: %tns,", $time, "<---->wave=%b", wave);
  end
  
endmodule
