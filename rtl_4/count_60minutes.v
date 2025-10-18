module count_60minutes (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Mode: 1 for auto-count, 0 for manual adjust
    input           up,
    input           down,
    input           rst_n,
    input           tick_minute,
    output  reg [3:0]   minutes_unit,
    output  reg [3:0]   minutes_ten,
    output  	         tick_hour
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
            minutes_unit <= 0;
            minutes_ten <= 0;  
        end
        else begin
            if (mode) begin 
                if (tick_minute) begin
                    if (minutes_ten == 4'd5 && minutes_unit == 4'd9) begin
                            minutes_unit <= 4'd0;
                            minutes_ten <= 4'd0;
                        end
                        else if (minutes_unit == 4'd9) begin
                            minutes_unit <= 0;
                            minutes_ten <= minutes_ten + 1'b1;
                        end
                        else begin
                            minutes_unit <= minutes_unit + 1'b1;
                        end 
                end
                else begin
                    
                end
            end
            else begin
                if (up && !down) begin
                    // Increment 
                    if (minutes_ten == 4'd5 && minutes_unit == 4'd9) begin
                        minutes_unit <= 4'd0;
                        minutes_ten <= 4'd0;
                    end
                    else if (minutes_unit == 4'd9) begin
                        minutes_unit <= 0;
                        minutes_ten <= minutes_ten + 1'b1;
                    end
                    else begin
                        minutes_unit <= minutes_unit + 1'b1;
                    end
                end
                else if (down && !up) begin
                    // Decrement
                    if (minutes_ten == 4'd0 && minutes_unit == 4'd0) begin
                        minutes_ten  <= 4'd5;
                        minutes_unit <= 4'd9;
                    end
                    else if (minutes_unit == 4'd0) begin
                        minutes_unit <= 4'd9;
                        minutes_ten <= minutes_ten - 1'b1;
                    end
                    else begin
                        minutes_unit <= minutes_unit - 1'b1;
                    end
                end
                else begin
                            
                end
            end
        end
    end
    assign tick_hour = (minutes_ten == 4'd5 && minutes_unit == 4'd9 && tick_minute == 1'b1) ? 1'b1 : 1'b0;
endmodule