module mealy(output flag,
             input din, clk, rst);
             
    localparam IDLE = 8'b0000_0001, A = 8'b0000_0010, B = 8'b0000_0100,
                  C = 8'b0000_1000, D = 8'b0001_0000, E = 8'b0010_0000,
                  F = 8'b0100_0000, G = 8'b1000_0000;
    reg [7:0] p_state, n_state;
    
    always @(posedge clk or negedge rst) begin
      if (!rst) p_state <= IDLE;
      else p_state <= n_state;
    end
    
    always @(*) begin
      case (p_state)
          IDLE:   n_state = (din)? A : IDLE;
          A:      n_state = (din)? A : B;
          B:      n_state = (din)? C : IDLE;
          C:      n_state = (din)? A : D;
          D:      n_state = (din)? E : IDLE;
          E:      n_state = (din)? A : F;
          F:      n_state = (din)? G : IDLE;
          G:      n_state = (din)? A : F;
          default: n_state = IDLE;
      endcase
    end
    
    assign flag = ((p_state == G) && (din == 1'b0)) ? 1'b1 : 1'b0;                         
endmodule