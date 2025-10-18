module day_of_month (
    input [3:0] months_unit,
    input [3:0] months_ten,
    input [3:0] years_unit,
    input [3:0] years_ten,
    input [3:0] years_hundred,
    input [3:0] years_thousand,
    output reg [4:0] max_days
);
    reg [7:0] years2_right;
    reg [7:0] months;
    reg [7:0] years2_left;

    always @(years_unit or years_ten or years_thousand or years_hundred or months_unit or months_ten) begin
        years2_right = (years_ten << 3) + (years_ten << 1) + years_unit;

        years2_left = (years_thousand << 3) + (years_thousand << 1) + years_hundred;

        months = (months_ten <<3) + (months_ten <<1) + months_unit;
    end
    always @( months or years2_right or years2_left) begin  
        case (months)
            8'b0001, 8'b0011, 8'b0101, 8'b0111, 8'b1000, 8'b1010, 8'b1100:
                max_days = 5'd31;
            8'b0100, 8'b0110, 8'b1001, 8'b1011: 
                max_days = 5'd30;
            8'b0010: begin
                if (years2_right[1:0] == 2'b00) begin // Chia hết cho 4
                    if (years2_right == 8'b0) begin // Chia hết cho 100
                        if (years2_left[1:0] == 2'b00) begin // Chia hết cho 400
                            max_days = 5'd29; 
                        end
                        else begin
                            max_days = 5'd28;
                        end
                    end
                    else begin
                        max_days = 5'd29; // Năm chia hết cho 4 nhưng không chia hết cho 100
                    end
                end
                else begin
                    max_days = 5'd28; // Không chia hết cho 4
                end
            end 
            
            default: begin
                max_days = 5'd0;
            end
        endcase
    end
endmodule