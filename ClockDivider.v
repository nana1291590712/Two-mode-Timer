module ClockDivider (
    input CLK_50MHz,       // 50MHz clock input
    input rst_n,           // Active-LOW reset
    output CLK_100Hz,      // 100Hz clock output
    output CLK_1Hz         // 1Hz clock output
);

    parameter DIV_100HZ = 250_000;
    parameter DIV_1HZ   = 25_000_000;

    reg [17:0] cnt_100Hz = 0;
    reg [24:0] cnt_1Hz   = 0;
    reg clk100 = 0;
    reg clk1   = 0;

    assign CLK_100Hz = clk100;
    assign CLK_1Hz   = clk1;

    always @(posedge CLK_50MHz or negedge rst_n) begin
        if (!rst_n) begin
            cnt_100Hz <= 0;
            cnt_1Hz <= 0;
            clk100 <= 0;
            clk1 <= 0;
        end else begin
            if (cnt_100Hz == DIV_100HZ - 1) begin
                cnt_100Hz <= 0;
                clk100 <= ~clk100;
            end else begin
                cnt_100Hz <= cnt_100Hz + 1;
            end

            if (cnt_1Hz == DIV_1HZ - 1) begin
                cnt_1Hz <= 0;
                clk1 <= ~clk1;
            end else begin
                cnt_1Hz <= cnt_1Hz + 1;
            end
        end
    end

endmodule
