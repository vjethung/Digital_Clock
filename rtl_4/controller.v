module controller (
    input       rst_n,
    input       mode,      // Nhấn mode để chuyển trạng thái
    input       display,
    input       clk_4Hz,
    output reg  blink_second_year,
    output reg  blink_minute_month,
    output reg  blink_hour_day,

    output reg  mode_second, mode_minute, mode_hour, mode_day, mode_month, mode_year
);

    localparam  DISPLAY      = 2'b00, 
                ADJ_YEAR_SEC = 2'b01, 
                ADJ_MON_MIN  = 2'b10, 
                ADJ_DAY_HOUR = 2'b11; 

    reg [1:0] cs, ns;

    always @(posedge clk_4Hz or negedge rst_n) begin
        if (~rst_n)
            cs <= DISPLAY; 
        else
            cs <= ns;
    end

    always @(cs or mode) begin
        ns = cs; // Mặc định giữ trạng thái hiện tại
        case (cs)
            DISPLAY: begin
                if (mode)
                    ns = ADJ_YEAR_SEC; // Chuyển sang điều chỉnh năm/giây
            end
            ADJ_YEAR_SEC: begin
                if (mode)
                    ns = ADJ_MON_MIN; // Chuyển sang điều chỉnh tháng/phút
            end
            ADJ_MON_MIN: begin
                if (mode)
                    ns = ADJ_DAY_HOUR; // Chuyển sang điều chỉnh ngày/giờ
            end
            ADJ_DAY_HOUR: begin
                if (mode)
                    ns = DISPLAY; // Quay lại hiển thị bình thường
            end
            default: begin
                ns = DISPLAY; // Mặc định về DISPLAY
            end
        endcase
    end
    always @(cs or display) begin
        blink_second_year = 1'b0;
        blink_minute_month = 1'b0;
        blink_hour_day = 1'b0;
        mode_second = 1'b1;
        mode_year = 1'b1;
        mode_minute = 1'b1;
        mode_month = 1'b1;
        mode_hour = 1'b1;
        mode_day = 1'b1;
        case (cs)
            DISPLAY: begin
                
            end
            ADJ_YEAR_SEC: begin
                blink_second_year = 1'b1; // Nháy năm/giây
                mode_second = ~display;
                mode_year = display;
            end
            ADJ_MON_MIN: begin
                blink_minute_month = 1'b1; // Nháy tháng/phút
                mode_minute = ~display;
                mode_month = display;
            end
            ADJ_DAY_HOUR: begin
                blink_hour_day = 1'b1; // Nháy ngày/giờ
                mode_hour = ~display;
                mode_day = display;
            end
            default: begin
                // Không nháy
                blink_second_year = 1'b0;
                blink_minute_month = 1'b0;
                blink_hour_day = 1'b0;
                mode_second = 1'b1;
                mode_year = 1'b1;
                mode_minute = 1'b1;
                mode_month = 1'b1;
                mode_hour = 1'b1;
                mode_day = 1'b1;
            end
        endcase
    end
endmodule