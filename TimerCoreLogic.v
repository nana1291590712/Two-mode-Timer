module TimerCoreLogic (
    input clk,                 // Clock (100Hz or 1Hz)
    input rst_n,              // Active-low reset
    input StartStop,          // Start/Stop toggle input
    input ModeSel,            // 0 = stopwatch, 1 = timer

    output [7:0] LSBbinaryout,
    output [7:0] MSBbinaryout
);

    reg [7:0] lsb_count;
    reg [7:0] msb_count;
    reg running;
    reg StartStop_prev;

    wire Start_rise = StartStop & ~StartStop_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            running <= 1'b0;
            StartStop_prev <= 1'b0;
            lsb_count <= 8'd0;
            msb_count <= (ModeSel) ? 8'd2 : 8'd0;
        end else begin
            StartStop_prev <= StartStop;
            if (Start_rise)
                running <= ~running;

            if (running) begin
                if (!ModeSel) begin
                    // Stopwatch mode: count up
                    if (lsb_count == 8'd99) begin
                        lsb_count <= 8'd0;
                        if (msb_count == 8'd99)
                            msb_count <= 8'd0;
                        else
                            msb_count <= msb_count + 1;
                    end else begin
                        lsb_count <= lsb_count + 1;
                    end
                end else begin
                    // Timer mode: count down
                    if (lsb_count == 8'd0) begin
                        if (msb_count != 8'd0) begin
                            msb_count <= msb_count - 1;
                            lsb_count <= 8'd59;
                        end
                    end else begin
                        lsb_count <= lsb_count - 1;
                    end
                end
            end
        end
    end

    assign LSBbinaryout = lsb_count;
    assign MSBbinaryout = msb_count;

endmodule
