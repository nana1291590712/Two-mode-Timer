`timescale 1ns/1ps

module MainCode_tb;

    reg CLK_50MHz;
    reg rst_n;
    reg StartStop;
    reg ModeSel;

    wire [6:0] HexMSBH;
    wire [6:0] HexMSBL;
    wire [6:0] HexLSBH;
    wire [6:0] HexLSBL;
    wire DOT;

    MainCode uut (
        .CLK_50MHz(CLK_50MHz),
        .rst_n(rst_n),
        .StartStop(StartStop),
        .ModeSel(ModeSel),
        .HexMSBH(HexMSBH),
        .HexMSBL(HexMSBL),
        .HexLSBH(HexLSBH),
        .HexLSBL(HexLSBL),
        .DOT(DOT)
    );

    initial CLK_50MHz = 0;
    always #10 CLK_50MHz = ~CLK_50MHz;

    function [3:0] decode7seg;
        input [6:0] seg;
        case (seg)
            7'b1000000: decode7seg = 4'd0;
            7'b1111001: decode7seg = 4'd1;
            7'b0100100: decode7seg = 4'd2;
            7'b0110000: decode7seg = 4'd3;
            7'b0011001: decode7seg = 4'd4;
            7'b0010010: decode7seg = 4'd5;
            7'b0000010: decode7seg = 4'd6;
            7'b1111000: decode7seg = 4'd7;
            7'b0000000: decode7seg = 4'd8;
            7'b0010000: decode7seg = 4'd9;
            default:    decode7seg = 4'd15;
        endcase
    endfunction

    reg [27:0] last_hex;
    always @(posedge uut.CLK_100Hz) begin
        if ({HexMSBH, HexMSBL, HexLSBH, HexLSBL} !== last_hex) begin
            $display("Mode: %s | Display = %d%d.%d%d | DOT=%b",
                (ModeSel ? "Countdown" : "Stopwatch"),
                decode7seg(HexMSBH),
                decode7seg(HexMSBL),
                decode7seg(HexLSBH),
                decode7seg(HexLSBL),
                DOT
            );
            last_hex <= {HexMSBH, HexMSBL, HexLSBH, HexLSBL};
        end
    end

    initial begin
        $display("=== Stopwatch + Countdown Mode Test Start ===");

        rst_n = 0;
        StartStop = 1;
        ModeSel = 0; // Stopwatch mode
        #100;
        rst_n = 1;

        #100_000;

        // Start Stopwatch
        $display(">>> Start Stopwatch");
        StartStop = 0; #100_000; StartStop = 1;

        // Run for 0.2s
        #200_000_000;

        // Switch to Countdown
        $display(">>> Switch to Countdown Mode");
        ModeSel = 1;
        #300_000;

        // Start Countdown
        $display(">>> Start Countdown");
        StartStop = 0; #100_000; StartStop = 1;

        // Run for 3s
        #3_000_000_000;

        $display("=== Simulation End ===");
        $stop;
    end

endmodule
