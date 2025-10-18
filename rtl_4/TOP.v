module TOP (
    input clk,
    input rst_n,    // SW1
    input mode,     // KEY2
    input display,  // SW0
    input up,       // KEY1
    input down,     // KEY0

    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7
);

    wire clk_1Hz_;
    wire clk_4Hz_;
    wire clk_5Hz_;
    wire clk_1MHz_;
    wire clk_20Hz_;

    wire blink_second_year;
    wire blink_minute_month;
    wire blink_hour_day;

    wire mode_second;
    wire mode_minute;
    wire mode_hour;
    wire mode_year;
    wire mode_month;
    wire mode_day;

    wire [3:0] seconds_unit;
    wire [3:0] seconds_ten;
    wire [3:0] minutes_unit;
    wire [3:0] minutes_ten;
    wire [3:0] hours_unit;
    wire [3:0] hours_ten;
    wire [3:0] days_unit;
    wire [3:0] days_ten;
    wire [3:0] months_unit;
    wire [3:0] months_ten;
    wire [3:0] years_unit;
    wire [3:0] years_ten;
    wire [3:0] years_hundred;
    wire [3:0] years_thousand;

    gen_clk_1Hz uut_gen_clk (
        .clk(clk),
        .rst_n(rst_n),
        .clk_1Hz(clk_1Hz_),
        .clk_4Hz(clk_4Hz_),
        .clk_5Hz(clk_5Hz_)
        // .clk_1MHz(clk_1MHz_),
        // .clk_20Hz(clk_20Hz_)
    );


    COUNT uut_count (
        .clk_1Hz(clk_1Hz_),
        .clk(clk),
        .clk_adjust(clk_5Hz_),
        .rst_n(rst_n),
        .mode_second(mode_second),
        .mode_minute(mode_minute),
        .mode_hour(mode_hour),
        .mode_day(mode_day),
        .mode_month(mode_month),
        .mode_year(mode_year),
        .up(~up),
        .down(~down),
        
        .seconds_unit(seconds_unit),
        .seconds_ten(seconds_ten),
        .minutes_unit(minutes_unit),
        .minutes_ten(minutes_ten),
        .hours_unit(hours_unit),
        .hours_ten(hours_ten),
        .days_unit(days_unit),
        .days_ten(days_ten),
        .months_unit(months_unit),
        .months_ten(months_ten),
        .years_unit(years_unit),
        .years_ten(years_ten),
        .years_hundred(years_hundred),
        .years_thousand(years_thousand)
    );

    controller uut_controller (
        .rst_n(rst_n),
        .mode(~mode),
        .display(display),
        .clk_4Hz(clk_4Hz_),
        .blink_second_year(blink_second_year),
        .blink_minute_month(blink_minute_month),
        .blink_hour_day(blink_hour_day),
        .mode_second(mode_second),
        .mode_minute(mode_minute),
        .mode_hour(mode_hour),
        .mode_day(mode_day),
        .mode_month(mode_month),
        .mode_year(mode_year)
    );

    display uut_display (
        .clk_4Hz(clk_4Hz_),
        .rst_n(rst_n),
        .display(display),
        .blink_second_year(blink_second_year),
        .blink_minute_month(blink_minute_month),
        .blink_hour_day(blink_hour_day),
        .seconds_unit(seconds_unit),
        .seconds_ten(seconds_ten),
        .minutes_unit(minutes_unit),
        .minutes_ten(minutes_ten),
        .hours_unit(hours_unit),
        .hours_ten(hours_ten),
        .days_unit(days_unit),
        .days_ten(days_ten),
        .months_unit(months_unit),
        .months_ten(months_ten),
        .years_unit(years_unit),
        .years_ten(years_ten),
        .years_hundred(years_hundred),
        .years_thousand(years_thousand),

        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );

endmodule