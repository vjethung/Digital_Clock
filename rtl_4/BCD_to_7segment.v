module BCD_to_7segment (
    input       [3:0] BCD,
    input             rst_n,
    output reg  [6:0] segment 
);
    always @(*) begin
        if (~rst_n) 
            segment = 7'b1000000;
        else begin
            case (BCD)
                4'b0000: 
                    segment = 7'b1000000;
                4'b0001: 
                    segment = 7'b1111001;
                4'b0010: 
                    segment = 7'b0100100;
                4'b0011: 
                    segment = 7'b0110000;
                4'b0100: 
                    segment = 7'b0011001;
                4'b0101: 
                    segment = 7'b0010010;
                4'b0110: 
                    segment = 7'b0000010;
                4'b0111: 
                    segment = 7'b1111000;
                4'b1000: 
                    segment = 7'b0000000;
                4'b1001: 
                    segment = 7'b0010000; 
                default: segment = 7'b1000000;
            endcase
        end
    end
endmodule