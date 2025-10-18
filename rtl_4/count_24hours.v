module count_24hours (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Mode: 1 for auto-count, 0 for manual adjust
    input           up,
    input           down,
    input           rst_n,
    input           tick_hour,
    output  reg [3:0]   hours_unit,
    output  reg [3:0]   hours_ten,
    output              tick_day
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
            hours_unit <= 0;
            hours_ten <= 0;    
        end
        else begin
            if (mode) begin
                if (tick_hour) begin
                    if (hours_ten == 4'd2 && hours_unit == 4'd3) begin
                        hours_unit <= 0;
                        hours_ten <= 0;
                    end
                    else if (hours_unit == 4'd9) begin
                        hours_unit <= 0;
                        hours_ten <= hours_ten + 1'b1;
                    end
                    else begin
                        hours_unit <= hours_unit + 1'b1;
                    end
                end 
                else begin
                    
                end
            end
            else begin
                if (up && !down) begin
                // Increment 
                    if (hours_ten == 4'd2 && hours_unit == 4'd3) begin
                        hours_unit <= 0;
                        hours_ten <= 0;
                    end
                    else if (hours_unit == 4'd9) begin
                        hours_unit <= 0;
                        hours_ten <= hours_ten + 1'b1;
                    end
                    else begin
                        hours_unit <= hours_unit + 1'b1;
                    end
                end
                else if (down && !up) begin
                // Decrement
                    if (hours_ten == 4'd0 && hours_unit == 4'd0) begin
                        hours_ten  <= 4'd2;
                        hours_unit <= 4'd3;
                    end
                    else if (hours_unit == 4'd0) begin
                        hours_unit <= 4'd9;
                        hours_ten <= hours_ten - 1'b1;
                    end
                    else begin
                        hours_unit <= hours_unit - 1'b1;
                    end
                end
                else begin
                            
                end
            end
        end
    end
    assign tick_day = (hours_ten == 4'd2 && hours_unit == 4'd3 && tick_hour == 1'b1) ? 1'b1 : 1'b0;
endmodule