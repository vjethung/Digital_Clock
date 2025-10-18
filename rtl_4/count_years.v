module count_years (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Mode: 1 for auto-count, 0 for manual adjust
    input           up,
    input           down,
    input           rst_n,
    input           tick_year,
    output reg [3:0] years_unit,
    output reg [3:0] years_ten,
    output reg [3:0] years_hundred,
    output reg [3:0] years_thousand
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
            years_unit <= 4'd0;
            years_ten <= 4'd0;
            years_hundred <= 4'd0;
            years_thousand <= 4'd0; 
        end
        else begin
            if (mode) begin
                if (tick_year) begin
                    if (years_thousand == 4'd9 && years_hundred == 4'd9 && years_ten == 4'd9 && years_unit == 4'd9) begin
                        years_unit <= 4'd0;
                        years_ten <= 4'd0;
                        years_hundred <= 4'd0;
                        years_thousand <= 4'd0; 
                    end
                    else if (years_unit == 4'd9) begin
                        years_unit <= 4'd0;
                        if (years_ten == 4'd9) begin
                            years_ten <= 4'd0;
                            if (years_hundred == 4'd9) begin
                                years_hundred <= 4'd0;
                                years_thousand <= years_thousand + 1'b1;
                            end
                            else begin
                                years_hundred <= years_hundred + 1'b1;
                            end
                        end
                        else begin
                            years_ten <= years_ten + 1'b1;
                        end
                    end
                    else begin
                        years_unit <= years_unit + 1'b1;
                    end
                end
                else begin
                    
                end
            end
            else begin
                // Manual mode
                if (up && !down) begin
                    // Increment
                    if (years_thousand == 4'd9 && years_hundred == 4'd9 && 
                        years_ten == 4'd9 && years_unit == 4'd9) begin
                        years_unit <= 4'd0;
                        years_ten <= 4'd0;
                        years_hundred <= 4'd0;
                        years_thousand <= 4'd0;
                    end
                    else if (years_unit == 4'd9) begin
                        years_unit <= 4'd0;
                        if (years_ten == 4'd9) begin
                            years_ten <= 4'd0;
                            if (years_hundred == 4'd9) begin
                                years_hundred <= 4'd0;
                                years_thousand <= years_thousand + 1'b1;
                            end
                            else begin
                                years_hundred <= years_hundred + 1'b1;
                            end
                        end
                        else begin
                            years_ten <= years_ten + 1'b1;
                        end
                    end
                    else begin
                        years_unit <= years_unit + 1'b1;
                    end
                end
                else if (down && !up) begin
                    // Decrement
                    if (years_thousand == 4'd0 && years_hundred == 4'd0 && 
                        years_ten == 4'd0 && years_unit == 4'd0) begin
                        years_unit <= 4'd9;
                        years_ten <= 4'd9;
                        years_hundred <= 4'd9;
                        years_thousand <= 4'd9;
                    end
                    else if (years_unit == 4'd0) begin
                        years_unit <= 4'd9;
                        if (years_ten == 4'd0) begin
                            years_ten <= 4'd9;
                            if (years_hundred == 4'd0) begin
                                years_hundred <= 4'd9;
                                years_thousand <= years_thousand - 1'b1;
                            end
                            else begin
                                years_hundred <= years_hundred - 1'b1;
                            end
                        end
                        else begin
                            years_ten <= years_ten - 1'b1;
                        end
                    end
                    else begin
                        years_unit <= years_unit - 1'b1;
                    end
                end
                else begin
                    
                end
            end
        end
    end
endmodule