
module TOP_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg mode;
    reg display;
    reg up;
    reg down;

    // Outputs
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

    TOP uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode(~mode), 
        .display(display),
        .up(~up),
        .down(~down),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );

    // 50MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Task to simulate pressing 'up' button for one clk_5Hz cycle
    task adjust_up;
        begin
            up = 1; // Press
            @(posedge uut.uut_gen_clk.clk_5Hz); // Wait for one 5Hz clock cycle
            up = 0; // Release
        end
    endtask

    // Task to simulate pressing 'down' button for one clk_5Hz cycle
    task adjust_down;
        begin
            down = 1; // Press
            @(posedge uut.uut_gen_clk.clk_5Hz); // Wait for one 5Hz clock cycle
            down = 0; // Release
        end
    endtask

    // Task to simulate pressing 'mode' button once
    task press_mode;
        begin
            mode = 1;
            @(posedge uut.uut_gen_clk.clk_4Hz); // Wait for one cycle of clk_4Hz for the FSM to detect the press
            mode = 0;
            @(posedge clk); // Wait a bit to simulate button release
        end
    endtask

    initial begin
        // Khởi tạo: Nút nhấn không được nhấn (mức cao)
        rst_n = 0; mode = 0; display = 1; up = 0; down = 0;
        #100;
        rst_n = 1;
        $display("[%0t ns] System reset released. Starting comprehensive tests...", $time);
        #200;

        // // Simulate auto-counting for 1 day (commented out for faster simulation)
        // $display("Starting auto-count for 1 day...");
        // repeat(86400) begin
        //     @(posedge uut.uut_gen_clk.clk_1Hz); // Wait for each clk_1Hz cycle
        // end
        // $display("Checking after 1 day...");
        // if (uut.uut_count.days_unit == 4'b0001 && // Day = 01
        //     uut.uut_count.days_ten == 4'b0000 &&
        //     uut.uut_count.hours_unit == 4'b0000 && // Hour = 00
        //     uut.uut_count.hours_ten == 4'b0000 &&
        //     uut.uut_count.minutes_unit == 4'b0000 && // Minute = 00
        //     uut.uut_count.minutes_ten == 4'b0000 &&
        //     uut.uut_count.seconds_unit == 4'b0000 && // Second = 00
        //     uut.uut_count.seconds_ten == 4'b0000)
        //     $display("PASS: Counted correctly for 1 day, day increased, time reset to 00:00:00");
        // else
        //     $display("FAIL: Incorrect count after 1 day");

        // ====================================================================
        // PHẦN 1: KIỂM TRA ĐẾM TỰ ĐỘNG (AUTO COUNTING)
        // ====================================================================
        $display("\n--- AUTO COUNTING VERIFICATION ---"); //PART 1: 

        // --- Test 1.1: 57s -> 00s (phút tăng) ---
        $display("\n[TEST 1.1] Checking seconds to minutes rollover (from 15m : 57s)...");
        force uut.uut_count.uut_min.minutes_ten = 4'd1; 
        force uut.uut_count.uut_min.minutes_unit = 4'd5;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;
        
        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.minutes_ten == 4'd1 && uut.uut_count.minutes_unit == 4'd6 &&
            uut.uut_count.seconds_ten == 4'd0 && uut.uut_count.seconds_unit == 4'd0  
            )
            $display("PASS: Rolled over to 16:00.");
        else
            $display("FAIL: Incorrect rollover. Time: %d %d:%d %d", uut.uut_count.minutes_ten, uut.uut_count.minutes_unit, 
                uut.uut_count.seconds_ten, uut.uut_count.seconds_unit);
        #10;

        // --- Test 1.2: 59m:57s -> 00m:00s (giờ tăng) ---
        $display("\n[TEST 1.2] Checking minutes to hours rollover (from 10:59:57)...");
        force uut.uut_count.uut_hour.hours_ten = 4'd1; 
        force uut.uut_count.uut_hour.hours_unit = 4'd0;
        force uut.uut_count.uut_min.minutes_ten = 4'd5; 
        force uut.uut_count.uut_min.minutes_unit = 4'd9;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_hour.hours_ten; 
        release uut.uut_count.uut_hour.hours_unit;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;

        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.hours_ten == 4'd1 && uut.uut_count.hours_unit == 4'd1 && 
            uut.uut_count.minutes_ten == 4'd0 && uut.uut_count.minutes_unit == 4'd0 && 
            uut.uut_count.seconds_ten == 4'd0 && uut.uut_count.seconds_unit == 4'd0)
            $display("PASS: Rolled over to 11:00:00.");
        else
            $display("FAIL: Incorrect rollover. Time: %d %d:%d %d:%d %d", uut.uut_count.hours_ten, uut.uut_count.hours_unit, 
                uut.uut_count.minutes_ten, uut.uut_count.minutes_unit, uut.uut_count.seconds_ten, uut.uut_count.seconds_unit);
        #10;
        // --- Test 1.3: 23h:59m:57s -> 00h:00m:00s (ngày tăng) ---
        $display("\n[TEST 1.3] Checking hours to days rollover (from 23:59:57, day=16)...");
        force uut.uut_count.uut_day.days_ten = 4'd1; 
        force uut.uut_count.uut_day.days_unit = 4'd6;
        force uut.uut_count.uut_hour.hours_ten = 4'd2; 
        force uut.uut_count.uut_hour.hours_unit = 4'd3;
        force uut.uut_count.uut_min.minutes_ten = 4'd5; 
        force uut.uut_count.uut_min.minutes_unit = 4'd9;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_day.days_ten; 
        release uut.uut_count.uut_day.days_unit;
        release uut.uut_count.uut_hour.hours_ten; 
        release uut.uut_count.uut_hour.hours_unit;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;

        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.days_ten == 4'd1 && uut.uut_count.days_unit == 4'd7 && 
            uut.uut_count.hours_ten == 4'd0 && uut.uut_count.hours_unit == 4'd0 && 
            uut.uut_count.minutes_ten == 4'd0 && uut.uut_count.minutes_unit == 4'd0 && 
            uut.uut_count.seconds_ten == 4'd0 && uut.uut_count.seconds_unit == 4'd0)
            $display("PASS: Rolled over to day 17, 00:00:00.");
        else
            $display("FAIL: Incorrect rollover. Day: %d %d", uut.uut_count.days_ten, uut.uut_count.days_unit);
        #10;
        // --- Test 1.4: Kết thúc tháng 2 năm không nhuận (2023) ---
        $display("\n[TEST 1.4] Checking end of Feb on a non-leap year (2023)...");
        force uut.uut_count.uut_year.years_thousand = 4'd2; 
        force uut.uut_count.uut_year.years_hundred = 4'd0;
        force uut.uut_count.uut_year.years_ten = 4'd2; 
        force uut.uut_count.uut_year.years_unit = 4'd3;

        force uut.uut_count.uut_month.months_ten = 4'd0; 
        force uut.uut_count.uut_month.months_unit = 4'd2;
        force uut.uut_count.uut_day.days_ten = 4'd2; 
        force uut.uut_count.uut_day.days_unit = 4'd8;
        force uut.uut_count.uut_hour.hours_ten = 4'd2; 
        force uut.uut_count.uut_hour.hours_unit = 4'd3;
        force uut.uut_count.uut_min.minutes_ten = 4'd5; 
        force uut.uut_count.uut_min.minutes_unit = 4'd9;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_year.years_thousand; 
        release uut.uut_count.uut_year.years_hundred;
        release uut.uut_count.uut_year.years_ten; 
        release uut.uut_count.uut_year.years_unit;
        release uut.uut_count.uut_month.months_ten; 
        release uut.uut_count.uut_month.months_unit;
        release uut.uut_count.uut_day.days_ten; 
        release uut.uut_count.uut_day.days_unit;
        release uut.uut_count.uut_hour.hours_ten; 
        release uut.uut_count.uut_hour.hours_unit;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;

        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.months_ten == 4'd0 && uut.uut_count.months_unit == 4'd3 && 
            uut.uut_count.days_ten == 4'd0 && uut.uut_count.days_unit == 4'd1)
            $display("PASS: Rolled over to 01/03.");
        else
            $display("FAIL: Incorrect rollover. Date: %d %d/%d %d", uut.uut_count.days_ten, uut.uut_count.days_unit, 
                uut.uut_count.months_ten, uut.uut_count.months_unit);
        #10;
        // --- Test 1.5: Kết thúc tháng 2 năm nhuận (2024) ---
        $display("\n[TEST 1.5] Checking end of Feb on a leap year (2024)...");
        force uut.uut_count.uut_year.years_thousand = 4'd2; 
        force uut.uut_count.uut_year.years_hundred = 4'd0;
        force uut.uut_count.uut_year.years_ten = 4'd2; 
        force uut.uut_count.uut_year.years_unit = 4'd4;
        force uut.uut_count.uut_month.months_ten = 4'd0; 
        force uut.uut_count.uut_month.months_unit = 4'd2;
        force uut.uut_count.uut_day.days_ten = 4'd2; 
        force uut.uut_count.uut_day.days_unit = 4'd9;
        force uut.uut_count.uut_hour.hours_ten = 4'd2; 
        force uut.uut_count.uut_hour.hours_unit = 4'd3;
        force uut.uut_count.uut_min.minutes_ten = 4'd5; 
        force uut.uut_count.uut_min.minutes_unit = 4'd9;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_year.years_thousand; 
        release uut.uut_count.uut_year.years_hundred;
        release uut.uut_count.uut_year.years_ten; 
        release uut.uut_count.uut_year.years_unit;
        release uut.uut_count.uut_month.months_ten; 
        release uut.uut_count.uut_month.months_unit;
        release uut.uut_count.uut_day.days_ten; 
        release uut.uut_count.uut_day.days_unit;
        release uut.uut_count.uut_hour.hours_ten; 
        release uut.uut_count.uut_hour.hours_unit;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;

        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.months_ten == 4'd0 && uut.uut_count.months_unit == 4'd3 && 
            uut.uut_count.days_ten == 4'd0 && uut.uut_count.days_unit == 4'd1)
            $display("PASS: Rolled over to 01/03.");
        else
            $display("FAIL: Incorrect rollover. Date: %d %d/%d %d", uut.uut_count.days_ten, uut.uut_count.days_unit, 
                uut.uut_count.months_ten, uut.uut_count.months_unit);
        #10;
        // --- Test 1.6: Chuyển năm từ 9999 sang 0000 ---
        $display("\n[TEST 1.6] Checking year rollover from 9999 to 0000...");
        force uut.uut_count.uut_year.years_thousand = 4'd9; 
        force uut.uut_count.uut_year.years_hundred = 4'd9;
        force uut.uut_count.uut_year.years_ten = 4'd9; 
        force uut.uut_count.uut_year.years_unit = 4'd9;
        force uut.uut_count.uut_month.months_ten = 4'd1; 
        force uut.uut_count.uut_month.months_unit = 4'd2;
        force uut.uut_count.uut_day.days_ten = 4'd3; 
        force uut.uut_count.uut_day.days_unit = 4'd1;
        force uut.uut_count.uut_hour.hours_ten = 4'd2; 
        force uut.uut_count.uut_hour.hours_unit = 4'd3;
        force uut.uut_count.uut_min.minutes_ten = 4'd5; 
        force uut.uut_count.uut_min.minutes_unit = 4'd9;
        force uut.uut_count.uut_sec.seconds_ten = 4'd5; 
        force uut.uut_count.uut_sec.seconds_unit = 4'd7;
        #1;
        release uut.uut_count.uut_year.years_thousand; 
        release uut.uut_count.uut_year.years_hundred;
        release uut.uut_count.uut_year.years_ten; 
        release uut.uut_count.uut_year.years_unit;
        release uut.uut_count.uut_month.months_ten; 
        release uut.uut_count.uut_month.months_unit;
        release uut.uut_count.uut_day.days_ten; 
        release uut.uut_count.uut_day.days_unit;
        release uut.uut_count.uut_hour.hours_ten; 
        release uut.uut_count.uut_hour.hours_unit;
        release uut.uut_count.uut_min.minutes_ten; 
        release uut.uut_count.uut_min.minutes_unit;
        release uut.uut_count.uut_sec.seconds_ten; 
        release uut.uut_count.uut_sec.seconds_unit;

        repeat(4) @(posedge uut.uut_gen_clk.clk_1Hz); 
        #10;
        if (uut.uut_count.years_thousand == 4'd0 && uut.uut_count.years_hundred == 4'd0 && 
            uut.uut_count.years_ten == 4'd0 && uut.uut_count.years_unit == 4'd0 && 
            uut.uut_count.months_ten == 4'd0 && uut.uut_count.months_unit == 4'd1 && 
            uut.uut_count.days_ten == 4'd0 && uut.uut_count.days_unit == 4'd1)
            $display("PASS: Rolled over to 0000-01-01.");
        else
            $display("FAIL: Incorrect year rollover. Year: %d %d %d %d, Date: %d %d/%d %d", 
                uut.uut_count.years_thousand, uut.uut_count.years_hundred, uut.uut_count.years_ten, uut.uut_count.years_unit,
                uut.uut_count.days_ten, uut.uut_count.days_unit, uut.uut_count.months_ten, uut.uut_count.months_unit);
        #10;
        
        // // ====================================================================
        // // PHẦN 2: KIỂM TRA CHỈNH SỬA BẰNG TAY (MANUAL ADJUSTMENT) - PHIÊN BẢN ĐÃ SỬA LỖI
        // // ====================================================================
        // $display("\n--- PART 2: MANUAL ADJUSTMENT VERIFICATION (FIXED) ---");

        // // --- BÀI TEST 2.1: CHẾ ĐỘ CHỈNH NĂM / GIÂY (ADJ_YEAR_SEC) ---
        // $display("\n[TEST 2.1] Verifying YEAR/SECOND adjustment mode...");
        
        // // Set initial state: 01/01/2024 00:00:00
        // force uut.uut_count.uut_year.years_unit = 4'd4; force uut.uut_count.uut_year.years_ten = 4'd2;
        // force uut.uut_count.uut_year.years_hundred = 4'd0; force uut.uut_count.uut_year.years_thousand = 4'd2;
        // force uut.uut_count.uut_month.months_unit = 4'd1; force uut.uut_count.uut_month.months_ten = 4'd0;
        // force uut.uut_count.uut_day.days_unit = 4'd1; force uut.uut_count.uut_day.days_ten = 4'd0;
        // #1; 
        // // Release individual signals
        // release uut.uut_count.uut_year.years_unit; release uut.uut_count.uut_year.years_ten;
        // release uut.uut_count.uut_year.years_hundred; release uut.uut_count.uut_year.years_thousand;
        // release uut.uut_count.uut_month.months_unit; release uut.uut_count.uut_month.months_ten;
        // release uut.uut_count.uut_day.days_unit; release uut.uut_count.uut_day.days_ten;
        // #100;

        // // Enter YEAR/SECOND adjustment mode
        // press_mode; 
        
        // // 2.1.1: Adjust YEAR (display = 0)
        // display = 0;
        // $display(" -> Adjusting YEAR (2024 -> 2025 -> 2024 -> ...)");
        // adjust_up; // 2024 -> 2025
        // if (uut.uut_count.years_ten == 4'd2 && uut.uut_count.years_unit == 4'd5) $display("    PASS: Year incremented to 2025.");
        // else $display("    FAIL: Year did not increment correctly.");
        
        // adjust_down; // 2025 -> 2024
        // if (uut.uut_count.years_ten == 4'd2 && uut.uut_count.years_unit == 4'd4) $display("    PASS: Year decremented to 2024.");
        // else $display("    FAIL: Year did not decrement correctly.");

        // // 2.1.2: Adjust SECOND (display = 1)
        // display = 1;
        // $display(" -> Adjusting SECOND (00s -> 59s -> 00s -> 01s)");
        // adjust_down; // 00 -> 59
        // if (uut.uut_count.seconds_ten == 4'd5 && uut.uut_count.seconds_unit == 4'd9) $display("    PASS: Second wrapped down to 59.");
        // else $display("    FAIL: Second did not wrap down correctly. Is: %d%d", uut.uut_count.seconds_ten, uut.uut_count.seconds_unit);
        
        // adjust_up; // 59 -> 00
        // adjust_up; // 00 -> 01
        // if (uut.uut_count.seconds_ten == 4'd0 && uut.uut_count.seconds_unit == 4'd1) $display("    PASS: Second incremented to 01.");
        // else $display("    FAIL: Second did not increment correctly. Is: %d%d", uut.uut_count.seconds_ten, uut.uut_count.seconds_unit);
        
        // // Exit to main display
        // press_mode; press_mode; press_mode;
        // #200;

        // // --- BÀI TEST 2.2: CHẾ ĐỘ CHỈNH THÁNG / PHÚT (ADJ_MON_MIN) VÀ TỰ SỬA NGÀY ---
        // $display("\n[TEST 2.2] Verifying MONTH/MINUTE adjustment and auto day correction...");
        
        // // Set initial state: 31/03/2023 (non-leap year)
        // force uut.uut_count.uut_year.years_unit = 4'd3; force uut.uut_count.uut_year.years_ten = 4'd2;
        // force uut.uut_count.uut_month.months_unit = 4'd3; force uut.uut_count.uut_month.months_ten = 4'd0;
        // force uut.uut_count.uut_day.days_unit = 4'd1; force uut.uut_count.uut_day.days_ten = 4'd3;
        // #1; 
        // // Release individual signals
        // release uut.uut_count.uut_year.years_unit; release uut.uut_count.uut_year.years_ten;
        // release uut.uut_count.uut_month.months_unit; release uut.uut_count.uut_month.months_ten;
        // release uut.uut_count.uut_day.days_unit; release uut.uut_count.uut_day.days_ten;
        // #100;
        
        // // Enter MONTH/MINUTE adjustment mode
        // press_mode; press_mode;

        // // 2.2.1: Adjust MONTH (display = 0) and check for auto-correction
        // display = 0;
        // $display(" -> Adjusting MONTH from March 31st down to February...");
        // adjust_down; // March -> February
        
        // #500; // Added delay to make the change visible in the waveform viewer

        // // Since 2023 is not a leap year, the day must be auto-corrected from 31 to 28
        // if (uut.uut_count.months_unit == 4'd2 && uut.uut_count.days_ten == 4'd2 && uut.uut_count.days_unit == 4'd8)
        //     $display("    PASS: Date auto-corrected from 31/03 to 28/02.");
        // else
        //     $display("    FAIL: Date did not correct. Date is: %d%d / %d%d", uut.uut_count.days_ten, uut.uut_count.days_unit, uut.uut_count.months_ten, uut.uut_count.months_unit);
        
        // // 2.2.2: Adjust MINUTE (display = 1)
        // display = 1;
        // $display(" -> Adjusting MINUTE (00m -> 59m)");
        // adjust_down; // 00 -> 59
        // if (uut.uut_count.minutes_ten == 5 && uut.uut_count.minutes_unit == 9) $display("    PASS: Minute wrapped down to 59.");
        // else $display("    FAIL: Minute did not wrap correctly.");

        // // Exit to main display
        // press_mode; press_mode;
        // #200;

        // // --- BÀI TEST 2.3: CHẾ ĐỘ CHỈNH NGÀY / GIỜ (ADJ_DAY_HOUR) ---
        // $display("\n[TEST 2.3] Verifying DAY/HOUR adjustment mode...");

        // // Set initial state: 28/02/2024 (leap year)
        // force uut.uut_count.uut_year.years_unit = 4'd4; force uut.uut_count.uut_year.years_ten = 4'd2;
        // force uut.uut_count.uut_month.months_unit = 4'd2; force uut.uut_count.uut_month.months_ten = 4'd0;
        // force uut.uut_count.uut_day.days_unit = 4'd8; force uut.uut_count.uut_day.days_ten = 4'd2;
        // #1; 
        // // Release individual signals
        // release uut.uut_count.uut_year.years_unit; release uut.uut_count.uut_year.years_ten;
        // release uut.uut_count.uut_month.months_unit; release uut.uut_count.uut_month.months_ten;
        // release uut.uut_count.uut_day.days_unit; release uut.uut_count.uut_day.days_ten;
        // #100;
        
        // // Enter DAY/HOUR adjustment mode
        // press_mode; press_mode; press_mode;

        // // 2.3.1: Adjust DAY (display = 0)
        // display = 0;
        // $display(" -> Adjusting DAY in a leap year (Feb 28 -> Feb 29 -> Mar 01)");
        // adjust_up; // 28 -> 29 (OK because 2024 is a leap year)
        // if (uut.uut_count.days_ten == 2 && uut.uut_count.days_unit == 9) $display("    PASS: Day incremented to 29 in a leap year.");
        // else $display("    FAIL: Day did not increment to 29. Is: %d%d", uut.uut_count.days_ten, uut.uut_count.days_unit);
        
        // adjust_up; // 29/02 -> 01/03 (auto month rollover)
        // if (uut.uut_count.days_ten == 0 && uut.uut_count.days_unit == 1 && uut.uut_count.months_unit == 3)
        //     $display("    PASS: Rolled over from Feb 29 to Mar 01.");
        // else
        //     $display("    FAIL: Did not roll over to Mar 01. Is: %d%d/%d%d", uut.uut_count.days_ten, uut.uut_count.days_unit, uut.uut_count.months_ten, uut.uut_count.months_unit);
            
        // // 2.3.2: Adjust HOUR (display = 1)
        // display = 1;
        // $display(" -> Adjusting HOUR (00h -> 23h -> 00h)");
        // adjust_down; // 00 -> 23
        // if (uut.uut_count.hours_ten == 2 && uut.uut_count.hours_unit == 3) $display("    PASS: Hour wrapped down to 23.");
        // else $display("    FAIL: Hour did not wrap correctly.");

        // adjust_up; // 23 -> 00
        // if (uut.uut_count.hours_ten == 0 && uut.uut_count.hours_unit == 0) $display("    PASS: Hour wrapped up to 00.");
        // else $display("    FAIL: Hour did not wrap correctly.");

        // // Exit to main display
        // press_mode;
        // #200;

        $display("\n[%0t ns] All tests completed.", $time);
        $finish;
    
    end
endmodule