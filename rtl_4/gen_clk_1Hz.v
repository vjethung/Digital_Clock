module gen_clk_1Hz (
    input       clk, // clock 50 Mhz (0-49 999 999)
    input       rst_n,
    output reg  clk_1Hz,
    output reg  clk_4Hz,
    output reg  clk_5Hz
    // output reg  clk_1MHz,
    // output reg  clk_20Hz
);
    reg [24:0] count_1hz = 0;
    reg [22:0] count_4hz = 0;
    reg [22:0] count_5Hz = 0;
    // reg [4:0] count_1mhz = 0;
    // reg [20:0] count_20Hz = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_1hz <= 0;
            clk_1Hz <= 0; 
        end
        else begin
            if (count_1hz == 25'd24_999_999) begin
                clk_1Hz <= ~clk_1Hz;
                count_1hz <= 0;
            end
            else count_1hz <= count_1hz + 1'b1;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_4hz <= 0;
            clk_4Hz<= 0; 
        end
        else begin
            if (count_4hz == 23'd6_249_999) begin
                clk_4Hz<= ~clk_4Hz;
                count_4hz <= 0;
            end
            else count_4hz <= count_4hz + 1'b1;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_5Hz <= 0;
            clk_5Hz<= 0; 
        end
        else begin
            if (count_5Hz == 23'd4_999_999) begin
                clk_5Hz<= ~clk_5Hz;
                count_5Hz <= 0;
            end
            else count_5Hz <= count_5Hz + 1'b1;
        end
    end
    // always @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) begin
    //         count_1mhz <= 0;
    //         clk_1MHz<= 0; 
    //     end
    //     else begin
    //         if (count_1mhz == 5'd24) begin
    //             clk_1MHz<= ~clk_1MHz;
    //             count_1mhz <= 0;
    //         end
    //         else count_1mhz <= count_1mhz + 1'b1;
    //     end
    // end
    // always @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) begin
    //         count_20Hz <= 0;
    //         clk_20Hz<= 0; 
    //     end
    //     else begin
    //         if (count_20Hz == 21'd1_249_999) begin
    //             clk_20Hz<= ~clk_20Hz;
    //             count_20Hz <= 0;
    //         end
    //         else count_20Hz <= count_20Hz + 1'b1;
    //     end
    // end
endmodule