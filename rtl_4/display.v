module display (
    input           clk_4Hz,
    input           rst_n,
    input           display,  // 1: gio, phut, giay   // 0: ngay, thang, nam
    input           blink_second_year,   // 1: không nháy; 0: nháy
    input           blink_minute_month,
    input           blink_hour_day,
    input  [3:0]   seconds_unit, seconds_ten,
    input  [3:0]   minutes_unit, minutes_ten,
    input  [3:0]   hours_unit, hours_ten,
    input  [3:0]   days_unit, days_ten,
    input  [3:0]   months_unit, months_ten,
    input  [3:0]   years_unit, years_ten, years_hundred, years_thousand,

    output reg [6:0]    HEX0,
    output reg [6:0]    HEX1,
    output reg [6:0]    HEX2,
    output reg [6:0]    HEX3,
    output reg [6:0]    HEX4,
    output reg [6:0]    HEX5,
    output reg [6:0]    HEX6,
    output reg [6:0]    HEX7
);

    wire [6:0] seconds_unit_;
    wire [6:0] seconds_ten_;
    wire [6:0] minutes_unit_;
    wire [6:0] minutes_ten_;
    wire [6:0] hours_unit_;
    wire [6:0] hours_ten_;
    wire [6:0] days_unit_;
    wire [6:0] days_ten_;
    wire [6:0] months_unit_;
    wire [6:0] months_ten_;
    wire [6:0] years_unit_;
    wire [6:0] years_ten_;
    wire [6:0] years_hundred_;
    wire [6:0] years_thousand_;

    BCD_to_7segment dut_seconds_unit(
        .rst_n(rst_n),
        .BCD(seconds_unit),
        .segment(seconds_unit_)
    );
    BCD_to_7segment dut_seconds_ten (
        .rst_n(rst_n),
        .BCD(seconds_ten),
        .segment(seconds_ten_)
    );

    BCD_to_7segment dut_minutes_unit (
        .rst_n(rst_n),
        .BCD(minutes_unit),
        .segment(minutes_unit_)
    );

    BCD_to_7segment dut_minutes_ten (
        .rst_n(rst_n),
        .BCD(minutes_ten),
        .segment(minutes_ten_)
    );

    BCD_to_7segment dut_hours_unit (
        .rst_n(rst_n),
        .BCD(hours_unit),
        .segment(hours_unit_)
    );

    BCD_to_7segment dut_hours_ten (
        .rst_n(rst_n),
        .BCD(hours_ten),
        .segment(hours_ten_)
    );

    BCD_to_7segment dut_days_unit (
        .rst_n(rst_n),
        .BCD(days_unit),
        .segment(days_unit_)
    );

    BCD_to_7segment dut_days_ten (
        .rst_n(rst_n),
        .BCD(days_ten),
        .segment(days_ten_)
    );

    BCD_to_7segment dut_months_unit (
        .rst_n(rst_n),
        .BCD(months_unit),
        .segment(months_unit_)
    );

    BCD_to_7segment dut_months_ten (
        .rst_n(rst_n),
        .BCD(months_ten),
        .segment(months_ten_)
    );

    BCD_to_7segment dut_years_unit (
        .rst_n(rst_n),
        .BCD(years_unit),
        .segment(years_unit_)
    );

    BCD_to_7segment dut_years_ten (
        .rst_n(rst_n),
        .BCD(years_ten),
        .segment(years_ten_)
    );

    BCD_to_7segment dut_years_hundred (
        .rst_n(rst_n),
        .BCD(years_hundred),
        .segment(years_hundred_)
    );

    BCD_to_7segment dut_years_thousand (
        .rst_n(rst_n),
        .BCD(years_thousand),
        .segment(years_thousand_)
    );
    
    // Biến để tạo hiệu ứng nháy
    reg blink;
    always @(posedge clk_4Hz or negedge rst_n) begin
        if (~rst_n)
            blink <= 1'b0;
        else
            blink <= ~blink; // Đảo trạng thái nháy mỗi chu kỳ clk_8Hz
    end
    
    always @(*) begin
        if (~rst_n) begin
            HEX0 = 7'b1000000; // Hiển thị số 0 khi reset
            HEX1 = 7'b1000000;
            HEX2 = 7'b1000000;
            HEX3 = 7'b1000000;
            HEX4 = 7'b1000000;
            HEX5 = 7'b1000000;
            HEX6 = 7'b1000000;
            HEX7 = 7'b1000000;
        end
        else begin
            if (display) begin // Hiển thị giờ, phút, giây
                HEX0 = 7'b1111111; // Tắt HEX0
                HEX1 = 7'b1111111; // Tắt HEX1
                
                HEX2 = (blink_second_year && blink) ? 7'b1111111 : seconds_unit_; // Nháy giây
                HEX3 = (blink_second_year && blink) ? 7'b1111111 : seconds_ten_;
                
                HEX4 = (blink_minute_month && blink) ? 7'b1111111 : minutes_unit_; // Nháy phút
                HEX5 = (blink_minute_month && blink) ? 7'b1111111 : minutes_ten_;
                
                HEX6 = (blink_hour_day && blink) ? 7'b1111111 : hours_unit_; // Nháy giờ
                HEX7 = (blink_hour_day && blink) ? 7'b1111111 : hours_ten_;
            end
            else begin // Hiển thị ngày, tháng, năm
                HEX0 = (blink_second_year && blink) ? 7'b1111111 : years_unit_; // Nháy năm
                HEX1 = (blink_second_year && blink) ? 7'b1111111 : years_ten_;
                
                HEX2 = (blink_second_year && blink) ? 7'b1111111 : years_hundred_;
                HEX3 = (blink_second_year && blink) ? 7'b1111111 : years_thousand_;

                HEX4 = (blink_minute_month && blink) ? 7'b1111111 : months_unit_; // Nháy tháng
                HEX5 = (blink_minute_month && blink) ? 7'b1111111 : months_ten_;
                
                HEX6 = (blink_hour_day && blink) ? 7'b1111111 : days_unit_; // Nháy ngày
                HEX7 = (blink_hour_day && blink) ? 7'b1111111 : days_ten_;
            end
        end
    end
endmodule