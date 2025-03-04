module alu(d1, d2, result, control, aluReady);
  input wire [31:0] d1;
  input wire [31:0] d2;
  output wire [31:0] result;
  input wire [3:0] control;
  output wire aluReady;
  
  wire [63:0] sext_rs1 = {{32{d1[31]}}, d1};
  wire [63:0] sra_rslt = sext_rs1 >> d2[4:0];
  wire [31:0] condinv = ~d2;
  wire [32:0] sum = {1'b1, condinv} + {1'b0, d1} + {32'b0, 1'b1};
  wire LT = (d1[31] ^ d2[31]) ? d1[31] : sum[32];
  wire LTU = sum[32];
  
  always @(*) 
    begin
      aluReady = 1'b0;
      case (control)
        4'b0000: begin result = d1 + d2; aluReady = 1'b1; end    // ADD
        4'b0001: result = d1 << d2[4:0];                      // SLL
        4'b0010: result = (LT ? 32'h00000001 : 32'h00000000); // SLT
        4'b0011: result = (LTU ? 32'h00000001 : 32'h00000000);// SLTU
        4'b0100: result = d1 ^ d2;                            // XOR
        4'b0101: result = d1 >> d2[4:0];                      // SRL
        4'b0110: result = d1 | d2;                            // OR
        4'b0111: result = d1 & d2;                            // AND
        4'b1000: result = d1 - d2;                            // SUB
        4'b1101: result = sra_rslt[31:0];                     // SRA
        default: result = 32'b0;
      endcase
    end
  /*
  assign result = (control == 4'b0000) ? (d1 + d2) :                           // ADD
                  (control == 4'b0001) ? (d1 << d2[4:0]) :                     // SLL
                  (control == 4'b0010) ? (LT ? 32'h00000001 : 32'h00000000) :  // SLT
                  (control == 4'b0011) ? (LTU ? 32'h00000001 : 32'h00000000) : // SLTU
                  (control == 4'b0100) ? (d1 ^ d2) :                           // XOR
                  (control == 4'b0101) ? (d1 >> d2[4:0]) :                     // SRL
                  (control == 4'b0110) ? (d1 | d2) :                           // OR
                  (control == 4'b0111) ? (d1 & d2) :                           // AND
                  (control == 4'b1000) ? (d1 - d2) :                           // SUB
                  (control == 4'b1101) ? sra_rslt  :                           // SRA
                  32'b0;
  */
endmodule
