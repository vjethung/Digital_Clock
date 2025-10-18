module COUNT (
    input   clk_1Hz,
    input   clk,
    input   clk_adjust,
    input   rst_n,
    input   mode_second, mode_minute, mode_hour, mode_day, mode_month, mode_year,
    input   up, down,
    output  [3:0]   seconds_unit, seconds_ten,
    output  [3:0]   minutes_unit, minutes_ten,
    output  [3:0]   hours_unit, hours_ten,
    output  [3:0]   days_unit, days_ten,
    output  [3:0]   months_unit, months_ten,
    output  [3:0]   years_unit, years_ten, years_hundred, years_thousand
);
    wire tick_minute_;
    wire tick_hour_;
    wire tick_day_;
    wire tick_month_;
    wire tick_year_;
    wire [4:0] max_days_;

    count_60seconds uut_sec (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_second),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .seconds_unit(seconds_unit),
        .seconds_ten(seconds_ten),
        .tick_minute(tick_minute_)
    );

    count_60minutes uut_min (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_minute),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .tick_minute(tick_minute_),
        .minutes_unit(minutes_unit),
        .minutes_ten(minutes_ten),
        .tick_hour(tick_hour_)
    );

    count_24hours uut_hour (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_hour),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .tick_hour(tick_hour_),
        .hours_unit(hours_unit),
        .hours_ten(hours_ten),
        .tick_day(tick_day_)
    );

    count_days uut_day (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_day),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .tick_day(tick_day_),
        .max_days(max_days_),
        .months_unit(months_unit),
        .months_ten(months_ten),
        .days_unit(days_unit),
        .days_ten(days_ten),
        .tick_month(tick_month_)
    );

    // Xác định số ngày tối đa của tháng
    day_of_month uut_day_of_month (
        .months_unit(months_unit),
        .months_ten(months_ten),
        .years_unit(years_unit),
        .years_ten(years_ten),
        .years_hundred(years_hundred),
        .years_thousand(years_thousand),
        .max_days(max_days_)
    );

    count_months uut_month (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_month),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .tick_month(tick_month_),
        .months_unit(months_unit),
        .months_ten(months_ten),
        .tick_year(tick_year_)
    );

    // Đếm năm
    count_years uut_year (
        .clk_1Hz(clk_1Hz),
        .clk(clk),
        .clk_adjust(clk_adjust),
        .mode(mode_year),
        .up(up),
        .down(down),
        .rst_n(rst_n),
        .tick_year(tick_year_),
        .years_unit(years_unit),
        .years_ten(years_ten),
        .years_hundred(years_hundred),
        .years_thousand(years_thousand)
    );
endmodule