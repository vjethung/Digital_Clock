module count_60seconds (
    input           clk_1Hz,
    input           clk,
    input           clk_adjust,
    input           mode,      // Chế độ: 1 cho đếm tự động, 0 cho điều chỉnh thủ công
    input           up,
    input           down,
    input           rst_n,
    output reg [3:0] seconds_unit,
    output reg [3:0] seconds_ten,
    output 		      tick_minute
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
            seconds_unit <= 4'd0;
            seconds_ten <= 4'd0;
        end
        else begin
            if (mode) begin  
                if (seconds_ten == 4'd5 && seconds_unit == 4'd9) begin
                    seconds_unit <= 4'd0;
                    seconds_ten <= 4'd0; 
                end
                else if (seconds_unit == 4'd9) begin
                    seconds_unit <= 4'd0;
                    seconds_ten <= seconds_ten + 1'b1; 
                end
                else begin
                    seconds_unit <= seconds_unit + 1'b1; 
                end
            end
            else begin  
                if (up && !down) begin
                    // Tăng
                    if (seconds_ten == 4'd5 && seconds_unit == 4'd9) begin
                        seconds_unit <= 4'd0;
                        seconds_ten <= 4'd0; 
                    end
                    else if (seconds_unit == 4'd9) begin
                        seconds_unit <= 4'd0;
                        seconds_ten <= seconds_ten + 1'b1; 
                    end
                    else begin
                        seconds_unit <= seconds_unit + 1'b1; 
                    end
                end
                else if (down && !up) begin
                    // Giảm
                    if (seconds_ten == 4'd0 && seconds_unit == 4'd0) begin
                        seconds_ten <= 4'd5;
                        seconds_unit <= 4'd9; 
                    end
                    else if (seconds_unit == 4'd0) begin
                        seconds_unit <= 4'd9;
                        seconds_ten <= seconds_ten - 1'b1; 
                    end
                    else begin
                        seconds_unit <= seconds_unit - 1'b1; 
                    end
                end
                else begin
                    
                end
            end
        end
    end
    // assign tick_minute = (seconds_ten == 4'd5 && seconds_unit == 4'd9) ? 1'b1 : 1'b0;
    reg tick_minute_reg;
    assign tick_minute = tick_minute_reg;

    always @(posedge clock or negedge rst_n) begin
        if (~rst_n) begin
            tick_minute_reg <= 1'b0;
        end else begin
            if (mode) begin 
                if (seconds_ten == 4'd5 && seconds_unit == 4'd8) begin
                    tick_minute_reg <= 1'b1;
                end else begin
                    tick_minute_reg <= 1'b0;
                end
            end else begin
                tick_minute_reg <= 1'b0; 
            end
        end
    end
endmodule