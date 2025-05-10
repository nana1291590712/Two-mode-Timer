module MainCode (
    input CLK_50MHz,        // MAX10_CLK1_50
    input rst_n,            // KEY0: Active-low reset (PIN_A7)
    input StartStop,        // KEY1: Toggle start/pause (PIN_B8)
    input ModeSel,          // SW0: Mode switch (0=stopwatch, 1=timer) (PIN_C10)

    output [6:0] HexMSBH,   // HEX3
    output [6:0] HexMSBL,   // HEX2[6:0]
    output [6:0] HexLSBH,   // HEX1
    output [6:0] HexLSBL,   // HEX0
    output DOT              // HEX2[7]
);

// Internal wires
wire CLK_100Hz;
wire CLK_1Hz;
wire [7:0] lsb_binary;
wire [7:0] msb_binary;
reg [5:0] dot_counter;
reg dot_state;
reg [5:0] dot_div;

// Register to detect mode switch
reg ModeSel_prev;
wire ModeChanged = (ModeSel != ModeSel_prev);

// Clock Divider
ClockDivider clkdiv (
    .CLK_50MHz(CLK_50MHz),
    .rst_n(rst_n),
    .CLK_100Hz(CLK_100Hz),
    .CLK_1Hz(CLK_1Hz)
);

// Select clock for TimerCoreLogic
wire selected_clk = (ModeSel) ? CLK_1Hz : CLK_100Hz;

// Internal reset pulse triggered on mode change
reg internal_reset;
always @(posedge CLK_50MHz or negedge rst_n) begin
    if (!rst_n) begin
        ModeSel_prev <= 0;
        internal_reset <= 0;
    end else begin
        ModeSel_prev <= ModeSel;
        internal_reset <= ModeChanged;  // Pulse when ModeSel toggles
    end
end

// Timer core logic handles all count behaviors
TimerCoreLogic core (
    .clk(selected_clk),
    .rst_n(rst_n & ~internal_reset),
    .StartStop(StartStop),
    .ModeSel(ModeSel),
    .LSBbinaryout(lsb_binary),
    .MSBbinaryout(msb_binary)
);

// DOT blink logic for stopwatch only
always @(posedge CLK_1Hz or negedge rst_n) begin
    if (!rst_n) begin
        dot_counter <= 0;
        dot_state <= 0;
    end else if (!ModeSel) begin
        if (dot_counter == 6'd49) begin
            dot_counter <= 0;
            dot_state <= ~dot_state;
        end else begin
            dot_counter <= dot_counter + 1;
        end
    end
end

// Segment encoder (no reversal needed)
SevenSegEncoder encoder (
    .LSBBinary(lsb_binary),
    .MSBBinary(msb_binary),
    .ModeSel(1'b0),
    .HexMSBH(HexMSBH),
    .HexMSBL(HexMSBL),
    .HexLSBH(HexLSBH),
    .HexLSBL(HexLSBL)
);

assign DOT = (ModeSel == 1'b0) ? dot_state : 1'b0;

endmodule