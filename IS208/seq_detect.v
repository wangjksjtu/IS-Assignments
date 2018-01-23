module seq_detect_1101(output reg flag,
                       input din, clk, rst_n);
    
    localparam IDLE = 5'b0_0001, A = 5'b0_0010, B = 5'b0_0100,
                  C = 5'b0_1000, D = 5'b1_0000;
    reg [4:0] state;
    
    always @(negedge clk) begin
      if (!rst_n) begin 
        flag <= 1'b0; 
        state <= IDLE;
      end
      else begin
        flag <= (state == D)? 1'b1 : 1'b0;
        case (state)
          IDLE:   state <= (din)? A : IDLE;
          A:      state <= (din)? B : IDLE;
          B:      state <= (din)? B : C;
          C:      state <= (din)? D : IDLE;
          D:      state <= (din)? B : IDLE;
          default: state <= IDLE;
        endcase
      end 
    end
         
endmodule

module seq_detect_0110(output reg flag,
                       input din, clk, rst_n);
    
    localparam IDLE = 5'b0_0001, A = 5'b0_0010, B = 5'b0_0100,
                  C = 5'b0_1000, D = 5'b1_0000;
    reg [4:0] state;
    
    always @(negedge clk) begin
      if (!rst_n) begin 
        flag <= 1'b0; 
        state <= IDLE;
      end
      else begin
        flag <= (state == D)? 1'b1: 1'b0;
        case (state)
          IDLE:   state <= (din)? IDLE : A;
          A:      state <= (din)? B : A;
          B:      state <= (din)? C : A;
          C:      state <= (din)? IDLE : D;
          D:      state <= (din)? B : A;
          default: state <= IDLE;
        endcase
      end 
    end
         
endmodule

module seq_detect(output reg flag, 
                  input din, clk, rst_n);
    
    wire flag1, flag2;
    seq_detect_1101 detect1(flag1, din, clk, rst_n);
    seq_detect_0110 detect2(flag2, din, clk, rst_n);
    
    always @(*) begin
      flag = flag1 | flag2;
    end        
endmodule