module seq_detect2(output reg flag,
                   input din, clk, rst_n);
    
    localparam IDLE = 9'b0_0000_0001, A = 9'b0_0000_0010, B = 9'b0_0000_0100,
                  C = 9'b0_0000_1000, D = 9'b0_0001_0000, E = 9'b0_0010_0000,
                  F = 9'b0_0100_0000, G = 9'b0_1000_0000, H = 9'b1_0000_0000;
    reg [8:0] state;
    
    always @(negedge clk) begin
      if (!rst_n) begin 
        flag <= 1'b0; 
        state <= IDLE;
      end
      else begin
        flag <= ((state == D) | (state == H))? 1'b1 : 1'b0;
        case (state)
          IDLE:   state <= (din)? A : E;
          A:      state <= (din)? B : E;
          B:      state <= (din)? B : C;
          C:      state <= (din)? D : E;
          D:      state <= (din)? G : E;
          E:      state <= (din)? F : E;
          F:      state <= (din)? G : E;
          G:      state <= (din)? B : H;
          H:      state <= (din)? D : E;
          default: state <= IDLE;
        endcase
      end 
    end
         
endmodule