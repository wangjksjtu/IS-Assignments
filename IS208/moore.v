module moore(output reg flag,
             input din, clk, rst);
  
    
    localparam IDLE = 9'b0000_0000_1, A = 9'b0000_0001_0, B = 9'b0000_0010_0,
                  C = 9'b0000_0100_0, D = 9'b0000_1000_0, E = 9'b0001_0000_0,
                  F = 9'b0010_0000_0, G = 9'b0100_0000_0, H = 9'b1000_0000_0;
    reg [8:0] state;
    

    
    always @(posedge clk or negedge rst) begin
      if (!rst) begin 
        flag <= 1'b0; 
        state <= IDLE;
      end
      else begin
        flag <= (state == H)? 1'b1: 1'b0;
        case (state)
          IDLE:   state <= (din)? A : IDLE;
          A:      state <= (din)? A : B;
          B:      state <= (din)? C : IDLE;
          C:      state <= (din)? A : D;
          D:      state <= (din)? E : IDLE;
          E:      state <= (din)? A : F;
          F:      state <= (din)? G : IDLE;
          G:      state <= (din)? A : H;
          H:      state <= (din)? G : IDLE;
          default: state <= IDLE;
        endcase
      end 
    end
         
endmodule
