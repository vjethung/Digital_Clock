module count_days (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Mode: 1 for auto-count, 0 for manual adjust
    input           up,
    input           down,
    input           rst_n,
    input           tick_day,
    input [4:0]     max_days,
    input [3:0]     months_unit,
    input [3:0]     months_ten,
    output reg [3:0] days_unit,
    output reg [3:0] days_ten,
    output           tick_month
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

    reg [7:0] days; 
    reg [3:0] prev_months_unit, prev_months_ten; 

    always @(days_ten or days_unit) begin
        days = (days_ten << 3) + (days_ten << 1) + days_unit; 
    end

    reg [3:0] max_days_ten, max_days_unit;
    always @(max_days) begin
        case (max_days)
            5'd28: begin
                max_days_ten = 4'd2;
                max_days_unit = 4'd8;
            end
            5'd29: begin
                max_days_ten = 4'd2;
                max_days_unit = 4'd9;
            end
            5'd30: begin
                max_days_ten = 4'd3;
                max_days_unit = 4'd0;
            end
            5'd31: begin
                max_days_ten = 4'd3;
                max_days_unit = 4'd1;
            end
            default: begin
                max_days_ten = 4'd3;
                max_days_unit = 4'd1; 
            end
        endcase
    end

    always @(posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            days_unit <= 4'd1;
            days_ten <= 4'd0; 
            prev_months_unit <= months_unit;
            prev_months_ten <= months_ten;
        end
        else begin
            // Update previous month
            prev_months_unit <= months_unit;
            prev_months_ten <= months_ten;

            // 
            if (months_unit != prev_months_unit || months_ten != prev_months_ten) begin
                if (days > max_days) begin
                    days_ten <= max_days_ten;
                    days_unit <= max_days_unit; 
                end
                else begin
                    
                end
            end
            else begin
                if (mode) begin
                    if (tick_day) begin
                        if (days == max_days) begin
                            days_unit <= 4'd1;
                            days_ten <= 4'd0; // rst_n to day 1
                        end
                        else if (days_unit == 4'd9) begin
                            days_unit <= 4'd0;
                            days_ten <= days_ten + 4'd1;
                        end
                        else begin
                            days_unit <= days_unit + 4'd1;
                        end     
                    end
                    else begin
                        
                    end               
                end
                else begin
                    // Manual mode
                    if (up && !down) begin
                        // Increment
                        if (days == max_days) begin
                            days_unit <= 4'd1;
                            days_ten <= 4'd0; // rst_n to dayq
                        end
                        else if (days_unit == 4'd9) begin
                            days_unit <= 4'd0;
                            days_ten <= days_ten + 1'd1;
                        end
                        else begin
                            days_unit <= days_unit + 1'd1;
                        end
                    end
                    else if (down && !up) begin
                        // Decrement
                        if (days == 5'd1) begin
                            days_ten <= max_days_ten;
                            days_unit <= max_days_unit; 
                        end
                        else if (days_unit == 4'd0) begin
                            days_unit <= 4'd9;
                            days_ten <= days_ten - 1'b1;
                        end
                        else begin
                            days_unit <= days_unit - 1'b1;
                        end
                    end
                    else begin
                            
                    end
                end
            end
        end
    end
    assign tick_month = (days_ten == max_days_ten && days_unit == max_days_unit && tick_day == 1'b1) ? 1'b1 : 1'b0;
endmodule