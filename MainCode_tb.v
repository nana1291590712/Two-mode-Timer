`timescale 1 ns / 100 ps

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

    // Instantiate the DUT
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

    // Clock generation
    initial begin
        CLK_50MHz = 0;
        forever #10 CLK_50MHz = ~CLK_50MHz; // 50MHz → 20ns周期
    end

    // 7段译码到数字
    function [7*8:1] seg_to_digit;
        input [6:0] seg;
        begin
            case (seg)
                7'b1000000: seg_to_digit = "0";
                7'b1111001: seg_to_digit = "1";
                7'b0100100: seg_to_digit = "2";
                7'b0110000: seg_to_digit = "3";
                7'b0011001: seg_to_digit = "4";
                7'b0010010: seg_to_digit = "5";
                7'b0000010: seg_to_digit = "6";
                7'b1111000: seg_to_digit = "7";
                7'b0000000: seg_to_digit = "8";
                7'b0010000: seg_to_digit = "9";
                default: seg_to_digit = "?";
            endcase
        end
    endfunction

    // Test scenario
    initial begin
        $display("=== MainCode Testbench Start ===");

        rst_n = 0; StartStop = 0; ModeSel = 0; #100;
        rst_n = 1; #100;

        // Start stopwatch mode
        StartStop = 1; #20; StartStop = 0;

        // Run for a few increments
        repeat (10) begin
            #100000; // simulate time
            $display("ModeA: Display = %s%s.%s%s | DOT=%b",
                seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                seg_to_digit(HexLSBH), seg_to_digit(HexLSBL),
                DOT);
        end

        // Switch to Mode B
        ModeSel = 1; #200;
        $display("Switched to Mode B (Countdown)");

        // Start countdown
        StartStop = 1; #20; StartStop = 0;

        // Run countdown for a few steps
        repeat (10) begin
            #1000000;
            $display("ModeB: Display = %s%s.%s%s | DOT=%b",
                seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                seg_to_digit(HexLSBH), seg_to_digit(HexLSBL),
                DOT);
        end

        // Switch back to Mode A again
        ModeSel = 0; #200;
        $display("Switched back to Mode A");

        // Wait and see if it's reset
        #100000;
        $display("Final: Display = %s%s.%s%s | DOT=%b",
            seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
            seg_to_digit(HexLSBH), seg_to_digit(HexLSBL),
            DOT);

        $display("=== MainCode Testbench Complete ===");
        $finish;
    end

endmodule
