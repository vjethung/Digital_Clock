module count_months (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Mode: 1 for auto-count, 0 for manual adjust
    input           up,
    input           down,
    input           rst_n,
    input           tick_month,
    output reg [3:0] months_unit,
    output reg [3:0] months_ten,
    output 		      tick_year
);

    reg clock;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            clock = 0;           
        end
        else begin
            if (mode) clock = clk_1Hz;
            else clock = clk_adjust;
        end
    end


    always @(posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            months_unit <= 4'd1;
            months_ten <= 4'd0;
        end
        else begin
            if (mode) begin
                if (tick_month) begin
                    if (months_ten == 4'd1 && months_unit == 4'd2) begin
                        months_unit <= 4'd1;
                        months_ten <= 4'd0; 
                    end
                    else if (months_unit == 4'd9) begin
                        months_unit <= 4'd0;
                        months_ten <= 4'd1; 
                    end
                    else begin
                        months_unit <= months_unit + 1'b1;
                    end
                end
                else begin
                    
                end
            end
            else begin
                // Manual mode
                if (up && !down) begin
                    if (months_ten == 4'd1 && months_unit == 4'd2) begin
                        months_unit <= 4'd1;
                        months_ten <= 4'd0; 
                    end
                    else if (months_unit == 4'd9) begin
                        months_unit <= 4'd0;
                        months_ten <= 4'd1; 
                    end
                    else begin
                        months_unit <= months_unit + 1'b1;
                    end
                end
                else if (down && !up) begin
                    // Decrement
                    if (months_ten == 4'd0 && months_unit == 4'd1) begin
                        months_unit <= 4'd2;
                        months_ten <= 4'd1;
                    end
                    else if (months_unit == 4'd0) begin
                        months_unit <= 4'd9;
                        months_ten <= 4'd0; 
                    end
                    else begin
                        months_unit <= months_unit - 1'b1;
                    end
                end
                else begin
                    
                end
            end
        end
    end
    assign tick_year = (months_ten == 4'd1 && months_unit == 4'd2 && tick_month) ? 1'b1 : 1'b0;
endmodule